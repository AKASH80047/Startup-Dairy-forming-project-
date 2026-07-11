import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../language/presentation/bloc/language_cubit.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  double _omScale = 0.5;
  double _omOpacity = 0.0;
  
  double _devotionalOpacity = 0.0;
  double _brandOpacity = 0.0;

  final List<Timer> _timers = [];

  @override
  void initState() {
    super.initState();
    _startAnimationSequence();
  }

  @override
  void dispose() {
    for (final timer in _timers) {
      timer.cancel();
    }
    super.dispose();
  }

  void _startAnimationSequence() {
    // Step 1: Animate the ॐ symbol
    _timers.add(Timer(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _omScale = 1.0;
          _omOpacity = 1.0;
        });
      }
    }));

    // Step 2: Show "ॐ नमः शिवाय" / "OM NAMAH SHIVAYA"
    _timers.add(Timer(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _devotionalOpacity = 1.0;
        });
      }
    }));

    // Step 3: Show "PANDEY DAIRY FARMING" + taglines
    _timers.add(Timer(const Duration(milliseconds: 2200), () {
      if (mounted) {
        setState(() {
          _brandOpacity = 1.0;
        });
      }
    }));

    // Step 4: Navigate to next page
    _timers.add(Timer(const Duration(milliseconds: 3800), () {
      if (mounted) {
        _navigateToNextScreen();
      }
    }));
  }

  void _navigateToNextScreen() {
    final languageCubit = context.read<LanguageCubit>();
    if (languageCubit.state.isLanguageSelected) {
      context.go('/home');
    } else {
      context.go('/language');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundCream,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Devotional Symbol (ॐ)
              AnimatedScale(
                scale: _omScale,
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutBack,
                child: AnimatedOpacity(
                  opacity: _omOpacity,
                  duration: const Duration(milliseconds: 600),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppConstants.accentGold.withValues(alpha: 0.4),
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      'ॐ',
                      style: TextStyle(
                        fontSize: 64,
                        color: AppConstants.accentGold,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Devotional Text Phase
              AnimatedOpacity(
                opacity: _devotionalOpacity,
                duration: const Duration(milliseconds: 800),
                child: Column(
                  children: [
                    Text(
                      AppConstants.shivayaHi,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppConstants.primaryGreen,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppConstants.shivayaEn,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: AppConstants.primaryGreen.withValues(alpha: 0.7),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),

              // Brand Identity & Taglines Phase
              AnimatedOpacity(
                opacity: _brandOpacity,
                duration: const Duration(milliseconds: 800),
                child: Column(
                  children: [
                    Text(
                      AppConstants.appNameHi.toUpperCase(),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppConstants.primaryGreen,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppConstants.appNameEn.toUpperCase(),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppConstants.primaryGreen,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppConstants.primaryGreen.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppConstants.primaryGreen.withValues(alpha: 0.1),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            AppConstants.taglineHi,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppConstants.primaryGreen,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            AppConstants.taglineEn,
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                  color: AppConstants.textSecondary,
                                  fontStyle: FontStyle.italic,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
