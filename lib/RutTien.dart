import 'package:flutter/material.dart';
import 'LichSuGiaoDich.dart';
class WithdrawMoneyScreen extends StatefulWidget {
  final int balance;
  final void Function(int newBalance) onBalanceChanged; 
    final List<Transaction> transactionHistory;


  WithdrawMoneyScreen({required this.balance, required this.onBalanceChanged, required this.transactionHistory});

  @override
  _WithdrawMoneyScreenState createState() => _WithdrawMoneyScreenState();
}

class _WithdrawMoneyScreenState extends State<WithdrawMoneyScreen> {
  TextEditingController amountController = TextEditingController();
  int balance = 100000;

  Map<String, int> noteCounts = {
    '500000': 10,
    '200000': 10,
    '100000': 10,
    '50000': 10,
  };

 @override
  void initState() {
    super.initState();
    balance = widget.balance; 
  }
  void withdrawMoney(int amount) {
    if (amount > balance) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Lỗi'),
            content: Text('Số dư không đủ.'),
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
    } else if (amount % 50000 != 0) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Lỗi'),
            content: Text('Số dư không chia hết cho 50000.'),
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
        int noteCount = noteCounts[denomination] ?? 0;
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
            noteCounts[denomination] = noteCounts[denomination]! - notesToWithdraw[denomination]!;
          }
          balance -= amount;
          widget.onBalanceChanged(balance);
        });

        widget.onBalanceChanged(balance);
 

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

  Widget buildNoteCounts() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: noteCounts.length,
      itemBuilder: (BuildContext context, int index) {
        String denomination = noteCounts.keys.elementAt(index);
        int count = noteCounts.values.elementAt(index);
        return ListTile(
          title: Text('$denomination VND'),
          subtitle: Text('Số tờ: $count'),
          trailing: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              showEditDialog(denomination, count);
            },
          ),
        );
      },
    );
  }

  void showEditDialog(String denomination, int count) {
    TextEditingController countController = TextEditingController(text: count.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cập nhật số tờ'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('$denomination VND'),
              SizedBox(height: 8.0),
              TextField(
                controller: countController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Số tờ',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Huỷ'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cập nhật'),
              onPressed: () {
                int? newCount = int.tryParse(countController.text);
                if (newCount != null) {
                  setState(() {
                    noteCounts[denomination] = newCount;
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
     
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Số lượng tờ tiền theo mệnh giá:',
              style: TextStyle(fontSize: 16.0),
            ),
            buildNoteCounts(),
            SizedBox(height: 16.0),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Nhập số tiền rút (VND)',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                int? amount = int.tryParse(amountController.text);
                if (amount != null && amount > 0) {
                  withdrawMoney(amount);
                  amountController.clear();
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Lỗi'),
                        content: Text('Vui lòng nhập số tiền hợp lệ. Số tiền là bội số của 50000.'),
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
              },
              child: Align(
                alignment: Alignment.center,
                child: Text('Rút Tiền'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
