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

  Future<void> updateFiles() async {
    print('should create file');

    String url = 'http://localhost:8080/shared/update.php';
    await http.post(url, body: {'txt': 'este es el texto'});
  }

  void saveEntry() async {
    if(formKey.currentState.validate()){
      formKey.currentState.save();
      await updateFiles();
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
                    value: 1,
                    autovalidate: _autovalidate,
                    validator: (value) => value != null ? null : 'Campo requerido.',
                    items: clients
                      .map<DropdownMenuItem<int>>((Client value) {
                        return DropdownMenuItem<int>(
                          value: value.id,
                          child: Text('${value.id}. ${value.name} ${value.lastName}'),
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
                  padding: const EdgeInsets.only(bottom: 18.0),
                  child: TextFormField(
                    initialValue: '0',
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

                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: DropdownButtonFormField(
                    autovalidate: _autovalidate,
                    value: 'Crédito',
                    items: <String>['Crédito', 'Débito']
                      .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
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

                Row(
                  children: <Widget>[
                    RaisedButton(
                      child: Text('Agregar'),
                      onPressed: saveEntry,
                    ),
                  ],
                )
              ]
            ),
          ),
         
        ],
      ),
    );
  }
}