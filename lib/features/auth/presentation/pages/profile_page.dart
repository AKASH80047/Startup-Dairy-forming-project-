import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../bloc/auth_cubit.dart';
import '../bloc/auth_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isHindi = Localizations.localeOf(context).languageCode == 'hi';

    return Scaffold(
      backgroundColor: AppConstants.backgroundCream,
      appBar: AppBar(
        title: Text(isHindi ? 'मेरा खाता' : 'My Account'),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is Unauthenticated) {
            context.go('/');
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return Center(
              child: CircularProgressIndicator(color: AppConstants.primaryGreen),
            );
          }

          if (state is Authenticated) {
            final user = state.user;
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 24),
                    // Profile Avatar
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppConstants.primaryGreen, width: 3),
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: AppConstants.dividerColor.withValues(alpha: 0.2),
                          backgroundImage: user.photoURL != null ? NetworkImage(user.photoURL!) : null,
                          child: user.photoURL == null
                              ? Icon(Icons.person_rounded, size: 60, color: AppConstants.primaryGreen)
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // User Display Name
                    Text(
                      user.displayName ?? (isHindi ? 'डेयरी ग्राहक' : 'Dairy Customer'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppConstants.textPrimary,
                          ),
                    ),
                    const SizedBox(height: 8),
                    // User UID badge
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppConstants.primaryGreen.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'ID: ${user.uid.substring(0, 12)}...',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppConstants.primaryGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // User Details Cards
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: AppConstants.dividerColor, width: 0.5),
                      ),
                      color: AppConstants.surfaceWhite,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            _buildInfoRow(
                              icon: Icons.email_outlined,
                              label: isHindi ? 'ईमेल आईडी' : 'Email Address',
                              value: user.email ?? (isHindi ? 'उपलब्ध नहीं' : 'Not Linked'),
                            ),
                            const Divider(height: 24),
                            _buildInfoRow(
                              icon: Icons.phone_iphone_rounded,
                              label: isHindi ? 'मोबाइल नंबर' : 'Phone Number',
                              value: user.phoneNumber ?? (isHindi ? 'उपलब्ध नहीं' : 'Not Linked'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: AppConstants.dividerColor, width: 0.5),
                      ),
                      color: AppConstants.surfaceWhite,
                      child: InkWell(
                        onTap: () => context.push('/select-location'),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                          child: Row(
                            children: [
                              Icon(Icons.location_on_rounded, color: AppConstants.primaryGreen, size: 24),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  isHindi ? 'प्रशासनिक पता चुनें (All-India)' : 'Select Administrative Location',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppConstants.textPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Icon(Icons.chevron_right_rounded, color: AppConstants.textSecondary),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: AppConstants.dividerColor, width: 0.5),
                      ),
                      color: AppConstants.surfaceWhite,
                      child: InkWell(
                        onTap: () => context.push('/lgd-states'),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                          child: Row(
                            children: [
                              Icon(Icons.map_rounded, color: AppConstants.primaryGreen, size: 24),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  isHindi ? 'राज्य निर्देशिका (LGD)' : 'LGD States Directory',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppConstants.textPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Icon(Icons.chevron_right_rounded, color: AppConstants.textSecondary),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: AppConstants.dividerColor, width: 0.5),
                      ),
                      color: AppConstants.surfaceWhite,
                      child: InkWell(
                        onTap: () => context.push('/lgd-villages'),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                          child: Row(
                            children: [
                              Icon(Icons.villa_rounded, color: AppConstants.primaryGreen, size: 24),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  isHindi ? 'ग्राम निर्देशिका (LGD)' : 'LGD Villages Directory',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppConstants.textPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Icon(Icons.chevron_right_rounded, color: AppConstants.textSecondary),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Log Out Button
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<AuthCubit>().signOut();
                      },
                      icon: const Icon(Icons.logout_rounded, color: Colors.white),
                      label: Text(
                        isHindi ? 'खाता लॉग आउट' : 'Sign Out Account',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Back to Home Button
                    OutlinedButton(
                      onPressed: () => context.go('/'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: AppConstants.primaryGreen),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        isHindi ? 'मुख्य पृष्ठ पर जाएं' : 'Back to Home',
                        style: TextStyle(
                          color: AppConstants.primaryGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // Fallback if state gets weird (should not happen because of listener redirect)
          return Center(
            child: ElevatedButton(
              onPressed: () => context.go('/login'),
              child: Text(isHindi ? 'लॉगिन करें' : 'Login'),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow({required IconData icon, required String label, required String value}) {
    return Row(
      children: [
        Icon(icon, color: AppConstants.primaryGreen, size: 22),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: AppConstants.textSecondary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: AppConstants.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
