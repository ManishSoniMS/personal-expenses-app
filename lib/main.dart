import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './transaction_list.dart';
import './transaction.dart';
import './new_transaction.dart';
import './chart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
            // ignore: deprecated_member_use
            title: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 20,
            ),
          ),
        ),
        textTheme: ThemeData.light().textTheme.copyWith(
          // ignore: deprecated_member_use
          title: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          button: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [];
  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.dateTime.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet<void>(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          child: NewTransaction(_addNewTransactions),
          onTap: () {},
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _addNewTransactions(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
      id: DateTime.now().toString(),
      title: txTitle,
      amount: txAmount,
      dateTime: chosenDate,
    );
    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) {
        return tx.id == id;
      });
    });
  }

  List<Widget> _buildLandscapeContent(
      MediaQueryData mediaQuery,
      AppBar appBar,
      Widget txListWidget,
      ) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Show Chart',
            style: Theme.of(context).textTheme.headline6,
          ),
          Switch.adaptive(
            activeColor: Theme.of(context).accentColor,
            value: _showChart,
            onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            },
          ),
        ],
      ),
      _showChart
          ? Container(
        height: (mediaQuery.size.height -
            appBar.preferredSize.height -
            mediaQuery.padding.top) *
            0.7,
        child: Chart(_recentTransactions),
      )
          : txListWidget
    ];
  }

  List<Widget> _buildPortraitContent(
      MediaQueryData mediaQuery,
      AppBar appBar,
      Widget txListWidget,
      ) {
    return [
      Container(
        height: (mediaQuery.size.height -
            appBar.preferredSize.height -
            mediaQuery.padding.top) *
            0.22,
        child: Chart(_recentTransactions),
      ),
      txListWidget
    ];
  }

  bool _showChart = false;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final appBar = AppBar(
      title: Text('Personal Expenses'),
      actions: [
        IconButton(
          onPressed: () => _startAddNewTransaction(context),
          icon: Icon(Icons.add),
        ),
      ],
    );
    // final PreferredSizeWidget appBar = Platform.isIOS
    //     ? CupertinoNavigationBar(
    //         middle: Text('Personal Expenses'),
    //         trailing: Row(
    //           mainAxisSize: MainAxisSize.min,
    //           children: [
    //             GestureDetector(
    //               onTap: () => _startAddNewTransaction(context),
    //               child: Icon(CupertinoIcons.add),
    //             ),
    //           ],
    //         ),
    //       )
    //     : AppBar(
    //         title: Text('Personal Expenses'),
    //         actions: [
    //           IconButton(
    //             onPressed: () => _startAddNewTransaction(context),
    //             icon: Icon(Icons.add),
    //           ),
    //         ],
    //       );
    final txListWidget = Container(
      height: (mediaQuery.size.height -
          appBar.preferredSize.height -
          mediaQuery.padding.top) *
          0.75,
      child: TransactionList(_userTransactions, _deleteTransaction),
    );
    final pageBody = Padding(
      padding: const EdgeInsets.all(8.0),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isLandscape)
                ..._buildLandscapeContent(mediaQuery, appBar, txListWidget),
              if (!isLandscape)
                ..._buildPortraitContent(mediaQuery, appBar, txListWidget),
            ],
          ),
        ),
      ),
    );
    return
      // Platform.isIOS
      //     ? CupertinoPageScaffold(
      //         child: pageBody,
      //         navigationBar: appBar,
      //       )
      //     :
      Scaffold(
        appBar: appBar,
        body: pageBody,
        floatingActionButton: Platform.isIOS
            ? Container()
            : FloatingActionButton(
          onPressed: () => _startAddNewTransaction(context),
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );
  }
}
