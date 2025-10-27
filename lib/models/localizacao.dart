class Localizacao {
  String cidade;
  String pais;
  double latitude;
  double longitude;
  double precisao; 
  String? pontoReferencia;

  Localizacao({
    required this.cidade,
    required this.pais,
    required this.latitude,
    required this.longitude,
    required this.precisao,
    this.pontoReferencia,
  });
}
