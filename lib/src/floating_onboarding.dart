import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'onboarding_step.dart';
import 'onboarding_controller.dart';
import 'onboarding_type.dart';

class FloatingOnboarding extends StatefulWidget {
  final List<OnboardingStep> steps;
  final OnboardingController controller;
  final VoidCallback? onComplete;
  final OnboardingTheme? theme;
  final bool showSkipButton;
  final bool showFloatingProgress;
  final Duration animationDuration;
  final Curve animationCurve;
  final EdgeInsetsGeometry padding;
  final bool enableParallaxEffect;
  final bool showParticleBackground;

  const FloatingOnboarding({
    Key? key,
    required this.steps,
    required this.controller,
    this.onComplete,
    this.theme,
    this.showSkipButton = true,
    this.showFloatingProgress = true,
    this.animationDuration = const Duration(milliseconds: 1200),
    this.animationCurve = Curves.easeInOutQuart,
    this.padding = const EdgeInsets.all(24.0),
    this.enableParallaxEffect = true,
    this.showParticleBackground = true,
  }) : super(key: key);

  @override
  State<FloatingOnboarding> createState() => _FloatingOnboardingState();
}

class _FloatingOnboardingState extends State<FloatingOnboarding>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _transitionController;
  late AnimationController _particleController;
  late Animation<double> _floatAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  List<ParticleData> _particles = [];

  @override
  void initState() {
    super.initState();

    _floatController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _transitionController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _particleController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _floatAnimation = Tween<double>(begin: -10.0, end: 10.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _transitionController,
        curve: Interval(0.2, 1.0, curve: widget.animationCurve),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _transitionController,
      curve: widget.animationCurve,
    ));

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _transitionController,
        curve: Interval(0.0, 0.8, curve: Curves.elasticOut),
      ),
    );

    _rotateAnimation = Tween<double>(begin: 0.0, end: 0.05).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );


    _initializeParticles();
    _transitionController.forward();

    widget.controller.addListener(_onControllerChanged);
  }

  void _initializeParticles() {
    _particles = List.generate(20, (index) {
      return ParticleData(
        x: math.Random().nextDouble(),
        y: math.Random().nextDouble(),
        size: math.Random().nextDouble() * 4 + 2,
        speed: math.Random().nextDouble() * 0.5 + 0.1,
        opacity: math.Random().nextDouble() * 0.6 + 0.1,
      );
    });
  }

  void _onControllerChanged() {
    _transitionController.reset();
    _transitionController.forward();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    _floatController.dispose();
    _transitionController.dispose();
    _particleController.dispose();
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
          
          return Stack(
            children: [
              _buildBackground(currentStep, theme),
              if (widget.showParticleBackground) _buildParticleBackground(),
              _buildFloatingContent(currentStep, theme),
              if (widget.showFloatingProgress) _buildFloatingProgress(theme),
              if (widget.showSkipButton) _buildSkipButton(theme),
              _buildFloatingNavigation(theme),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBackground(OnboardingStep step, OnboardingTheme theme) {
    return Container(
      decoration: step.backgroundDecoration ??
          BoxDecoration(
            gradient: step.backgroundGradient ??
                LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    step.backgroundColor ?? theme.backgroundColor ?? Colors.deepPurple.shade400,
                    (step.backgroundColor ?? theme.backgroundColor ?? Colors.deepPurple.shade400).withValues(alpha: 0.7),
                  ],
                ),
          ),
    );
  }

  Widget _buildParticleBackground() {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return CustomPaint(
          painter: ParticlePainter(
            particles: _particles,
            animationValue: _particleController.value,
          ),
          size: Size.infinite,
        );
      },
    );
  }

  Widget _buildFloatingContent(OnboardingStep step, OnboardingTheme theme) {
    return SafeArea(
      child: AnimatedBuilder(
        animation: Listenable.merge([_floatAnimation, _fadeAnimation]),
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _floatAnimation.value),
            child: Transform.rotate(
              angle: _rotateAnimation.value,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
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
                                padding: const EdgeInsets.all(30),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.3),
                                    width: 3,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.2),
                                      blurRadius: 30,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: AnimatedBuilder(
                                  animation: _floatController,
                                  builder: (context, child) {
                                    return Transform.translate(
                                      offset: Offset(_floatAnimation.value * 0.3, _floatAnimation.value * 0.2),
                                      child: step.displayIcon!,
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: step.spacing ?? 50),
                            ],
                            _buildFloatingCard(
                              child: Text(
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
                              theme: theme,
                            ),
                            SizedBox(height: step.spacing ?? 20),
                            _buildFloatingCard(
                              child: Text(
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
                              theme: theme,
                              delay: 200,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFloatingCard({
    required Widget child,
    required OnboardingTheme theme,
    int delay = 0,
  }) {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, _) {
        return Transform.translate(
          offset: Offset(
            _floatAnimation.value * 0.1,
            _floatAnimation.value * 0.15 + (delay * 0.001),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: child,
          ),
        );
      },
    );
  }

  Widget _buildFloatingProgress(OnboardingTheme theme) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 30,
      left: 0,
      right: 0,
      child: Center(
        child: AnimatedBuilder(
          animation: _floatController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _floatAnimation.value * 0.1),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    widget.steps.length,
                    (index) => AnimatedContainer(
                      duration: widget.animationDuration,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: index == widget.controller.currentIndex ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: index <= widget.controller.currentIndex
                            ? (theme.progressIndicatorColor ?? Colors.white)
                            : Colors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: index == widget.controller.currentIndex
                            ? [
                                BoxShadow(
                                  color: Colors.white.withValues(alpha: 0.5),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ]
                            : null,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSkipButton(OnboardingTheme theme) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 20,
      right: 20,
      child: AnimatedBuilder(
        animation: _floatController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(_floatAnimation.value * 0.05, _floatAnimation.value * 0.1),
            child: GestureDetector(
              onTap: widget.onComplete,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Text(
                  'Skip',
                  style: theme.buttonTextStyle?.copyWith(
                    color: theme.skipButtonColor ?? Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFloatingNavigation(OnboardingTheme theme) {
    return Positioned(
      bottom: MediaQuery.of(context).padding.bottom + 40,
      left: 20,
      right: 20,
      child: AnimatedBuilder(
        animation: Listenable.merge([widget.controller, _floatController]),
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _floatAnimation.value * 0.15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!widget.controller.isFirstStep)
                  _buildFloatingNavButton(
                    'Previous',
                    icon: Icons.arrow_back_ios,
                    onTap: widget.controller.previousStep,
                    isSecondary: true,
                    theme: theme,
                  )
                else
                  const SizedBox.shrink(),
                _buildFloatingNavButton(
                  widget.controller.isLastStep ? 'Get Started' : 'Next',
                  icon: widget.controller.isLastStep ? Icons.check : Icons.arrow_forward_ios,
                  onTap: widget.controller.isLastStep
                      ? widget.onComplete
                      : widget.controller.nextStep,
                  theme: theme,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFloatingNavButton(
    String text, {
    required IconData icon,
    required VoidCallback? onTap,
    bool isSecondary = false,
    required OnboardingTheme theme,
  }) {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            _floatAnimation.value * (isSecondary ? -0.05 : 0.05),
            _floatAnimation.value * 0.1,
          ),
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isSecondary ? 0.1 : 0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isSecondary) Icon(
                    icon,
                    color: Colors.white.withValues(alpha: 0.8),
                    size: 18,
                  ),
                  if (isSecondary) const SizedBox(width: 8),
                  Text(
                    text,
                    style: theme.buttonTextStyle?.copyWith(
                      color: isSecondary
                          ? Colors.white.withValues(alpha: 0.8)
                          : (theme.buttonTextColor ?? Colors.black),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (!isSecondary) const SizedBox(width: 8),
                  if (!isSecondary) Icon(
                    icon,
                    color: theme.buttonTextColor ?? Colors.black,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ParticleData {
  double x;
  double y;
  double size;
  double speed;
  double opacity;

  ParticleData({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
  });
}

class ParticlePainter extends CustomPainter {
  final List<ParticleData> particles;
  final double animationValue;

  ParticlePainter({
    required this.particles,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < particles.length; i++) {
      final particle = particles[i];
      
      // Update particle position
      particle.y -= particle.speed * 0.005;
      if (particle.y < 0) {
        particle.y = 1.0;
        particle.x = math.Random().nextDouble();
      }

      // Add floating effect
      final floatOffset = math.sin(animationValue * 2 * math.pi + i) * 0.01;
      
      paint.color = Colors.white.withValues(alpha: particle.opacity);
      
      canvas.drawCircle(
        Offset(
          (particle.x + floatOffset) * size.width,
          particle.y * size.height,
        ),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}