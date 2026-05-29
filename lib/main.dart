import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyC-siZ2Z3VQU3bbMjsfflauRzZRdjfiEKA",
        appId: "1:25429940980:ios:45d0365544b4624c755ca1",
        messagingSenderId: "25429940980",
        projectId: "biogas11",
        databaseURL:
            "https://biogas11-default-rtdb.asia-southeast1.firebasedatabase.app",
        storageBucket: "biogas11.firebasestorage.app",
      ),
    ).timeout(
      const Duration(seconds: 10),
      onTimeout: () =>
          throw Exception("Firebase init timed out — check network / ATS"),
    );

    FirebaseDatabase.instance.setPersistenceEnabled(true);
    FirebaseDatabase.instance.ref('realtime').keepSynced(true);
    FirebaseDatabase.instance.ref('history').keepSynced(true);
    FirebaseDatabase.instance.ref('config').keepSynced(true);
  } catch (e) {
    runApp(MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFFF5F0EB),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              "Startup Error:\n$e",
              style: const TextStyle(
                  color: Color(0xFFE07C7C),
                  fontSize: 15,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    ));
    return;
  }

  runApp(const BiogasApp());
}

// ── Pastel colour palette (light) ────────────────────────────────────────────
class AppColors {
  static const bg         = Color(0xFFF7F4F0);
  static const card       = Color(0xFFFFFFFF);
  static const green      = Color(0xFF5BBF8E);
  static const greenLight = Color(0xFFCCEEDD);
  static const red        = Color(0xFFE8645A);
  static const redLight   = Color(0xFFFCDEDC);
  static const blue       = Color(0xFF5A9FD4);
  static const blueLight  = Color(0xFFCCE4F7);
  static const peach      = Color(0xFFEA8C55);
  static const peachLight = Color(0xFFFFE4CC);
  static const purple     = Color(0xFF9B7FD4);
  static const purpleLight= Color(0xFFE8DEFF);
  static const text       = Color(0xFF2B2B2B);
  static const textLight  = Color(0xFF8A8A8A);
  static const divider    = Color(0xFFEAE6E1);

  // Dark mode equivalents
  static const darkBg     = Color(0xFF121418);
  static const darkCard   = Color(0xFF1E2128);
  static const darkText   = Color(0xFFF0EEFF);
  static const darkTextLight = Color(0xFF7A7A8A);
  static const darkDivider   = Color(0xFF2E3040);
}

class BiogasApp extends StatelessWidget {
  const BiogasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Biogas Monitor',
      debugShowCheckedModeBanner: false,
      // ── Light Theme ──
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.bg,
        fontFamily: 'SF Pro Display',
        colorScheme: const ColorScheme.light(
          primary: AppColors.green,
          surface: AppColors.card,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.card,
          selectedItemColor: AppColors.green,
          unselectedItemColor: AppColors.textLight,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
        ),
        dialogTheme: const DialogTheme(
          backgroundColor: AppColors.card,
        ),
      ),
      // ── Dark Theme ──
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.darkBg,
        fontFamily: 'SF Pro Display',
        colorScheme: const ColorScheme.dark(
          primary: AppColors.green,
          surface: AppColors.darkCard,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.darkCard,
          selectedItemColor: AppColors.green,
          unselectedItemColor: AppColors.darkTextLight,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
        ),
        dialogTheme: const DialogTheme(
          backgroundColor: AppColors.darkCard,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
    );
  }
}

// ── Splash Screen ─────────────────────────────────────────────────────────────
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _scale = Tween<double>(begin: 0.80, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.forward();

    Future.delayed(const Duration(milliseconds: 2600), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const MainScreen(),
            transitionDuration: const Duration(milliseconds: 500),
            transitionsBuilder: (_, anim, __, child) =>
                FadeTransition(opacity: anim, child: child),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBg : AppColors.bg;
    final textColor = isDark ? AppColors.darkText : AppColors.text;
    final subtleColor = isDark ? AppColors.darkTextLight : AppColors.textLight;

    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: ScaleTransition(
            scale: _scale,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon bubble
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF5BBF8E), Color(0xFF3A9E72)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.green.withOpacity(0.4),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.biotech_outlined,
                      color: Colors.white, size: 48),
                ),
                const SizedBox(height: 24),
                Text(
                  'Biogas Monitor',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Real-time sensor dashboard',
                  style: TextStyle(
                    color: subtleColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: AppColors.green.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Main screen ──────────────────────────────────────────────────────────────
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = const [
    RealtimeTab(),
    HistoryTab(),
    GraphTab(),
    StatsTab(),
  ];

  final List<String> _titles = ['Live Sensors', 'History', 'Graph', 'Analytics'];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBg : AppColors.bg;
    final cardColor = isDark ? AppColors.darkCard : AppColors.card;
    final divColor = isDark ? AppColors.darkDivider : AppColors.divider;
    final textColor = isDark ? AppColors.darkText : AppColors.text;
    final subtleColor = isDark ? AppColors.darkTextLight : AppColors.textLight;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _titles[_currentIndex],
              style: TextStyle(
                color: textColor,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
            Text(
              'Biogas Monitor',
              style: TextStyle(
                color: subtleColor,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      body: _tabs[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: cardColor,
          border: Border(top: BorderSide(color: divColor, width: 1)),
        ),
        child: SafeArea(
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (i) => setState(() => _currentIndex = i),
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: AppColors.green,
            unselectedItemColor: subtleColor,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.sensors_outlined),
                  activeIcon: Icon(Icons.sensors),
                  label: 'Live'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.history_outlined),
                  activeIcon: Icon(Icons.history),
                  label: 'History'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.show_chart_outlined),
                  activeIcon: Icon(Icons.show_chart),
                  label: 'Graph'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.bar_chart_outlined),
                  activeIcon: Icon(Icons.bar_chart),
                  label: 'Analytics'),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Shared helpers ───────────────────────────────────────────────────────────
double _parse(dynamic value) {
  if (value == null) return 0.0;
  if (value is int) return value.toDouble();
  if (value is double) return value.isNaN || value.isInfinite ? 0.0 : value;
  if (value is String) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 0.0;
    return double.tryParse(trimmed) ?? 0.0;
  }
  return 0.0;
}

// ── Theme helper ─────────────────────────────────────────────────────────────
extension ThemeHelpers on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  Color get bgColor => isDark ? AppColors.darkBg : AppColors.bg;
  Color get cardColor => isDark ? AppColors.darkCard : AppColors.card;
  Color get textColor => isDark ? AppColors.darkText : AppColors.text;
  Color get subtleColor => isDark ? AppColors.darkTextLight : AppColors.textLight;
  Color get divColor => isDark ? AppColors.darkDivider : AppColors.divider;
}

// ── 1. Realtime Tab ──────────────────────────────────────────────────────────
class RealtimeTab extends StatelessWidget {
  const RealtimeTab({super.key});

  void _editThreshold(BuildContext context, String key, double current) {
    final ctrl = TextEditingController(text: current.toStringAsFixed(1));
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 32,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: ctx.divColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('Edit Threshold',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: ctx.textColor)),
            const SizedBox(height: 4),
            Text(key,
                style: TextStyle(fontSize: 13, color: ctx.subtleColor)),
            const SizedBox(height: 16),
            TextField(
              controller: ctrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              autofocus: true,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: ctx.textColor),
              decoration: InputDecoration(
                filled: true,
                fillColor: ctx.bgColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.green,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  final v = double.tryParse(ctrl.text);
                  if (v != null) {
                    FirebaseDatabase.instance
                        .ref('config')
                        .update({key: v});
                  }
                  Navigator.pop(ctx);
                },
                child: const Text('Save',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sensorCard(
    BuildContext context, {
    required String title,
    required String unit,
    required double value,
    required double threshold,
    required String configKey,
    required Color color,
    required Color bgColor,
    required IconData icon,
  }) {
    final bool danger = value > threshold;
    final cardColor = context.cardColor;
    final textColor = context.textColor;
    final subtleColor = context.subtleColor;
    final divColor = context.divColor;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(context.isDark ? 0.2 : 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: bgColor.withOpacity(context.isDark ? 0.25 : 1.0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(title,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: textColor)),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: danger
                      ? AppColors.red.withOpacity(context.isDark ? 0.25 : 1.0)
                      : AppColors.greenLight.withOpacity(context.isDark ? 0.25 : 1.0),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  danger ? 'BAHAYA' : 'AMAN',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: danger ? AppColors.red : AppColors.green,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                  letterSpacing: -1,
                  height: 1,
                ),
              ),
              const SizedBox(width: 6),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(unit,
                    style: TextStyle(
                        fontSize: 16,
                        color: subtleColor,
                        fontWeight: FontWeight.w500)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(height: 1, color: divColor),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.tune_outlined, size: 14, color: subtleColor),
                  const SizedBox(width: 4),
                  Text(
                    'Threshold: ${threshold.toStringAsFixed(1)} $unit',
                    style: TextStyle(fontSize: 13, color: subtleColor),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => _editThreshold(context, configKey, threshold),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: context.bgColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.edit_outlined, size: 13, color: subtleColor),
                      const SizedBox(width: 4),
                      Text('Edit',
                          style: TextStyle(
                              fontSize: 12,
                              color: subtleColor,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DatabaseEvent>(
      stream: FirebaseDatabase.instance.ref('config').onValue,
      builder: (context, configSnap) {
        return StreamBuilder<DatabaseEvent>(
          stream: FirebaseDatabase.instance.ref('realtime').onValue,
          builder: (context, realtimeSnap) {
            if (!configSnap.hasData || !realtimeSnap.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                    color: AppColors.green, strokeWidth: 2),
              );
            }

            final cfg =
                configSnap.data?.snapshot.value as Map<dynamic, dynamic>? ??
                    {};
            final rt =
                realtimeSnap.data?.snapshot.value as Map<dynamic, dynamic>? ??
                    {};

            return ListView(
              padding: const EdgeInsets.only(top: 8, bottom: 24),
              children: [
                _sensorCard(
                  context,
                  title: 'Temperature',
                  unit: '°C',
                  value: _parse(rt['suhu']),
                  threshold: _parse(cfg['suhuThreshold']),
                  configKey: 'suhuThreshold',
                  color: AppColors.peach,
                  bgColor: AppColors.peachLight,
                  icon: Icons.thermostat_outlined,
                ),
                _sensorCard(
                  context,
                  title: 'Gas (MQ Sensor)',
                  unit: 'PPM',
                  value: _parse(rt['ppm']),
                  threshold: _parse(cfg['ppmThreshold']),
                  configKey: 'ppmThreshold',
                  color: AppColors.blue,
                  bgColor: AppColors.blueLight,
                  icon: Icons.air_outlined,
                ),
                _sensorCard(
                  context,
                  title: 'pH Level',
                  unit: 'pH',
                  value: _parse(rt['ph']),
                  threshold: _parse(cfg['phThreshold']),
                  configKey: 'phThreshold',
                  color: AppColors.green,
                  bgColor: AppColors.greenLight,
                  icon: Icons.science_outlined,
                ),
              ],
            );
          },
        );
      },
    );
  }
}

// ── 2. History Tab (with swipe to delete) ────────────────────────────────────
class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});

  void _confirmDelete(BuildContext context, String key) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.cardColor,
        title: Text('Delete entry?',
            style: TextStyle(color: context.textColor)),
        content: Text('This action cannot be undone.',
            style: TextStyle(color: context.subtleColor)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: TextStyle(color: context.subtleColor)),
          ),
          TextButton(
            onPressed: () {
              FirebaseDatabase.instance.ref('history').child(key).remove();
              Navigator.pop(ctx);
            },
            child: const Text('Delete',
                style: TextStyle(color: AppColors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DatabaseEvent>(
      stream:
          FirebaseDatabase.instance.ref('history').limitToLast(100).onValue,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(
                  color: AppColors.green, strokeWidth: 2));
        }

        final map =
            snapshot.data?.snapshot.value as Map<dynamic, dynamic>?;
        if (map == null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.history_outlined,
                    size: 48, color: context.subtleColor),
                const SizedBox(height: 12),
                Text('No history yet',
                    style: TextStyle(
                        color: context.subtleColor, fontSize: 15)),
              ],
            ),
          );
        }

        final keys = map.keys.toList()..sort();
        final reversed = keys.reversed.toList();

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: reversed.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final key = reversed[index];
            final rawItem = map[key];
            if (rawItem is! Map) return const SizedBox.shrink();
            final item = rawItem as Map<dynamic, dynamic>;
            final sensor = item['sensorType'] ?? 'Unknown';

            Color dotColor = AppColors.green;
            if (sensor.toString().toLowerCase().contains('suhu')) {
              dotColor = AppColors.peach;
            } else if (sensor.toString().toLowerCase().contains('ppm') ||
                sensor.toString().toLowerCase().contains('mq')) {
              dotColor = AppColors.blue;
            }

            // Format values to 1 decimal place safely
            final suhuVal = _parse(item['suhu']);
            final ppmVal  = _parse(item['ppm']);
            final phVal   = _parse(item['ph']);

            return Dismissible(
              key: Key(key.toString()),
              direction: DismissDirection.horizontal,
              background: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 20),
                decoration: BoxDecoration(
                  color: AppColors.red,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.delete_outline,
                    color: Colors.white, size: 24),
              ),
              secondaryBackground: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                decoration: BoxDecoration(
                  color: AppColors.red,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.delete_outline,
                    color: Colors.white, size: 24),
              ),
              confirmDismiss: (_) {
                _confirmDelete(context, key.toString());
                return Future.value(false);
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withOpacity(context.isDark ? 0.2 : 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: dotColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Triggered by: $sensor',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: context.textColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            // ★ 1 decimal place
                            'Temp: ${suhuVal.toStringAsFixed(1)}°C  ·  '
                            'PPM: ${ppmVal.toStringAsFixed(1)}  ·  '
                            'pH: ${phVal.toStringAsFixed(1)}',
                            style: TextStyle(
                                fontSize: 12, color: context.subtleColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// ── 3. Graph Tab ─────────────────────────────────────────────────────────────
class GraphTab extends StatefulWidget {
  const GraphTab({super.key});
  @override
  State<GraphTab> createState() => _GraphTabState();
}

class _GraphTabState extends State<GraphTab> {
  String _metric = 'suhu';

  static const _metrics = [
    _MetricOption('suhu', 'Temp °C', AppColors.peach,  AppColors.peachLight),
    _MetricOption('ppm',  'Gas PPM', AppColors.blue,   AppColors.blueLight),
    _MetricOption('ph',   'pH',      AppColors.green,  AppColors.greenLight),
  ];

  @override
  Widget build(BuildContext context) {
    final selected = _metrics.firstWhere((m) => m.key == _metric);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Metric selector chips
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Row(
            children: _metrics.map((m) {
              final active = m.key == _metric;
              return GestureDetector(
                onTap: () => setState(() => _metric = m.key),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: active
                        ? m.color
                        : context.cardColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: active
                        ? [
                            BoxShadow(
                              color: m.color.withOpacity(0.35),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            )
                          ]
                        : [],
                  ),
                  child: Text(
                    m.label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: active ? Colors.white : context.subtleColor,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 12),
        // Chart container
        Expanded(
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            padding: const EdgeInsets.fromLTRB(12, 20, 20, 16),
            decoration: BoxDecoration(
              color: context.cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black
                      .withOpacity(context.isDark ? 0.2 : 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: StreamBuilder<DatabaseEvent>(
              stream: FirebaseDatabase.instance
                  .ref('history')
                  .limitToLast(20)
                  .onValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(
                          color: AppColors.green, strokeWidth: 2));
                }

                final map = snapshot.data?.snapshot.value
                    as Map<dynamic, dynamic>?;
                if (map == null || map.isEmpty) {
                  return Center(
                    child: Text('No data yet',
                        style: TextStyle(
                            color: context.subtleColor, fontSize: 14)),
                  );
                }

                final sortedKeys = map.keys.toList()..sort();
                final spots = <FlSpot>[];
                for (var i = 0; i < sortedKeys.length; i++) {
                  final raw = map[sortedKeys[i]];
                  if (raw is! Map) continue;
                  final item = raw as Map<dynamic, dynamic>;
                  final y = _parse(item[_metric]);
                  spots.add(FlSpot(i.toDouble(), y));
                }

                if (spots.isEmpty) {
                  return Center(
                    child: Text('No valid data',
                        style: TextStyle(
                            color: context.subtleColor, fontSize: 14)),
                  );
                }

                final gridLineColor = context.divColor;
                final labelColor = context.subtleColor;

                return LineChart(
                  LineChartData(
                    lineTouchData: LineTouchData(
                      enabled: true,
                      touchTooltipData: LineTouchTooltipData(
                        tooltipBgColor:
                            context.textColor.withOpacity(0.9),
                        tooltipRoundedRadius: 8,
                        tooltipPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((spot) {
                            return LineTooltipItem(
                              '${spot.y.toStringAsFixed(1)} ${selected.label}',
                              const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            );
                          }).toList();
                        },
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (_) => FlLine(
                        color: gridLineColor,
                        strokeWidth: 1,
                      ),
                    ),
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 36,
                          getTitlesWidget: (value, meta) => Text(
                            value.toInt().toString(),
                            style: TextStyle(
                                fontSize: 10, color: labelColor),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        // ★ Straight lines (not curved)
                        isCurved: false,
                        color: selected.color,
                        barWidth: 2.5,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, _, __, ___) =>
                              FlDotCirclePainter(
                            radius: 4,
                            color: context.cardColor,
                            strokeWidth: 2,
                            strokeColor: selected.color,
                          ),
                        ),
                        // ★ More opaque / colorful area fill
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              selected.color.withOpacity(0.55),
                              selected.color.withOpacity(0.18),
                              selected.color.withOpacity(0.0),
                            ],
                            stops: const [0.0, 0.5, 1.0],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

// ── 4. Analytics / Stats Tab ──────────────────────────────────────────────────
class StatsTab extends StatelessWidget {
  const StatsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DatabaseEvent>(
      stream:
          FirebaseDatabase.instance.ref('history').limitToLast(200).onValue,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(
                  color: AppColors.green, strokeWidth: 2));
        }

        final map =
            snapshot.data?.snapshot.value as Map<dynamic, dynamic>?;

        if (map == null || map.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.bar_chart_outlined,
                    size: 48, color: context.subtleColor),
                const SizedBox(height: 12),
                Text('No data for analytics',
                    style: TextStyle(
                        color: context.subtleColor, fontSize: 15)),
              ],
            ),
          );
        }

        // Aggregate stats from history
        final suhuVals = <double>[];
        final ppmVals  = <double>[];
        final phVals   = <double>[];

        // Count danger events per sensor
        int suhuDanger = 0, ppmDanger = 0, phDanger = 0;

        for (final key in map.keys) {
          final raw = map[key];
          if (raw is! Map) continue;
          final item = raw as Map<dynamic, dynamic>;

          final suhu = _parse(item['suhu']);
          final ppm  = _parse(item['ppm']);
          final ph   = _parse(item['ph']);

          if (suhu > 0) suhuVals.add(suhu);
          if (ppm > 0)  ppmVals.add(ppm);
          if (ph > 0)   phVals.add(ph);

          final sensor = (item['sensorType'] ?? '').toString().toLowerCase();
          if (sensor.contains('suhu')) suhuDanger++;
          if (sensor.contains('ppm') || sensor.contains('mq')) ppmDanger++;
          if (sensor.contains('ph')) phDanger++;
        }

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            // Summary row
            _SummaryBanner(
              totalReadings: map.length,
              dangerCount: suhuDanger + ppmDanger + phDanger,
              context: context,
            ),
            const SizedBox(height: 16),

            // Sensor stat cards
            _SensorStatCard(
              context: context,
              title: 'Temperature',
              unit: '°C',
              icon: Icons.thermostat_outlined,
              color: AppColors.peach,
              bgColor: AppColors.peachLight,
              values: suhuVals,
              dangerCount: suhuDanger,
            ),
            const SizedBox(height: 12),
            _SensorStatCard(
              context: context,
              title: 'Gas (MQ Sensor)',
              unit: 'PPM',
              icon: Icons.air_outlined,
              color: AppColors.blue,
              bgColor: AppColors.blueLight,
              values: ppmVals,
              dangerCount: ppmDanger,
            ),
            const SizedBox(height: 12),
            _SensorStatCard(
              context: context,
              title: 'pH Level',
              unit: 'pH',
              icon: Icons.science_outlined,
              color: AppColors.green,
              bgColor: AppColors.greenLight,
              values: phVals,
              dangerCount: phDanger,
            ),
          ],
        );
      },
    );
  }
}

class _SummaryBanner extends StatelessWidget {
  final int totalReadings;
  final int dangerCount;
  final BuildContext context;

  const _SummaryBanner({
    required this.totalReadings,
    required this.dangerCount,
    required this.context,
  });

  @override
  Widget build(BuildContext ctx) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.green.withOpacity(0.85),
            AppColors.blue.withOpacity(0.75),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.green.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Readings',
                  style: TextStyle(
                      color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 2),
                Text(
                  '$totalReadings',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          Container(width: 1, height: 40, color: Colors.white30),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Danger Events',
                  style: TextStyle(
                      color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 2),
                Text(
                  '$dangerCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SensorStatCard extends StatelessWidget {
  final BuildContext context;
  final String title;
  final String unit;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final List<double> values;
  final int dangerCount;

  const _SensorStatCard({
    required this.context,
    required this.title,
    required this.unit,
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.values,
    required this.dangerCount,
  });

  @override
  Widget build(BuildContext ctx) {
    double? min, max, avg;
    if (values.isNotEmpty) {
      min = values.reduce((a, b) => a < b ? a : b);
      max = values.reduce((a, b) => a > b ? a : b);
      avg = values.fold(0.0, (s, v) => s + v) / values.length;
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(context.isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: bgColor.withOpacity(context.isDark ? 0.25 : 1.0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(title,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: context.textColor)),
              ),
              if (dangerCount > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.red.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$dangerCount alerts',
                    style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.red),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          if (values.isEmpty)
            Text('No data available',
                style: TextStyle(
                    fontSize: 13, color: context.subtleColor))
          else
            Row(
              children: [
                _StatPill(
                    label: 'Min',
                    value: min!.toStringAsFixed(1),
                    unit: unit,
                    color: AppColors.blue,
                    context: context),
                const SizedBox(width: 8),
                _StatPill(
                    label: 'Avg',
                    value: avg!.toStringAsFixed(1),
                    unit: unit,
                    color: color,
                    context: context),
                const SizedBox(width: 8),
                _StatPill(
                    label: 'Max',
                    value: max!.toStringAsFixed(1),
                    unit: unit,
                    color: AppColors.red,
                    context: context),
              ],
            ),
          const SizedBox(height: 10),
          // Mini bar showing spread as a visual
          if (values.isNotEmpty && max! > min!) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (avg! - min!) / (max! - min!),
                minHeight: 6,
                backgroundColor: context.divColor,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${values.length} readings',
                    style: TextStyle(
                        fontSize: 11, color: context.subtleColor)),
                Text('avg ${avg.toStringAsFixed(1)} $unit',
                    style: TextStyle(
                        fontSize: 11,
                        color: color,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final Color color;
  final BuildContext context;

  const _StatPill({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
    required this.context,
  });

  @override
  Widget build(BuildContext ctx) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(context.isDark ? 0.15 : 0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(label,
                style: TextStyle(
                    fontSize: 10,
                    color: context.subtleColor,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 2),
            Text(value,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: color)),
            Text(unit,
                style: TextStyle(
                    fontSize: 10, color: context.subtleColor)),
          ],
        ),
      ),
    );
  }
}

class _MetricOption {
  final String key;
  final String label;
  final Color color;
  final Color bgColor;
  const _MetricOption(this.key, this.label, this.color, this.bgColor);
}
