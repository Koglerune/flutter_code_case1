import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../providers/driver_provider.dart';
import '../../models/driver_model.dart';
import 'driver_avatar.dart';

class DriverHeader extends ConsumerWidget {
  final Driver driver;
  final List<Driver> drivers;
  final String activeId;

  const DriverHeader({
    super.key,
    required this.driver,
    required this.drivers,
    required this.activeId,
  });

  String _statusText(DriverStatus status) => status == DriverStatus.idle ? "Boşta" : status == DriverStatus.waitingForLoad ? "Yük Bekliyor" : "Seferde";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isHistoryOpen = ref.watch(historyVisibilityProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: DriverAvatar(name: driver.name, status: driver.status),
            title: Row(
              children: [
                Text(driver.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                Icon(Icons.expand_more, size: 22, color: isDark ? Colors.white54 : Colors.black54),
              ],
            ),
            subtitle: Text("Durum: ${_statusText(driver.status)}"),
            onTap: () => _showPicker(context, ref, drivers, activeId, isDark),
          ),
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () => ref.read(historyVisibilityProvider.notifier).toggle(),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(shape: BoxShape.circle, color: isDark ? Colors.grey[800] : Colors.grey[200]),
                child: Icon(Icons.history, color: isHistoryOpen ? Colors.green : (isDark ? Colors.white54 : Colors.black54)),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => ref.read(themeProvider.notifier).toggleTheme(),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(shape: BoxShape.circle, color: isDark ? Colors.grey[800] : Colors.grey[200]),
                child: Icon(isDark ? Icons.light_mode : Icons.dark_mode, color: isDark ? Colors.white : Colors.amber),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showPicker(BuildContext context, WidgetRef ref, List<Driver> drivers, String activeId, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1C1C1E) : Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (_) => Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 24),
            const Text("Sürücü Değiştir", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: drivers.length,
                itemBuilder: (context, index) {
                  final d = drivers[index];
                  final isSelected = d.id == activeId;
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    leading: DriverAvatar(name: d.name, status: d.status, size: 40),
                    title: Text(d.name, style: TextStyle(fontSize: 16, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? (isDark ? Colors.white : Colors.black) : Colors.grey)),
                    trailing: isSelected ? const Icon(Icons.check_circle, color: Colors.green, size: 28) : null,
                    onTap: () { ref.read(activeDriverIdProvider.notifier).setActiveDriver(d.id); Navigator.pop(context); },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}