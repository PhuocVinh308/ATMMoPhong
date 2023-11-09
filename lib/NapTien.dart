import 'package:flutter/material.dart';
import 'LichSuGiaoDich.dart';

class TopUpMoneyScreen extends StatefulWidget {
  final int balance;
  final void Function(int newBalance) onBalanceChanged;
  final List<Transaction> transactionHistory;

  TopUpMoneyScreen({
    required this.balance,
    required this.onBalanceChanged,
    required this.transactionHistory,
  });

  @override
  _TopUpMoneyScreenState createState() => _TopUpMoneyScreenState();
}

class _TopUpMoneyScreenState extends State<TopUpMoneyScreen> {
  TextEditingController amountController = TextEditingController();

  void topUpMoney(int amount) {
    if (amount > 0) {
      int newBalance = widget.balance + amount;
      widget.onBalanceChanged(newBalance); // Update the balance using onBalanceChanged
      Transaction transaction = Transaction(
         'Nạp tiền',amount, DateTime.now(),
      );
      widget.transactionHistory.add(transaction);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Nạp tiền thành công'),
            content: Text('Bạn đã nạp $amount VND vào tài khoản.'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Nhập số tiền nạp (VND)',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                int? amount = int.tryParse(amountController.text);
                if (amount != null && amount > 0) {
                  topUpMoney(amount);
                  amountController.clear();
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Lỗi'),
                        content: Text('Vui lòng nhập số tiền hợp lệ.'),
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
                child: Text('Nạp Tiền'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
