import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../widgets/kemora_app_bar.dart';
import '../home/home_screen.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const KemoraAppBar(showBack: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Create Account', style: AppTypography.headlineLarge),
            const SizedBox(height: 8),
            Text('Join the elite travel circle today.', style: AppTypography.bodyLarge),
            const SizedBox(height: 48),
            
            Text('FULL NAME', style: AppTypography.labelSmall),
            const SizedBox(height: 8),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Enter your full name',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            
            const SizedBox(height: 24),
            Text('EMAIL ADDRESS', style: AppTypography.labelSmall),
            const SizedBox(height: 8),
            TextField(
              decoration: const InputDecoration(
                hintText: 'name@luxury-travel.com',
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
            
            const SizedBox(height: 24),
            Text('PASSWORD', style: AppTypography.labelSmall),
            const SizedBox(height: 8),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                hintText: '••••••••',
                prefixIcon: Icon(Icons.lock_outline),
                suffixIcon: Icon(Icons.visibility_off),
              ),
            ),
            
            const SizedBox(height: 24),
            Text('COUNTRY', style: AppTypography.labelSmall),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.public, color: AppColors.onSurfaceVariant),
                  const SizedBox(width: 12),
                  Text('Select your country', style: AppTypography.bodyMedium),
                  const Spacer(),
                  const Icon(Icons.expand_more, color: AppColors.onSurfaceVariant),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: false,
                    onChanged: (val) {},
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: AppTypography.bodySmall,
                      children: [
                        const TextSpan(text: 'I agree to the '),
                        TextSpan(text: 'Terms & Conditions', style: TextStyle(color: AppColors.primaryContainer, fontWeight: FontWeight.bold)),
                        const TextSpan(text: ' and '),
                        TextSpan(text: 'Privacy Policy', style: TextStyle(color: AppColors.primaryContainer, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
              },
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 56)),
              child: const Text('Create Account'),
            ),
            
            const SizedBox(height: 32),
            Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text('OR SIGN UP WITH', style: AppTypography.labelSmall),
                ),
                const Expanded(child: Divider()),
              ],
            ),
            
            const SizedBox(height: 32),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.g_mobiledata, color: Colors.black, size: 28),
              label: const Text('Continue with Google', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
              ),
            ),
            
            const SizedBox(height: 32),
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: RichText(
                  text: TextSpan(
                    style: AppTypography.bodyMedium,
                    children: [
                      const TextSpan(text: 'Already have an account? '),
                      TextSpan(text: 'Login', style: TextStyle(color: AppColors.primaryContainer, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
