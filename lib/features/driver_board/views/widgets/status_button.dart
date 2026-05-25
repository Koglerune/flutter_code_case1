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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
}