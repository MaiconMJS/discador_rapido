import 'package:discador_rapido/contato.dart';
import 'package:discador_rapido/to_title_case.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:discador_rapido/main.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as join;

class AtualizarContato extends StatefulWidget {
  const AtualizarContato({Key? key}) : super(key: key);
  @override
  State<AtualizarContato> createState() => AtualizarContatoState();
}

class AtualizarContatoState extends State<AtualizarContato> {
  final formNome = GlobalKey<FormState>();
  final formTelefone = GlobalKey<FormState>();
  final nomeText = TextEditingController();
  final telefoneText = TextEditingController();
  dynamic fotoAvatar = 'assets/personIcon.png';
  bool ativador = false;
  late final ImagePicker imageAvatar;
  late List<Contato> contato;

  @override
  void initState() {
    super.initState();
    contato = Contato.repository;
    imageAvatar = ImagePicker();
    if (DiscagemState.avatarIcon is String) {
      //Null
    } else {
      ativador = true;
      fotoAvatar = DiscagemState.avatarIcon;
    }
    if (DiscagemState.avatarNome != '') {
      nomeText.text = DiscagemState.avatarNome.substring(5);
      telefoneText.text = DiscagemState.avatarPhoneCall;
    }
  }

  @override
  void dispose() {
    closeDB();
    super.dispose();
  }

  Future<void> closeDB() async {
    final db = await openDB();
    db.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Atualizar Contato'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            FocusManager.instance.primaryFocus!.unfocus();
            Navigator.of(context).pushReplacement(
              PageTransition(
                child: const Discagem(),
                type: PageTransitionType.leftToRight,
                duration: const Duration(milliseconds: 500),
              ),
            );
          },
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.10,
        ),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Form(
              key: formNome,
              child: TextFormField(
                controller: nomeText,
                decoration: const InputDecoration(
                  labelText: 'Nome Atualizar',
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
              key: formTelefone,
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: telefoneText,
                decoration: const InputDecoration(
                  labelText: 'Telefone Atualizar',
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
              child: ElevatedButton(
                onPressed: () async {
                  FocusManager.instance.primaryFocus!.unfocus();
                  formNome.currentState!.validate();
                  formTelefone.currentState!.validate();
                  Timer(const Duration(seconds: 2), () {
                    formNome.currentState?.reset();
                    formTelefone.currentState?.reset();
                  });
                  if (formNome.currentState!.validate() == true &&
                      formTelefone.currentState!.validate() == true) {
                    if (nomeText.text.length >= 8) {
                      nomeText.text = '${nomeText.text.substring(0, 8)}..';
                    }
                    for (Contato contatos in contato) {
                      if (contatos.id == DiscagemState.idContato.toString()) {
                        contato.removeWhere(
                            (element) => element.id == contatos.id);
                        contato.add(
                          Contato(
                            id: DiscagemState.idContato.toString(),
                            nome: nomeText.text.trim().toTitleCase(),
                            telefone: telefoneText.text.trim(),
                            avatar: fotoAvatar,
                          ),
                        );
                        Contato.toMap['ids'] =
                            DiscagemState.idContato.toString();
                        Contato.toMap['nome'] =
                            nomeText.text.trim().toTitleCase();
                        Contato.toMap['telefone'] = telefoneText.text.trim();
                        Contato.toMap['avatar'] = fotoAvatar;
                        await updateContato(
                            ids: DiscagemState.idContato.toString());
                        await voltar();
                      }
                    }
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                    const Text('Atualizar'),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
              child: Column(
                children: const [
                  Text(
                    'Click Na Imagem\nPara Atualizar A Foto',
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

  Future<void> updateContato({required String ids}) async {
    final db = await openDB();
    db.update(
      'contatos',
      Contato.toMap,
      where: "ids = ?",
      whereArgs: [ids],
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
}
