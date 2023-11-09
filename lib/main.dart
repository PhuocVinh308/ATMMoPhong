import 'package:flutter/material.dart';
import 'package:nlcsn/HienThiGiaoDich.dart';
import 'NapTien.dart';
import 'RutTien.dart';
import 'QuetMaQR.dart';
import 'LichSuGiaoDich.dart';
void main() {
  int initialBalance = 1000000; 
  runApp(MyApp(initialBalance: initialBalance));
}

class MyApp extends StatelessWidget {
  final int initialBalance;

  MyApp({required this.initialBalance});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ATM PhuocVinh Bank',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(initialBalance: initialBalance),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  final int initialBalance;

  HomePage({required this.initialBalance});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  int balance = 1000000;
  List<Transaction> transactionHistory = [];

  @override
  void initState() {
    super.initState();
    balance = widget.initialBalance;
  }

  List<Widget> get pages {
    return [
      WithdrawMoneyScreen(
        balance: balance,
        onBalanceChanged: (newBalance) {
          setState(() {
            balance = newBalance;
          });
        }, transactionHistory: transactionHistory,
      ),
      QRScannerScreen(balance: balance,onBalanceChanged: (newBalance) {
          setState(() {
            balance = newBalance;
          });
        }, transactionHistory: transactionHistory, ),
      TransactionHistoryScreen(transactions: transactionHistory,),
      TopUpMoneyScreen(balance: balance,  onBalanceChanged: (newBalance) {
          setState(() {
            balance = newBalance;
          });
        },transactionHistory: transactionHistory,),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ATM PhuocVinh Bank'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0, bottom: 16.0, top: 16.0),
            child: Text(
              '$balance VND',
              style: TextStyle(fontSize: 20.0),
            ),
          ),
        ],
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color.fromARGB(255, 255, 251, 251),
        selectedItemColor: const Color.fromARGB(255, 0, 140, 255),
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 8,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.money),
            label: 'Rút Tiền',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code),
            label: 'Quét mã QR',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Lịch sử',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: 'Nạp Tiền',
          ),
        ],
      ),
    );
  }
}



