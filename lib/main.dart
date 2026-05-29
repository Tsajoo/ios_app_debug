import 'dart:async';
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

// ── Theme extension with pastel colors ───────────────────────────────────────
@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color bg;
  final Color card;
  final Color green;
  final Color greenLight;
  final Color red;
  final Color redLight;
  final Color blue;
  final Color blueLight;
  final Color peach;
  final Color peachLight;
  final Color text;
  final Color textLight;
  final Color divider;

  const AppColors({
    required this.bg,
    required this.card,
    required this.green,
    required this.greenLight,
    required this.red,
    required this.redLight,
    required this.blue,
    required this.blueLight,
    required this.peach,
    required this.peachLight,
    required this.text,
    required this.textLight,
    required this.divider,
  });

  // Light pastel theme
  static const light = AppColors(
    bg: Color(0xFFF7F4F0),
    card: Color(0xFFFFFFFF),
    green: Color(0xFF7EC8A4),
    greenLight: Color(0xFFD6F0E4),
    red: Color(0xFFE8857A),
    redLight: Color(0xFFFCE0DE),
    blue: Color(0xFF85B4D4),
    blueLight: Color(0xFFD6EAF7),
    peach: Color(0xFFF5C49A),
    peachLight: Color(0xFFFFF0E0),
    text: Color(0xFF3A3A3A),
    textLight: Color(0xFF8A8A8A),
    divider: Color(0xFFEAE6E1),
  );

  // Dark pastel theme (professional, slightly muted)
  static const dark = AppColors(
    bg: Color(0xFF1E1E2C),
    card: Color(0xFF2A2A3C),
    green: Color(0xFF7EC8A4),
    greenLight: Color(0xFF365545),
    red: Color(0xFFE8857A),
    redLight: Color(0xFF543636),
    blue: Color(0xFF85B4D4),
    blueLight: Color(0xFF314A5A),
    peach: Color(0xFFF5C49A),
    peachLight: Color(0xFF534034),
    text: Color(0xFFEAEAEA),
    textLight: Color(0xFFA0A0B0),
    divider: Color(0xFF3A3A4C),
  );

  @override
  AppColors copyWith() => AppColors(
        bg: bg,
        card: card,
        green: green,
        greenLight: greenLight,
        red: red,
        redLight: redLight,
        blue: blue,
        blueLight: blueLight,
        peach: peach,
        peachLight: peachLight,
        text: text,
        textLight: textLight,
        divider: divider,
      );

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      bg: Color.lerp(bg, other.bg, t)!,
      card: Color.lerp(card, other.card, t)!,
      green: Color.lerp(green, other.green, t)!,
      greenLight: Color.lerp(greenLight, other.greenLight, t)!,
      red: Color.lerp(red, other.red, t)!,
      redLight: Color.lerp(redLight, other.redLight, t)!,
      blue: Color.lerp(blue, other.blue, t)!,
      blueLight: Color.lerp(blueLight, other.blueLight, t)!,
      peach: Color.lerp(peach, other.peach, t)!,
      peachLight: Color.lerp(peachLight, other.peachLight, t)!,
      text: Color.lerp(text, other.text, t)!,
      textLight: Color.lerp(textLight, other.textLight, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
    );
  }
}

class BiogasApp extends StatelessWidget {
  const BiogasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Biogas Monitor',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,   // Dark mode support
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.light.bg,
        fontFamily: 'SF Pro Display',
        colorScheme: ColorScheme.light(
          primary: AppColors.light.green,
          surface: AppColors.light.card,
        ),
        extensions: const [AppColors.light],
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.transparent,
          selectedItemColor: AppColors.light.green,
          unselectedItemColor: AppColors.light.textLight,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.dark.bg,
        fontFamily: 'SF Pro Display',
        colorScheme: ColorScheme.dark(
          primary: AppColors.dark.green,
          surface: AppColors.dark.card,
        ),
        extensions: const [AppColors.dark],
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.transparent,
          selectedItemColor: AppColors.dark.green,
          unselectedItemColor: AppColors.dark.textLight,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
        ),
      ),
      home: const SplashScreen(),   // Splash screen first
    );
  }
}

// ── Splash Screen ────────────────────────────────────────────────────────────
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    // After 2.5 seconds, navigate to main screen
    Timer(const Duration(milliseconds: 2500), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Scaffold(
      backgroundColor: colors.bg,
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.energy_savings_leaf,
                size: 72,
                color: colors.green,
              ),
              const SizedBox(height: 24),
              Text(
                'Biogas Monitor',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: colors.text,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Real-time monitoring',
                style: TextStyle(
                  fontSize: 14,
                  color: colors.textLight,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Main screen with bottom navigation ───────────────────────────────────────
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  late final List<Widget> _tabs;
  late final List<String> _titles;

  @override
  void initState() {
    super.initState();
    _tabs = const [
      RealtimeTab(),
      HistoryTab(),
      GraphTab(),
      StatsTab(), // New tab
    ];
    _titles = const [
      'Live Sensors',
      'History',
      'Graph',
      'Stats',
    ];
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        backgroundColor: colors.bg,
        elevation: 0,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _titles[_currentIndex],
              style: TextStyle(
                color: colors.text,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
            Text(
              'Biogas Monitor',
              style: TextStyle(
                color: colors.textLight,
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
          color: colors.card,
          border: Border(top: BorderSide(color: colors.divider, width: 1)),
        ),
        child: SafeArea(
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (i) => setState(() => _currentIndex = i),
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: colors.green,
            unselectedItemColor: colors.textLight,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.sensors_outlined),
                activeIcon: Icon(Icons.sensors),
                label: 'Live',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history_outlined),
                activeIcon: Icon(Icons.history),
                label: 'History',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.show_chart_outlined),
                activeIcon: Icon(Icons.show_chart),
                label: 'Graph',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.analytics_outlined),
                activeIcon: Icon(Icons.analytics),
                label: 'Stats',
              ),
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
  if (value is double) return value;
  if (value is String) {
    final parsed = double.tryParse(value);
    return parsed ?? 0.0;
  }
  return 0.0;
}

/// Format a value to 1 decimal place if numeric, else return string as is or dash.
String _fmt(dynamic val) {
  final num = double.tryParse(val?.toString() ?? '');
  if (num != null) return num.toStringAsFixed(1);
  return val?.toString() ?? '-';
}

// ── 1. Realtime Tab ──────────────────────────────────────────────────────────
class RealtimeTab extends StatelessWidget {
  const RealtimeTab({super.key});

  void _editThreshold(BuildContext context, String key, double current) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final ctrl = TextEditingController(text: current.toStringAsFixed(1));
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.card,
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
                  color: colors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('Edit Threshold',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: colors.text)),
            const SizedBox(height: 4),
            Text(key,
                style: TextStyle(fontSize: 13, color: colors.textLight)),
            const SizedBox(height: 16),
            TextField(
              controller: ctrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              autofocus: true,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: colors.text),
              decoration: InputDecoration(
                filled: true,
                fillColor: colors.bg,
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
                  backgroundColor: colors.green,
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
    final colors = Theme.of(context).extension<AppColors>()!;
    final bool danger = value > threshold;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: bgColor,
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
                        color: colors.text)),
              ),
              // Status pill
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: danger ? colors.redLight : colors.greenLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  danger ? 'BAHAYA' : 'AMAN',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: danger ? colors.red : colors.green,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          // Big value
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w700,
                  color: colors.text,
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
                        color: colors.textLight,
                        fontWeight: FontWeight.w500)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(height: 1, color: colors.divider),
          const SizedBox(height: 12),
          // Threshold row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.tune_outlined,
                      size: 14, color: colors.textLight),
                  const SizedBox(width: 4),
                  Text(
                    'Threshold: ${threshold.toStringAsFixed(1)} $unit',
                    style: TextStyle(fontSize: 13, color: colors.textLight),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => _editThreshold(context, configKey, threshold),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: colors.bg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.edit_outlined,
                          size: 13, color: colors.textLight),
                      const SizedBox(width: 4),
                      Text('Edit',
                          style: TextStyle(
                              fontSize: 12,
                              color: colors.textLight,
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
            final colors = Theme.of(context).extension<AppColors>()!;
            if (!configSnap.hasData || !realtimeSnap.hasData) {
              return Center(
                child: CircularProgressIndicator(
                    color: colors.green, strokeWidth: 2),
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
                  color: colors.peach,
                  bgColor: colors.peachLight,
                  icon: Icons.thermostat_outlined,
                ),
                _sensorCard(
                  context,
                  title: 'Gas (MQ Sensor)',
                  unit: 'PPM',
                  value: _parse(rt['ppm']),
                  threshold: _parse(cfg['ppmThreshold']),
                  configKey: 'ppmThreshold',
                  color: colors.blue,
                  bgColor: colors.blueLight,
                  icon: Icons.air_outlined,
                ),
                _sensorCard(
                  context,
                  title: 'pH Level',
                  unit: 'pH',
                  value: _parse(rt['ph']),
                  threshold: _parse(cfg['phThreshold']),
                  configKey: 'phThreshold',
                  color: colors.green,
                  bgColor: colors.greenLight,
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
    final colors = Theme.of(context).extension<AppColors>()!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete entry?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              FirebaseDatabase.instance.ref('history').child(key).remove();
              Navigator.pop(ctx);
            },
            child: Text('Delete',
                style: TextStyle(color: colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return StreamBuilder<DatabaseEvent>(
      stream:
          FirebaseDatabase.instance.ref('history').limitToLast(100).onValue,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(
                  color: colors.green, strokeWidth: 2));
        }

        final map =
            snapshot.data?.snapshot.value as Map<dynamic, dynamic>?;
        if (map == null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.history_outlined,
                    size: 48, color: colors.textLight),
                const SizedBox(height: 12),
                Text('No history yet',
                    style: TextStyle(
                        color: colors.textLight, fontSize: 15)),
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
            final item = map[key] as Map<dynamic, dynamic>;
            final sensor = item['sensorType'] ?? 'Unknown';

            Color dotColor = colors.green;
            final sensorStr = sensor.toString().toLowerCase();
            if (sensorStr.contains('suhu')) {
              dotColor = colors.peach;
            } else if (sensorStr.contains('ppm') ||
                sensorStr.contains('mq')) {
              dotColor = colors.blue;
            }

            // Format values to 1 decimal place
            final suhu = _fmt(item['suhu']);
            final ppm = _fmt(item['ppm']);
            final ph = _fmt(item['ph']);

            return Dismissible(
              key: Key(key),
              direction: DismissDirection.horizontal,
              background: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 20),
                decoration: BoxDecoration(
                  color: colors.red,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.delete_outline,
                    color: Colors.white, size: 24),
              ),
              secondaryBackground: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                decoration: BoxDecoration(
                  color: colors.red,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.delete_outline,
                    color: Colors.white, size: 24),
              ),
              confirmDismiss: (_) {
                _confirmDelete(context, key);
                return Future.value(false);
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors.card,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
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
                              color: colors.text,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Temp: ${suhu}°C  ·  PPM: ${ppm}  ·  pH: $ph',
                            style: TextStyle(
                                fontSize: 12, color: colors.textLight),
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

// ── 3. Graph Tab (with straight lines, better area fill) ─────────────────────
class GraphTab extends StatefulWidget {
  const GraphTab({super.key});
  @override
  State<GraphTab> createState() => _GraphTabState();
}

class _GraphTabState extends State<GraphTab> {
  String _metric = 'suhu';

  static final _metrics = [
    _MetricOption(
        'suhu', 'Temp °C', AppColors.light.peach, AppColors.light.peachLight),
    _MetricOption(
        'ppm', 'Gas PPM', AppColors.light.blue, AppColors.light.blueLight),
    _MetricOption(
        'ph', 'pH', AppColors.light.green, AppColors.light.greenLight),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final selected = _metrics.firstWhere(
      (m) => m.key == _metric,
      orElse: () => _metrics[0],
    );

    // Map colors to theme-aware versions
    final lineColor = () {
      switch (_metric) {
        case 'suhu':
          return colors.peach;
        case 'ppm':
          return colors.blue;
        case 'ph':
        default:
          return colors.green;
      }
    }();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Metric selector
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Row(
            children: _metrics.map((m) {
              final active = m.key == _metric;
              final Color activeColor = m.key == 'suhu'
                  ? colors.peach
                  : m.key == 'ppm'
                      ? colors.blue
                      : colors.green;
              return GestureDetector(
                onTap: () => setState(() => _metric = m.key),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: active ? activeColor : colors.card,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: active
                        ? [
                            BoxShadow(
                              color: activeColor.withOpacity(0.3),
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
                      color: active ? Colors.white : colors.textLight,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 12),
        // Chart
        Expanded(
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            padding: const EdgeInsets.fromLTRB(12, 20, 20, 16),
            decoration: BoxDecoration(
              color: colors.card,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
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
                  return Center(
                      child: CircularProgressIndicator(
                          color: colors.green, strokeWidth: 2));
                }

                final map = snapshot.data?.snapshot.value
                    as Map<dynamic, dynamic>?;
                if (map == null || map.isEmpty) {
                  return Center(
                    child: Text('No data yet',
                        style: TextStyle(
                            color: colors.textLight, fontSize: 14)),
                  );
                }

                final sortedKeys = map.keys.toList()..sort();
                final spots = <FlSpot>[];
                for (var i = 0; i < sortedKeys.length; i++) {
                  final item =
                      map[sortedKeys[i]] as Map<dynamic, dynamic>;
                  spots.add(FlSpot(i.toDouble(), _parse(item[_metric])));
                }

                return LineChart(
                  LineChartData(
                    lineTouchData: LineTouchData(
                      enabled: true,
                      touchTooltipData: LineTouchTooltipData(
                        tooltipBgColor: colors.text.withOpacity(0.9),
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
                        color: colors.divider,
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
                                fontSize: 10, color: colors.textLight),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: false,                  // ★ Straight lines
                        color: lineColor,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, _, __, ___) =>
                              FlDotCirclePainter(
                            radius: 4,
                            color: colors.card,
                            strokeWidth: 2,
                            strokeColor: lineColor,
                          ),
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          // ★ Better area fill: more colorful and distinct
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              lineColor.withOpacity(0.35),
                              lineColor.withOpacity(0.0),
                            ],
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

class _MetricOption {
  final String key;
  final String label;
  final Color color;
  final Color bgColor;
  const _MetricOption(this.key, this.label, this.color, this.bgColor);
}

// ── 4. Stats / Analytics Tab ─────────────────────────────────────────────────
class StatsTab extends StatelessWidget {
  const StatsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return StreamBuilder<DatabaseEvent>(
      stream: FirebaseDatabase.instance.ref('history').onValue,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
                color: colors.green, strokeWidth: 2),
          );
        }

        final map =
            snapshot.data?.snapshot.value as Map<dynamic, dynamic>?;
        if (map == null || map.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.analytics_outlined,
                    size: 48, color: colors.textLight),
                const SizedBox(height: 12),
                Text('No history data',
                    style: TextStyle(
                        color: colors.textLight, fontSize: 15)),
              ],
            ),
          );
        }

        // Extract all entries and compute stats for each sensor
        final entries = map.values
            .whereType<Map<dynamic, dynamic>>()
            .toList();

        // Helper to compute stats from a list of values
        Map<String, double> compute(List<double> values) {
          if (values.isEmpty) return {'min': 0, 'max': 0, 'avg': 0};
          double min = values.first;
          double max = values.first;
          double sum = 0;
          for (final v in values) {
            if (v < min) min = v;
            if (v > max) max = v;
            sum += v;
          }
          return {
            'min': min,
            'max': max,
            'avg': sum / values.length,
          };
        }

        // Separate data per sensor
        final suhuValues = <double>[];
        final ppmValues = <double>[];
        final phValues = <double>[];
        DateTime? latestTimestamp;

        for (final entry in entries) {
          final suhu = _parse(entry['suhu']);
          final ppm = _parse(entry['ppm']);
          final ph = _parse(entry['ph']);
          suhuValues.add(suhu);
          ppmValues.add(ppm);
          phValues.add(ph);
          // Use the key timestamp if available
        }

        final suhuStats = compute(suhuValues);
        final ppmStats = compute(ppmValues);
        final phStats = compute(phValues);
        final totalRecords = entries.length;

        // For "last 24h count" we would need timestamps; we'll approximate with total records
        // (in a real app you'd filter by timestamp)
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            _StatsCard(
              color: colors.peach,
              bgColor: colors.peachLight,
              icon: Icons.thermostat_outlined,
              title: 'Temperature',
              unit: '°C',
              min: suhuStats['min']!,
              max: suhuStats['max']!,
              avg: suhuStats['avg']!,
              count: totalRecords,
            ),
            const SizedBox(height: 12),
            _StatsCard(
              color: colors.blue,
              bgColor: colors.blueLight,
              icon: Icons.air_outlined,
              title: 'Gas (MQ Sensor)',
              unit: 'PPM',
              min: ppmStats['min']!,
              max: ppmStats['max']!,
              avg: ppmStats['avg']!,
              count: totalRecords,
            ),
            const SizedBox(height: 12),
            _StatsCard(
              color: colors.green,
              bgColor: colors.greenLight,
              icon: Icons.science_outlined,
              title: 'pH Level',
              unit: 'pH',
              min: phStats['min']!,
              max: phStats['max']!,
              avg: phStats['avg']!,
              count: totalRecords,
            ),
          ],
        );
      },
    );
  }
}

class _StatsCard extends StatelessWidget {
  final Color color;
  final Color bgColor;
  final IconData icon;
  final String title;
  final String unit;
  final double min;
  final double max;
  final double avg;
  final int count;

  const _StatsCard({
    required this.color,
    required this.bgColor,
    required this.icon,
    required this.title,
    required this.unit,
    required this.min,
    required this.max,
    required this.avg,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
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
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: colors.text,
                  ),
                ),
              ),
              Text(
                '$count records',
                style: TextStyle(fontSize: 12, color: colors.textLight),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Stats row
          Row(
            children: [
              _StatItem(
                  label: 'Min', value: '$min $unit', color: colors.textLight),
              const SizedBox(width: 16),
              _StatItem(
                  label: 'Max', value: '$max $unit', color: colors.textLight),
              const SizedBox(width: 16),
              _StatItem(
                  label: 'Average',
                  value: '${avg.toStringAsFixed(1)} $unit',
                  color: colors.textLight),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(fontSize: 11, color: color.withOpacity(0.7))),
          const SizedBox(height: 4),
          Text(value,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: color)),
        ],
      ),
    );
  }
}
