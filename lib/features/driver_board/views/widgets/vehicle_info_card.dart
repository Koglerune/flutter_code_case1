import 'package:flutter/material.dart';

class VehicleInfoCard extends StatelessWidget {
  final String truckName;
  const VehicleInfoCard({super.key, required this.truckName});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subtitleColor = isDark ? Colors.grey.shade400 : Colors.grey.shade700;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isDark ? Colors.transparent : Colors.white,
        border: Border.all(
          color: isDark ? Colors.white24 : Colors.grey.shade300,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("ARAÇ", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: subtitleColor, letterSpacing: 0.5)),
          const SizedBox(height: 6),
          Text(truckName.toUpperCase(), style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
        ],
      ),
    );
  }
}