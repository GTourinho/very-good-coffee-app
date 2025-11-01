import 'package:coffee_app/l10n/generated/app_localizations.dart';
import 'package:coffee_app/src/coffee/view/widgets/main_navigation.dart';
import 'package:coffee_app/src/core/design_system/app_colors.dart';
import 'package:coffee_app/src/core/design_system/app_spacing.dart';
import 'package:coffee_app/src/core/design_system/app_text_styles.dart';
import 'package:coffee_app/src/core/design_system/app_theme.dart';
import 'package:coffee_app/src/core/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Settings page widget.
class SettingsPage extends StatelessWidget {
  /// Creates a settings page.
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: ListView(
        padding: AppSpacing.paddingAllMedium,
        children: [
          Text(
            l10n.themeSettings,
            style: AppTextStyles.sectionTitle,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.chooseYourRoast,
            style: AppTextStyles.caption,
          ),
          const SizedBox(height: AppSpacing.md),
          BlocBuilder<ThemeCubit, CoffeeRoast>(
            builder: (context, currentRoast) {
              return Column(
                children: [
                  _RoastThemeCard(
                    roast: CoffeeRoast.lightRoast,
                    title: l10n.lightRoast,
                    description: l10n.lightRoastDescription,
                    icon: '☕',
                    color: AppColors.lightRoastPrimary,
                    isSelected: currentRoast == CoffeeRoast.lightRoast,
                    onTap: () async {
                      await context.read<ThemeCubit>().setTheme(
                            CoffeeRoast.lightRoast,
                          );
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _RoastThemeCard(
                    roast: CoffeeRoast.mediumRoast,
                    title: l10n.mediumRoast,
                    description: l10n.mediumRoastDescription,
                    icon: '☕☕',
                    color: AppColors.mediumRoastPrimary,
                    isSelected: currentRoast == CoffeeRoast.mediumRoast,
                    onTap: () async {
                      await context.read<ThemeCubit>().setTheme(
                            CoffeeRoast.mediumRoast,
                          );
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _RoastThemeCard(
                    roast: CoffeeRoast.darkRoast,
                    title: l10n.darkRoast,
                    description: l10n.darkRoastDescription,
                    icon: '☕☕☕',
                    color: AppColors.darkRoastPrimary,
                    isSelected: currentRoast == CoffeeRoast.darkRoast,
                    onTap: () async {
                      await context.read<ThemeCubit>().setTheme(
                            CoffeeRoast.darkRoast,
                          );
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNavigation(currentIndex: 2),
    );
  }
}

class _RoastThemeCard extends StatelessWidget {
  const _RoastThemeCard({
    required this.roast,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  final CoffeeRoast roast;
  final String title;
  final String description;
  final String icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
      child: Container(
        padding: AppSpacing.paddingAllMedium,
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : null,
          border: Border.all(
            color: isSelected
                ? color
                : Theme.of(context).colorScheme.onSurface.withValues(
                      alpha: 0.2,
                    ),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
              ),
              child: Center(
                child: Text(
                  icon,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    description,
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
            // Check mark
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: color,
                size: AppSpacing.iconMedium,
              ),
          ],
        ),
      ),
    );
  }
}
