import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:proyecto_uno/models/clients.dart';
import 'package:http/http.dart' as http;

class TransactionsScreen extends StatefulWidget {
  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final formKey = GlobalKey<FormState>();
  bool _autovalidate = false;

  Client _client;
  String _type;
  String _total;
  

  Future<void> updateFiles() async {
    String url = 'http://localhost:8080/shared/update.php';
    dynamic body = {
      'id': _client.id,
      'name': _client.name,
      'last_name': _client.lastName,
      'type': _type,
      'date': DateTime.now().toIso8601String(),
      'total': _total,
    };
    try{
      await http.post(url, body: body);
      Navigator.of(context).pop(true);
    } catch (e) {
      print(e);
    }

  }

  void saveEntry() async {
    if(formKey.currentState.validate()){
      formKey.currentState.save();
      updateFiles();
    } else {
      setState(() {
        this._autovalidate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 48.0, bottom: 36),
        child: FloatingActionButton.extended(
          onPressed: saveEntry,
          icon: Icon(Icons.save_alt),
          label: Text('Guardar'),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(64.0),
        children: <Widget>[

          Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: DropdownButtonFormField(
                    onSaved: (value) => _client = value,
                    value: clients[0],
                    autovalidate: _autovalidate,
                    validator: (value) => value != null ? null : 'Campo requerido.',
                    items: clients
                      .map<DropdownMenuItem<Client>>((Client client) {
                        return DropdownMenuItem<Client>(
                          value: client,
                          child: Text('${client.id}. ${client.name} ${client.lastName}'),
                        );
                      })
                      .toList(),
                    onChanged: (value){},
                    decoration: InputDecoration(
                        labelText: 'Cliente',
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: DropdownButtonFormField(
                    onSaved: (value) => _type = value,
                    autovalidate: _autovalidate,
                    value: 'credito',
                    items: <dynamic>[
                        {"value": 'credito', "text": 'Crédito'},
                        {"value": 'debito', "text": 'Débito'}
                      ]
                      .map<DropdownMenuItem<dynamic>>((dynamic item) {
                        return DropdownMenuItem<dynamic>(
                          value: item['value'],
                          child: Text(item['text']),
                        );
                      })
                      .toList(),
                    onChanged: (value){},
                    decoration: InputDecoration(
                        labelText: 'Tipo',
                      // hintText: 'Ingresar...'
                    ),
                  ),
                ),

                    
                Padding(
                  padding: const EdgeInsets.only(bottom: 18.0),
                  child: TextFormField(
                    onSaved: (value) => _total = value,
                    initialValue: '100',
                    inputFormatters: [WhitelistingTextInputFormatter(RegExp("[0-9]"))],
                    autovalidate: _autovalidate,
                    cursorColor: Colors.blue,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    validator: (value) => (value.isNotEmpty && (double.tryParse(value) ?? 0) > 0) ? null : 'Ingrese una cantidad mayor a 0.',
              
                    decoration: InputDecoration(
                      labelText: 'Cantidad',
                      // hintText: 'Ingresar...'
                    ),
                  ),
                ),
              ]
            ),
          ),
         
        ],
      ),
    );
  }
}