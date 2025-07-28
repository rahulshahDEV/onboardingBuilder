import 'package:flutter/material.dart';
import 'onboarding_step.dart';
import 'onboarding_controller.dart';
import 'onboarding_type.dart';

class CardOnboarding extends StatefulWidget {
  final List<OnboardingStep> steps;
  final OnboardingController controller;
  final VoidCallback? onComplete;
  final OnboardingTheme? theme;
  final bool showSkipButton;
  final bool showProgressBar;
  final Duration animationDuration;
  final Curve animationCurve;
  final EdgeInsetsGeometry padding;
  final double? cardElevation;
  final double? cardBorderRadius;

  const CardOnboarding({
    Key? key,
    required this.steps,
    required this.controller,
    this.onComplete,
    this.theme,
    this.showSkipButton = true,
    this.showProgressBar = true,
    this.animationDuration = const Duration(milliseconds: 400),
    this.animationCurve = Curves.easeInOutCubic,
    this.padding = const EdgeInsets.all(20.0),
    this.cardElevation = 8.0,
    this.cardBorderRadius = 16.0,
  }) : super(key: key);

  @override
  State<CardOnboarding> createState() => _CardOnboardingState();
}

class _CardOnboardingState extends State<CardOnboarding>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: Duration(milliseconds: widget.animationDuration.inMilliseconds ~/ 2),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: widget.animationCurve,
    ));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.elasticOut),
    );

    _slideController.forward();
    _fadeController.forward();

    widget.controller.addListener(_onControllerChanged);
  }

  void _onControllerChanged() {
    _slideController.reset();
    _fadeController.reset();
    _slideController.forward();
    _fadeController.forward();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme ?? const OnboardingTheme();
    
    return Scaffold(
      backgroundColor: theme.backgroundColor ?? Colors.grey[100],
      body: SafeArea(
        child: AnimatedBuilder(
          animation: widget.controller,
          builder: (context, child) {
            final currentStep = widget.steps[widget.controller.currentIndex];
            
            return Column(
              children: [
                if (widget.showSkipButton) _buildSkipButton(theme),
                if (widget.showProgressBar) _buildProgressBar(theme),
                Expanded(
                  child: Padding(
                    padding: widget.padding,
                    child: Center(
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: ScaleTransition(
                            scale: _scaleAnimation,
                            child: _buildCard(currentStep, theme),
                          ),
                        ),
                      ),
                    ),
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

  Widget _buildProgressBar(OnboardingTheme theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Step ${widget.controller.currentIndex + 1}',
                style: TextStyle(
                  color: theme.textColor ?? Colors.grey[600],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${widget.controller.currentIndex + 1}/${widget.steps.length}',
                style: TextStyle(
                  color: theme.textColor ?? Colors.grey[600],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          AnimatedContainer(
            duration: widget.animationDuration,
            child: LinearProgressIndicator(
              value: widget.controller.progress,
              backgroundColor: theme.secondaryColor ?? Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.progressIndicatorColor ?? theme.primaryColor ?? Theme.of(context).primaryColor,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(OnboardingStep step, OnboardingTheme theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: widget.cardElevation ?? 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            widget.cardBorderRadius ?? theme.borderRadius ?? 16.0,
          ),
        ),
        child: Container(
          decoration: step.backgroundDecoration != null 
            ? BoxDecoration(
                color: (step.backgroundDecoration as BoxDecoration?)?.color,
                gradient: (step.backgroundDecoration as BoxDecoration?)?.gradient,
                image: (step.backgroundDecoration as BoxDecoration?)?.image,
                border: (step.backgroundDecoration as BoxDecoration?)?.border,
                boxShadow: (step.backgroundDecoration as BoxDecoration?)?.boxShadow,
                borderRadius: BorderRadius.circular(
                  widget.cardBorderRadius ?? theme.borderRadius ?? 16.0,
                ),
              )
            : BoxDecoration(
                borderRadius: BorderRadius.circular(
                  widget.cardBorderRadius ?? theme.borderRadius ?? 16.0,
                ),
              ),
          child: Padding(
            padding: step.padding ?? const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: step.mainAxisAlignment ?? MainAxisAlignment.center,
              crossAxisAlignment: step.crossAxisAlignment ?? CrossAxisAlignment.center,
              children: [
                if (step.customContent != null)
                  step.customContent!
                else ...[
                  if (step.displayIcon != null) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: (theme.primaryColor ?? Theme.of(context).primaryColor).withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: step.displayIcon!,
                    ),
                    SizedBox(height: step.spacing ?? 24),
                  ],
                  Text(
                    step.title,
                    style: step.titleStyle ??
                        theme.titleStyle ??
                        Theme.of(context).textTheme.headlineSmall?.copyWith(
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
                          height: 1.5,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButtons(OnboardingTheme theme) {
    return Container(
      padding: widget.padding,
      child: Row(
        children: [
          if (!widget.controller.isFirstStep)
            Expanded(
              child: OutlinedButton(
                onPressed: widget.controller.previousStep,
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.secondaryColor ?? Colors.grey[600],
                  side: BorderSide(
                    color: theme.secondaryColor ?? Colors.grey[300]!,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(theme.borderRadius ?? 8),
                  ),
                ),
                child: Text(
                  'Previous',
                  style: theme.buttonTextStyle?.copyWith(
                    color: theme.secondaryColor ?? Colors.grey[600],
                  ),
                ),
              ),
            ),
          if (!widget.controller.isFirstStep) const SizedBox(width: 16),
          Expanded(
            flex: widget.controller.isFirstStep ? 1 : 1,
            child: ElevatedButton(
              onPressed: widget.controller.isLastStep
                  ? widget.onComplete
                  : widget.controller.nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.buttonColor ?? theme.primaryColor ?? Theme.of(context).primaryColor,
                foregroundColor: theme.buttonTextColor ?? Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(theme.borderRadius ?? 8),
                ),
              ),
              child: Text(
                widget.controller.isLastStep ? 'Get Started' : 'Next',
                style: theme.buttonTextStyle?.copyWith(
                  color: theme.buttonTextColor ?? Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}