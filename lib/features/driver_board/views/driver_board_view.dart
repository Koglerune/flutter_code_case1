import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_code_case1/core/theme/theme_provider.dart';
import 'package:flutter_code_case1/features/driver_board/providers/driver_provider.dart';
import '../models/driver_model.dart';

class DriverBoardView extends ConsumerWidget {
  const DriverBoardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drivers = ref.watch(driverListProvider);
    final activeId = ref.watch(activeDriverIdProvider);
    final driver = drivers.firstWhere((d) => d.id == activeId);
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;

    Color statusColor = driver.status == DriverStatus.idle ? Colors.grey : 
                        driver.status == DriverStatus.waitingForLoad ? Colors.orange : Colors.green;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      // İsim yanına aşağı ok butonu eklendi
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
              const SizedBox(height: 24),
              
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: isDark ? const LinearGradient(colors: [Color(0xFF2C2C2E), Color(0xFF1C1C1E)])
                                   : const LinearGradient(colors: [Color(0xFFE5E7EB), Color(0xFFF3F4F6)]),
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
                        key: ValueKey(driver.status), // Animasyonu tetikleyen kilit nokta
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
              const Spacer(),
              _statusButton(ref, driver, "Boşta", DriverStatus.idle, Colors.grey),
              const SizedBox(height: 12),
              _statusButton(ref, driver, "Yük Bekliyor", DriverStatus.waitingForLoad, Colors.orange),
              const SizedBox(height: 12),
              _statusButton(ref, driver, "Seferde", DriverStatus.onRoute, Colors.green),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  String _statusText(DriverStatus status) => status == DriverStatus.idle ? "Boşta" : status == DriverStatus.waitingForLoad ? "Yük Bekliyor" : "Seferde";

  Widget _statusButton(WidgetRef ref, Driver driver, String text, DriverStatus status, Color color) {
    final isSelected = driver.status == status;
    return SizedBox(
      width: double.infinity, height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? color : Colors.transparent,
          foregroundColor: isSelected ? Colors.white : color,
          side: isSelected ? BorderSide.none : BorderSide(color: color),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        onPressed: () => ref.read(driverListProvider.notifier).updateDriverStatus(driver.id, status),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

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