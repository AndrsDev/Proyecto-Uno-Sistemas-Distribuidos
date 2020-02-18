import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_uno/models/balance.dart';
import 'package:http/http.dart' as http;
import 'package:proyecto_uno/screens/history.dart';
import 'package:proyecto_uno/screens/transaction.dart';

enum MenuOptions { history, delete, restore }

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
    try {
      balances.clear();
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
            updated: DateTime.tryParse(data[3]) ?? DateTime.now(),
            balance: double.tryParse(data[4])?? 0,
          );

          balances.add(balance);
        }

        balances.sort((a, b) => a.id.compareTo(b.id));
      } else {
        print('no file');
      }
    } catch(e){
      print(e);
    }

    setState(() {});
  }

  Future<void> addEntry() async{
    bool updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => TransactionsScreen()),
    );
    if(updated == true){
      getBalances();
    }
  }

  Future<void> delete() async{
    String url = 'http://localhost:8080/shared/delete.php';
    try{
      await http.post(url);
      getBalances();
    } catch (e) {
      print(e);
    }
  }

  Future<void> restore() async{
    String url = 'http://localhost:8080/shared/restore.php';
    try{
      await http.post(url);
      getBalances();
    } catch (e) {
      print(e);
    }
  }

  void history(){
    Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => HistoryPage()),
    );
  }

  void optionSelected(MenuOptions option){
    switch (option) {
      case MenuOptions.delete: delete(); break;
      case MenuOptions.restore: restore(); break;
      case MenuOptions.history: history(); break;
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 56.0),
          child: Text('Saldos'),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 56.0),
            child: PopupMenuButton(
              onSelected: optionSelected,
              itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuOptions>>[
                const PopupMenuItem<MenuOptions>(
                  value: MenuOptions.history,
                  child: ListTile(
                    dense: true,
                    leading: Icon(Icons.format_list_bulleted),
                    title: Text('Historial')
                  ),
                ),  
                const PopupMenuItem<MenuOptions>(
                  value: MenuOptions.delete,
                  child: ListTile(
                    dense: true,
                    leading: Icon(Icons.delete),
                    title: Text('Eliminar')
                  ),
                ),
                const PopupMenuItem<MenuOptions>(
                  value: MenuOptions.restore,
                  child: ListTile(
                    dense: true,
                    leading: Icon(Icons.restore),
                    title: Text('Restaurar')
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 48.0, bottom: 36),
        child: FloatingActionButton.extended(
          onPressed: addEntry,
          icon: Icon(Icons.add),
          label: Text('Registrar'),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(64.0),
        children: <Widget>[


          Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal, 
              child: DataTable(
   
                columns: [
                  DataColumn(
                    label: Text('ID'),
                  ),
                  DataColumn(label: Text('Nombre')),
                  DataColumn(label: Text('Apellido')),
                  DataColumn(label: Text('Actualizado')),
                  DataColumn(label: Text('Balance'), numeric: true),
                ], 
                rows: [
                  for (var balance in balances) 
                    DataRow(cells: [
                      DataCell(Text(balance.id.toString())),
                      DataCell(Text(balance.name)),
                      DataCell(Text(balance.lastName)),
                      DataCell(Text(DateFormat('dd-MM-yyyy hh:mm').format(balance.updated))),
                      DataCell(Text(balance.balance.toStringAsFixed(2))),
                      
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
