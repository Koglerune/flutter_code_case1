import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_code_case1/core/theme/theme_provider.dart';
import 'package:flutter_code_case1/features/driver_board/providers/driver_provider.dart';
import '../models/driver_model.dart';
import 'widgets/driver_history_list.dart';
import 'widgets/status_button.dart';
import 'widgets/driver_avatar.dart';

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
    
    Color subtitleColor = isDark ? Colors.grey.shade400 : Colors.grey.shade700;

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
                      leading: DriverAvatar(name: driver.name, status: driver.status),
                      title: Row(
                        children: [
                          Text(driver.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 8),
                          Icon(Icons.expand_more, size: 22, color: isDark ? Colors.white54 : Colors.black54),
                        ],
                      ),
                      subtitle: Text("Durum: ${_statusText(driver.status)}"),
                      onTap: () => _showPicker(context, ref, drivers, activeId),
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
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: statusColor.withValues(alpha: 0.1),
                            border: Border.all(color: statusColor.withValues(alpha: 0.5)),
                          ),
                          child: Icon(
                            driver.status == DriverStatus.idle ? Icons.radio_button_unchecked : 
                            driver.status == DriverStatus.waitingForLoad ? Icons.access_time : Icons.local_shipping,
                            size: 14,
                            color: statusColor,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text("MEVCUT DURUM", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: subtitleColor)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
                      layoutBuilder: (currentChild, previousChildren) => Stack(
                        alignment: Alignment.centerLeft,
                        children: <Widget>[
                          ...previousChildren,
                          if (currentChild != null) currentChild,
                        ],
                      ),
                      child: Column(
                        key: ValueKey(driver.status),
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_statusText(driver.status), style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: statusColor)),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              driver.status == DriverStatus.idle 
                                  ? "Atanmış iş bulunamadı" 
                                  : driver.status == DriverStatus.waitingForLoad 
                                      ? "Sefere geçmesi bekleniliyor" 
                                      : driver.tripStartTime != null 
                                          ? "Başlangıç: ${driver.tripStartTime!.hour.toString().padLeft(2, '0')}:${driver.tripStartTime!.minute.toString().padLeft(2, '0')}"
                                          : "",
                              style: TextStyle(color: subtitleColor, fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: FractionallySizedBox(
                        widthFactor: 0.7,
                        child: Container(
                          height: 1,
                          color: isDark ? Colors.white24 : Colors.black12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatColumn("BUGÜN", "${driver.hoursWorkedToday} sa", subtitleColor, isDark),
                        _buildVerticalDivider(isDark),
                        _buildStatColumn("MESAFE", "${driver.distanceTraveled} km", subtitleColor, isDark),
                        _buildVerticalDivider(isDark),
                        _buildStatColumn("KAZANÇ", "₺ ${_formatCurrency(driver.earnings)}", subtitleColor, isDark),
                      ],
                    )
                  ],
                ),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                child: isHistoryOpen
                    ? Container(
                        margin: const EdgeInsets.only(top: 20),
                        width: double.infinity,
                        height: 140,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E7EB),
                        ),
                        child: DriverHistoryList(key: ValueKey(driver.id), history: driver.history ?? []),
                      )
                    : const SizedBox.shrink(),
              ),
              const SizedBox(height: 20),
              Container(
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
                    Text(driver.truckName.toUpperCase(), style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                  ],
                ),
              ),
              const Spacer(),
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

  String _formatCurrency(double amount) {
    if (amount >= 1000) {
      final thousands = (amount / 1000).floor();
      final remainder = (amount % 1000).toInt().toString().padLeft(3, '0');
      return "$thousands.$remainder";
    }
    return amount.toInt().toString();
  }

  Widget _buildStatColumn(String title, String value, Color titleColor, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: titleColor, letterSpacing: 0.5)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppColors.getBlackColor(isDark))),
      ],
    );
  }

  Widget _buildVerticalDivider(bool isDark) {
    return Container(
      width: 1,
      height: 30,
      color: isDark ? Colors.white24 : Colors.black12,
      margin: const EdgeInsets.symmetric(horizontal: 8),
    );
  }

  void _showPicker(BuildContext context, WidgetRef ref, List<Driver> drivers, String activeId) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1C1C1E) : Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (_) => Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2)),
            ),
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
                    title: Text(
                      d.name, 
                      style: TextStyle(
                        fontSize: 16, 
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? (isDark ? Colors.white : Colors.black) : Colors.grey,
                      )
                    ),
                    trailing: isSelected 
                      ? const Icon(Icons.check_circle, color: Colors.green, size: 28) 
                      : null,
                    onTap: () {
                      ref.read(activeDriverIdProvider.notifier).setActiveDriver(d.id);
                      Navigator.pop(context);
                    },
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

class AppColors {
  static Color getBlackColor(bool isDark) => isDark ? Colors.white : Colors.black87;
}