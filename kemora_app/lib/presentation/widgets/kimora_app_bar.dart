import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class KimoraAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBack;
  final Widget? trailing;
  final VoidCallback? onMenuPressed;
  final VoidCallback? onSearchTap;

  const KimoraAppBar({
    super.key,
    this.showBack = false,
    this.trailing,
    this.onMenuPressed,
    this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 40,
            offset: const Offset(0, 20),
          )
        ],
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: SafeArea(
            bottom: false,
            child: Container(
              height: 64,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Leading
                  GestureDetector(
                    onTap: () {
                      if (showBack) {
                        Navigator.of(context).pop();
                      } else if (onMenuPressed != null) {
                        onMenuPressed!();
                      }
                    },
                    child: Icon(
                      showBack ? Icons.arrow_back : Icons.menu,
                      color: AppColors.primaryContainer,
                      size: 24,
                    ),
                  ),
                  
                  // Center
                  Text(
                    'KIMORA',
                    style: AppTypography.headlineSmall.copyWith(
                      color: AppColors.primaryContainer,
                      letterSpacing: 2.0, // Widest tracking
                    ),
                  ),
                  
                  // Trailing
                  if (trailing != null)
                    trailing!
                  else
                    GestureDetector(
                      onTap: onSearchTap ?? () {},
                      child: const Icon(
                        Icons.search,
                        color: AppColors.primaryContainer,
                        size: 24,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}
