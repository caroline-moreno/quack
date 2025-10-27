import 'package:patos_teste/main.dart';
import 'package:patos_teste/models/drone_info.dart';
import 'package:patos_teste/models/localizacao.dart';
import 'package:patos_teste/models/super_poder.dart';

class PatoPrimordial {
  String id;
  DroneInfo drone;
  double altura;
  double peso;
  Localizacao localizacao;
  StatusHibernacao status;
  int? batimentosCardiacos;
  int quantidadeMutacoes;
  SuperPoder? superPoder;

  PatoPrimordial({
    required this.id,
    required this.drone,
    required this.altura,
    required this.peso,
    required this.localizacao,
    required this.status,
    this.batimentosCardiacos,
    required this.quantidadeMutacoes,
    this.superPoder,
  });
}
