import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:patos_teste/controllers/patos_manager.dart';
import 'package:patos_teste/main.dart';
import 'package:patos_teste/models/pato_primordial.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class DroneMapPage extends StatefulWidget {
  const DroneMapPage({super.key});

  @override
  State<DroneMapPage> createState() => _DroneMapPageState();
}

class _DroneMapPageState extends State<DroneMapPage> {
  GoogleMapController? _mapController;
  final double _droneSpeed = 0.0001;
  final double _detectionRadius = 0.002;
  Set<Marker> _markers = {};
  int _patosEncontradosCount = 0;

  Timer? _movementTimer;
  double _joystickX = 0.0;
  double _joystickY = 0.0;

  String plataforma = 'ios';

  @override
  void initState() {
    super.initState();
    PatosGlobalManager().inicializarPatos();

    _selecionarPlataforma();
    _createMarkers();
    _updatePatosCount();

    PatosGlobalManager().updateStream.listen((_) {
      if (mounted) {
        _updatePatosCount();
        _createMarkers();
      }
    });
  }

  @override
  void dispose() {
    _movementTimer?.cancel();
    super.dispose();
  }

  void _updatePatosCount() {
    setState(() {
      _patosEncontradosCount = PatosGlobalManager().patosEncontrados.length;
    });
  }

  void _selecionarPlataforma() {
    if (Platform.isIOS) {
      plataforma = 'ios';
    } else if (Platform.isAndroid) {
      plataforma = 'android';
    }

    setState(() {});
  }

  Future<void> _createMarkers() async {
    final manager = PatosGlobalManager();
    final markers = <Marker>{};

    markers.add(
      Marker(
        markerId: const MarkerId('drone'),
        position: PatosGlobalManager().dronePosition,
        icon: await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(size: Size(48, 48)),
          'assets/$plataforma/drone.png',
        ),
        infoWindow: const InfoWindow(title: 'Seu Drone'),
      ),
    );

    for (var pato in manager.todosOsPatos) {
      String path = 'assets/$plataforma/desaparecido.png';
      final isEncontrado = manager.isEncontrado(pato.id);

      if (isEncontrado) {
        path = 'assets/$plataforma/encontrado.png';
      } else {
        path = 'assets/$plataforma/desaparecido.png';
      }

      final location = LatLng(
        pato.localizacao.latitude,
        pato.localizacao.longitude,
      );

      markers.add(
        Marker(
          markerId: MarkerId(pato.id),
          position: location,
          icon: await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(48, 48)),
            path,
          ),
          infoWindow: InfoWindow(
            title: isEncontrado ? '🦆 ${pato.id}' : '❓ Pato Desconhecido',
            snippet: isEncontrado
                ? '${pato.localizacao.cidade}, ${pato.localizacao.pais}'
                : 'Aproxime-se para descobrir',
          ),
          onTap: () {
            if (isEncontrado) {
              _showPatoDetails(pato);
            }
          },
        ),
      );
    }

    setState(() {
      _markers = markers;
    });
  }

  void _startMovement() {
    _movementTimer?.cancel();
    _movementTimer = Timer.periodic(const Duration(milliseconds: 75), (timer) {
      if (_joystickX != 0 || _joystickY != 0) {
        _moveDrone(_joystickY * _droneSpeed, _joystickX * _droneSpeed);
      }
    });
  }

  void _stopMovement() {
    _movementTimer?.cancel();
    setState(() {
      _joystickX = 0.0;
      _joystickY = 0.0;
    });
  }

  void _moveDrone(double latDelta, double lngDelta) {
    setState(() {
      PatosGlobalManager().dronePosition = LatLng(
        PatosGlobalManager().dronePosition.latitude + latDelta,
        PatosGlobalManager().dronePosition.longitude + lngDelta,
      );
    });

    _mapController?.animateCamera(
      CameraUpdate.newLatLng(PatosGlobalManager().dronePosition),
      duration: Duration(milliseconds: 10),
    );

    _checkForNearbyPatos();
    _createMarkers();
  }

  void _checkForNearbyPatos() {
    final manager = PatosGlobalManager();

    for (var pato in manager.todosOsPatos) {
      if (manager.isEncontrado(pato.id)) continue;

      final distance = _calculateDistance(
        PatosGlobalManager().dronePosition.latitude,
        PatosGlobalManager().dronePosition.longitude,
        pato.localizacao.latitude,
        pato.localizacao.longitude,
      );

      if (distance <= _detectionRadius) {
        manager.marcarComoEncontrado(pato.id);
        _showDiscoveryDialog(pato);
        break;
      }
    }
  }

  double _calculateDistance(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    return sqrt(pow(lat2 - lat1, 2) + pow(lng2 - lng1, 2));
  }

  void _showDiscoveryDialog(PatoPrimordial pato) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.celebration, color: Colors.amber),
            SizedBox(width: 8),
            Text('Pato Descoberto!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ID: ${pato.id}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Localização: ${pato.localizacao.cidade}, ${pato.localizacao.pais}',
            ),
            Text('Status: ${_getStatusText(pato.status)}'),
            Text('Mutações: ${pato.quantidadeMutacoes}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Continuar Explorando'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showPatoDetails(pato);
            },
            child: const Text('Ver Detalhes'),
          ),
        ],
      ),
    );
  }

  void _showPatoDetails(PatoPrimordial pato) {
    bool usarSistemaImperial = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          final peso = usarSistemaImperial ? pato.peso * 0.00220462 : pato.peso;
          final unidadePeso = usarSistemaImperial ? 'lb' : 'g';

          final altura = usarSistemaImperial
              ? pato.altura * 0.0328084
              : pato.altura;
          final unidadeAltura = usarSistemaImperial ? 'ft' : 'cm';

          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('Pato ${pato.id}')],
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Características Físicas',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    'Altura',
                    '${altura.toStringAsFixed(2)} $unidadeAltura',
                  ),
                  _buildDetailRow(
                    'Peso',
                    '${peso.toStringAsFixed(2)} $unidadePeso',
                  ),
                  _buildDetailRow('Mutações', '${pato.quantidadeMutacoes}'),
                  _buildDetailRow('Status', _getStatusText(pato.status)),
                  if (pato.batimentosCardiacos != null)
                    _buildDetailRow('BPM', '${pato.batimentosCardiacos}'),

                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),
                  const Text(
                    'Drone Responsável',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow('Série', pato.drone.numeroSerie),
                  _buildDetailRow('Marca', pato.drone.marca),
                  _buildDetailRow('Fabricante', pato.drone.fabricante),
                  _buildDetailRow('País', pato.drone.paisOrigem),

                  if (pato.superPoder != null) ...[
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),
                    Text(
                      '⚡ ${pato.superPoder!.nome}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.deepOrange,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(pato.superPoder!.descricao),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: pato.superPoder!.classificacoes
                          .map(
                            (c) => Chip(
                              label: Text(
                                c,
                                style: const TextStyle(fontSize: 11),
                              ),
                              backgroundColor: Colors.deepOrange.withOpacity(
                                0.2,
                              ),
                              padding: const EdgeInsets.all(2),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton.icon(
                onPressed: () {
                  setStateDialog(() {
                    usarSistemaImperial = !usarSistemaImperial;
                  });
                },
                icon: const Icon(Icons.swap_horiz),
                label: Text(usarSistemaImperial ? 'Métrico' : 'Imperial'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Fechar'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$label:', style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  String _getStatusText(StatusHibernacao status) {
    switch (status) {
      case StatusHibernacao.desperto:
        return 'Desperto ⚠️';
      case StatusHibernacao.transe:
        return 'Em Transe';
      case StatusHibernacao.hibernacaoProfunda:
        return 'Hibernação Profunda';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: const Text('Controle do Drone'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Encontrados: $_patosEncontradosCount/${PatosGlobalManager().todosOsPatos.length}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: PatosGlobalManager().dronePosition,
              zoom: 13,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
            },
            markers: _markers,
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            zoomGesturesEnabled: true,
          ),
          Positioned(
            bottom: 40,
            right: 40,
            child: JoystickWidget(
              onMove: (x, y) {
                setState(() {
                  _joystickX = x;
                  _joystickY = y;
                });
                if (_movementTimer == null || !_movementTimer!.isActive) {
                  _startMovement();
                }
              },
              onStop: _stopMovement,
            ),
          ),
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Card(
              color: Colors.black87,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'CONTROLE DE DRONE',
                      style: TextStyle(
                        color: Colors.cyanAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Use o joystick para pilotar o drone',
                      style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    ),
                    Text(
                      'Aproxime-se dos marcadores vermelhos para descobrir patos',
                      style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_joystickX != 0 || _joystickY != 0)
            Positioned(
              bottom: 220,
              right: 40,
              child: Card(
                color: Colors.black87,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.speed,
                        color: Colors.cyanAccent,
                        size: 20,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${(sqrt(_joystickX * _joystickX + _joystickY * _joystickY) * 100).toStringAsFixed(0)}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class JoystickWidget extends StatefulWidget {
  final Function(double x, double y) onMove;
  final VoidCallback onStop;

  const JoystickWidget({Key? key, required this.onMove, required this.onStop})
    : super(key: key);

  @override
  State<JoystickWidget> createState() => _JoystickWidgetState();
}

class _JoystickWidgetState extends State<JoystickWidget> {
  double _knobX = 0.0;
  double _knobY = 0.0;
  final double _baseSize = 140.0;
  final double _knobSize = 50.0;

  void _updatePosition(Offset localPosition) {
    final center = Offset(_baseSize / 2, _baseSize / 2);
    final delta = localPosition - center;
    final distance = delta.distance;
    final maxDistance = (_baseSize - _knobSize) / 2;

    if (distance > maxDistance) {
      final angle = atan2(delta.dy, delta.dx);
      _knobX = cos(angle) * maxDistance;
      _knobY = sin(angle) * maxDistance;
    } else {
      _knobX = delta.dx;
      _knobY = delta.dy;
    }

    final normalizedX = _knobX / maxDistance;
    final normalizedY = _knobY / maxDistance;

    setState(() {});
    widget.onMove(normalizedX, -normalizedY);
  }

  void _resetPosition() {
    setState(() {
      _knobX = 0.0;
      _knobY = 0.0;
    });
    widget.onStop();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) => _updatePosition(details.localPosition),
      onPanUpdate: (details) => _updatePosition(details.localPosition),
      onPanEnd: (_) => _resetPosition(),
      onPanCancel: _resetPosition,
      child: Container(
        width: _baseSize,
        height: _baseSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withOpacity(0.3),
          border: Border.all(
            color: Colors.cyanAccent.withOpacity(0.5),
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Container(
                width: _baseSize * 0.7,
                height: 2,
                color: Colors.cyanAccent.withOpacity(0.3),
              ),
            ),
            Center(
              child: Container(
                width: 2,
                height: _baseSize * 0.7,
                color: Colors.cyanAccent.withOpacity(0.3),
              ),
            ),
            Center(
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.cyanAccent.withOpacity(0.5),
                ),
              ),
            ),
            Positioned(
              left: (_baseSize / 2) + _knobX - (_knobSize / 2),
              top: (_baseSize / 2) + _knobY - (_knobSize / 2),
              child: Container(
                width: _knobSize,
                height: _knobSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [Colors.cyanAccent, Colors.blue.shade700],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.cyanAccent.withOpacity(0.6),
                      blurRadius: 15,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: const Icon(Icons.flight, color: Colors.white, size: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
