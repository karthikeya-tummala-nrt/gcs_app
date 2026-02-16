import 'package:flutter/material.dart';
import 'package:gcs_app/widgets/dashboard_app_bar.dart';
import 'package:gcs_app/widgets/battery_indicator.dart';
import 'package:gcs_app/widgets/gps_indicator.dart';
import 'package:gcs_app/widgets/map_panel.dart';
import 'package:gcs_app/widgets/signal_indicator.dart';
import '../controllers/dashboard_controller.dart';
import '../widgets/armed_indicator.dart';
import '../widgets/controls_panel.dart';
import '../widgets/telemetry_panel.dart';
import '../services/alert_service.dart';
import '../widgets/alert_panel.dart';

class DashboardScreen extends StatefulWidget {
  final AlertService alertService;
  final DashboardController controller;
  const DashboardScreen({
    super.key,
    required this.alertService,
    required this.controller, // 2. ADD: required parameter
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}


class _DashboardScreenState extends State<DashboardScreen> {

  @override
  void initState() {
    super.initState();
    widget.controller.start(context, widget.alertService);
    widget.controller.addListener(_updateState);
  }

  void _updateState() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateState);
    widget.controller.disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final viewPadding = MediaQuery.of(context).viewPadding;
    const double appBarHeight = 40.0;

    final bool isPhone = size.shortestSide < 600;
    // FIXED: Added isLarge for laptop scaling
    final bool isLarge = size.width > 1000;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: TransparentDashboardAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.white, size: 20),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
            Flexible(
              flex: 3,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: GPSIndicator(gps: widget.controller.gps),
              ),
            ),
            Flexible(
              flex: 2,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: ArmedIndicator(isArmed: widget.controller.armed),
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
                        signalStrength: widget.controller.rssi,
                        signalPercentage: widget.controller.signal
                    ),
                    const SizedBox(width: 8),
                    BatteryIndicator(
                        batteryPercentage: widget.controller.battery,
                        voltage: widget.controller.voltage
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double availableHeight = constraints.maxHeight - viewPadding.top - appBarHeight - 20;

          return Stack(
            children: [
              // 1. Background Map (Fills the available area)
              Positioned.fill(
                child: MapPanel(),
              ),

              // 2. Telemetry Panel (Left)
              Positioned(
                left: 10,
                top: viewPadding.top + appBarHeight + 10,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: availableHeight * 0.7,
                    maxWidth: isPhone ? 120 : (isLarge ? 320 : 210),
                  ),
                  child: TelemetryPanel(controller: widget.controller, forceSingleColumn: isPhone),
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
