import 'package:flutter/material.dart';
import 'package:gcs_app/widgets/dashboard_app_bar.dart';
import 'package:gcs_app/widgets/battery_indicator.dart';
import 'package:gcs_app/widgets/gps_indicator.dart';
import 'package:gcs_app/widgets/signal_indicator.dart';
import '../controllers/dashboard_controller.dart';
import '../widgets/armed_indicator.dart';
import '../widgets/controls_panel.dart';
import '../widgets/telemetry_panel.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DashboardController controller = DashboardController();

  @override
  void initState() {
    super.initState();
    controller.start();
    controller.addListener(_updateState);
  }

  void _updateState() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    controller.removeListener(_updateState);
    controller.disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final viewPadding = MediaQuery.of(context).viewPadding;
    const double appBarHeight = 40.0;

    final bool isPhone = size.shortestSide < 600;

    return Scaffold(
      extendBodyBehindAppBar: true,
      // Ensure the background is transparent so the Map fills the whole screen
      backgroundColor: Colors.transparent,
      appBar: TransparentDashboardAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Menu button to trigger the Drawer in MainNavigationWrapper
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.white, size: 20),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
            Flexible(
              flex: 3,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: GPSIndicator(gps: controller.gps),
              ),
            ),
            Flexible(
              flex: 2,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: ArmedIndicator(isArmed: controller.armed),
              ),
            ),
            Flexible(
              flex: 4,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: Row(
                  children: [
                    SignalIndicator(
                        signalStrength: controller.rssi,
                        signalPercentage: controller.signal
                    ),
                    const SizedBox(width: 8),
                    BatteryIndicator(
                        batteryPercentage: controller.battery,
                        voltage: controller.voltage
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // Use LayoutBuilder for DYNAMIC calculation of available space
      body: LayoutBuilder(
        builder: (context, constraints) {
          // constraints.maxHeight is now the EXACT space available
          // after the BottomNav is rendered.
          final double availableHeight = constraints.maxHeight - viewPadding.top - appBarHeight - 20;

          return Stack(
            children: [
              // 1. Background Map (Fills the available area)
              Positioned.fill(
                child: Image.asset('assets/images/static_map.png', fit: BoxFit.cover),
              ),

              // 2. Telemetry Panel (Left)
              Positioned(
                left: 10,
                top: viewPadding.top + appBarHeight + 10,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: availableHeight,
                    maxWidth: isPhone ? 120 : 210,
                  ),
                  child: IntrinsicWidth(
                    child: TelemetryPanel(controller: controller, forceSingleColumn: isPhone),
                  ),
                ),
              ),

              // 3. Controls Panel (Right)
              Positioned(
                right: 10,
                top: viewPadding.top + appBarHeight + 10,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: availableHeight,
                    maxWidth: isPhone ? 110 : 200,
                  ),
                  child: IntrinsicWidth(
                    child: ControlsPanel(forceSingleColumn: isPhone),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}