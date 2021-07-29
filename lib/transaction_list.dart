import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './transaction.dart';
import 'transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;
  TransactionList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'No transactions is added yet!',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: constraints.maxHeight * 0.625,
                    child: Icon(
                      CupertinoIcons.book,
                      size: constraints.maxHeight * 0.4,
                    ),
                  ),
                ],
              );
            },
          )
        : ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (ctx, index) {
              return TransactionItem(
                transaction: transactions[index],
                deleteTx: deleteTx,
              );
            },
          );
  }
}
