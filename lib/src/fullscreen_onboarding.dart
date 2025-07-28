import 'package:flutter/material.dart';
import 'onboarding_step.dart';
import 'onboarding_controller.dart';
import 'onboarding_type.dart';

class FullScreenOnboarding extends StatefulWidget {
  final List<OnboardingStep> steps;
  final OnboardingController controller;
  final VoidCallback? onComplete;
  final OnboardingTheme? theme;
  final bool showSkipButton;
  final bool showProgressIndicator;
  final Duration animationDuration;
  final Curve animationCurve;
  final bool enableSwipeGesture;
  final Widget? backgroundWidget;

  const FullScreenOnboarding({
    Key? key,
    required this.steps,
    required this.controller,
    this.onComplete,
    this.theme,
    this.showSkipButton = true,
    this.showProgressIndicator = true,
    this.animationDuration = const Duration(milliseconds: 600),
    this.animationCurve = Curves.easeInOutQuart,
    this.enableSwipeGesture = true,
    this.backgroundWidget,
  }) : super(key: key);

  @override
  State<FullScreenOnboarding> createState() => _FullScreenOnboardingState();
}

class _FullScreenOnboardingState extends State<FullScreenOnboarding>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _backgroundController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _mainController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _backgroundController = AnimationController(
      duration: Duration(milliseconds: widget.animationDuration.inMilliseconds * 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: Interval(0.3, 1.0, curve: widget.animationCurve),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: widget.animationCurve,
    ));

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: Interval(0.0, 0.7, curve: Curves.elasticOut),
      ),
    );

    _colorAnimation = ColorTween(
      begin: Colors.transparent,
      end: Colors.black.withValues(alpha: 0.1),
    ).animate(_backgroundController);

    _mainController.forward();
    _backgroundController.forward();

    widget.controller.addListener(_onControllerChanged);
  }

  void _onControllerChanged() {
    _mainController.reset();
    _mainController.forward();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    _mainController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme ?? const OnboardingTheme();
    
    return Scaffold(
      body: AnimatedBuilder(
        animation: widget.controller,
        builder: (context, child) {
          final currentStep = widget.steps[widget.controller.currentIndex];
          
          return GestureDetector(
            onHorizontalDragEnd: widget.enableSwipeGesture ? _handleSwipe : null,
            child: Stack(
              children: [
                _buildBackground(currentStep, theme),
                AnimatedBuilder(
                  animation: _colorAnimation,
                  builder: (context, child) {
                    return Container(
                      color: _colorAnimation.value,
                      child: child,
                    );
                  },
                  child: SafeArea(
                    child: Column(
                      children: [
                        _buildHeader(theme),
                        Expanded(
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: FadeTransition(
                              opacity: _fadeAnimation,
                              child: ScaleTransition(
                                scale: _scaleAnimation,
                                child: _buildContent(currentStep, theme),
                              ),
                            ),
                          ),
                        ),
                        _buildFooter(theme),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBackground(OnboardingStep step, OnboardingTheme theme) {
    if (step.backgroundImageProvider != null || step.backgroundImagePath != null) {
      return Container(
        decoration: step.backgroundDecoration,
        child: widget.backgroundWidget,
      );
    }
    
    if (step.backgroundGradient != null) {
      return Container(
        decoration: BoxDecoration(gradient: step.backgroundGradient),
        child: widget.backgroundWidget,
      );
    }
    
    return Container(
      color: step.backgroundColor ?? theme.backgroundColor ?? Theme.of(context).primaryColor,
      child: widget.backgroundWidget,
    );
  }

  Widget _buildHeader(OnboardingTheme theme) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (widget.showProgressIndicator) _buildProgressIndicator(theme),
          if (widget.showSkipButton) _buildSkipButton(theme),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(OnboardingTheme theme) {
    return Row(
      children: List.generate(
        widget.steps.length,
        (index) => Container(
          margin: const EdgeInsets.only(right: 8),
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: index <= widget.controller.currentIndex
                ? (theme.progressIndicatorColor ?? Colors.white)
                : Colors.white.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }

  Widget _buildSkipButton(OnboardingTheme theme) {
    return TextButton(
      onPressed: widget.onComplete,
      style: TextButton.styleFrom(
        foregroundColor: theme.skipButtonColor ?? Colors.white,
        backgroundColor: Colors.white.withValues(alpha: 0.2),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        'Skip',
        style: theme.buttonTextStyle?.copyWith(
          color: theme.skipButtonColor ?? Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildContent(OnboardingStep step, OnboardingTheme theme) {
    return Padding(
      padding: step.padding ?? const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        mainAxisAlignment: step.mainAxisAlignment ?? MainAxisAlignment.center,
        crossAxisAlignment: step.crossAxisAlignment ?? CrossAxisAlignment.center,
        children: [
          if (step.customContent != null)
            step.customContent!
          else ...[
            if (step.displayIcon != null) ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: step.displayIcon!,
              ),
              SizedBox(height: step.spacing ?? 40),
            ],
            Text(
              step.title,
              style: step.titleStyle ??
                  theme.titleStyle ??
                  TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: step.titleColor ?? theme.textColor ?? Colors.white,
                    height: 1.2,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: step.spacing ?? 20),
            Text(
              step.description,
              style: step.descriptionStyle ??
                  theme.descriptionStyle ??
                  TextStyle(
                    fontSize: 18,
                    color: step.descriptionColor ?? theme.textColor ?? Colors.white.withValues(alpha: 0.9),
                    height: 1.6,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFooter(OnboardingTheme theme) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        children: [
          if (!widget.controller.isLastStep)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.controller.nextStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.buttonColor ?? Colors.white,
                  foregroundColor: theme.buttonTextColor ?? Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(theme.borderRadius ?? 12),
                  ),
                ),
                child: Text(
                  'Continue',
                  style: theme.buttonTextStyle?.copyWith(
                    color: theme.buttonTextColor ?? Theme.of(context).primaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          else
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.onComplete,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.buttonColor ?? Colors.white,
                  foregroundColor: theme.buttonTextColor ?? Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(theme.borderRadius ?? 12),
                  ),
                ),
                child: Text(
                  'Get Started',
                  style: theme.buttonTextStyle?.copyWith(
                    color: theme.buttonTextColor ?? Theme.of(context).primaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          const SizedBox(height: 20),
          if (!widget.controller.isFirstStep)
            TextButton(
              onPressed: widget.controller.previousStep,
              style: TextButton.styleFrom(
                foregroundColor: Colors.white.withValues(alpha: 0.8),
              ),
              child: Text(
                'Previous',
                style: theme.buttonTextStyle?.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 16,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _handleSwipe(DragEndDetails details) {
    if (details.primaryVelocity! > 0) {
      if (!widget.controller.isFirstStep) {
        widget.controller.previousStep();
      }
    } else if (details.primaryVelocity! < 0) {
      if (!widget.controller.isLastStep) {
        widget.controller.nextStep();
      } else {
        widget.onComplete?.call();
      }
    }
  }
}