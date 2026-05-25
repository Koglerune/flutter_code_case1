import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_code_case1/features/driver_board/providers/driver_provider.dart';
import '../models/driver_model.dart';

import 'widgets/driver_header.dart';
import 'widgets/current_status_card.dart';
import 'widgets/vehicle_info_card.dart';
import 'widgets/status_button.dart';

class DriverBoardView extends ConsumerWidget {
  const DriverBoardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drivers = ref.watch(driverListProvider);
    final activeId = ref.watch(activeDriverIdProvider);
    final driver = drivers.firstWhere((d) => d.id == activeId);
    
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                child: Column(
                  children: [
                    DriverHeader(driver: driver, drivers: drivers, activeId: activeId),
                    const SizedBox(height: 24),
                    

                    CurrentStatusCard(driver: driver),
                    const SizedBox(height: 20),
                    
                    VehicleInfoCard(truckName: driver.truckName),
                    
                    const Spacer(),
                    
                    const SizedBox(height: 20),
                    
                    StatusButton(driver: driver, text: "Boşta", status: DriverStatus.idle, color: Colors.grey),
                    const SizedBox(height: 12),
                    StatusButton(driver: driver, text: "Yük Bekliyor", status: DriverStatus.waitingForLoad, color: Colors.orange),
                    const SizedBox(height: 12),
                    StatusButton(driver: driver, text: "Seferde", status: DriverStatus.onRoute, color: Colors.green),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}