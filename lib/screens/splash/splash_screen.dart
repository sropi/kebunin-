import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/constants.dart';
import '../../app/routes.dart';
import '../../services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  String _statusText = "Menyiapkan pasar tani hari ini...";
  final List<Timer> _timers = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _controller.forward();

    // Step animation for status text
    _timers.add(Timer(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() {
          _statusText = "Menghubungkan ke kelompok tani lokal...";
        });
      }
    }));

    _timers.add(Timer(const Duration(milliseconds: 2200), () {
      if (mounted) {
        setState(() {
          _statusText = "Mengecek pasokan panen segar subuh...";
        });
      }
    }));

    // Navigate to next screen
    _timers.add(Timer(const Duration(milliseconds: 3000), () {
      if (mounted) {
        final authService = context.read<AuthService>();
        if (authService.isLoggedIn) {
          Navigator.pushReplacementNamed(context, AppRoutes.mainNav);
        } else {
          Navigator.pushReplacementNamed(context, AppRoutes.login);
        }
      }
    }));
  }

  @override
  void dispose() {
    for (final timer in _timers) {
      timer.cancel();
    }
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KebuninColors.warmCream,
      body: Stack(
        children: [
          // Ambient Glow Accents
          Positioned(
            top: -60,
            left: -60,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: KebuninColors.leafGreen.withOpacity(0.12),
              ),
            ),
          ),
          Positioned(
            bottom: -40,
            right: -40,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: KebuninColors.carrotOrange.withOpacity(0.08),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top Freshness Badge
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: KebuninColors.white,
                        borderRadius:
                            BorderRadius.circular(KebuninRadius.pill),
                        border: Border.all(color: KebuninColors.border),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x06000000),
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.eco_rounded,
                              size: 16, color: KebuninColors.leafGreen),
                          SizedBox(width: 6),
                          Text(
                            'PANEN SUBUH LANGSUNG KE RUMAH',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                              color: KebuninColors.forestGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Center Logo & Title
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Brand Icon Container
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: KebuninColors.white,
                              borderRadius:
                                  BorderRadius.circular(KebuninRadius.xl),
                              border: Border.all(
                                color: KebuninColors.border,
                                width: 1.5,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x12245C3A),
                                  blurRadius: 20,
                                  offset: Offset(0, 8),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                '🌿',
                                style: TextStyle(fontSize: 48),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Brand Name
                          const Text(
                            'KEBUNIN',
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.w900,
                              color: KebuninColors.forestGreen,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 6),

                          // Tagline
                          const Text(
                            'Belanja Sayur Segar, Lebih Mudah.',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: KebuninColors.forestGreenDark,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Subtitle
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text(
                              'Pilihan tani nusantara terkurasi, dipetik higienis dengan jaminan kesegaran alami.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: KebuninColors.mutedGrey,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Bottom Loading Tracker & Version
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 36,
                        height: 36,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              KebuninColors.forestGreen),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        _statusText,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: KebuninColors.mutedGrey,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: KebuninColors.white,
                          borderRadius:
                              BorderRadius.circular(KebuninRadius.pill),
                          border: Border.all(color: KebuninColors.border),
                        ),
                        child: const Text(
                          'Versi 2.4.0 • 100% Petani Lokal',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: KebuninColors.mutedGrey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
