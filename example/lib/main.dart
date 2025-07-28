import 'package:flutter/material.dart';
import 'package:onboarding_builder/onboarding_builder.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Onboarding Builder Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const OnboardingTypeSelector(),
    );
  }
}

class OnboardingTypeSelector extends StatelessWidget {
  const OnboardingTypeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Onboarding Style'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text(
              'Select an Onboarding Style',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            _buildOnboardingButton(
              context,
              'Slide Onboarding',
              'Classic slide-through experience with progress dots',
              Icons.swipe_right,
              Colors.blue,
              () => _navigateToOnboarding(context, OnboardingType.slide),
            ),
            const SizedBox(height: 20),
            _buildOnboardingButton(
              context,
              'Card Onboarding',
              'Beautiful card-based layout with smooth animations',
              Icons.credit_card,
              Colors.purple,
              () => _navigateToOnboarding(context, OnboardingType.card),
            ),
            const SizedBox(height: 20),
            _buildOnboardingButton(
              context,
              'Full Screen Onboarding',
              'Immersive full-screen experience with gradients',
              Icons.fullscreen,
              Colors.orange,
              () => _navigateToOnboarding(context, OnboardingType.fullScreen),
            ),
            const SizedBox(height: 20),
            _buildOnboardingButton(
              context,
              'Story Onboarding',
              'Instagram-style story onboarding with auto-advance',
              Icons.auto_stories,
              Colors.pink,
              () => _navigateToOnboarding(context, OnboardingType.story),
            ),
            const SizedBox(height: 20),
            _buildOnboardingButton(
              context,
              'Liquid Wave Onboarding',
              'Animated liquid waves with mesmerizing effects',
              Icons.waves,
              Colors.cyan,
              () => _navigateToOnboarding(context, OnboardingType.liquid),
            ),
            const SizedBox(height: 20),
            _buildOnboardingButton(
              context,
              'Vertical Scrolling',
              'Smooth vertical scrolling onboarding experience',
              Icons.swap_vert,
              Colors.green,
              () => _navigateToOnboarding(context, OnboardingType.vertical),
            ),
            const SizedBox(height: 20),
            _buildOnboardingButton(
              context,
              'Floating Elements',
              'Magical floating elements with particle effects',
              Icons.bubble_chart,
              Colors.deepPurple,
              () => _navigateToOnboarding(context, OnboardingType.floating),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingButton(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToOnboarding(BuildContext context, OnboardingType type) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => OnboardingExample(type: type),
      ),
    );
  }
}

class OnboardingExample extends StatelessWidget {
  final OnboardingType type;

  const OnboardingExample({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return OnboardingBuilder(
      type: type,
      steps: _getStepsForType(type),
      theme: _getThemeForType(type),
      onComplete: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      },
    );
  }

  List<OnboardingStep> _getStepsForType(OnboardingType type) {
    switch (type) {
      case OnboardingType.slide:
        return [
          const OnboardingStep(
            title: 'Welcome!',
            description:
                'Welcome to our amazing app. Let us show you around and help you get started.',
            icon: Icon(Icons.waving_hand, size: 80, color: Colors.blue),
          ),
          const OnboardingStep(
            title: 'Easy to Use',
            description:
                'Our intuitive interface makes it simple to accomplish your goals quickly and efficiently.',
            icon: Icon(Icons.touch_app, size: 80, color: Colors.green),
          ),
          const OnboardingStep(
            title: 'Stay Connected',
            description:
                'Connect with friends, share experiences, and build meaningful relationships.',
            icon: Icon(Icons.people, size: 80, color: Colors.orange),
          ),
          const OnboardingStep(
            title: 'Get Started',
            description:
                'You are all set! Tap the button below to begin your journey with us.',
            icon: Icon(Icons.rocket_launch, size: 80, color: Colors.purple),
          ),
        ];

      case OnboardingType.card:
        return [
          const OnboardingStep(
            title: 'Beautiful Cards',
            description:
                'Experience our elegant card-based onboarding with smooth animations and modern design.',
            icon: Icon(Icons.credit_card, size: 60, color: Colors.purple),
          ),
          OnboardingStep(
            title: 'Rich Customization',
            description:
                'Customize colors, gradients, images, and more to match your brand perfectly.',
            backgroundGradient: LinearGradient(
              colors: [Colors.purple.shade100, Colors.blue.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            icon: const Icon(Icons.palette, size: 60, color: Colors.deepPurple),
          ),
          const OnboardingStep(
            title: 'Smooth Animations',
            description:
                'Enjoy buttery smooth transitions and delightful micro-interactions.',
            icon: Icon(Icons.animation, size: 60, color: Colors.indigo),
            titleColor: Colors.indigo,
          ),
        ];

      case OnboardingType.fullScreen:
        return [
          OnboardingStep(
            title: 'Immersive Experience',
            description:
                'Full-screen onboarding with beautiful gradients and immersive design.',
            backgroundGradient: LinearGradient(
              colors: [Colors.orange.shade400, Colors.pink.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            icon: const Icon(Icons.fullscreen, size: 80, color: Colors.white),
          ),
          OnboardingStep(
            title: 'Swipe Gestures',
            description:
                'Navigate through steps with intuitive swipe gestures or use the buttons.',
            backgroundGradient: LinearGradient(
              colors: [Colors.blue.shade600, Colors.purple.shade600],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            icon: const Icon(Icons.swipe, size: 80, color: Colors.white),
          ),
          OnboardingStep(
            title: 'Ready to Go!',
            description:
                'You are now ready to explore all the amazing features we have prepared for you.',
            backgroundGradient: LinearGradient(
              colors: [Colors.green.shade500, Colors.teal.shade500],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            icon: const Icon(Icons.check_circle, size: 80, color: Colors.white),
          ),
        ];
        
      case OnboardingType.story:
        return [
          OnboardingStep(
            title: 'Story Mode',
            description: 'Experience onboarding like Instagram stories with auto-advance and tap navigation.',
            backgroundGradient: LinearGradient(
              colors: [Colors.pink.shade600, Colors.purple.shade600],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            icon: const Icon(Icons.auto_stories, size: 80, color: Colors.white),
          ),
          OnboardingStep(
            title: 'Auto Progress',
            description: 'Watch the progress bar fill automatically or tap to advance manually.',
            backgroundGradient: LinearGradient(
              colors: [Colors.orange.shade500, Colors.red.shade500],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            icon: const Icon(Icons.timer, size: 80, color: Colors.white),
          ),
          OnboardingStep(
            title: 'Interactive Experience',
            description: 'Tap anywhere to skip ahead or use the navigation buttons for full control.',
            backgroundGradient: LinearGradient(
              colors: [Colors.indigo.shade500, Colors.blue.shade500],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            icon: const Icon(Icons.touch_app, size: 80, color: Colors.white),
          ),
        ];
        
      case OnboardingType.liquid:
        return [
          const OnboardingStep(
            title: 'Liquid Waves',
            description: 'Beautiful animated liquid waves create a mesmerizing background effect.',
            icon: Icon(Icons.waves, size: 80, color: Colors.white),
          ),
          const OnboardingStep(
            title: 'Dynamic Colors',
            description: 'Wave colors blend and shift creating a dynamic, ever-changing atmosphere.',
            icon: Icon(Icons.color_lens, size: 80, color: Colors.white),
          ),
          const OnboardingStep(
            title: 'Smooth Flow',
            description: 'Experience the smooth, organic flow of liquid animations throughout your journey.',
            icon: Icon(Icons.water_drop, size: 80, color: Colors.white),
          ),
        ];
        
      case OnboardingType.vertical:
        return [
          OnboardingStep(
            title: 'Scroll Vertically',
            description: 'Navigate through onboarding steps with natural vertical scrolling motion.',
            backgroundGradient: LinearGradient(
              colors: [Colors.green.shade400, Colors.teal.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            icon: const Icon(Icons.swap_vert, size: 80, color: Colors.white),
          ),
          OnboardingStep(
            title: 'Side Progress',
            description: 'Track your progress with the elegant side progress indicator.',
            backgroundGradient: LinearGradient(
              colors: [Colors.blue.shade500, Colors.indigo.shade500],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            icon: const Icon(Icons.timeline, size: 80, color: Colors.white),
          ),
          OnboardingStep(
            title: 'Smooth Transitions',
            description: 'Enjoy buttery smooth transitions with snap-to-page scrolling physics.',
            backgroundGradient: LinearGradient(
              colors: [Colors.purple.shade500, Colors.pink.shade500],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            icon: const Icon(Icons.animation, size: 80, color: Colors.white),
          ),
        ];
        
      case OnboardingType.floating:
        return [
          OnboardingStep(
            title: 'Floating Magic',
            description: 'Elements float and dance with enchanting particle effects in the background.',
            backgroundGradient: LinearGradient(
              colors: [Colors.deepPurple.shade600, Colors.indigo.shade600],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            icon: const Icon(Icons.bubble_chart, size: 80, color: Colors.white),
          ),
          OnboardingStep(
            title: 'Parallax Effects',
            description: 'Experience depth with beautiful parallax scrolling and floating animations.',
            backgroundGradient: LinearGradient(
              colors: [Colors.teal.shade500, Colors.cyan.shade500],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            icon: const Icon(Icons.layers, size: 80, color: Colors.white),
          ),
          OnboardingStep(
            title: 'Immersive Design',
            description: 'Get lost in the immersive design with floating cards and animated particles.',
            backgroundGradient: LinearGradient(
              colors: [Colors.pink.shade500, Colors.purple.shade500],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            icon: const Icon(Icons.auto_fix_high, size: 80, color: Colors.white),
          ),
        ];
    }
  }

  OnboardingTheme _getThemeForType(OnboardingType type) {
    switch (type) {
      case OnboardingType.slide:
        return const OnboardingTheme(
          primaryColor: Colors.blue,
          buttonColor: Colors.blue,
          buttonTextColor: Colors.white,
          skipButtonColor: Colors.grey,
        );

      case OnboardingType.card:
        return const OnboardingTheme(
          primaryColor: Colors.purple,
          buttonColor: Colors.purple,
          buttonTextColor: Colors.white,
          skipButtonColor: Colors.grey,
          borderRadius: 16,
        );

      case OnboardingType.fullScreen:
        return const OnboardingTheme(
          primaryColor: Colors.white,
          buttonColor: Colors.white,
          buttonTextColor: Colors.black87,
          skipButtonColor: Colors.white,
          progressIndicatorColor: Colors.white,
          titleStyle: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          descriptionStyle: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        );
        
      case OnboardingType.story:
        return const OnboardingTheme(
          primaryColor: Colors.white,
          buttonColor: Colors.white,
          buttonTextColor: Colors.black87,
          skipButtonColor: Colors.white,
          progressIndicatorColor: Colors.white,
          titleStyle: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          descriptionStyle: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        );
        
      case OnboardingType.liquid:
        return const OnboardingTheme(
          primaryColor: Colors.cyan,
          buttonColor: Colors.white,
          buttonTextColor: Colors.cyan,
          skipButtonColor: Colors.white,
          progressIndicatorColor: Colors.white,
          titleStyle: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          descriptionStyle: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        );
        
      case OnboardingType.vertical:
        return const OnboardingTheme(
          primaryColor: Colors.green,
          buttonColor: Colors.green,
          buttonTextColor: Colors.white,
          skipButtonColor: Colors.grey,
          progressIndicatorColor: Colors.green,
          borderRadius: 12,
        );
        
      case OnboardingType.floating:
        return const OnboardingTheme(
          primaryColor: Colors.deepPurple,
          buttonColor: Colors.white,
          buttonTextColor: Colors.deepPurple,
          skipButtonColor: Colors.white,
          progressIndicatorColor: Colors.white,
          titleStyle: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          descriptionStyle: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        );
    }
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const OnboardingTypeSelector(),
                ),
              );
            },
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.celebration, size: 100, color: Colors.green),
            SizedBox(height: 20),
            Text(
              'Welcome to the App!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'You have successfully completed the onboarding process.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 20),
            Text(
              'Tap the refresh icon to try another onboarding style!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
