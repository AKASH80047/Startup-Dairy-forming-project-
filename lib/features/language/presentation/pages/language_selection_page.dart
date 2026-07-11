import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../bloc/language_cubit.dart';

class LanguageSelectionPage extends StatefulWidget {
  const LanguageSelectionPage({super.key});

  @override
  State<LanguageSelectionPage> createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
  String _selectedLangCode = 'en';

  @override
  Widget build(BuildContext context) {
    final bool isHindiSelected = _selectedLangCode == 'hi';

    return Scaffold(
      backgroundColor: AppConstants.backgroundCream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              // Devotional Header
              Center(
                child: Text(
                  isHindiSelected ? AppConstants.shivayaHi : AppConstants.shivayaEn,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppConstants.primaryGreen.withValues(alpha: 0.6),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                      ),
                ),
              ),
              const SizedBox(height: 32),
              
              // Localized Main Title
              Text(
                isHindiSelected ? 'अपनी भाषा चुनें' : 'Choose Your Language',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: AppConstants.primaryGreen,
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                isHindiSelected 
                    ? 'कृपया आगे बढ़ने के लिए अपनी पसंदीदा भाषा चुनें।'
                    : 'Please select your preferred language to continue.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppConstants.textSecondary,
                    ),
              ),
              const SizedBox(height: 48),

              // Language Cards Grid/List
              Expanded(
                child: Column(
                  children: [
                    _buildLanguageCard(
                      langName: 'English',
                      langSubtitle: 'Pure • Fresh • From Our Roots',
                      code: 'en',
                      isSelected: _selectedLangCode == 'en',
                    ),
                    const SizedBox(height: 16),
                    _buildLanguageCard(
                      langName: 'हिंदी (Hindi)',
                      langSubtitle: 'शुद्ध • ताज़ा • अपनी मिट्टी से',
                      code: 'hi',
                      isSelected: _selectedLangCode == 'hi',
                    ),
                  ],
                ),
              ),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Update Cubit state and navigate to Home
                    context.read<LanguageCubit>().changeLanguage(_selectedLangCode);
                    context.go('/home');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(isHindiSelected ? 'आगे बढ़ें' : 'Continue'),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_rounded, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageCard({
    required String langName,
    required String langSubtitle,
    required String code,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedLangCode = code;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? AppConstants.surfaceWhite : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppConstants.primaryGreen : AppConstants.dividerColor,
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppConstants.primaryGreen.withValues(alpha: 0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  )
                ]
              : [],
        ),
        child: Row(
          children: [
            // Custom Radio Icon
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppConstants.primaryGreen : AppConstants.textSecondary,
                  width: 2.0,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: AppConstants.primaryGreen,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 20),
            // Text Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    langName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: isSelected ? AppConstants.primaryGreen : AppConstants.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    langSubtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppConstants.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
