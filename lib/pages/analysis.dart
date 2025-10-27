import 'package:patos_teste/controllers/patos_manager.dart';
import 'package:patos_teste/main.dart';
import 'package:flutter/material.dart';

class AnalysisPage extends StatefulWidget {
  const AnalysisPage({super.key});

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  final patosEncontrados = PatosGlobalManager().patosEncontrados;
  List<String> filtros = ['Todos', 'Alto Risco', 'Viável'];
  String filtro = 'Todos';

  double calcularCusto(double altura, double peso, int mutacoes) {
    const alturaMin = 50;
    const alturaMax = 500;
    const pesoMin = 5000;
    const pesoMax = 100000;
    const mutacoesMax = 10;

    double alturaNorm = (altura - alturaMin) / (alturaMax - alturaMin);
    double pesoNorm = (peso - pesoMin) / (pesoMax - pesoMin);
    double mutacoesNorm = mutacoes / mutacoesMax;

    alturaNorm = alturaNorm.clamp(0, 1);
    pesoNorm = pesoNorm.clamp(0, 1);
    mutacoesNorm = mutacoesNorm.clamp(0, 1);

    double custo =
        (pesoNorm * 0.5 + alturaNorm * 0.3 + mutacoesNorm * 0.2) * 10;

    return custo.clamp(0, 10);
  }

  double calcularRisco(StatusHibernacao status, int batidas) {
    double mult;
    switch (status) {
      case StatusHibernacao.hibernacaoProfunda:
        mult = 0.2;
        break;
      case StatusHibernacao.transe:
        mult = 0.5;
        break;
      case StatusHibernacao.desperto:
        mult = 1.0;
        break;
    }

    double batidaNorm = ((batidas - 20) / (200 - 20)).clamp(0.0, 1.0);
    double risco = ((mult + batidaNorm) / 2) * 10;
    return risco.clamp(0, 10);
  }

  double calcularPoderioMilitar(double risco, String superPoder) {
    double multiplicador;

    switch (superPoder.toLowerCase()) {
      case 'fraco':
        multiplicador = 0.8;
        break;
      case 'medio':
        multiplicador = 1.0;
        break;
      case 'forte':
        multiplicador = 1.2;
        break;
      default:
        multiplicador = 1.0;
    }

    double poderio = (risco / 10) * multiplicador * 10;
    return poderio.clamp(0, 10);
  }

  double calcularGanhoConhecimento(int mutacoes) {
    double valorNorm = mutacoes / 9;
    return (valorNorm * 10).clamp(0, 10);
  }

  double calcularViabilidade(
    double custoOperacional,
    double poderioMilitar,
    double grauRisco,
    double ganhoConhecimento,
  ) {
    return ((custoOperacional * 2) +
            poderioMilitar +
            (grauRisco * 2) +
            ganhoConhecimento) /
        6;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: const Text('Análise Operacional'),
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
          : Column(
              children: [
                Column(
                  children: [
                    Container(height: 8),
                    Row(
                      children: [
                        Container(width: 16),
                        Icon(Icons.filter_list, color: Colors.grey[600]),
                        const SizedBox(width: 8),
                        const Text("Filtrar", style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    Container(height: 8),
                    Row(
                      children: [
                        Container(width: 16),
                        for (String f in filtros)
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: ChoiceChip(
                              label: Text(f),
                              selected: filtro == f,
                              onSelected: (selected) {
                                setState(() {
                                  filtro = f;
                                });
                              },
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: patosEncontrados.length,
                    itemBuilder: (context, index) {
                      final pato = patosEncontrados[index];

                      double custoOperacional = calcularCusto(
                        pato.altura,
                        pato.peso,
                        pato.quantidadeMutacoes,
                      );

                      double grauRisco = calcularRisco(
                        pato.status,
                        pato.batimentosCardiacos ?? 0,
                      );

                      double poderioMilitar = calcularPoderioMilitar(
                        grauRisco,
                        pato.superPoder?.nivel ?? 'medio',
                      );

                      double ganhoConhecimento = calcularGanhoConhecimento(
                        pato.quantidadeMutacoes,
                      );

                      double viabilidade = calcularViabilidade(
                        custoOperacional,
                        poderioMilitar,
                        grauRisco,
                        ganhoConhecimento,
                      );

                      if (filtro == 'Todos' ||
                          (filtro == 'Viável' && viabilidade > 5) ||
                          (filtro == 'Alto Risco' && viabilidade <= 5)) {
                        return _buildAnalysisCard(
                          pato.id,
                          custoOperacional: custoOperacional,
                          poderioMilitar: poderioMilitar,
                          grauRisco: grauRisco,
                          ganhoConhecimento: ganhoConhecimento,
                          viabilidade: viabilidade,
                          context: context,
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildAnalysisCard(
    String id, {
    required double custoOperacional,
    required double poderioMilitar,
    required double grauRisco,
    required double ganhoConhecimento,
    required double viabilidade,
    required BuildContext context,
  }) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Pato $id', style: Theme.of(context).textTheme.titleLarge),
                Chip(
                  label: Text(
                    viabilidade > 5 ? 'VIÁVEL' : 'ALTO RISCO',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  backgroundColor: viabilidade > 5 ? Colors.green : Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildMetricBar('Custo Operacional', custoOperacional, Colors.blue),
            _buildMetricBar('Poderio Militar', poderioMilitar, Colors.orange),
            _buildMetricBar('Grau de Risco', grauRisco, Colors.red),
            _buildMetricBar(
              'Ganho em Conhecimento',
              ganhoConhecimento,
              Colors.green,
            ),
            const SizedBox(height: 8),
            _buildMetricBar('Viabilidade Geral', viabilidade, Colors.purple),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricBar(String label, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(label), Text('${value.toStringAsFixed(1)}/10')],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: value / 10,
            backgroundColor: Colors.grey[300],
            color: color,
            minHeight: 8,
          ),
        ],
      ),
    );
  }
}
