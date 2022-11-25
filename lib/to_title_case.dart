extension StringExtension on String {
  String toTitleCase() {
    List<String> string = split(' ');
    List<String> pronto = [];
    while (string.contains('')) {
      string.remove('');
    }
    for (String fatia in string) {
      String parte = fatia.replaceFirst(fatia[0], fatia[0].toUpperCase());
      pronto.add(parte);
    }
    return pronto.join(' ');
  }
}
