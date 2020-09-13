import 'package:flutter/material.dart';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class Emprestimo {
  String tipoObjeto;
  String descricao;
  String pessoa;
  String data;
  bool devolvido = false;

  Emprestimo(this.descricao, this.pessoa, this.tipoObjeto);

  String getString() {
    return tipoObjeto +
        "," +
        descricao +
        "," +
        pessoa +
        "," +
        data +
        "," +
        devolvido.toString();
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Trabalho 3'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String dropdownValue = 'Livro';
  var emprestimos = List<Emprestimo>();

  final _formKey = GlobalKey<FormState>();
  TextEditingController _pessoa = TextEditingController();
  TextEditingController _descricao = TextEditingController();

  _MyHomePageState() {
    carrega();
  }

  void save() async {
    var file = File("atividades.json");
    String t = "";

    for (var emp in emprestimos) {
      t += emp.getString() + ";";
    }

    file.writeAsString(t);
  }

  void carrega() async {
    var file = File("atividades.json");
    file.readAsString().then((dado) {
      setState(() {
        for (var line in dado.split(";")) {
          var data = line.split(",");

          emprestimos.add(Emprestimo(
              data.elementAt(0), data.elementAt(1), data.elementAt(2)));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Column(
          children: [
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _pessoa,
                      style: TextStyle(fontFamily: "Courier New", fontSize: 22),
                      decoration: const InputDecoration(
                        hintText: 'Nome da pessoa',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Campo obrigatório';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _descricao,
                      style: TextStyle(fontFamily: "Courier New", fontSize: 22),
                      decoration: const InputDecoration(
                        hintText: 'Descrição do objeto',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Campo obrigatório';
                        }
                        return null;
                      },
                    ),
                    Text(
                      "Tipo do item:",
                      style: TextStyle(
                          fontFamily: "Courier New",
                          fontSize: 22,
                          color: Colors.deepPurple),
                    ),
                    DropdownButton<String>(
                      value: dropdownValue,
                      icon: Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 64,
                      isExpanded: true,
                      style: TextStyle(color: Colors.deepPurple, fontSize: 24),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownValue = newValue;
                        });
                      },
                      items: <String>['Livro', 'Ferramenta', 'Utilitário']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    RaisedButton(
                      child: Text('Adicionar Emprestimo'),
                      onPressed: () {
                        setState(() {
                          emprestimos.add(Emprestimo(
                              _pessoa.text, _descricao.text, dropdownValue));
                          save();
                        });
                      },
                    ),
                  ],
                )),
            Expanded(
              child: ListView.builder(
                itemCount: emprestimos.length,
                itemBuilder: (context, index) {
                  var elemento = emprestimos.elementAt(index);
                  return Center(
                      child: Container(
                          decoration: new BoxDecoration(
                              border: new Border.all(color: Colors.grey[500]),
                              color: Colors.white),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: Text(
                                      "Emprestimo #" +
                                          index.toString() +
                                          ": " +
                                          elemento.pessoa,
                                      style: TextStyle(
                                          color: Colors.deepPurple,
                                          fontSize: 16))),
                              Expanded(
                                  child: Column(
                                children: [
                                  Text("Objeto: " + elemento.tipoObjeto,
                                      style: TextStyle(
                                          color: Colors.deepPurple,
                                          fontSize: 16)),
                                  Text("Tipo: " + elemento.descricao,
                                      style: TextStyle(
                                          color: Colors.deepPurple,
                                          fontSize: 16))
                                ],
                              )),
                              Expanded(
                                  child: Checkbox(
                                value: elemento.devolvido,
                                tristate: false,
                                onChanged: (value) {
                                  setState(() {
                                    elemento.devolvido = value;
                                    save();
                                  });
                                },
                              ))
                            ],
                          )));
                },
              ),
            )
          ],
        ));
  }
}
