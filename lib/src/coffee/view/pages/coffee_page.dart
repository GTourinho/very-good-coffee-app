import 'package:coffee_app/l10n/generated/app_localizations.dart';
import 'package:coffee_app/l10n/l10n.dart';
import 'package:coffee_app/src/coffee/bloc/coffee_bloc.dart';
import 'package:coffee_app/src/coffee/bloc/coffee_event.dart';
import 'package:coffee_app/src/coffee/bloc/coffee_state.dart';
import 'package:coffee_app/src/coffee/bloc/coffee_state_extensions.dart';
import 'package:coffee_app/src/coffee/view/widgets/coffee_image_widget.dart';
import 'package:coffee_app/src/coffee/view/widgets/main_navigation.dart';
import 'package:coffee_app/src/core/design_system/app_colors.dart';
import 'package:coffee_app/src/core/design_system/app_spacing.dart';
import 'package:coffee_app/src/core/design_system/app_text_styles.dart';
import 'package:coffee_app/src/core/services/user_feedback_service.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

/// Main coffee page widget.
class CoffeePage extends StatelessWidget {
  /// Creates a coffee page.
  const CoffeePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<CoffeeBloc>(),
      child: _CoffeePageContent(),
    );
  }
}

class _CoffeePageContent extends StatefulWidget {
  @override
  State<_CoffeePageContent> createState() => _CoffeePageContentState();
}

class _CoffeePageContentState extends State<_CoffeePageContent> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Sync favorite status when page becomes visible
    // This happens when navigating back from other pages
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<CoffeeBloc>().add(const CoffeeFavoriteSyncRequested());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
      ),
      body: BlocListener<CoffeeBloc, CoffeeState>(
        listenWhen: (previous, current) =>
            current is CoffeeLoadFailure || current is CoffeeActionError,
        listener: (context, state) {
          if (state is CoffeeLoadFailure) {
            UserFeedbackService.showSnackBar(
              context,
              state.getLocalizedMessage(context),
              type: FeedbackType.error,
            );
          } else if (state is CoffeeActionError) {
            UserFeedbackService.showSnackBar(
              context,
              state.getLocalizedMessage(context),
              type: FeedbackType.error,
            );
          }
        },
        child: BlocBuilder<CoffeeBloc, CoffeeState>(
          builder: (context, state) {
            if (state is CoffeeInitial) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.appTitle,
                      style: AppTextStyles.pageTitle,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ElevatedButton(
                      onPressed: () => context
                          .read<CoffeeBloc>()
                          .add(const CoffeeRequested()),
                      child: Text(l10n.getYourFirstCoffee),
                    ),
                  ],
                ),
              );
            }

            if (state is CoffeeLoadInProgress) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CoffeeLoadSuccess) {
              return _buildCoffeeContent(state, l10n, context);
            }

            if (state is CoffeeLoadFailure) {
              return Center(
                child: Padding(
                  padding: AppSpacing.paddingHorizontalMedium,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: AppSpacing.iconXLarge,
                        color: AppColors.error,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        l10n.oopsSomethingWentWrong,
                        style: AppTextStyles.sectionTitle,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        state.getLocalizedMessage(context),
                        style: AppTextStyles.bodyText,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      ElevatedButton(
                        onPressed: () => context
                            .read<CoffeeBloc>()
                            .add(const CoffeeRequested()),
                        child: Text(l10n.tryAgain),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Handle CoffeeActionError by showing the previous state
            if (state is CoffeeActionError) {
              return _buildCoffeeContent(state.previousState, l10n, context);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
      bottomNavigationBar: const AppBottomNavigation(currentIndex: 0),
    );
  }

  Widget _buildCoffeeContent(
    CoffeeLoadSuccess state, AppLocalizations l10n, BuildContext context,) {
    final coffee = state.currentCoffee;
    if (coffee == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.appTitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.pageTitle,
            ),
            const SizedBox(height: AppSpacing.md),
            ElevatedButton(
              onPressed: () => context
                  .read<CoffeeBloc>()
                  .add(const CoffeeRequested()),
              child: Text(l10n.getYourFirstCoffee),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: AppSpacing.paddingAllMedium,
            child: CoffeeImageWidget<CoffeeModel>(
              coffee: CoffeeModel.fromEntity(coffee),
              onRefresh: () => context
                  .read<CoffeeBloc>()
                  .add(const CoffeeRequested()),
            ),
          ),
        ),
      ],
    );
  }
}
