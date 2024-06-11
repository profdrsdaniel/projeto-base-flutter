import 'package:exercicioflutterapi/models/character.dart';
import 'package:exercicioflutterapi/services/character_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  CharacterService service = CharacterService();

  // FUTURE
  late Future<List<Character>> _personangesFuture;

  late List<Character> _personagens;
  late List<Character> _personangesFiltrados;

  @override
  void initState() {
    super.initState();
    _personangesFuture = _getCharacters();
  }

  Future<List<Character>> _getCharacters() async {
    _personagens = await service.getCharacters();
    _personangesFiltrados = _personagens;
    return _personagens;
  }

  _filtroPersonanges(String filtro) {
    setState(() {
      _personangesFiltrados = _personagens
          .where(
              (item) => item.name.toLowerCase().contains(filtro.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Personagens"),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                onChanged: (value) {
                  _filtroPersonanges(value);
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Filtro"),
              ),
            ),
            FutureBuilder<List<Character>>(
                future: _personangesFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 50),
                        child: ListView.separated(
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(_personangesFiltrados[index].name),
                                leading: Image.network(
                                    _personangesFiltrados[index].image),
                              );
                            },
                            separatorBuilder: (context, int) {
                              return Divider();
                            },
                            itemCount: _personangesFiltrados.length),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    debugPrint(snapshot.error.toString());
                    return Text("Error");
                  }

                  return Center(child: CircularProgressIndicator());
                }),
          ],
        ),
      ),
    );
  }
}
