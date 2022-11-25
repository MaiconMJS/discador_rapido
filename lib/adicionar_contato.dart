import 'package:discador_rapido/contato.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:discador_rapido/main.dart';
import 'package:page_transition/page_transition.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:discador_rapido/to_title_case.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as join;

class AdicionarContato extends StatefulWidget {
  const AdicionarContato({Key? key}) : super(key: key);
  @override
  State<AdicionarContato> createState() => AdicionarContatoState();
}

class AdicionarContatoState extends State<AdicionarContato> {
  final formKey = GlobalKey<FormState>();
  final formKeyTelefone = GlobalKey<FormState>();
  final nomeText = TextEditingController();
  final telefoneText = TextEditingController();
  late final ImagePicker imageAvatar;
  dynamic fotoAvatar = '';
  bool ativador = false;

  @override
  void initState() {
    super.initState();
    imageAvatar = ImagePicker();
  }

  @override
  void dispose() {
    closeDB();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async {
            FocusManager.instance.primaryFocus!.unfocus();
            Navigator.of(context).pushReplacement(
              PageTransition(
                  child: const Discagem(),
                  type: PageTransitionType.leftToRight,
                  duration: const Duration(milliseconds: 500)),
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
        centerTitle: true,
        title: const Text('Adicionar Contato'),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.10),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Form(
              key: formKey,
              child: TextFormField(
                controller: nomeText,
                decoration: const InputDecoration(
                  labelText: 'Nome Do Contato',
                  border: OutlineInputBorder(),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Nome Obrigatório';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Form(
              key: formKeyTelefone,
              child: TextFormField(
                controller: telefoneText,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Telefone Do Contato',
                  border: OutlineInputBorder(),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Telefone Obrigatório';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.80,
              child: ElevatedButton(
                onPressed: () async {
                  FocusManager.instance.primaryFocus!.unfocus();
                  formKey.currentState!.validate();
                  formKeyTelefone.currentState!.validate();
                  Timer(const Duration(seconds: 2), () {
                    formKey.currentState?.reset();
                    formKeyTelefone.currentState?.reset();
                  });
                  if (formKey.currentState!.validate() == true &&
                      formKeyTelefone.currentState!.validate() == true) {
                    if (nomeText.text.length >= 8) {
                      nomeText.text = '${nomeText.text.substring(0, 8)}..';
                    }
                    Contato.repository.add(
                      Contato(
                          id: DiscagemState.idContato.toString(),
                          nome: nomeText.text.trim().toTitleCase(),
                          telefone: telefoneText.text.trim(),
                          avatar:
                              ativador ? fotoAvatar : 'assets/personIcon.png'),
                    );
                    Contato.toMap['ids'] = Contato.repository.last.id;
                    Contato.toMap['nome'] = Contato.repository.last.nome;
                    Contato.toMap['telefone'] =
                        Contato.repository.last.telefone;
                    Contato.toMap['avatar'] = Contato.repository.last.avatar;
                    await insertContatos();
                    await voltar();
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                    const Text('Salvar'),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
              child: Column(
                children: const [
                  Text(
                    'Click Na Imagem\nPara Adicionar Uma Foto',
                    style: TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () async {
                final caminho =
                    await imageAvatar.pickImage(source: ImageSource.gallery);
                File file = File(caminho!.path);
                fotoAvatar = file.readAsBytesSync();
                setState(() => ativador = true);
              },
              child: !ativador
                  ? CircleAvatar(
                      radius: MediaQuery.of(context).size.width * 0.15,
                      backgroundImage:
                          const AssetImage('assets/personIcon.png'),
                    )
                  : CircleAvatar(
                      radius: MediaQuery.of(context).size.width * 0.15,
                      backgroundImage: MemoryImage(fotoAvatar),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> voltar() async {
    await Navigator.of(context).pushReplacement(
      PageTransition(
        child: const Discagem(),
        type: PageTransitionType.rightToLeft,
        duration: const Duration(milliseconds: 500),
      ),
    );
  }

  Future<void> insertContatos() async {
    final Database db = await openDB();
    await db.insert(
      "contatos",
      Contato.toMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Database> openDB() async {
    final dataBase = await openDatabase(
      join.join(await getDatabasesPath(), "contatos.db"),
      onCreate: (db, version) {
        return db.execute(
            "CREATE TABLE IF NOT EXISTS contatos(id INTEGER PRIMARY KEY AUTOINCREMENT, ids TEXT NOT NULL, nome TEXT NOT NULL, telefone TEXT NOT NULL, avatar BLOB NOT NULL)");
      },
      version: 1,
    );
    return dataBase;
  }

  Future<void> closeDB() async {
    final db = await openDB();
    db.close();
  }
}
