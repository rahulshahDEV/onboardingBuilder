import 'package:flutter/material.dart';
import 'onboarding_step.dart';
import 'onboarding_controller.dart';
import 'onboarding_type.dart';
import 'slide_onboarding.dart';
import 'card_onboarding.dart';
import 'fullscreen_onboarding.dart';
import 'story_onboarding.dart';
import 'liquid_onboarding.dart';
import 'vertical_onboarding.dart';
import 'floating_onboarding.dart';

class OnboardingBuilder extends StatefulWidget {
  final List<OnboardingStep> steps;
  final OnboardingController? controller;
  final VoidCallback? onComplete;
  final OnboardingType type;
  final OnboardingTheme? theme;
  final Widget Function(BuildContext context, int currentIndex)? customStepBuilder;
  final Widget Function(BuildContext context, OnboardingController controller)? customNavigationBuilder;
  final EdgeInsetsGeometry padding;
  final bool showProgressIndicator;
  final bool showSkipButton;
  final Duration animationDuration;
  final Curve animationCurve;
  final double? cardElevation;
  final double? cardBorderRadius;
  final bool enableSwipeGesture;
  final Widget? backgroundWidget;
  final bool autoAdvance;
  final Duration autoAdvanceDuration;
  final List<Color>? waveColors;
  final bool enableSnapScrolling;
  final ScrollPhysics? scrollPhysics;
  final bool enableParallaxEffect;
  final bool showParticleBackground;

  const OnboardingBuilder({
    Key? key,
    required this.steps,
    this.controller,
    this.onComplete,
    this.type = OnboardingType.slide,
    this.theme,
    this.customStepBuilder,
    this.customNavigationBuilder,
    this.padding = const EdgeInsets.all(24.0),
    this.showProgressIndicator = true,
    this.showSkipButton = true,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
    this.cardElevation,
    this.cardBorderRadius,
    this.enableSwipeGesture = true,
    this.backgroundWidget,
    this.autoAdvance = false,
    this.autoAdvanceDuration = const Duration(seconds: 3),
    this.waveColors,
    this.enableSnapScrolling = true,
    this.scrollPhysics,
    this.enableParallaxEffect = true,
    this.showParticleBackground = true,
  }) : super(key: key);

  @override
  State<OnboardingBuilder> createState() => _OnboardingBuilderState();
}

class _OnboardingBuilderState extends State<OnboardingBuilder> {
  late OnboardingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? OnboardingController(totalSteps: widget.steps.length);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.customStepBuilder != null || widget.customNavigationBuilder != null) {
      return _buildCustomOnboarding();
    }

    switch (widget.type) {
      case OnboardingType.slide:
        return SlideOnboarding(
          steps: widget.steps,
          controller: _controller,
          onComplete: widget.onComplete,
          theme: widget.theme,
          showSkipButton: widget.showSkipButton,
          showProgressDots: widget.showProgressIndicator,
          animationDuration: widget.animationDuration,
          animationCurve: widget.animationCurve,
          padding: widget.padding,
        );
      case OnboardingType.card:
        return CardOnboarding(
          steps: widget.steps,
          controller: _controller,
          onComplete: widget.onComplete,
          theme: widget.theme,
          showSkipButton: widget.showSkipButton,
          showProgressBar: widget.showProgressIndicator,
          animationDuration: widget.animationDuration,
          animationCurve: widget.animationCurve,
          padding: widget.padding,
          cardElevation: widget.cardElevation,
          cardBorderRadius: widget.cardBorderRadius,
        );
      case OnboardingType.fullScreen:
        return FullScreenOnboarding(
          steps: widget.steps,
          controller: _controller,
          onComplete: widget.onComplete,
          theme: widget.theme,
          showSkipButton: widget.showSkipButton,
          showProgressIndicator: widget.showProgressIndicator,
          animationDuration: widget.animationDuration,
          animationCurve: widget.animationCurve,
          enableSwipeGesture: widget.enableSwipeGesture,
          backgroundWidget: widget.backgroundWidget,
        );
      case OnboardingType.story:
        return StoryOnboarding(
          steps: widget.steps,
          controller: _controller,
          onComplete: widget.onComplete,
          theme: widget.theme,
          showSkipButton: widget.showSkipButton,
          showProgressBar: widget.showProgressIndicator,
          animationDuration: widget.animationDuration,
          animationCurve: widget.animationCurve,
          padding: widget.padding,
          autoAdvance: widget.autoAdvance,
          autoAdvanceDuration: widget.autoAdvanceDuration,
        );
      case OnboardingType.liquid:
        return LiquidOnboarding(
          steps: widget.steps,
          controller: _controller,
          onComplete: widget.onComplete,
          theme: widget.theme,
          showSkipButton: widget.showSkipButton,
          animationDuration: widget.animationDuration,
          animationCurve: widget.animationCurve,
          padding: widget.padding,
          waveColors: widget.waveColors,
        );
      case OnboardingType.vertical:
        return VerticalOnboarding(
          steps: widget.steps,
          controller: _controller,
          onComplete: widget.onComplete,
          theme: widget.theme,
          showSkipButton: widget.showSkipButton,
          showSideProgress: widget.showProgressIndicator,
          animationDuration: widget.animationDuration,
          animationCurve: widget.animationCurve,
          padding: widget.padding,
          enableSnapScrolling: widget.enableSnapScrolling,
          scrollPhysics: widget.scrollPhysics,
        );
      case OnboardingType.floating:
        return FloatingOnboarding(
          steps: widget.steps,
          controller: _controller,
          onComplete: widget.onComplete,
          theme: widget.theme,
          showSkipButton: widget.showSkipButton,
          showFloatingProgress: widget.showProgressIndicator,
          animationDuration: widget.animationDuration,
          animationCurve: widget.animationCurve,
          padding: widget.padding,
          enableParallaxEffect: widget.enableParallaxEffect,
          showParticleBackground: widget.showParticleBackground,
        );
    }
  }

  Widget _buildCustomOnboarding() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final currentStep = widget.steps[_controller.currentIndex];
        final theme = widget.theme ?? const OnboardingTheme();
        
        return Scaffold(
          backgroundColor: currentStep.backgroundColor ?? theme.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: Padding(
              padding: widget.padding,
              child: Column(
                children: [
                  if (widget.showProgressIndicator)
                    _buildProgressIndicator(theme),
                  const SizedBox(height: 32),
                  Expanded(
                    child: widget.customStepBuilder?.call(context, _controller.currentIndex) ??
                        _buildDefaultStep(currentStep, theme),
                  ),
                  const SizedBox(height: 32),
                  widget.customNavigationBuilder?.call(context, _controller) ??
                      _buildDefaultNavigation(theme),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgressIndicator(OnboardingTheme theme) {
    return LinearProgressIndicator(
      value: _controller.progress,
      backgroundColor: theme.secondaryColor ?? Colors.grey[300],
      valueColor: AlwaysStoppedAnimation<Color>(
        theme.progressIndicatorColor ?? theme.primaryColor ?? Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildDefaultStep(OnboardingStep step, OnboardingTheme theme) {
    return Container(
      decoration: step.backgroundDecoration,
      child: Padding(
        padding: step.padding ?? EdgeInsets.zero,
        child: Column(
          mainAxisAlignment: step.mainAxisAlignment ?? MainAxisAlignment.center,
          crossAxisAlignment: step.crossAxisAlignment ?? CrossAxisAlignment.center,
          children: [
            if (step.customContent != null)
              step.customContent!
            else ...[
              if (step.displayIcon != null) ...[
                step.displayIcon!,
                SizedBox(height: step.spacing ?? 32),
              ],
              Text(
                step.title,
                style: step.titleStyle ?? 
                    theme.titleStyle ??
                    Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: step.titleColor ?? theme.textColor,
                    ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: step.spacing ?? 16),
              Text(
                step.description,
                style: step.descriptionStyle ?? 
                    theme.descriptionStyle ??
                    Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: step.descriptionColor ?? theme.textColor ?? Colors.grey[600],
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultNavigation(OnboardingTheme theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (!_controller.isFirstStep)
          TextButton(
            onPressed: _controller.previousStep,
            style: TextButton.styleFrom(
              foregroundColor: theme.secondaryColor ?? Colors.grey[600],
            ),
            child: Text(
              'Previous',
              style: theme.buttonTextStyle?.copyWith(
                color: theme.secondaryColor ?? Colors.grey[600],
              ),
            ),
          )
        else
          const SizedBox.shrink(),
        if (!_controller.isLastStep)
          ElevatedButton(
            onPressed: _controller.nextStep,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.buttonColor ?? theme.primaryColor ?? Theme.of(context).primaryColor,
              foregroundColor: theme.buttonTextColor ?? Colors.white,
            ),
            child: Text(
              'Next',
              style: theme.buttonTextStyle?.copyWith(
                color: theme.buttonTextColor ?? Colors.white,
              ),
            ),
          )
        else
          ElevatedButton(
            onPressed: widget.onComplete,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.buttonColor ?? theme.primaryColor ?? Theme.of(context).primaryColor,
              foregroundColor: theme.buttonTextColor ?? Colors.white,
            ),
            child: Text(
              'Get Started',
              style: theme.buttonTextStyle?.copyWith(
                color: theme.buttonTextColor ?? Colors.white,
              ),
            ),
          ),
      ],
    );
  }
}