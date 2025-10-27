import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:patos_teste/controllers/patos_manager.dart';
import 'package:patos_teste/main.dart';
import 'package:flutter/material.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  final patosEncontrados = PatosGlobalManager().patosEncontrados;
  bool usarSistemaImperial = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: const Text('Catalogação de Patos'),
      ),
      body: patosEncontrados.isEmpty
          ? const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Text(
                  "Nenhum pato encontrado. Navegue com o drone para encontrar...",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: patosEncontrados.length,
              itemBuilder: (context, index) {
                final pato = patosEncontrados[index];

                final peso = usarSistemaImperial
                    ? pato.peso * 0.00220462
                    : pato.peso;
                final unidadePeso = usarSistemaImperial ? 'lb' : 'g';

                final altura = usarSistemaImperial
                    ? pato.altura * 0.0328084
                    : pato.altura;
                final unidadeAltura = usarSistemaImperial ? 'ft' : 'cm';

                final precisao = usarSistemaImperial
                    ? pato.localizacao.precisao * 1.0936133333333
                    : pato.localizacao.precisao;
                final unidadePrecisao = usarSistemaImperial ? 'yd' : 'm';

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundColor: _getStatusColor(pato.status),
                      child: const Icon(Icons.badge, color: Colors.white),
                    ),
                    title: Text('Pato ${pato.id}'),
                    subtitle: Text(
                      '${pato.localizacao.cidade}, ${pato.localizacao.pais}',
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 200,
                                  height: 200,
                                  child: Card(
                                    child: Flutter3DViewer(
                                      src: 'assets/pato.glb',
                                      activeGestureInterceptor: false,
                                      onProgress: (p) => debugPrint(
                                        'model loading progress : $p',
                                      ),
                                      onLoad: (address) {
                                        debugPrint('model loaded : $address');
                                      },
                                      onError: (error) => debugPrint(
                                        'model failed to load : $error',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(height: 16),
                            Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      usarSistemaImperial =
                                          !usarSistemaImperial;
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: usarSistemaImperial
                                            ? [
                                                Colors.red.shade400,
                                                Colors.red.shade600,
                                              ]
                                            : [
                                                Colors.blue.shade400,
                                                Colors.blue.shade600,
                                              ],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              (usarSistemaImperial
                                                      ? Colors.red
                                                      : Colors.blue)
                                                  .withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          usarSistemaImperial
                                              ? Icons.flag
                                              : Icons.straighten,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          usarSistemaImperial
                                              ? 'Sistema Imperial (US)'
                                              : 'Sistema Métrico (SI)',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        const Icon(
                                          Icons.swap_horiz,
                                          color: Colors.white70,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            _buildInfoSection('Dados do Drone', [
                              'Série: ${pato.drone.numeroSerie}',
                              'Marca: ${pato.drone.marca}',
                              'Fabricante: ${pato.drone.fabricante}',
                              'País: ${pato.drone.paisOrigem}',
                            ]),
                            const Divider(),
                            _buildInfoSection('Características Físicas', [
                              'Altura: ${altura.toStringAsFixed(2)} $unidadeAltura',
                              'Peso: ${(peso).toStringAsFixed(2)} $unidadePeso',
                              'Mutações: ${pato.quantidadeMutacoes}',
                            ]),
                            const Divider(),
                            _buildInfoSection('Localização', [
                              'GPS: ${pato.localizacao.latitude.toStringAsFixed(4)}, ${pato.localizacao.longitude.toStringAsFixed(4)}',
                              'Precisão: ${precisao.toStringAsFixed(2)} $unidadePrecisao',
                              if (pato.localizacao.pontoReferencia != null)
                                'Referência: ${pato.localizacao.pontoReferencia}',
                            ]),
                            const Divider(),
                            _buildInfoSection('Status', [
                              'Estado: ${_getStatusText(pato.status)}',
                              if (pato.batimentosCardiacos != null)
                                'Batimentos: ${pato.batimentosCardiacos} bpm',
                            ]),
                            if (pato.superPoder != null) ...[
                              const Divider(),
                              _buildInfoSection('Super-Poder', [
                                '⚡ ${pato.superPoder!.nome}',
                                pato.superPoder!.descricao,
                                'Classificações: ${pato.superPoder!.classificacoes.join(", ")}',
                              ]),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildInfoSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 4),
            child: Text(item),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(StatusHibernacao status) {
    switch (status) {
      case StatusHibernacao.desperto:
        return Colors.red;
      case StatusHibernacao.transe:
        return Colors.orange;
      case StatusHibernacao.hibernacaoProfunda:
        return Colors.green;
    }
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
}
