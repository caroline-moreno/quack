import 'package:patos_teste/pages/Analysis.dart';
import 'package:patos_teste/pages/catalog.dart';
import 'package:patos_teste/pages/drone_map.dart';
import 'package:patos_teste/pages/operation.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: const Text('Operação Patos Primordiais'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    _buildMissionCard(
                      context,
                      title: 'Controle do Drone',
                      description:
                          'Pilote o drone e explore o mapa em busca de Patos Primordiais',
                      icon: Icons.flight,
                      color: Colors.cyan,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DroneMapPage(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildMissionCard(
                      context,
                      title: 'Catalogação',
                      description:
                          'Catalogar informações sobre Patos Primordiais',
                      icon: Icons.library_books,
                      color: Colors.green,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CatalogPage(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildMissionCard(
                      context,
                      title: 'Análise Operacional',
                      description:
                          'Calcular custos, riscos e viabilidade de captura',
                      icon: Icons.analytics,
                      color: Colors.orange,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AnalysisPage(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildMissionCard(
                      context,
                      title: 'Operação de Captura',
                      description:
                          'Controlar o drone de combate e capturar os Patos Primordiais',
                      icon: Icons.military_tech,
                      color: Colors.red,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OperationPage(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMissionCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 40, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
    );
  }
}
