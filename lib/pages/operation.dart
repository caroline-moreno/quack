import 'package:flutter/material.dart';

class OperationPage extends StatefulWidget {
  const OperationPage({super.key});

  @override
  State<OperationPage> createState() => _OperationPageState();
}

class _OperationPageState extends State<OperationPage> {
  int _index = 1;
  double _bateria = 100;
  double _combustivel = 100;
  double _integridade = 100;
  double _altitude = 0;
  bool _emMissao = false;
  bool _btnAtivo = true;
  String _statusMissao = 'Aguardando ordens...';

  void finalizarMissao() {
    if (_bateria < 0) {
      _bateria = 0;
    }

    if (_combustivel < 0) {
      _combustivel = 0;
    }

    if (_integridade < 0) {
      _integridade = 0;
    }

    setState(() {
      _statusMissao = 'Falha no drone. Missão abortada.';
      _emMissao = false;
      _altitude = 0;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && !_emMissao) {
        setState(() {
          _statusMissao = 'Alterando para o próximo drone...';
        });
      }
    });

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted && !_emMissao) {
        setState(() {
          _statusMissao = 'Aguardando ordens...';

          _bateria = 100;
          _combustivel = 100;
          _integridade = 100;

          _index++;
          _btnAtivo = true;
        });
      }
    });
  }

  void _iniciarMissao() {
    setState(() {
      _emMissao = true;
      _btnAtivo = false;
      _statusMissao = 'Decolando...';
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && _emMissao) {
        setState(() {
          _altitude = 100;
          _statusMissao = 'Voando para o alvo...';
          _combustivel -= 10;

          if (_combustivel <= 0 || _bateria <= 0 || _integridade <= 0) {
            finalizarMissao();
            return;
          }
        });
      }
    });

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted && _emMissao) {
        setState(() {
          _statusMissao = 'Alvo detectado! Iniciando análise...';
          _bateria -= 15;

          if (_combustivel <= 0 || _bateria <= 0 || _integridade <= 0) {
            finalizarMissao();
            return;
          }
        });
      }
    });

    Future.delayed(const Duration(seconds: 6), () {
      if (mounted && _emMissao) {
        setState(() {
          _statusMissao = 'Ponto fraco identificado: região dorsal!';
        });
      }
    });

    Future.delayed(const Duration(seconds: 8), () {
      if (mounted && _emMissao) {
        setState(() {
          _statusMissao =
              'Iniciando ataque estratégico: Arpão magnético no dorso';
          _integridade -= 10;
          _bateria -= 10;

          if (_combustivel <= 0 || _bateria <= 0 || _integridade <= 0) {
            finalizarMissao();
            return;
          }
        });
      }
    });

    Future.delayed(const Duration(seconds: 8), () {
      if (mounted && _emMissao) {
        setState(() {
          _statusMissao = 'Iniciando ataque estratégico...';
          _integridade -= 5;
          _bateria -= 10;

          if (_combustivel <= 0 || _bateria <= 0 || _integridade <= 0) {
            finalizarMissao();
            return;
          }
        });
      }
    });

    Future.delayed(const Duration(seconds: 10), () {
      if (mounted && _emMissao) {
        setState(() {
          _statusMissao = 'Captura bem-sucedida! Retornando à base...';
          _combustivel -= 15;
          _altitude = 0;

          if (_combustivel <= 0 || _bateria <= 0 || _integridade <= 0) {
            finalizarMissao();
            return;
          }
        });
      }
    });

    Future.delayed(const Duration(seconds: 12), () {
      if (mounted && _emMissao) {
        setState(() {
          _emMissao = false;
          _statusMissao = 'Missão concluída com sucesso!';
          _btnAtivo = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: const Text('Operação de Captura'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              color: Colors.black87,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'DRONE DE COMBATE X-$_index',
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildStatusBar(
                      'Bateria',
                      _bateria,
                      Icons.battery_full,
                      Colors.green,
                    ),
                    _buildStatusBar(
                      'Combustível',
                      _combustivel,
                      Icons.local_gas_station,
                      Colors.blue,
                    ),
                    _buildStatusBar(
                      'Integridade física',
                      _integridade,
                      Icons.shield,
                      Colors.orange,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.flight, color: Colors.cyanAccent),
                        const SizedBox(width: 8),
                        Text(
                          'Altitude: ${_altitude.toStringAsFixed(0)}m',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Icon(Icons.radar, size: 50, color: Colors.blue),
                      const SizedBox(height: 16),
                      Text(
                        _statusMissao,
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Estratégias Disponíveis:',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        _buildStrategy(
                          'Ataque Aéreo',
                          'Efetivo contra alvos >100cm',
                        ),
                        _buildStrategy(
                          'Defesa Aleatória',
                          'Sistema SGDA ativado',
                        ),
                        _buildStrategy(
                          'Análise Térmica',
                          'Detecta pontos fracos',
                        ),
                        _buildStrategy(
                          'Rede de Contenção',
                          'Para alvos em transe',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: !_btnAtivo ? null : _iniciarMissao,
                icon: Icon(
                  !_btnAtivo ? Icons.hourglass_empty : Icons.rocket_launch,
                ),
                label: Text(
                  !_btnAtivo ? 'MISSÃO EM ANDAMENTO' : 'INICIAR MISSÃO',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBar(
    String label,
    double value,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(label, style: const TextStyle(color: Colors.white)),
                    Text(
                      '${value.toStringAsFixed(0)}%',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: value / 100,
                  backgroundColor: Colors.grey[800],
                  color: color,
                  minHeight: 8,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStrategy(String title, String description) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(Icons.military_tech, color: Colors.blue),
        title: Text(title),
        subtitle: Text(description),
        dense: true,
      ),
    );
  }
}
