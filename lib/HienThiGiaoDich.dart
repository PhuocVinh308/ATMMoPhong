import 'package:flutter/material.dart';
import 'LichSuGiaoDich.dart';

class TransactionHistoryScreen extends StatelessWidget {
  final List<Transaction> transactions;

  TransactionHistoryScreen({required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (BuildContext context, int index) {
          Transaction transaction = transactions[index];
          return ListTile(
            title: Text(transaction.type),
            subtitle: Text('Số tiền: ${transaction.amount} VND'),
            trailing: Text(transaction.date.toString()),
          );
        },
      ),
    );
  }
}
