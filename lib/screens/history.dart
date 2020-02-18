import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:proyecto_uno/models/transaction.dart';


class HistoryPage extends StatefulWidget {
  HistoryPage({Key key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Transaction> transactions = List();
  
  @override
  void initState() {
    getBalances();
    super.initState();
  }

  Future<void> getBalances() async{
    try {
      transactions.clear();
      String content = await http.read('http://localhost:8080/shared/transactions.txt');
      if(content != null){
        LineSplitter ls = LineSplitter();
        List<String> lines = ls.convert(content);

        for (var line in lines) {
          List<String> data = line.split(',');
          Transaction transaction = Transaction(
            id: int.tryParse(data[0]) ?? 0,
            account: int.tryParse(data[1]) ?? 0,
            name: data[2],
            lastName: data[3],
            type: data[4],
            updated: DateTime.tryParse(data[5]) ?? DateTime.now(),
            total: double.tryParse(data[6])?? 0,
          );

          transactions.add(transaction);
        }

      } else {
        print('no file');
      }
    } catch(e){
      print(e);
    }

    setState(() {});
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Historial'),
      ),
      body: ListView(
        padding: EdgeInsets.all(64.0),
        children: <Widget>[

          Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                // sortColumnIndex: 0,
                columns: [
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('Nombre')),
                  DataColumn(label: Text('Apellido')),
                  DataColumn(label: Text('Tipo')),
                  DataColumn(label: Text('Fecha')),
                  DataColumn(label: Text('Balance'), numeric: true),
                ], 
                rows: [
                  for (var row in transactions) 
                    DataRow(cells: [
                      DataCell(Text(row.id.toString())),
                      DataCell(Text(row.name)),
                      DataCell(Text(row.lastName)),
                      DataCell(Text(row.type)),
                      DataCell(Text(DateFormat('dd-MM-yyyy hh:mm').format(row.updated))),
                      DataCell(Text(row.total.toStringAsFixed(2))),
                      
                    ]),
                  
                ],
              ),
            ),
          )
        ],
      ),

    );
  }
}
