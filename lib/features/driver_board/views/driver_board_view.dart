import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_code_case1/core/theme/theme_provider.dart';
import 'package:flutter_code_case1/features/driver_board/providers/driver_provider.dart';
import '../models/driver_model.dart';

// Ayırdığımız widget'ları import ediyoruz
import 'widgets/driver_history_list.dart';
import 'widgets/status_button.dart';

class DriverBoardView extends ConsumerWidget {
  const DriverBoardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drivers = ref.watch(driverListProvider);
    final activeId = ref.watch(activeDriverIdProvider);
    final driver = drivers.firstWhere((d) => d.id == activeId);
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;
    final isHistoryOpen = ref.watch(historyVisibilityProvider);

    Color statusColor = driver.status == DriverStatus.idle ? Colors.grey : 
                        driver.status == DriverStatus.waitingForLoad ? Colors.orange : Colors.green;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              // HEADER KISMI
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Row(
                        children: [
                          Text(driver.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 8),
                          Icon(Icons.expand_more, size: 22, color: isDark ? Colors.white54 : Colors.black54),
                        ],
                      ),
                      subtitle: Text("Durum: ${_statusText(driver.status)}"),
                      onTap: () => _showPicker(context, ref, drivers),
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
              ),
              const SizedBox(height: 24),
              
              // MEVCUT DURUM KARTI
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark 
                      ? [statusColor.withValues(alpha: 0.2), const Color(0xFF1C1C1E)]
                      : [statusColor.withValues(alpha: 0.15), const Color(0xFFF3F4F6)],
                  ),
                  border: Border.all(color: statusColor.withValues(alpha: 0.3), width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("MEVCUT DURUM", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey)),
                    const SizedBox(height: 12),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
                      child: Column(
                        key: ValueKey(driver.status),
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_statusText(driver.status).toUpperCase(), style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: statusColor)),
                          if (driver.tripStartTime != null) 
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text("Başlangıç: ${driver.tripStartTime!.hour.toString().padLeft(2, '0')}:${driver.tripStartTime!.minute.toString().padLeft(2, '0')}", style: const TextStyle(color: Colors.grey)),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // GEÇMİŞ LİSTESİ WIDGET'I
              AnimatedSize(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                child: isHistoryOpen
                    ? Container(
                        margin: const EdgeInsets.only(top: 20),
                        width: double.infinity,
                        height: 180,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E7EB),
                        ),
                        child: DriverHistoryList(key: ValueKey(driver.id), history: driver.history ?? []),
                      )
                    : const SizedBox.shrink(),
              ),
              const Spacer(),

              // DURUM BUTONLARI WIDGET'LARI
              StatusButton(driver: driver, text: "Boşta", status: DriverStatus.idle, color: Colors.grey),
              const SizedBox(height: 12),
              StatusButton(driver: driver, text: "Yük Bekliyor", status: DriverStatus.waitingForLoad, color: Colors.orange),
              const SizedBox(height: 12),
              StatusButton(driver: driver, text: "Seferde", status: DriverStatus.onRoute, color: Colors.green),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  String _statusText(DriverStatus status) => status == DriverStatus.idle ? "Boşta" : status == DriverStatus.waitingForLoad ? "Yük Bekliyor" : "Seferde";

  void _showPicker(BuildContext context, WidgetRef ref, List<Driver> drivers) {
    showModalBottomSheet(context: context, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => SizedBox(height: 300, child: Column(children: [
          const SizedBox(height: 20),
          const Text("Sürücü Seç", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Expanded(child: ListView.builder(
            itemCount: drivers.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(drivers[index].name),
              onTap: () { ref.read(activeDriverIdProvider.notifier).setActiveDriver(drivers[index].id); Navigator.pop(context); }
            )
          )),
        ])),
    );
  }
}