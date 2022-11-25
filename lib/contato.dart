class Contato {
  String id;
  String nome;
  String telefone;
  dynamic avatar;
  Contato({
    required this.id,
    required this.nome,
    required this.telefone,
    this.avatar = 'assets/personIcon.png',
  });
  static List<Contato> repository = [];
  static Map<String, dynamic> toMap = {};
}
