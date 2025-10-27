import 'dart:async';
import 'dart:math';
import 'package:patos_teste/main.dart';
import 'package:patos_teste/models/drone_info.dart';
import 'package:patos_teste/models/localizacao.dart';
import 'package:patos_teste/models/pato_primordial.dart';
import 'package:patos_teste/models/super_poder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PatosGlobalManager {
  LatLng dronePosition = const LatLng(-23.5475, -46.6361);

  static final PatosGlobalManager _instance = PatosGlobalManager._internal();
  factory PatosGlobalManager() => _instance;
  PatosGlobalManager._internal();

  final List<PatoPrimordial> _todosOsPatos = [];
  final Set<String> _patosEncontrados = {};
  final StreamController<void> _updateController = StreamController.broadcast();

  Stream<void> get updateStream => _updateController.stream;

  List<PatoPrimordial> get todosOsPatos => _todosOsPatos;
  List<PatoPrimordial> get patosEncontrados =>
      _todosOsPatos.where((p) => _patosEncontrados.contains(p.id)).toList();

  bool isEncontrado(String id) => _patosEncontrados.contains(id);

  void marcarComoEncontrado(String id) {
    _patosEncontrados.add(id);
    _updateController.add(null);
  }

  void inicializarPatos() {
    if (_todosOsPatos.isNotEmpty) return;

    final random = Random();
    final localizacoes = [
      {
        'cidade': 'São Paulo',
        'pais': 'Brasil',
        'lat': -23.5505,
        'lng': -46.6333,
      },
      {
        'cidade': 'São Paulo',
        'pais': 'Brasil',
        'lat': -23.5629,
        'lng': -46.6544,
      },
      {
        'cidade': 'São Paulo',
        'pais': 'Brasil',
        'lat': -23.5856,
        'lng': -46.6745,
      },
      {
        'cidade': 'São Paulo',
        'pais': 'Brasil',
        'lat': -23.5489,
        'lng': -46.6388,
      },
      {
        'cidade': 'São Paulo',
        'pais': 'Brasil',
        'lat': -23.5640,
        'lng': -46.6890,
      },
      {
        'cidade': 'São Paulo',
        'pais': 'Brasil',
        'lat': -23.6107,
        'lng': -46.6970,
      },
      {
        'cidade': 'São Paulo',
        'pais': 'Brasil',
        'lat': -23.5100,
        'lng': -46.6240,
      },
      {
        'cidade': 'São Paulo',
        'pais': 'Brasil',
        'lat': -23.6470,
        'lng': -46.6360,
      },
      {
        'cidade': 'São Paulo',
        'pais': 'Brasil',
        'lat': -23.5010,
        'lng': -46.7230,
      },
      {
        'cidade': 'São Paulo',
        'pais': 'Brasil',
        'lat': -23.5692,
        'lng': -46.7590,
      },
    ];

    final superPoderes = [
      SuperPoder(
        nome: 'Tempestade Elétrica',
        descricao: 'Gera descargas elétricas em área',
        nivel: 'forte',
        classificacoes: ['bélico', 'raro', 'alto risco de curto-circuito'],
      ),
      SuperPoder(
        nome: 'Laser Ocular',
        descricao: 'Dispara feixes de energia pelos olhos',
        nivel: 'medio',
        classificacoes: ['bélico', 'precisão', 'alto dano'],
      ),
      SuperPoder(
        nome: 'Manipulação de Água',
        descricao: 'Controla corpos d\'água e umidade',
        nivel: 'medio',
        classificacoes: ['elementar', 'versátil', 'médio alcance'],
      ),
      SuperPoder(
        nome: 'Telecinese',
        descricao: 'Move objetos com o poder da mente',
        nivel: 'forte',
        classificacoes: ['psíquico', 'versátil', 'alto controle'],
      ),
      SuperPoder(
        nome: 'Manipulação de Gelo',
        descricao: 'Congela área ao redor',
        nivel: 'fraco',
        classificacoes: ['elementar', 'controle de área', 'baixa temperatura'],
      ),
    ];

    for (int i = 0; i < 10; i++) {
      final loc = localizacoes[i];
      final status = StatusHibernacao.values[random.nextInt(3)];

      _todosOsPatos.add(
        PatoPrimordial(
          id: 'PP-${1000 + i}',
          drone: DroneInfo(
            numeroSerie: 'DRN-${random.nextInt(9999)}',
            marca: ['AeroTech', 'SkyScanner', 'DroneX'][random.nextInt(3)],
            fabricante: ['TechCorp', 'AeroIndustries'][random.nextInt(2)],
            paisOrigem: random.nextBool() ? 'Brasil' : 'EUA',
          ),
          altura: 150 + random.nextDouble() * (175 - 150),
          peso: 50000 + random.nextDouble() * (90000 - 50000),
          localizacao: Localizacao(
            cidade: loc['cidade'] as String,
            pais: loc['pais'] as String,
            latitude: loc['lat'] as double,
            longitude: loc['lng'] as double,
            precisao: 0.04 + random.nextDouble() * 29.96,
            pontoReferencia: i == 0 ? 'Pico da Neblina' : null,
          ),
          status: status,
          batimentosCardiacos: status != StatusHibernacao.desperto
              ? 20 + random.nextInt(80)
              : null,
          quantidadeMutacoes: random.nextInt(10),
          superPoder: status == StatusHibernacao.desperto
              ? superPoderes[random.nextInt(superPoderes.length)]
              : null,
        ),
      );
    }
  }

  void dispose() {
    _updateController.close();
  }
}
