import 'package:flutter/material.dart';
import 'onboarding_step.dart';
import 'onboarding_controller.dart';
import 'onboarding_type.dart';

class SlideOnboarding extends StatefulWidget {
  final List<OnboardingStep> steps;
  final OnboardingController controller;
  final VoidCallback? onComplete;
  final OnboardingTheme? theme;
  final bool showSkipButton;
  final bool showProgressDots;
  final Duration animationDuration;
  final Curve animationCurve;
  final EdgeInsetsGeometry padding;

  const SlideOnboarding({
    Key? key,
    required this.steps,
    required this.controller,
    this.onComplete,
    this.theme,
    this.showSkipButton = true,
    this.showProgressDots = true,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
    this.padding = const EdgeInsets.all(24.0),
  }) : super(key: key);

  @override
  State<SlideOnboarding> createState() => _SlideOnboardingState();
}

class _SlideOnboardingState extends State<SlideOnboarding>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: widget.animationCurve),
    );
    _animationController.forward();
    
    widget.controller.addListener(_onControllerChanged);
  }

  void _onControllerChanged() {
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        widget.controller.currentIndex,
        duration: widget.animationDuration,
        curve: widget.animationCurve,
      );
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme ?? const OnboardingTheme();
    
    return Scaffold(
      backgroundColor: theme.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: widget.controller,
          builder: (context, child) {
            return Column(
              children: [
                if (widget.showSkipButton) _buildSkipButton(theme),
                if (widget.showProgressDots) _buildProgressDots(theme),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      widget.controller.goToStep(index);
                    },
                    itemCount: widget.steps.length,
                    itemBuilder: (context, index) {
                      return FadeTransition(
                        opacity: _fadeAnimation,
                        child: _buildStepContent(widget.steps[index], theme),
                      );
                    },
                  ),
                ),
                _buildNavigationButtons(theme),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSkipButton(OnboardingTheme theme) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, right: 16),
      child: Align(
        alignment: Alignment.topRight,
        child: TextButton(
          onPressed: widget.onComplete,
          style: TextButton.styleFrom(
            foregroundColor: theme.skipButtonColor ?? Colors.grey[600],
          ),
          child: Text(
            'Skip',
            style: theme.buttonTextStyle?.copyWith(
              color: theme.skipButtonColor ?? Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressDots(OnboardingTheme theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          widget.steps.length,
          (index) => AnimatedContainer(
            duration: widget.animationDuration,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: widget.controller.currentIndex == index ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: widget.controller.currentIndex == index
                  ? (theme.primaryColor ?? Theme.of(context).primaryColor)
                  : (theme.secondaryColor ?? Colors.grey[300]),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent(OnboardingStep step, OnboardingTheme theme) {
    return Container(
      decoration: step.backgroundDecoration,
      child: Padding(
        padding: step.padding ?? widget.padding,
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

  Widget _buildNavigationButtons(OnboardingTheme theme) {
    return Padding(
      padding: widget.padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (!widget.controller.isFirstStep)
            TextButton(
              onPressed: widget.controller.previousStep,
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
          ElevatedButton(
            onPressed: widget.controller.isLastStep
                ? widget.onComplete
                : widget.controller.nextStep,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.buttonColor ?? theme.primaryColor ?? Theme.of(context).primaryColor,
              foregroundColor: theme.buttonTextColor ?? Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(theme.borderRadius ?? 8),
              ),
            ),
            child: Text(
              widget.controller.isLastStep ? 'Get Started' : 'Next',
              style: theme.buttonTextStyle?.copyWith(
                color: theme.buttonTextColor ?? Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}