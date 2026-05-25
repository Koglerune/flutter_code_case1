import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/driver_model.dart';
import '../../providers/driver_provider.dart';

class StatusButton extends ConsumerWidget {
  final Driver driver;
  final String text;
  final DriverStatus status;
  final Color color;

  const StatusButton({
    super.key,
    required this.driver,
    required this.text,
    required this.status,
    required this.color,
  });

  IconData get _icon {
    switch (status) {
      case DriverStatus.idle: //boş daire
        return Icons.radio_button_unchecked;
      case DriverStatus.waitingForLoad:
        return Icons.access_time; //saat
      case DriverStatus.onRoute:
        return Icons.local_shipping; // kamyon
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = driver.status == status;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final unselectedBgColor = isDark ? Colors.transparent : Colors.white;
    final unselectedTextColor = isDark ? Colors.white70 : Colors.black87;
    final unselectedBorderColor = isDark ? Colors.white24 : Colors.grey.shade300;

    return SizedBox(
      width: double.infinity, 
      height: 60, 
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? color : unselectedBgColor,
          foregroundColor: isSelected ? Colors.white : unselectedTextColor,
          elevation: isSelected ? 4 : 0, 
          side: isSelected ? BorderSide.none : BorderSide(color: unselectedBorderColor, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        onPressed: () => ref.read(driverListProvider.notifier).updateDriverStatus(driver.id, status),
        child: Row(
          children: [
            Icon(_icon, size: 24, color: isSelected ? Colors.white : color),
            const SizedBox(width: 16),
            
            Expanded(
              child: Text(
                text, 
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                textAlign: TextAlign.left,
              ),
            ),
            
            Icon(Icons.chevron_right, size: 24, color: isSelected ? Colors.white : Colors.grey),
          ],
        ),
      ),
    );
  }
}