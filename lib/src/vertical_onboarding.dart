import 'package:flutter/material.dart';
import 'onboarding_step.dart';
import 'onboarding_controller.dart';
import 'onboarding_type.dart';

class VerticalOnboarding extends StatefulWidget {
  final List<OnboardingStep> steps;
  final OnboardingController controller;
  final VoidCallback? onComplete;
  final OnboardingTheme? theme;
  final bool showSkipButton;
  final bool showSideProgress;
  final Duration animationDuration;
  final Curve animationCurve;
  final EdgeInsetsGeometry padding;
  final bool enableSnapScrolling;
  final ScrollPhysics? scrollPhysics;

  const VerticalOnboarding({
    super.key,
    required this.steps,
    required this.controller,
    this.onComplete,
    this.theme,
    this.showSkipButton = true,
    this.showSideProgress = true,
    this.animationDuration = const Duration(milliseconds: 500),
    this.animationCurve = Curves.easeInOutCubic,
    this.padding = const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
    this.enableSnapScrolling = true,
    this.scrollPhysics,
  });

  @override
  State<VerticalOnboarding> createState() => _VerticalOnboardingState();
}

class _VerticalOnboardingState extends State<VerticalOnboarding>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  
  double _currentScrollOffset = 0.0;
  int _visibleStepIndex = 0;

  @override
  void initState() {
    super.initState();
    
    _scrollController = ScrollController();
    _fadeController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _slideController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: widget.animationCurve),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController, 
      curve: widget.animationCurve,
    ));

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.elasticOut),
    );

    _scrollController.addListener(_onScroll);
    _fadeController.forward();
    _slideController.forward();

    widget.controller.addListener(_onControllerChanged);
  }

  void _onScroll() {
    final screenHeight = MediaQuery.of(context).size.height;
    final currentIndex = (_scrollController.offset / screenHeight).round();
    
    if (currentIndex != _visibleStepIndex && 
        currentIndex >= 0 && 
        currentIndex < widget.steps.length) {
      setState(() {
        _visibleStepIndex = currentIndex;
      });
      widget.controller.goToStep(currentIndex);
    }
    
    setState(() {
      _currentScrollOffset = _scrollController.offset;
    });
  }

  void _onControllerChanged() {
    final screenHeight = MediaQuery.of(context).size.height;
    final targetOffset = widget.controller.currentIndex * screenHeight;
    
    if (widget.enableSnapScrolling && _scrollController.hasClients) {
      _scrollController.animateTo(
        targetOffset,
        duration: widget.animationDuration,
        curve: widget.animationCurve,
      );
    }
    
    _fadeController.reset();
    _slideController.reset();
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme ?? const OnboardingTheme();
    
    return Scaffold(
      backgroundColor: theme.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          _buildVerticalContent(theme),
          if (widget.showSideProgress) _buildSideProgress(theme),
          if (widget.showSkipButton) _buildSkipButton(theme),
          _buildFloatingNavigation(theme),
        ],
      ),
    );
  }

  Widget _buildVerticalContent(OnboardingTheme theme) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, child) {
        return SingleChildScrollView(
          controller: _scrollController,
          physics: widget.scrollPhysics ?? 
              (widget.enableSnapScrolling 
                ? const PageScrollPhysics() 
                : const ClampingScrollPhysics()),
          child: Column(
            children: widget.steps.asMap().entries.map((entry) {
              final index = entry.key;
              final step = entry.value;
              return _buildStepContainer(step, index, theme);
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildStepContainer(OnboardingStep step, int index, OnboardingTheme theme) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isVisible = index == _visibleStepIndex;
    
    return Container(
      height: screenHeight,
      decoration: step.backgroundDecoration,
      child: SafeArea(
        child: AnimatedOpacity(
          opacity: isVisible ? 1.0 : 0.7,
          duration: widget.animationDuration,
          child: AnimatedScale(
            scale: isVisible ? 1.0 : 0.95,
            duration: widget.animationDuration,
            curve: widget.animationCurve,
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
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: (theme.primaryColor ?? Theme.of(context).primaryColor).withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: (theme.primaryColor ?? Theme.of(context).primaryColor).withValues(alpha: 0.3),
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: step.displayIcon!,
                            ),
                            SizedBox(height: step.spacing ?? 40),
                          ],
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: (theme.primaryColor ?? Theme.of(context).primaryColor).withValues(alpha: 0.2),
                              ),
                            ),
                            child: Text(
                              step.title,
                              style: step.titleStyle ??
                                  theme.titleStyle ??
                                  Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: step.titleColor ?? theme.textColor,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: step.spacing ?? 24),
                          Container(
                            padding: const EdgeInsets.all(20),
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.03),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.grey.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Text(
                              step.description,
                              style: step.descriptionStyle ??
                                  theme.descriptionStyle ??
                                  Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: step.descriptionColor ?? theme.textColor ?? Colors.grey[600],
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
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSideProgress(OnboardingTheme theme) {
    return Positioned(
      right: 20,
      top: 0,
      bottom: 0,
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              widget.steps.length,
              (index) => AnimatedContainer(
                duration: widget.animationDuration,
                margin: const EdgeInsets.symmetric(vertical: 6),
                width: index == widget.controller.currentIndex ? 6 : 4,
                height: index == widget.controller.currentIndex ? 40 : 20,
                decoration: BoxDecoration(
                  color: index <= widget.controller.currentIndex
                      ? (theme.progressIndicatorColor ?? theme.primaryColor ?? Theme.of(context).primaryColor)
                      : (theme.secondaryColor ?? Colors.grey[300]),
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: index == widget.controller.currentIndex
                      ? [
                          BoxShadow(
                            color: (theme.primaryColor ?? Theme.of(context).primaryColor).withValues(alpha: 0.4),
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
      ),
    );
  }

  Widget _buildSkipButton(OnboardingTheme theme) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      right: widget.showSideProgress ? 60 : 20,
      child: GestureDetector(
        onTap: widget.onComplete,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.grey.withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            'Skip',
            style: theme.buttonTextStyle?.copyWith(
              color: theme.skipButtonColor ?? Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingNavigation(OnboardingTheme theme) {
    return Positioned(
      bottom: MediaQuery.of(context).padding.bottom + 30,
      left: 20,
      right: 20,
      child: AnimatedBuilder(
        animation: widget.controller,
        builder: (context, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (!widget.controller.isFirstStep)
                _buildNavButton(
                  'Previous',
                  icon: Icons.keyboard_arrow_up,
                  onTap: widget.controller.previousStep,
                  isSecondary: true,
                  theme: theme,
                )
              else
                const SizedBox.shrink(),
              _buildNavButton(
                widget.controller.isLastStep ? 'Get Started' : 'Next',
                icon: widget.controller.isLastStep ? Icons.check : Icons.keyboard_arrow_down,
                onTap: widget.controller.isLastStep
                    ? widget.onComplete
                    : widget.controller.nextStep,
                theme: theme,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNavButton(
    String text, {
    required IconData icon,
    required VoidCallback? onTap,
    bool isSecondary = false,
    required OnboardingTheme theme,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSecondary
              ? Colors.white.withValues(alpha: 0.1)
              : (theme.buttonColor ?? theme.primaryColor ?? Theme.of(context).primaryColor),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSecondary
                ? Colors.grey.withValues(alpha: 0.3)
                : Colors.transparent,
          ),
          boxShadow: isSecondary
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSecondary) Icon(
              icon,
              color: theme.secondaryColor ?? Colors.grey[600],
              size: 20,
            ),
            if (isSecondary) const SizedBox(width: 6),
            Text(
              text,
              style: theme.buttonTextStyle?.copyWith(
                color: isSecondary
                    ? (theme.secondaryColor ?? Colors.grey[600])
                    : (theme.buttonTextColor ?? Colors.white),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (!isSecondary) const SizedBox(width: 6),
            if (!isSecondary) Icon(
              icon,
              color: theme.buttonTextColor ?? Colors.white,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}