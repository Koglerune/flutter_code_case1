import 'package:flutter/material.dart';
import '../../models/driver_model.dart';

class DriverAvatar extends StatelessWidget {
  final String name;
  final DriverStatus status;
  final double size;

  const DriverAvatar({
    super.key,
    required this.name,
    required this.status,
    this.size = 44,
  });

  String get _initials {
    List<String> names = name.split(" ");
    String initials = "";
    if (names.isNotEmpty) initials += names[0][0];
    if (names.length > 1) initials += names[names.length - 1][0];
    return initials.toUpperCase();
  }

  Color get _statusColor {
    switch (status) {
      case DriverStatus.idle: return Colors.grey;
      case DriverStatus.waitingForLoad: return Colors.orange;
      case DriverStatus.onRoute: return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final borderColor = isDark ? const Color(0xFF1C1C1E) : Colors.white;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          CircleAvatar(
            radius: size / 2,
            backgroundColor: Colors.grey.withValues(alpha: 0.2),
            child: Text(
              _initials,
              style: TextStyle(
                fontSize: size * 0.4,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
          ),
          
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: size * 0.32,  
              height: size * 0.32,
              decoration: BoxDecoration(
                color: _statusColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: borderColor, 
                  width: 2.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}