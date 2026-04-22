import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../home/home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    color: AppColors.surfaceContainerHigh,
                    child: const Center(child: Icon(Icons.image, size: 64, color: AppColors.outlineVariant)),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black.withValues(alpha: 0.2), Colors.black.withValues(alpha: 0.8)],
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('KIMORA', style: AppTypography.displaySmall.copyWith(color: Colors.white, letterSpacing: 4.0)),
                        const SizedBox(height: 8),
                        Text('THE MODERN ARCHIVIST', style: AppTypography.labelSmall.copyWith(color: AppColors.primaryFixedDim, letterSpacing: 2.0)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Welcome Back', style: AppTypography.headlineLarge.copyWith(color: AppColors.primaryContainer)),
                  const SizedBox(height: 8),
                  Text('Sign in to continue your journey.', style: AppTypography.bodyLarge),
                  const SizedBox(height: 48),
                  
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Email Address',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline),
                      suffixIcon: Icon(Icons.visibility_off),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text('Forgot Password?', style: AppTypography.labelMedium.copyWith(color: AppColors.primaryContainer)),
                  ),
                  
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
                    },
                    style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 56)),
                    child: const Text('SIGN IN TO KIMORA'),
                  ),
                  
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text('DISCOVERY LOGIN', style: AppTypography.labelSmall),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.g_mobiledata, color: Colors.black),
                          label: const Text('Google', style: TextStyle(color: Colors.black)),
                          style: OutlinedButton.styleFrom(backgroundColor: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.apple, color: Colors.white),
                          label: const Text('Apple'),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 40),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RegisterScreen()));
                      },
                      child: RichText(
                        text: TextSpan(
                          style: AppTypography.bodyMedium,
                          children: [
                            const TextSpan(text: 'New to the archives? '),
                            TextSpan(text: 'Create an account', style: TextStyle(color: AppColors.primaryContainer, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40), // Bottom padding
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
