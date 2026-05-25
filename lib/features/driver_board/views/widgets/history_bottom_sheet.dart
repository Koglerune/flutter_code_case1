import 'package:flutter/material.dart';
import '../../models/driver_model.dart';

class HistoryBottomSheet extends StatelessWidget {
  final Driver driver;

  const HistoryBottomSheet({super.key, required this.driver});

  Map<String, List<HistoryEntry>> _groupHistoryByDate() {
    final Map<String, List<HistoryEntry>> grouped = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    for (var entry in (driver.history ?? [])) {
      final entryDate = DateTime(entry.timestamp.year, entry.timestamp.month, entry.timestamp.day);
      String key;

      if (entryDate == today) {
        key = "BUGÜN";
      } else if (entryDate == yesterday) {
        key = "DÜN";
      } else {
        key = "${entryDate.day.toString().padLeft(2, '0')}.${entryDate.month.toString().padLeft(2, '0')}.${entryDate.year}";
      }

      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]!.add(entry);
    }
    return grouped;
  }

  Color _getStatusColor(String statusText) {
    if (statusText == "Boşta") return Colors.grey;
    if (statusText == "Yük Bekliyor") return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final groupedHistory = _groupHistoryByDate();
    final totalCount = driver.history?.length ?? 0;
    final subtitleColor = isDark ? Colors.grey.shade400 : Colors.grey.shade600;

    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 24, right: 24, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2)),
            ),
          ),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Geçmiş", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(driver.name, style: TextStyle(fontSize: 15, color: subtitleColor)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2C2C2E) : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text("$totalCount kayıt", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: subtitleColor)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          Expanded(
            child: groupedHistory.isEmpty
                ? const Center(child: Text("Geçmiş kaydı bulunmamaktadır."))
                : ListView.builder(
                    itemCount: groupedHistory.keys.length,
                    itemBuilder: (context, index) {
                      final dateKey = groupedHistory.keys.elementAt(index);
                      final entries = groupedHistory[dateKey]!;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 4, bottom: 12),
                              child: Text(
                                "$dateKey  ·  ${entries.length} kayıt",
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: subtitleColor, letterSpacing: 0.5),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF2C2C2E) : Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: isDark ? Colors.white12 : Colors.grey.shade200),
                              ),
                              child: Column(
                                children: entries.map((entry) {
                                  return ListTile(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                    leading: Container(
                                      width: 12, height: 12,
                                      decoration: BoxDecoration(
                                        color: _getStatusColor(entry.statusText),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    minLeadingWidth: 12,
                                    title: Text(entry.statusText, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                    trailing: Text(
                                      "${entry.timestamp.hour.toString().padLeft(2, '0')}:${entry.timestamp.minute.toString().padLeft(2, '0')}",
                                      style: TextStyle(fontSize: 14, color: subtitleColor),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}