import 'package:coffee_app/l10n/generated/app_localizations.dart';
import 'package:coffee_app/src/coffee/data/models/coffee_model.dart';
import 'package:coffee_app/src/coffee/presentation/bloc/coffee_bloc.dart';
import 'package:coffee_app/src/coffee/presentation/bloc/coffee_event.dart';
import 'package:coffee_app/src/coffee/presentation/bloc/coffee_state.dart';
import 'package:coffee_app/src/coffee/presentation/widgets/coffee_image_widget.dart';
import 'package:coffee_app/src/core/design_system/app_colors.dart';
import 'package:coffee_app/src/core/design_system/app_spacing.dart';
import 'package:coffee_app/src/core/design_system/app_text_styles.dart';
import 'package:coffee_app/src/core/services/user_feedback_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Main coffee page widget.
class CoffeePage extends StatelessWidget {
  /// Creates a coffee page.
  const CoffeePage({required this.coffeeBloc, super.key});

  /// The coffee bloc instance.
  final CoffeeBloc coffeeBloc;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
      ),
      body: BlocListener<CoffeeBloc, CoffeeState>(
        bloc: coffeeBloc,
        listenWhen: (previous, current) =>
            current is CoffeeLoadFailure || current is CoffeeActionError,
        listener: (context, state) {
          if (state is CoffeeLoadFailure) {
            UserFeedbackService.showSnackBar(
              context,
              state.error,
              type: FeedbackType.error,
            );
          } else if (state is CoffeeActionError) {
            UserFeedbackService.showSnackBar(
              context,
              state.error,
              type: FeedbackType.error,
            );
          }
        },
        child: BlocBuilder<CoffeeBloc, CoffeeState>(
          bloc: coffeeBloc,
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
                    onPressed: () => coffeeBloc.add(const CoffeeRequested()),
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
                      onPressed: () => coffeeBloc.add(const CoffeeRequested()),
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
                      onRefresh: () => coffeeBloc.add(const CoffeeRequested()),
                    ),
                  ),
                ),
              ],
            );
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
                      state.error,
                      style: AppTextStyles.bodyText,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ElevatedButton(
                      onPressed: () => coffeeBloc.add(const CoffeeRequested()),
                      child: Text(l10n.tryAgain),
                    ),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
