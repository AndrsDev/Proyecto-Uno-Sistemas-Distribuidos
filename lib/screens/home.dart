import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:proyecto_uno/models/balance.dart';
import 'package:http/http.dart' as http;


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Balance> balances = List();
  
  @override
  void initState() {
    getBalances();
    super.initState();
  }

  Future<void> getBalances() async{
    String content = await http.read('http://localhost:8080/shared/balances.txt');

    if(content != null){
      LineSplitter ls = LineSplitter();
      List<String> lines = ls.convert(content);

      for (var line in lines) {
        List<String> data = line.split(',');
        Balance balance = Balance(
          id: int.tryParse(data[0]) ?? 0,
          name: data[1],
          lastName: data[2],
          balance: double.tryParse(data[3])?? 0,
        );

        balances.add(balance);
      }

    } else {
      print('no file');
    }

    setState(() {});

  }




  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){},
        icon: Icon(Icons.add),
        label: Text('Registrar'),
      ),
      body: ListView(
        padding: EdgeInsets.all(64.0),
        children: <Widget>[


          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Text(
              'Saldos',
              style: theme.headline2
            ),
          ),



          DataTable(
            // sortColumnIndex: 0,
            columns: [
              DataColumn(label: Text('ID')),
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Last Name')),
              DataColumn(label: Text('Balance'), numeric: true),
            ], 
            rows: [
              for (var balance in balances) 
                DataRow(cells: [
                  DataCell(Text(balance.id.toString())),
                  DataCell(Text(balance.name)),
                  DataCell(Text(balance.lastName)),
                  DataCell(Text(balance.balance.toString())),
                  
                ]),
              
            ],
          )
        ],
      ),

    );
  }
}
