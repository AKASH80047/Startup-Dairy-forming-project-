import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../bloc/auth_cubit.dart';
import '../bloc/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();

  // Text Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  bool _isObscure = true;

  @override
  void initState() {
    super.initState();
    // 0: Email Login, 1: Register, 2: Phone Login
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isHindi = Localizations.localeOf(context).languageCode == 'hi';

    return Scaffold(
      backgroundColor: AppConstants.backgroundCream,
      appBar: AppBar(
        title: Text(isHindi ? 'खाता लॉग इन' : 'Account Sign In'),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  isHindi
                      ? 'सफलतापूर्वक लॉग इन किया गया! स्वागत है, ${state.user.displayName ?? state.user.email ?? state.user.phoneNumber}'
                      : 'Successfully signed in! Welcome, ${state.user.displayName ?? state.user.email ?? state.user.phoneNumber}',
                ),
                backgroundColor: AppConstants.primaryGreen,
              ),
            );
            // Redirect back or go home
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Brand / Logo Header
                    const SizedBox(height: 20),
                    Center(
                      child: Icon(
                        Icons.pets_rounded,
                        size: 80,
                        color: AppConstants.primaryGreen,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isHindi ? 'पांडे डेयरी फार्म' : 'Pandey Dairy Farm',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: AppConstants.primaryGreen,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      isHindi ? 'शुद्ध दूध, सीधा आपके घर' : 'Pure milk, directly to your home',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppConstants.textSecondary,
                          ),
                    ),
                    const SizedBox(height: 32),

                    // Custom Tab Bar for Auth Modes
                    Container(
                      decoration: BoxDecoration(
                        color: AppConstants.dividerColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        labelColor: Colors.white,
                        unselectedLabelColor: AppConstants.textSecondary,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: BoxDecoration(
                          color: AppConstants.primaryGreen,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        tabs: [
                          Tab(text: isHindi ? 'लॉगिन' : 'Login'),
                          Tab(text: isHindi ? 'रजिस्टर' : 'Register'),
                          Tab(text: isHindi ? 'फ़ोन OTP' : 'Phone OTP'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Auth Input forms
                    SizedBox(
                      height: 280,
                      child: TabBarView(
                        controller: _tabController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          // 1. Email Login Tab
                          _buildEmailLoginTab(isHindi),
                          // 2. Email Register Tab
                          _buildRegisterTab(isHindi),
                          // 3. Phone OTP Tab
                          _buildPhoneOtpTab(isHindi, state),
                        ],
                      ),
                    ),

                    // Action Button or Loading Indicator
                    if (state is AuthLoading)
                      Center(
                        child: CircularProgressIndicator(
                          color: AppConstants.primaryGreen,
                        ),
                      )
                    else
                      ElevatedButton(
                        onPressed: () => _handleSubmit(state),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          _getButtonText(isHindi, state),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),

                    const SizedBox(height: 24),

                    // Divider
                    Row(
                      children: [
                        Expanded(
                          child: Divider(color: AppConstants.dividerColor, thickness: 1),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            isHindi ? 'या' : 'OR',
                            style: TextStyle(color: AppConstants.textSecondary, fontSize: 13),
                          ),
                        ),
                        Expanded(
                          child: Divider(color: AppConstants.dividerColor, thickness: 1),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Google Sign-In Button
                    OutlinedButton.icon(
                      onPressed: () {
                        context.read<AuthCubit>().signInWithGoogle();
                      },
                      icon: const Icon(Icons.g_mobiledata_rounded, size: 30, color: Colors.red),
                      label: Text(
                        isHindi ? 'गूगल के साथ साइन-इन करें' : 'Continue with Google',
                        style: TextStyle(
                          color: AppConstants.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(color: AppConstants.dividerColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmailLoginTab(bool isHindi) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.email_outlined),
            hintText: isHindi ? 'ईमेल एड्रेस' : 'Email Address',
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return isHindi ? 'कृपया ईमेल दर्ज करें' : 'Please enter email';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
              return isHindi ? 'कृपया सही ईमेल दर्ज करें' : 'Please enter a valid email';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _passwordController,
          obscureText: _isObscure,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
              onPressed: () => setState(() => _isObscure = !_isObscure),
            ),
            hintText: isHindi ? 'पासवर्ड' : 'Password',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return isHindi ? 'कृपया पासवर्ड दर्ज करें' : 'Please enter password';
            }
            if (value.length < 6) {
              return isHindi ? 'पासवर्ड कम से कम ६ अक्षरों का होना चाहिए' : 'Password must be at least 6 characters';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildRegisterTab(bool isHindi) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.person_outline),
            hintText: isHindi ? 'आपका नाम' : 'Your Full Name',
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return isHindi ? 'कृपया नाम दर्ज करें' : 'Please enter your name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.email_outlined),
            hintText: isHindi ? 'ईमेल एड्रेस' : 'Email Address',
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return isHindi ? 'कृपया ईमेल दर्ज करें' : 'Please enter email';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
              return isHindi ? 'कृपया सही ईमेल दर्ज करें' : 'Please enter a valid email';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _passwordController,
          obscureText: _isObscure,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
              onPressed: () => setState(() => _isObscure = !_isObscure),
            ),
            hintText: isHindi ? 'पासवर्ड' : 'Password',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return isHindi ? 'कृपया पासवर्ड दर्ज करें' : 'Please enter password';
            }
            if (value.length < 6) {
              return isHindi ? 'पासवर्ड कम से कम ६ अक्षरों का होना चाहिए' : 'Password must be at least 6 characters';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPhoneOtpTab(bool isHindi, AuthState state) {
    final isOtpSent = state is OtpSent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          enabled: !isOtpSent,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.phone_iphone_rounded),
            hintText: isHindi ? 'मोबाइल नंबर (जैसे +919999999999)' : 'Phone Number (e.g. +919999999999)',
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return isHindi ? 'कृपया फोन नंबर दर्ज करें' : 'Please enter phone number';
            }
            if (!value.trim().startsWith('+')) {
              return isHindi
                  ? 'कृपया कंट्री कोड के साथ दर्ज करें (जैसे +91)'
                  : 'Please start with country code (e.g. +91)';
            }
            return null;
          },
        ),
        if (isOtpSent) ...[
          const SizedBox(height: 16),
          TextFormField(
            controller: _otpController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.pin_rounded),
              hintText: isHindi ? '६-अंकीय OTP कोड दर्ज करें' : 'Enter 6-digit OTP Code',
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return isHindi ? 'कृपया ओटीपी दर्ज करें' : 'Please enter OTP';
              }
              if (value.trim().length != 6) {
                return isHindi ? 'ओटीपी ६ अंकों का होना चाहिए' : 'OTP must be 6 digits';
              }
              return null;
            },
          ),
        ],
      ],
    );
  }

  String _getButtonText(bool isHindi, AuthState state) {
    if (_tabController.index == 0) {
      return isHindi ? 'लॉगिन करें' : 'Sign In';
    } else if (_tabController.index == 1) {
      return isHindi ? 'रजिस्टर करें' : 'Create Account';
    } else {
      return state is OtpSent
          ? (isHindi ? 'ओटीपी सत्यापित करें' : 'Verify OTP Code')
          : (isHindi ? 'ओटीपी कोड भेजें' : 'Send Verification Code');
    }
  }

  void _handleSubmit(AuthState state) {
    if (!_formKey.currentState!.validate()) return;

    final cubit = context.read<AuthCubit>();
    if (_tabController.index == 0) {
      // Email Login
      cubit.signInWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text,
      );
    } else if (_tabController.index == 1) {
      // Email Register
      cubit.signUpWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text,
        _nameController.text.trim(),
      );
    } else {
      // Phone OTP Flow
      if (state is OtpSent) {
        cubit.verifyOtp(state.verificationId, _otpController.text.trim());
      } else {
        cubit.verifyPhoneNumber(_phoneController.text.trim());
      }
    }
  }
}
