import 'package:flutter/material.dart';
import '../transaction.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatelessWidget {
  TransactionItem({
    required this.transaction,
    required this.deleteTx,
  });

  final Transaction transaction;
  final Function deleteTx;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      elevation: 5,
      child: ListTile(
        leading: CircleAvatar(
          radius: 40,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: FittedBox(
              child: Text('₹${transaction.amount}'),
            ),
          ),
        ),
        title: Text(
          transaction.title,
          // ignore: deprecated_member_use
          style: Theme.of(context).textTheme.title,
        ),
        subtitle: Text(
          DateFormat.yMMMd().format(transaction.dateTime),
        ),
        trailing: MediaQuery.of(context).size.width > 400
        // ignore: deprecated_member_use
            ? FlatButton.icon(
          onPressed: () => deleteTx(transaction.id),
          icon: Icon(Icons.delete),
          textColor: Theme.of(context).errorColor,
          label: Text('Delete'),
        )
            : IconButton(
          icon: Icon(
            Icons.delete,
            color: Theme.of(context).errorColor,
          ),
          onPressed: () => deleteTx(transaction.id),
        ),
      ),
    );
  }
}
