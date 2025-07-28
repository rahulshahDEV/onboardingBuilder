import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'onboarding_step.dart';
import 'onboarding_controller.dart';
import 'onboarding_type.dart';

class LiquidOnboarding extends StatefulWidget {
  final List<OnboardingStep> steps;
  final OnboardingController controller;
  final VoidCallback? onComplete;
  final OnboardingTheme? theme;
  final bool showSkipButton;
  final Duration animationDuration;
  final Curve animationCurve;
  final EdgeInsetsGeometry padding;
  final List<Color>? waveColors;

  const LiquidOnboarding({
    Key? key,
    required this.steps,
    required this.controller,
    this.onComplete,
    this.theme,
    this.showSkipButton = true,
    this.animationDuration = const Duration(milliseconds: 1000),
    this.animationCurve = Curves.easeInOutQuart,
    this.padding = const EdgeInsets.all(20.0),
    this.waveColors,
  }) : super(key: key);

  @override
  State<LiquidOnboarding> createState() => _LiquidOnboardingState();
}

class _LiquidOnboardingState extends State<LiquidOnboarding>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _transitionController;
  late Animation<double> _waveAnimation;
  late Animation<double> _progressAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _waveController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _transitionController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _waveAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.linear),
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _transitionController, curve: widget.animationCurve),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _transitionController,
        curve: Interval(0.3, 1.0, curve: widget.animationCurve),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _transitionController,
      curve: widget.animationCurve,
    ));

    _transitionController.forward();
    widget.controller.addListener(_onControllerChanged);
  }

  void _onControllerChanged() {
    _transitionController.reset();
    _transitionController.forward();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    _waveController.dispose();
    _transitionController.dispose();
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
          final colors = _getColorsForStep(currentStep, theme);
          
          return Stack(
            children: [
              _buildLiquidBackground(colors),
              _buildContent(currentStep, theme),
              if (widget.showSkipButton) _buildSkipButton(theme),
              _buildProgressIndicator(theme),
              _buildNavigation(theme),
            ],
          );
        },
      ),
    );
  }

  List<Color> _getColorsForStep(OnboardingStep step, OnboardingTheme theme) {
    if (widget.waveColors != null && widget.waveColors!.isNotEmpty) {
      return widget.waveColors!;
    }
    
    if (step.backgroundGradient != null) {
      final gradient = step.backgroundGradient as LinearGradient?;
      return gradient?.colors ?? [
        theme.primaryColor ?? Colors.blue,
        theme.secondaryColor ?? Colors.purple,
      ];
    }
    
    return [
      step.backgroundColor ?? theme.primaryColor ?? Colors.blue,
      theme.secondaryColor ?? Colors.purple,
    ];
  }

  Widget _buildLiquidBackground(List<Color> colors) {
    return AnimatedBuilder(
      animation: _waveAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colors[0].withValues(alpha: 0.8),
                colors.length > 1 ? colors[1].withValues(alpha: 0.9) : colors[0].withValues(alpha: 0.9),
              ],
            ),
          ),
          child: Stack(
            children: [
              _buildWaveLayer(colors[0], 0.3, 0.8),
              _buildWaveLayer(
                colors.length > 1 ? colors[1] : colors[0], 
                0.5, 
                0.6,
                offset: math.pi / 2,
              ),
              _buildWaveLayer(
                colors.length > 2 ? colors[2] : colors[0], 
                0.7, 
                0.4,
                offset: math.pi,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWaveLayer(Color color, double amplitude, double frequency, {double offset = 0}) {
    return Positioned.fill(
      child: CustomPaint(
        painter: WavePainter(
          waveValue: _waveAnimation.value + offset,
          color: color.withValues(alpha: 0.3),
          amplitude: amplitude,
          frequency: frequency,
        ),
      ),
    );
  }

  Widget _buildContent(OnboardingStep step, OnboardingTheme theme) {
    return SafeArea(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
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
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: step.displayIcon!,
                    ),
                    SizedBox(height: step.spacing ?? 40),
                  ],
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Text(
                      step.title,
                      style: step.titleStyle ??
                          theme.titleStyle ??
                          TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: step.titleColor ?? theme.textColor ?? Colors.white,
                            height: 1.3,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: step.spacing ?? 20),
                  Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Text(
                      step.description,
                      style: step.descriptionStyle ??
                          theme.descriptionStyle ??
                          TextStyle(
                            fontSize: 16,
                            color: step.descriptionColor ?? theme.textColor ?? Colors.white.withValues(alpha: 0.9),
                            height: 1.6,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ],
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

  Widget _buildProgressIndicator(OnboardingTheme theme) {
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
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
              child: AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, child) {
                  return FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: index <= widget.controller.currentIndex ? 1.0 : 0.0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.progressIndicatorColor ?? Colors.white,
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.5),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
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
      bottom: MediaQuery.of(context).padding.bottom + 30,
      left: 20,
      right: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (!widget.controller.isFirstStep)
            _buildNavButton(
              'Previous',
              onTap: widget.controller.previousStep,
              isSecondary: true,
              theme: theme,
            )
          else
            const SizedBox.shrink(),
          _buildNavButton(
            widget.controller.isLastStep ? 'Get Started' : 'Next',
            onTap: widget.controller.isLastStep
                ? widget.onComplete
                : widget.controller.nextStep,
            theme: theme,
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(
    String text, {
    required VoidCallback? onTap,
    bool isSecondary = false,
    required OnboardingTheme theme,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        decoration: BoxDecoration(
          color: isSecondary
              ? Colors.white.withValues(alpha: 0.1)
              : (theme.buttonColor ?? Colors.white),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSecondary
                ? Colors.white.withValues(alpha: 0.3)
                : Colors.transparent,
          ),
          boxShadow: isSecondary
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
        ),
        child: Text(
          text,
          style: theme.buttonTextStyle?.copyWith(
            color: isSecondary
                ? Colors.white.withValues(alpha: 0.8)
                : (theme.buttonTextColor ?? Colors.black),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final double waveValue;
  final Color color;
  final double amplitude;
  final double frequency;

  WavePainter({
    required this.waveValue,
    required this.color,
    required this.amplitude,
    required this.frequency,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final waveHeight = size.height * amplitude;
    final waveLength = size.width / frequency;

    path.moveTo(0, size.height);

    for (double x = 0; x <= size.width; x++) {
      final y = size.height - waveHeight * math.sin((x / waveLength) * 2 * math.pi + waveValue);
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);

    // Add additional wave layers for more complexity
    final secondaryPaint = Paint()
      ..color = color.withValues(alpha: color.alpha * 0.5)
      ..style = PaintingStyle.fill;

    final secondaryPath = Path();
    secondaryPath.moveTo(0, size.height);

    for (double x = 0; x <= size.width; x++) {
      final y = size.height - (waveHeight * 0.7) * math.sin((x / (waveLength * 1.5)) * 2 * math.pi + waveValue + math.pi / 4);
      secondaryPath.lineTo(x, y);
    }

    secondaryPath.lineTo(size.width, size.height);
    secondaryPath.close();

    canvas.drawPath(secondaryPath, secondaryPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}