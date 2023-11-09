
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'LichSuGiaoDich.dart';
class QRScannerScreen extends StatefulWidget {
  final int balance;
  final void Function(int newBalance) onBalanceChanged;
  final List<Transaction> transactionHistory;

  QRScannerScreen({
    required this.balance,
    required this.onBalanceChanged,
    required this.transactionHistory,
  });

  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  QRViewController? _controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool _isScanning = false;

  Map<String, int> _noteCounts = {
    '500000': 10,
    '200000': 20,
    '100000': 30,
    '50000': 40,
  };

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      _controller = controller;
      _isScanning = true;
    });

    controller.scannedDataStream.listen((scanData) {
      if (_isScanning) {
        _isScanning = false;
        _controller?.pauseCamera();
        _processQRCodeData(scanData.code!);
      }
    });
  }

  void _resumeScanning() {
    _isScanning = true;
    _controller?.resumeCamera();
  }

 void _processQRCodeData(String qrCodeData) {
  int amount = int.tryParse(qrCodeData) ?? 0;
  int balance = widget.balance;

  if (amount > balance || amount % 50000 != 0) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Lỗi'),
          content: Text('Số dư không đủ hoặc tiền không là bội của 50000.'),
          actions: <Widget>[
            TextButton(
              child: Text('Đóng'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  } else {
    int remainingAmount = amount;
    Map<String, int> notesToWithdraw = {};

    List<String> noteDenominations = ['500000', '200000', '100000', '50000'];

    for (String denomination in noteDenominations) {
      int noteCount = _noteCounts[denomination] ?? 0;
      int numNotes = remainingAmount ~/ int.parse(denomination);
      numNotes = numNotes > noteCount ? noteCount : numNotes;
      if (numNotes > 0) {
        notesToWithdraw[denomination] = numNotes;
        remainingAmount -= numNotes * int.parse(denomination);
      }
    }

    if (remainingAmount == 0) {
      setState(() {
        for (String denomination in notesToWithdraw.keys) {
          _noteCounts[denomination] = _noteCounts[denomination]! - notesToWithdraw[denomination]!;
        }
        balance -= amount;
      });
              widget.onBalanceChanged(balance);
widget.transactionHistory.add(Transaction(
  'Rút tiền mã QR', 
   amount,
   DateTime.now(),
));
      
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Rút tiền thành công'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Bạn đã rút $amount VND từ tài khoản.'),
                SizedBox(height: 8.0),
                if (notesToWithdraw.isNotEmpty) Text('Số tờ đã rút:'),
                for (var entry in notesToWithdraw.entries) ...[
                  Text('${entry.key} VND: ${entry.value} tờ'),
                ],
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Đóng'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Lỗi'),
            content: Text('Không thể rút số tiền này với số dư hiện có hoặc số tờ tiền không đủ vui lòng cập nhật số tiền.'),
            actions: <Widget>[
              TextButton(
                child: Text('Đóng'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: ElevatedButton(
                onPressed: _isScanning ? null : _resumeScanning,
                child: Text('Quét lại'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
