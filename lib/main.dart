import 'package:discador_rapido/adicionar_contato.dart';
import 'package:discador_rapido/atualizar_contato.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:discador_rapido/contato.dart';
import 'package:page_transition/page_transition.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:path/path.dart' as join;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Root());
}

class Root extends StatelessWidget {
  const Root({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: RootController.controller,
      builder: (BuildContext context, Widget? child) {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: Colors.green,
          ),
        );
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'discagem_rapida',
          theme: ThemeData(
            brightness: RootController.controller.themeDark
                ? Brightness.dark
                : Brightness.light,
            primarySwatch: Colors.green,
            useMaterial3: false,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: const Discagem(),
        );
      },
    );
  }
}

class RootController extends ChangeNotifier {
  static RootController controller = RootController();
  bool themeDark = false;
  Future<void> trocarDart() async {
    themeDark = !themeDark;
    await savePreferences(tema: themeDark);
    notifyListeners();
  }

  Future<void> readPreferences() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final boleana = sharedPreferences.getBool('theme') ?? false;
    if (boleana) {
      DiscagemState.modo = 'Escuro';
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(systemNavigationBarColor: Colors.black87),
      );
    } else {
      DiscagemState.modo = 'Claro';
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(systemNavigationBarColor: Colors.green),
      );
    }
    themeDark = boleana;
    notifyListeners();
  }

  Future<void> savePreferences({required bool tema}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool('theme', tema);
  }
}

class Discagem extends StatefulWidget {
  const Discagem({Key? key}) : super(key: key);
  @override
  State<Discagem> createState() => DiscagemState();
}

class DiscagemState extends State<Discagem> {
  static dynamic avatarIcon = 'assets/personIcon.png';
  String avatarPhone = '';
  static String avatarNome = '';
  static String avatarPhoneCall = '';
  String number1 = 'Vazio';
  String number2 = 'Vazio';
  String number3 = 'Vazio';
  String number4 = 'Vazio';
  String number5 = 'Vazio';
  String number6 = 'Vazio';
  String number7 = 'Vazio';
  String number8 = 'Vazio';
  String number9 = 'Vazio';
  double tamanhoText1 = 0.10;
  double tamanhoText2 = 0.10;
  double tamanhoText3 = 0.10;
  double tamanhoText4 = 0.10;
  double tamanhoText5 = 0.10;
  double tamanhoText6 = 0.10;
  double tamanhoText7 = 0.10;
  double tamanhoText8 = 0.10;
  double tamanhoText9 = 0.10;
  Color corNumer1 = Colors.green;
  Color corNumer2 = Colors.green;
  Color corNumer3 = Colors.green;
  Color corNumer4 = Colors.green;
  Color corNumer5 = Colors.green;
  Color corNumer6 = Colors.green;
  Color corNumer7 = Colors.green;
  Color corNumer8 = Colors.green;
  Color corNumer9 = Colors.green;
  static int idContato = 0;
  bool ativo = true;
  bool confirmacaoParaDeletar = false;
  String nomeParaAlert = '';
  dynamic photoParaAlert = '';
  String idParaAlert = '';
  static String modo = 'Claro';

  @override
  void initState() {
    super.initState();
    openDB();
    carregar();
    RootController.controller.readPreferences();
  }

  @override
  void dispose() {
    closeDB();
    super.dispose();
  }

  Future<List<Contato>> queryContato() async {
    final Database db = await openDB();
    final List<Map<String, dynamic>> maps = await db.query("contatos");
    return List.generate(
      maps.length,
      (int i) {
        return Contato(
          id: maps[i]['ids'],
          nome: maps[i]['nome'],
          telefone: maps[i]['telefone'],
          avatar: maps[i]['avatar'],
        );
      },
    );
  }

  Future<void> carregar() async {
    final carregando = await queryContato();
    for (Contato contatos in carregando) {
      Contato.repository.add(
        Contato(
          id: contatos.id,
          nome: contatos.nome,
          telefone: contatos.telefone,
          avatar: contatos.avatar,
        ),
      );
    }
    setState(() => distribuirContato());
  }

  Future<void> closeDB() async {
    final db = await openDB();
    db.close();
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

  void distribuirContato() {
    if (Contato.repository.isNotEmpty) {
      for (Contato contatos in Contato.repository) {
        if (contatos.id == '1') {
          number1 = contatos.nome;
        }
        if (contatos.id == '2') {
          number2 = contatos.nome;
        }
        if (contatos.id == '3') {
          number3 = contatos.nome;
        }
        if (contatos.id == '4') {
          number4 = contatos.nome;
        }
        if (contatos.id == '5') {
          number5 = contatos.nome;
        }
        if (contatos.id == '6') {
          number6 = contatos.nome;
        }
        if (contatos.id == '7') {
          number7 = contatos.nome;
        }
        if (contatos.id == '8') {
          number8 = contatos.nome;
        }
        if (contatos.id == '9') {
          number9 = contatos.nome;
        }
      }
    }
    if (Contato.repository.isNotEmpty) {
      for (Contato contatos in Contato.repository) {
        if (idContato.toString() == contatos.id) {
          ativo = false;
          avatarNome = 'Nome: ${contatos.nome}';
          avatarPhone = 'Telefone: ${contatos.telefone}';
          avatarIcon = contatos.avatar;
          avatarPhoneCall = contatos.telefone;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Discador Rápido'),
        actions: [
          Center(
            child: Text(
              modo,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Switch(
            value: RootController.controller.themeDark,
            onChanged: (value) {
              RootController.controller.trocarDart();
              value = RootController.controller.themeDark;
              setState(() {
                if (modo == 'Claro') {
                  modo = 'Escuro';
                  SystemChrome.setSystemUIOverlayStyle(
                    const SystemUiOverlayStyle(
                      systemNavigationBarColor: Colors.black87,
                    ),
                  );
                } else {
                  modo = 'Claro';
                  SystemChrome.setSystemUIOverlayStyle(
                    const SystemUiOverlayStyle(
                      systemNavigationBarColor: Colors.green,
                    ),
                  );
                }
              });
            },
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            avatarIcon is String
                ? CircleAvatar(
                    radius: MediaQuery.of(context).size.height * 0.10,
                    backgroundImage: AssetImage(avatarIcon),
                  )
                : CircleAvatar(
                    radius: MediaQuery.of(context).size.width * 0.20,
                    backgroundImage: MemoryImage(avatarIcon),
                  ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Text(
              avatarPhone,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.05,
                color: Colors.green,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
            Text(
              avatarNome,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.05,
                color: Colors.green,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
              child: Text(
                'ID: $idContato',
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onLongPress: phoneCall,
                  onPressed: funcao7,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      width: 2,
                      color: Colors.green,
                    ),
                    padding: const EdgeInsets.all(10),
                    shape: const CircleBorder(),
                  ),
                  child: AnimatedDefaultTextStyle(
                    curve: Curves.easeInOutCirc,
                    duration: const Duration(milliseconds: 500),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize:
                            MediaQuery.of(context).size.width * tamanhoText7),
                    child: const Text(
                      '7',
                      style: TextStyle(
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
                OutlinedButton(
                  onLongPress: phoneCall,
                  onPressed: funcao8,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      width: 2,
                      color: Colors.green,
                    ),
                    padding: const EdgeInsets.all(10),
                    shape: const CircleBorder(),
                  ),
                  child: AnimatedDefaultTextStyle(
                    curve: Curves.easeInOutCirc,
                    duration: const Duration(milliseconds: 500),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize:
                            MediaQuery.of(context).size.width * tamanhoText8),
                    child: const Text(
                      '8',
                      style: TextStyle(
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
                OutlinedButton(
                  onLongPress: phoneCall,
                  onPressed: funcao9,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      width: 2,
                      color: Colors.green,
                    ),
                    padding: const EdgeInsets.all(10),
                    shape: const CircleBorder(),
                  ),
                  child: AnimatedDefaultTextStyle(
                    curve: Curves.easeInOutCirc,
                    duration: const Duration(milliseconds: 500),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize:
                            MediaQuery.of(context).size.width * tamanhoText9),
                    child: const Text(
                      '9',
                      style: TextStyle(
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  number7,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: corNumer7,
                      fontSize: MediaQuery.of(context).size.width * 0.04),
                ),
                Text(
                  number8,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: corNumer8,
                      fontSize: MediaQuery.of(context).size.width * 0.04),
                ),
                Text(
                  number9,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: corNumer9,
                      fontSize: MediaQuery.of(context).size.width * 0.04),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onLongPress: phoneCall,
                  onPressed: funcao4,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      width: 2,
                      color: Colors.green,
                    ),
                    padding: const EdgeInsets.all(10),
                    shape: const CircleBorder(),
                  ),
                  child: AnimatedDefaultTextStyle(
                    curve: Curves.easeInOutCirc,
                    duration: const Duration(milliseconds: 500),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize:
                            MediaQuery.of(context).size.width * tamanhoText4),
                    child: const Text(
                      '4',
                      style: TextStyle(
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
                OutlinedButton(
                  onLongPress: phoneCall,
                  onPressed: funcao5,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      width: 2,
                      color: Colors.green,
                    ),
                    padding: const EdgeInsets.all(10),
                    shape: const CircleBorder(),
                  ),
                  child: AnimatedDefaultTextStyle(
                    curve: Curves.easeInOutCirc,
                    duration: const Duration(milliseconds: 500),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize:
                            MediaQuery.of(context).size.width * tamanhoText5),
                    child: const Text(
                      '5',
                      style: TextStyle(
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
                OutlinedButton(
                  onLongPress: phoneCall,
                  onPressed: funcao6,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      width: 2,
                      color: Colors.green,
                    ),
                    padding: const EdgeInsets.all(10),
                    shape: const CircleBorder(),
                  ),
                  child: AnimatedDefaultTextStyle(
                    curve: Curves.easeInOutCirc,
                    duration: const Duration(milliseconds: 500),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize:
                            MediaQuery.of(context).size.width * tamanhoText6),
                    child: const Text(
                      '6',
                      style: TextStyle(
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  number4,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: corNumer4,
                      fontSize: MediaQuery.of(context).size.width * 0.04),
                ),
                Text(
                  number5,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: corNumer5,
                      fontSize: MediaQuery.of(context).size.width * 0.04),
                ),
                Text(
                  number6,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: corNumer6,
                      fontSize: MediaQuery.of(context).size.width * 0.04),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onLongPress: phoneCall,
                  onPressed: funcao1,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      width: 2,
                      color: Colors.green,
                    ),
                    padding: const EdgeInsets.all(10),
                    shape: const CircleBorder(),
                  ),
                  child: AnimatedDefaultTextStyle(
                    curve: Curves.easeInOutCirc,
                    duration: const Duration(milliseconds: 500),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize:
                            MediaQuery.of(context).size.width * tamanhoText1),
                    child: const Text(
                      '1',
                      style: TextStyle(
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
                OutlinedButton(
                  onLongPress: phoneCall,
                  onPressed: funcao2,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      width: 2,
                      color: Colors.green,
                    ),
                    padding: const EdgeInsets.all(10),
                    shape: const CircleBorder(),
                  ),
                  child: AnimatedDefaultTextStyle(
                    curve: Curves.easeInOutCirc,
                    duration: const Duration(milliseconds: 500),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize:
                            MediaQuery.of(context).size.width * tamanhoText2),
                    child: const Text(
                      '2',
                      style: TextStyle(
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
                OutlinedButton(
                  onLongPress: phoneCall,
                  onPressed: funcao3,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      width: 2,
                      color: Colors.green,
                    ),
                    padding: const EdgeInsets.all(10),
                    shape: const CircleBorder(),
                  ),
                  child: AnimatedDefaultTextStyle(
                    curve: Curves.easeInOutCirc,
                    duration: const Duration(milliseconds: 500),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize:
                            MediaQuery.of(context).size.width * tamanhoText3),
                    child: const Text(
                      '3',
                      style: TextStyle(
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  number1,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: corNumer1,
                      fontSize: MediaQuery.of(context).size.width * 0.04),
                ),
                Text(
                  number2,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: corNumer2,
                      fontSize: MediaQuery.of(context).size.width * 0.04),
                ),
                Text(
                  number3,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: corNumer3,
                      fontSize: MediaQuery.of(context).size.width * 0.04),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: ativo
                      ? () {
                          if (idContato == 0) {
                            Get.snackbar(
                                'Falta Selecionar Um Número', 'Do Teclado',
                                snackPosition: SnackPosition.BOTTOM,
                                colorText: Colors.green,
                                icon: const Icon(Icons.phone,
                                    color: Colors.green),
                                barBlur: 0.1);
                          } else if (idContato > 0) {
                            Navigator.of(context).pushReplacement(
                              PageTransition(
                                child: const AdicionarContato(),
                                type: PageTransitionType.rightToLeft,
                                duration: const Duration(milliseconds: 500),
                              ),
                            );
                          }
                        }
                      : null,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Colors.green,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    'Adicionar',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                    ),
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    if (avatarNome == '') {
                      Get.snackbar(
                        'Não Há Contatos Para Atualizar',
                        '',
                        snackPosition: SnackPosition.BOTTOM,
                        colorText: Colors.green,
                        icon: const Icon(Icons.phone, color: Colors.green),
                        barBlur: 0.1,
                      );
                    } else {
                      Navigator.of(context).pushReplacement(
                        PageTransition(
                          child: const AtualizarContato(),
                          type: PageTransitionType.rightToLeft,
                          duration: const Duration(milliseconds: 500),
                        ),
                      );
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Colors.green,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    'Atualizar',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                    ),
                  ),
                ),
                OutlinedButton(
                  onPressed: () async {
                    if (avatarNome == '') {
                      Get.snackbar(
                        'Não Há Contatos Para Deletar',
                        '',
                        snackPosition: SnackPosition.BOTTOM,
                        colorText: Colors.green,
                        icon: const Icon(Icons.phone, color: Colors.green),
                        barBlur: 0.1,
                      );
                    } else {
                      for (Contato contatos in Contato.repository) {
                        if (idContato.toString() == contatos.id) {
                          idParaAlert = contatos.id;
                          nomeParaAlert = contatos.nome;
                          photoParaAlert = contatos.avatar;
                        }
                      }
                      await tempoEspera(
                        nomeContato: nomeParaAlert,
                        fotoPerson: photoParaAlert,
                      );
                      if (confirmacaoParaDeletar) {
                        await deleteContato(ids: idParaAlert);
                        removerNumber(idParaAlert);
                        setState(() {
                          avatarIcon = 'assets/personIcon.png';
                          avatarPhone = '';
                          avatarNome = '';
                          avatarPhoneCall = '';
                          ativo = true;
                        });
                        Contato.repository.removeWhere(
                            (element) => element.id == idParaAlert);
                        confirmacaoParaDeletar = false;
                      }
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Colors.green,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    'Deletar',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> deleteContato({required String ids}) async {
    final db = await openDB();
    await db.delete(
      'contatos',
      where: "ids = ?",
      whereArgs: [ids],
    );
  }

  Future<void> tempoEspera(
      {required String nomeContato, required dynamic fotoPerson}) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert(nome: nomeContato, foto: fotoPerson);
      },
    );
  }

  AlertDialog alert({required String nome, required dynamic foto}) {
    AlertDialog alert = AlertDialog(
      title: const Text(
        'Tem Certeza?',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Row(
        children: [
          Text(
            'Deletar: ',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.05,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            nome,
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.width * 0.05,
            ),
          ),
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(MediaQuery.of(context).size.width * 0.05),
      ),
      elevation: 50,
      icon: avatarIcon is String
          ? Image.asset('assets/personIcon.png',
              width: MediaQuery.of(context).size.width * 0.25)
          : CircleAvatar(
              radius: MediaQuery.of(context).size.width * 0.25,
              backgroundImage: MemoryImage(foto),
            ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Cancelar',
            style:
                TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05),
          ),
        ),
        TextButton(
          onPressed: () {
            confirmacaoParaDeletar = true;
            Navigator.of(context).pop();
          },
          child: Text(
            'Deletar',
            style:
                TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05),
          ),
        ),
      ],
    );
    return alert;
  }

  void removerNumber(String id) {
    if (id == '1') {
      number1 = 'Vazio';
    }
    if (id == '2') {
      number2 = 'Vazio';
    }
    if (id == '3') {
      number3 = 'Vazio';
    }
    if (id == '4') {
      number4 = 'Vazio';
    }
    if (id == '5') {
      number5 = 'Vazio';
    }
    if (id == '6') {
      number6 = 'Vazio';
    }
    if (id == '7') {
      number7 = 'Vazio';
    }
    if (id == '8') {
      number8 = 'Vazio';
    }
    if (id == '9') {
      number9 = 'Vazio';
    }
  }

  Future<void> phoneCall() async {
    await launchUrlString(
      'tel:$avatarPhoneCall',
      mode: LaunchMode.platformDefault,
    );
  }

  void funcao1() {
    setState(() {
      idContato = 1;
      ativo = true;
      avatarPhone = '';
      avatarIcon = 'assets/personIcon.png';
      avatarNome = '';
      avatarPhoneCall = '';
    });
    for (Contato contatos in Contato.repository) {
      if (contatos.id == '1') {
        setState(() {
          ativo = false;
          avatarNome = 'Nome: ${contatos.nome}';
          avatarPhone = 'Telefone: ${contatos.telefone}';
          avatarIcon = contatos.avatar;
          avatarPhoneCall = contatos.telefone;
        });
      }
    }
    setState(() {
      tamanhoText1 = 0.15;
      corNumer1 = Colors.yellow;
      Timer(const Duration(milliseconds: 500), () {
        setState(() {
          tamanhoText1 = 0.10;
          corNumer1 = Colors.green;
        });
      });
    });
  }

  void funcao2() {
    setState(() {
      idContato = 2;
      ativo = true;
      avatarPhone = '';
      avatarIcon = 'assets/personIcon.png';
      avatarNome = '';
      avatarPhoneCall = '';
    });
    for (Contato contatos in Contato.repository) {
      if (contatos.id == '2') {
        setState(() {
          ativo = false;
          avatarNome = 'Nome: ${contatos.nome}';
          avatarPhone = 'Telefone: ${contatos.telefone}';
          avatarIcon = contatos.avatar;
          avatarPhoneCall = contatos.telefone;
        });
      }
    }
    setState(() {
      tamanhoText2 = 0.15;
      corNumer2 = Colors.yellow;
      Timer(const Duration(milliseconds: 500), () {
        setState(() {
          tamanhoText2 = 0.10;
          corNumer2 = Colors.green;
        });
      });
    });
  }

  void funcao3() {
    setState(() {
      idContato = 3;
      ativo = true;
      avatarPhone = '';
      avatarIcon = 'assets/personIcon.png';
      avatarNome = '';
      avatarPhoneCall = '';
    });
    for (Contato contatos in Contato.repository) {
      if (contatos.id == '3') {
        setState(() {
          ativo = false;
          avatarNome = 'Nome: ${contatos.nome}';
          avatarPhone = 'Telefone: ${contatos.telefone}';
          avatarIcon = contatos.avatar;
          avatarPhoneCall = contatos.telefone;
        });
      }
    }
    setState(() {
      tamanhoText3 = 0.15;
      corNumer3 = Colors.yellow;
      Timer(const Duration(milliseconds: 500), () {
        setState(() {
          tamanhoText3 = 0.10;
          corNumer3 = Colors.green;
        });
      });
    });
  }

  void funcao4() {
    setState(() {
      idContato = 4;
      ativo = true;
      avatarPhone = '';
      avatarIcon = 'assets/personIcon.png';
      avatarNome = '';
      avatarPhoneCall = '';
    });
    for (Contato contatos in Contato.repository) {
      if (contatos.id == '4') {
        setState(() {
          ativo = false;
          avatarNome = 'Nome: ${contatos.nome}';
          avatarPhone = 'Telefone: ${contatos.telefone}';
          avatarIcon = contatos.avatar;
          avatarPhoneCall = contatos.telefone;
        });
      }
    }
    setState(() {
      tamanhoText4 = 0.15;
      corNumer4 = Colors.yellow;
      Timer(const Duration(milliseconds: 500), () {
        setState(() {
          tamanhoText4 = 0.10;
          corNumer4 = Colors.green;
        });
      });
    });
  }

  void funcao5() {
    setState(() {
      idContato = 5;
      ativo = true;
      avatarPhone = '';
      avatarIcon = 'assets/personIcon.png';
      avatarNome = '';
      avatarPhoneCall = '';
    });
    for (Contato contatos in Contato.repository) {
      if (contatos.id == '5') {
        setState(() {
          ativo = false;
          avatarNome = 'Nome: ${contatos.nome}';
          avatarPhone = 'Telefone: ${contatos.telefone}';
          avatarIcon = contatos.avatar;
          avatarPhoneCall = contatos.telefone;
        });
      }
    }
    setState(() {
      tamanhoText5 = 0.15;
      corNumer5 = Colors.yellow;
      Timer(const Duration(milliseconds: 500), () {
        setState(() {
          tamanhoText5 = 0.10;
          corNumer5 = Colors.green;
        });
      });
    });
  }

  void funcao6() {
    setState(() {
      idContato = 6;
      ativo = true;
      avatarPhone = '';
      avatarIcon = 'assets/personIcon.png';
      avatarNome = '';
      avatarPhoneCall = '';
    });
    for (Contato contatos in Contato.repository) {
      if (contatos.id == '6') {
        setState(() {
          ativo = false;
          avatarNome = 'Nome: ${contatos.nome}';
          avatarPhone = 'Telefone: ${contatos.telefone}';
          avatarIcon = contatos.avatar;
          avatarPhoneCall = contatos.telefone;
        });
      }
    }
    setState(() {
      tamanhoText6 = 0.15;
      corNumer6 = Colors.yellow;
      Timer(const Duration(milliseconds: 500), () {
        setState(() {
          tamanhoText6 = 0.10;
          corNumer6 = Colors.green;
        });
      });
    });
  }

  void funcao7() {
    setState(() {
      idContato = 7;
      ativo = true;
      avatarPhone = '';
      avatarIcon = 'assets/personIcon.png';
      avatarNome = '';
      avatarPhoneCall = '';
    });
    for (Contato contatos in Contato.repository) {
      if (contatos.id == '7') {
        setState(() {
          ativo = false;
          avatarNome = 'Nome: ${contatos.nome}';
          avatarPhone = 'Telefone: ${contatos.telefone}';
          avatarIcon = contatos.avatar;
          avatarPhoneCall = contatos.telefone;
        });
      }
    }
    setState(() {
      tamanhoText7 = 0.15;
      corNumer7 = Colors.yellow;
      Timer(const Duration(milliseconds: 500), () {
        setState(() {
          tamanhoText7 = 0.10;
          corNumer7 = Colors.green;
        });
      });
    });
  }

  void funcao8() {
    setState(() {
      idContato = 8;
      ativo = true;
      avatarPhone = '';
      avatarIcon = 'assets/personIcon.png';
      avatarNome = '';
      avatarPhoneCall = '';
    });
    for (Contato contatos in Contato.repository) {
      if (contatos.id == '8') {
        setState(() {
          ativo = false;
          avatarNome = 'Nome: ${contatos.nome}';
          avatarPhone = 'Telefone: ${contatos.telefone}';
          avatarIcon = contatos.avatar;
          avatarPhoneCall = contatos.telefone;
        });
      }
    }
    setState(() {
      tamanhoText8 = 0.15;
      corNumer8 = Colors.yellow;
      Timer(const Duration(milliseconds: 500), () {
        setState(() {
          tamanhoText8 = 0.10;
          corNumer8 = Colors.green;
        });
      });
    });
  }

  void funcao9() {
    setState(() {
      idContato = 9;
      ativo = true;
      avatarPhone = '';
      avatarIcon = 'assets/personIcon.png';
      avatarNome = '';
      avatarPhoneCall = '';
    });
    for (Contato contatos in Contato.repository) {
      if (contatos.id == '9') {
        setState(() {
          ativo = false;
          avatarNome = 'Nome: ${contatos.nome}';
          avatarPhone = 'Telefone: ${contatos.telefone}';
          avatarIcon = contatos.avatar;
          avatarPhoneCall = contatos.telefone;
        });
      }
    }
    setState(() {
      tamanhoText9 = 0.15;
      corNumer9 = Colors.yellow;
      Timer(const Duration(milliseconds: 500), () {
        setState(() {
          tamanhoText9 = 0.10;
          corNumer9 = Colors.green;
        });
      });
    });
  }
}
