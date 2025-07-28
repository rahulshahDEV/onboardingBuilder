import 'package:flutter/material.dart';
import 'onboarding_step.dart';
import 'onboarding_controller.dart';
import 'onboarding_type.dart';

class StoryOnboarding extends StatefulWidget {
  final List<OnboardingStep> steps;
  final OnboardingController controller;
  final VoidCallback? onComplete;
  final OnboardingTheme? theme;
  final bool showSkipButton;
  final bool showProgressBar;
  final Duration animationDuration;
  final Curve animationCurve;
  final EdgeInsetsGeometry padding;
  final bool autoAdvance;
  final Duration autoAdvanceDuration;

  const StoryOnboarding({
    super.key,
    required this.steps,
    required this.controller,
    this.onComplete,
    this.theme,
    this.showSkipButton = true,
    this.showProgressBar = true,
    this.animationDuration = const Duration(milliseconds: 800),
    this.animationCurve = Curves.easeInOutCubic,
    this.padding = const EdgeInsets.all(20.0),
    this.autoAdvance = false,
    this.autoAdvanceDuration = const Duration(seconds: 3),
  });

  @override
  State<StoryOnboarding> createState() => _StoryOnboardingState();
}

class _StoryOnboardingState extends State<StoryOnboarding>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _progressController;
  late Animation<Offset> _slideInAnimation;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _progressAnimation;

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
    
    _progressController = AnimationController(
      duration: widget.autoAdvanceDuration,
      vsync: this,
    );

    _slideInAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Interval(0.0, 0.6, curve: widget.animationCurve),
    ));

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.elasticOut),
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.linear),
    );

    _slideController.forward();
    _fadeController.forward();
    
    if (widget.autoAdvance) {
      _startAutoAdvance();
    }

    widget.controller.addListener(_onControllerChanged);
  }

  void _onControllerChanged() {
    _slideController.reset();
    _fadeController.reset();
    _slideController.forward();
    _fadeController.forward();
    
    if (widget.autoAdvance) {
      _progressController.reset();
      _startAutoAdvance();
    }
  }

  void _startAutoAdvance() {
    if (!widget.controller.isLastStep) {
      _progressController.forward().then((_) {
        if (mounted && !widget.controller.isLastStep) {
          widget.controller.nextStep();
        }
      });
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    _slideController.dispose();
    _fadeController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme ?? const OnboardingTheme();
    
    return Scaffold(
      backgroundColor: theme.backgroundColor ?? Colors.black,
      body: AnimatedBuilder(
        animation: widget.controller,
        builder: (context, child) {
          final currentStep = widget.steps[widget.controller.currentIndex];
          
          return GestureDetector(
            onTap: () {
              if (!widget.controller.isLastStep) {
                _progressController.stop();
                widget.controller.nextStep();
              } else {
                widget.onComplete?.call();
              }
            },
            child: Stack(
              children: [
                _buildBackground(currentStep, theme),
                _buildContent(currentStep, theme),
                if (widget.showSkipButton) _buildSkipButton(theme),
                if (widget.showProgressBar) _buildProgressBar(theme),
                _buildNavigation(theme),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBackground(OnboardingStep step, OnboardingTheme theme) {
    return Container(
      decoration: step.backgroundDecoration ??
          BoxDecoration(
            color: step.backgroundColor ?? theme.backgroundColor ?? Colors.black,
          ),
      child: step.backgroundImageProvider != null || step.backgroundImagePath != null
          ? Container(
              decoration: BoxDecoration(
                image: step.backgroundImageProvider != null
                    ? DecorationImage(
                        image: step.backgroundImageProvider!,
                        fit: step.backgroundImageFit ?? BoxFit.cover,
                      )
                    : step.backgroundImagePath != null
                        ? DecorationImage(
                            image: AssetImage(step.backgroundImagePath!),
                            fit: step.backgroundImageFit ?? BoxFit.cover,
                          )
                        : null,
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                    ],
                  ),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildContent(OnboardingStep step, OnboardingTheme theme) {
    return Positioned.fill(
      child: SafeArea(
        child: Padding(
          padding: step.padding ?? widget.padding,
          child: SlideTransition(
            position: _slideInAnimation,
            child: FadeTransition(
              opacity: _fadeInAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: step.mainAxisAlignment ?? MainAxisAlignment.end,
                  crossAxisAlignment: step.crossAxisAlignment ?? CrossAxisAlignment.start,
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
                        SizedBox(height: step.spacing ?? 30),
                      ],
                      Text(
                        step.title,
                        style: step.titleStyle ??
                            theme.titleStyle ??
                            TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: step.titleColor ?? theme.textColor ?? Colors.white,
                              height: 1.2,
                            ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: step.spacing ?? 16),
                      Text(
                        step.description,
                        style: step.descriptionStyle ??
                            theme.descriptionStyle ??
                            TextStyle(
                              fontSize: 16,
                              color: step.descriptionColor ?? theme.textColor ?? Colors.white.withValues(alpha: 0.9),
                              height: 1.6,
                            ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 100), // Space for navigation
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSkipButton(OnboardingTheme theme) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      right: 20,
      child: GestureDetector(
        onTap: widget.onComplete,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            'Skip',
            style: theme.buttonTextStyle?.copyWith(
              color: theme.skipButtonColor ?? Colors.white,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar(OnboardingTheme theme) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 20,
      left: 20,
      right: widget.showSkipButton ? 100 : 20,
      child: Row(
        children: List.generate(
          widget.steps.length,
          (index) => Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 4),
              height: 3,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
              child: AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, child) {
                  double progress = 0.0;
                  if (index < widget.controller.currentIndex) {
                    progress = 1.0;
                  } else if (index == widget.controller.currentIndex && widget.autoAdvance) {
                    progress = _progressAnimation.value;
                  }
                  
                  return FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: progress,
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.progressIndicatorColor ?? Colors.white,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigation(OnboardingTheme theme) {
    return Positioned(
      bottom: MediaQuery.of(context).padding.bottom + 20,
      left: 20,
      right: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (!widget.controller.isFirstStep)
            GestureDetector(
              onTap: () {
                _progressController.stop();
                widget.controller.previousStep();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  'Previous',
                  style: theme.buttonTextStyle?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 16,
                  ),
                ),
              ),
            )
          else
            const SizedBox.shrink(),
          GestureDetector(
            onTap: () {
              if (!widget.controller.isLastStep) {
                _progressController.stop();
                widget.controller.nextStep();
              } else {
                widget.onComplete?.call();
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              decoration: BoxDecoration(
                color: theme.buttonColor ?? Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                widget.controller.isLastStep ? 'Get Started' : 'Next',
                style: theme.buttonTextStyle?.copyWith(
                  color: theme.buttonTextColor ?? Colors.black,
                  fontSize: 16,
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