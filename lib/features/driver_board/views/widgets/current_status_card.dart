import 'package:flutter/material.dart';
import '../../models/driver_model.dart';

class CurrentStatusCard extends StatelessWidget {
  final Driver driver;

  const CurrentStatusCard({super.key, required this.driver});

  String _statusText(DriverStatus status) => status == DriverStatus.idle ? "Boşta" : status == DriverStatus.waitingForLoad ? "Yük Bekliyor" : "Seferde";

  String _formatCurrency(double amount) {
    if (amount >= 1000) {
      final thousands = (amount / 1000).floor();
      final remainder = (amount % 1000).toInt().toString().padLeft(3, '0');
      return "$thousands.$remainder";
    }
    return amount.toInt().toString();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subtitleColor = isDark ? Colors.grey.shade400 : Colors.grey.shade700;
    final statusColor = driver.status == DriverStatus.idle ? Colors.grey : driver.status == DriverStatus.waitingForLoad ? Colors.orange : Colors.green;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark ? [statusColor.withValues(alpha: 0.2), const Color(0xFF1C1C1E)] : [statusColor.withValues(alpha: 0.15), const Color(0xFFF3F4F6)],
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
                decoration: BoxDecoration(shape: BoxShape.circle, color: statusColor.withValues(alpha: 0.1), border: Border.all(color: statusColor.withValues(alpha: 0.5))),
                child: Icon(driver.status == DriverStatus.idle ? Icons.radio_button_unchecked : driver.status == DriverStatus.waitingForLoad ? Icons.access_time : Icons.local_shipping, size: 14, color: statusColor),
              ),
              const SizedBox(width: 10),
              Text("MEVCUT DURUM", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: subtitleColor)),
            ],
          ),
          const SizedBox(height: 16),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
            layoutBuilder: (currentChild, previousChildren) => Stack(alignment: Alignment.centerLeft, children: <Widget>[...previousChildren, if (currentChild != null) currentChild]),
            child: Column(
              key: ValueKey(driver.status),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_statusText(driver.status), style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: statusColor)),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    driver.status == DriverStatus.idle ? "Atanmış iş bulunamadı" : driver.status == DriverStatus.waitingForLoad ? "Sefere geçmesi bekleniliyor" : driver.tripStartTime != null ? "Başlangıç: ${driver.tripStartTime!.hour.toString().padLeft(2, '0')}:${driver.tripStartTime!.minute.toString().padLeft(2, '0')}" : "",
                    style: TextStyle(color: subtitleColor, fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Center(child: FractionallySizedBox(widthFactor: 0.7, child: Container(height: 1, color: isDark ? Colors.white24 : Colors.black12))),
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
    );
  }

  Widget _buildStatColumn(String title, String value, Color titleColor, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: titleColor, letterSpacing: 0.5)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
      ],
    );
  }

  Widget _buildVerticalDivider(bool isDark) {
    return Container(width: 1, height: 30, color: isDark ? Colors.white24 : Colors.black12, margin: const EdgeInsets.symmetric(horizontal: 8));
  }
}