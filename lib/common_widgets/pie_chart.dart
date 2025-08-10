import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DonutChartScreen extends StatelessWidget {
  const DonutChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Overview')),
      body: Center(
        child: SizedBox(
          width: 320,
          height: 420,
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: PieChart(
                      PieChartData(
                        sections: _buildPieChartSections(),
                        centerSpaceRadius: 50,
                        sectionsSpace: 2,
                        startDegreeOffset: -90,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildLegend(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections() {
    return [
      PieChartSectionData(value: 40, color: Colors.purple.shade700, title: ''),
      PieChartSectionData(value: 30, color: Colors.green, title: ''),
      PieChartSectionData(value: 30, color: Colors.orange.shade400, title: ''),
    ];
  }

  Widget _buildLegend() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLegendItem(Colors.purple.shade700, 'Assigned'),
        const SizedBox(height: 8),
        _buildLegendItem(Colors.green, 'Completed'),
        const SizedBox(height: 8),
        _buildLegendItem(Colors.orange.shade400, 'Remaining'),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(width: 16, height: 16, color: color),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
