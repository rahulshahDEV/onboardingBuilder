# onboarding_builder

A highly customizable Flutter package for building beautiful onboarding flows with multiple UI styles and extensive customization options.

## Features

- **7 Built-in Onboarding Types**: Slide, Card, Full-Screen, Story, Liquid Wave, Vertical Scrolling, and Floating Elements styles  
- **Extensive Customization**: Colors, gradients, images, fonts, and more
- **Rich Animation Support**: Smooth transitions with customizable curves and durations
- **Advanced Effects**: Liquid wave animations, floating particles, parallax effects, and story-style progressions
- **Gesture Support**: Swipe navigation, vertical scrolling, and tap interactions
- **Image Support**: Asset images, network images, and custom image providers
- **Theme System**: Comprehensive theming with OnboardingTheme
- **Progress Indicators**: Dots, bars, side progress, floating progress, and custom displays
- **Skip Functionality**: Optional skip button with customization
- **Auto-advance**: Automatic progression for story-style onboarding
- **Custom Builders**: Override any component with custom widgets
- **Material Design 3**: Full compatibility with Material 3

## DEMO

## Screenshots

<div style="display: flex; overflow-x: auto; gap: 10px; height: 200px;">
  <img src="https://i.imgur.com/aIZ2wVU.jpg" height="200">
  <img src="https://i.imgur.com/OwOVdOH.jpg" height="200">
  <img src="https://i.imgur.com/k8MlawL.jpg" height="200">
  <img src="https://i.imgur.com/1hiay6B.jpg" height="200">
  <img src="https://i.imgur.com/peDX7qF.jpg" height="200">
  <img src="https://i.imgur.com/rbL5qvT.jpg" height="200">
</div>





## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  onboarding_builder: ^0.1.0
```

Then run:

```bash
flutter pub get
```

## Onboarding Types

### 1. Slide Onboarding (Default)
Classic slide-through experience with progress dots and smooth transitions.

### 2. Card Onboarding
Elegant card-based layout with beautiful animations and modern design.

### 3. Full-Screen Onboarding
Immersive full-screen experience with gradient backgrounds and swipe gestures.

### 4. Story Onboarding
Instagram-style story onboarding with progress bars, auto-advance, and tap-to-continue functionality.

### 5. Liquid Wave Onboarding
Dynamic liquid wave animations with fluid transitions and mesmerizing visual effects.

### 6. Vertical Scrolling Onboarding
Vertical scroll-based onboarding with snap scrolling, side progress indicators, and smooth animations.

### 7. Floating Elements Onboarding
Floating UI elements with parallax effects, particle backgrounds, and 3D-like animations.

## Usage

### Basic Usage

```dart
import 'package:flutter/material.dart';
import 'package:onboarding_builder/onboarding_builder.dart';

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final steps = [
      OnboardingStep(
        title: 'Welcome!',
        description: 'Welcome to our amazing app.',
        icon: Icon(Icons.waving_hand, size: 80, color: Colors.blue),
      ),
      OnboardingStep(
        title: 'Easy to Use',
        description: 'Our intuitive interface makes everything simple.',
        icon: Icon(Icons.touch_app, size: 80, color: Colors.green),
      ),
      OnboardingStep(
        title: 'Get Started',
        description: 'You are all set! Let\'s begin.',
        icon: Icon(Icons.rocket_launch, size: 80, color: Colors.purple),
      ),
    ];

    return OnboardingBuilder(
      type: OnboardingType.slide, // Choose your onboarding type
      steps: steps,
      onComplete: () {
        // Navigate to main app
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      },
    );
  }
}
```

### Card Onboarding Example

```dart
OnboardingBuilder(
  type: OnboardingType.card,
  steps: [
    OnboardingStep(
      title: 'Beautiful Cards',
      description: 'Experience elegant card-based onboarding.',
      icon: Icon(Icons.credit_card, size: 60, color: Colors.purple),
      backgroundGradient: LinearGradient(
        colors: [Colors.purple.shade100, Colors.blue.shade100],
      ),
    ),
    // ... more steps
  ],
  theme: OnboardingTheme(
    primaryColor: Colors.purple,
    buttonColor: Colors.purple,
    borderRadius: 16,
  ),
  onComplete: () => Navigator.pushReplacement(/* your route */),
)
```

### Full-Screen Onboarding Example

```dart
OnboardingBuilder(
  type: OnboardingType.fullScreen,
  steps: [
    OnboardingStep(
      title: 'Immersive Experience',
      description: 'Full-screen onboarding with beautiful gradients.',
      backgroundGradient: LinearGradient(
        colors: [Colors.orange.shade400, Colors.pink.shade400],
      ),
      icon: Icon(Icons.fullscreen, size: 80, color: Colors.white),
    ),
    // ... more steps
  ],
  theme: OnboardingTheme(
    titleStyle: TextStyle(fontSize: 32, color: Colors.white),
    descriptionStyle: TextStyle(fontSize: 18, color: Colors.white),
  ),
  enableSwipeGesture: true,
  onComplete: () => Navigator.pushReplacement(/* your route */),
)
```

### Story Onboarding Example

```dart
OnboardingBuilder(
  type: OnboardingType.story,
  steps: [
    OnboardingStep(
      title: 'Welcome to Stories',
      description: 'Experience Instagram-style onboarding with auto-advance.',
      backgroundGradient: LinearGradient(
        colors: [Colors.purple.shade400, Colors.pink.shade400],
      ),
      icon: Icon(Icons.auto_stories, size: 80, color: Colors.white),
    ),
    OnboardingStep(
      title: 'Tap to Continue',
      description: 'Tap anywhere to move to the next step.',
      backgroundGradient: LinearGradient(
        colors: [Colors.blue.shade400, Colors.cyan.shade400],
      ),
      icon: Icon(Icons.touch_app, size: 80, color: Colors.white),
    ),
    // ... more steps
  ],
  autoAdvance: true, // Enable auto-advance
  autoAdvanceDuration: Duration(seconds: 3),
  onComplete: () => Navigator.pushReplacement(/* your route */),
)
```

### Liquid Wave Onboarding Example

```dart
OnboardingBuilder(
  type: OnboardingType.liquid,
  steps: [
    OnboardingStep(
      title: 'Liquid Animations',
      description: 'Beautiful wave animations with fluid transitions.',
      backgroundGradient: LinearGradient(
        colors: [Colors.teal.shade300, Colors.blue.shade400],
      ),
      icon: Icon(Icons.waves, size: 80, color: Colors.white),
    ),
    OnboardingStep(
      title: 'Smooth Flow',
      description: 'Experience mesmerizing liquid wave effects.',
      backgroundGradient: LinearGradient(
        colors: [Colors.indigo.shade400, Colors.purple.shade400],
      ),
      icon: Icon(Icons.water_drop, size: 80, color: Colors.white),
    ),
    // ... more steps
  ],
  waveColors: [Colors.blue.shade200, Colors.purple.shade200],
  animationDuration: Duration(milliseconds: 1000),
  onComplete: () => Navigator.pushReplacement(/* your route */),
)
```

### Vertical Scrolling Onboarding Example

```dart
OnboardingBuilder(
  type: OnboardingType.vertical,
  steps: [
    OnboardingStep(
      title: 'Scroll Vertically',
      description: 'Scroll through steps with smooth snap animations.',
      backgroundColor: Colors.lightBlue.shade50,
      icon: Icon(Icons.swipe_vertical, size: 80, color: Colors.blue),
    ),
    OnboardingStep(
      title: 'Side Progress',
      description: 'Track your progress with the side indicator.',
      backgroundColor: Colors.green.shade50,
      icon: Icon(Icons.timeline, size: 80, color: Colors.green),
    ),
    // ... more steps
  ],
  showSideProgress: true,
  enableSnapScrolling: true,
  animationDuration: Duration(milliseconds: 500),
  onComplete: () => Navigator.pushReplacement(/* your route */),
)
```

### Floating Elements Onboarding Example

```dart
OnboardingBuilder(
  type: OnboardingType.floating,
  steps: [
    OnboardingStep(
      title: 'Floating Magic',
      description: 'Elements that float with stunning parallax effects.',
      backgroundGradient: LinearGradient(
        colors: [Colors.deepPurple.shade400, Colors.pink.shade300],
      ),
      icon: Icon(Icons.bubble_chart, size: 80, color: Colors.white),
    ),
    OnboardingStep(
      title: 'Particle Effects',
      description: 'Beautiful particle backgrounds add depth.',
      backgroundGradient: LinearGradient(
        colors: [Colors.orange.shade400, Colors.red.shade400],
      ),
      icon: Icon(Icons.auto_fix_high, size: 80, color: Colors.white),
    ),
    // ... more steps
  ],
  enableParallaxEffect: true,
  showParticleBackground: true,
  showFloatingProgress: true,
  animationDuration: Duration(milliseconds: 1200),
  onComplete: () => Navigator.pushReplacement(/* your route */),
)
```

### Advanced Usage with Custom Controller

```dart
import 'package:flutter/material.dart';
import 'package:onboarding_builder/onboarding_builder.dart';

class AdvancedOnboardingScreen extends StatefulWidget {
  @override
  _AdvancedOnboardingScreenState createState() => _AdvancedOnboardingScreenState();
}

class _AdvancedOnboardingScreenState extends State<AdvancedOnboardingScreen> {
  late OnboardingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = OnboardingController(totalSteps: 3);
  }

  @override
  Widget build(BuildContext context) {
    final steps = [
      OnboardingStep(
        title: 'Step 1',
        description: 'This is the first step',
        backgroundColor: Colors.blue[100],
      ),
      OnboardingStep(
        title: 'Step 2',
        description: 'This is the second step',
        backgroundColor: Colors.green[100],
      ),
      OnboardingStep(
        title: 'Step 3',
        description: 'This is the final step',
        backgroundColor: Colors.purple[100],
      ),
    ];

    return OnboardingBuilder(
      steps: steps,
      controller: _controller,
      showProgressIndicator: true,
      progressIndicatorColor: Colors.blue,
      customNavigationBuilder: (context, controller) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (!controller.isFirstStep)
              ElevatedButton(
                onPressed: controller.previousStep,
                child: Text('Back'),
              ),
            ElevatedButton(
              onPressed: controller.isLastStep
                  ? () {
                      // Handle completion
                    }
                  : controller.nextStep,
              child: Text(controller.isLastStep ? 'Finish' : 'Continue'),
            ),
          ],
        );
      },
    );
  }
}
```

## Advanced Customization

### Using Images

```dart
OnboardingStep(
  title: 'Custom Images',
  description: 'Use asset images or network images.',
  imagePath: 'assets/images/welcome.png', // Asset image
  iconSize: 120,
  backgroundImagePath: 'assets/images/background.jpg',
  backgroundImageFit: BoxFit.cover,
)

// Or use ImageProvider
OnboardingStep(
  title: 'Network Image',
  description: 'Load images from network.',
  imageProvider: NetworkImage('https://example.com/image.png'),
  backgroundImageProvider: NetworkImage('https://example.com/bg.jpg'),
)
```

### Custom Styling

```dart
OnboardingStep(
  title: 'Custom Style',
  description: 'Fully customizable styling options.',
  titleColor: Colors.blue,
  descriptionColor: Colors.grey,
  backgroundColor: Colors.white,
  backgroundGradient: LinearGradient(
    colors: [Colors.blue.shade100, Colors.purple.shade100],
  ),
  borderRadius: 20,
  padding: EdgeInsets.all(32),
  spacing: 24, // Space between elements
)
```

### OnboardingTheme

Global theming for consistent styling across all steps.

```dart
OnboardingTheme(
  primaryColor: Colors.blue,
  secondaryColor: Colors.grey,
  backgroundColor: Colors.white,
  textColor: Colors.black,
  buttonColor: Colors.blue,
  buttonTextColor: Colors.white,
  progressIndicatorColor: Colors.blue,
  skipButtonColor: Colors.grey,
  titleStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  descriptionStyle: TextStyle(fontSize: 16, height: 1.5),
  buttonTextStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  borderRadius: 12,
  padding: EdgeInsets.all(24),
  margin: EdgeInsets.all(16),
)
```

## API Reference

### OnboardingBuilder

The main widget for creating onboarding flows.

#### Properties

- `steps` (required): List of `OnboardingStep` objects
- `type`: Onboarding type (`OnboardingType.slide`, `card`, `fullScreen`, `story`, `liquid`, `vertical`, or `floating`)
- `theme`: Global theme configuration (`OnboardingTheme`)
- `controller`: Optional `OnboardingController` for custom control
- `onComplete`: Callback when onboarding is completed
- `customStepBuilder`: Custom builder for step content
- `customNavigationBuilder`: Custom builder for navigation controls
- `padding`: Padding around the content (default: `EdgeInsets.all(24.0)`)
- `showProgressIndicator`: Whether to show progress indicator (default: `true`)
- `showSkipButton`: Whether to show skip button (default: `true`)
- `animationDuration`: Duration for animations (default: varies by type)
- `animationCurve`: Animation curve (default: varies by type)

#### Type-Specific Properties

**Card Type:**
- `cardElevation`: Card elevation (default: `8.0`)
- `cardBorderRadius`: Card border radius (default: `16.0`)

**Full-Screen Type:**
- `enableSwipeGesture`: Enable swipe navigation (default: `true`)
- `backgroundWidget`: Custom background widget

**Story Type:**
- `showProgressBar`: Show story progress bars (default: `true`)
- `autoAdvance`: Enable auto-advance (default: `false`)
- `autoAdvanceDuration`: Duration for auto-advance (default: `3s`)

**Liquid Type:**
- `waveColors`: Custom colors for wave animations
- `animationDuration`: Wave animation duration (default: `1000ms`)

**Vertical Type:**
- `showSideProgress`: Show side progress indicator (default: `true`)
- `enableSnapScrolling`: Enable snap scrolling (default: `true`)
- `scrollPhysics`: Custom scroll physics

**Floating Type:**
- `showFloatingProgress`: Show floating progress indicator (default: `true`)
- `enableParallaxEffect`: Enable parallax effects (default: `true`)
- `showParticleBackground`: Show particle background (default: `true`)

### OnboardingStep

Represents a single step in the onboarding flow.

#### Properties

##### Content
- `title` (required): Step title
- `description` (required): Step description
- `customContent`: Override default content with custom widget

##### Icons & Images
- `icon`: Custom icon widget
- `imagePath`: Asset image path
- `imageProvider`: Custom image provider
- `iconSize`: Size of icon/image (default: `80`)
- `iconColor`: Color of icon

##### Background
- `backgroundColor`: Background color
- `backgroundGradient`: Background gradient
- `backgroundImagePath`: Background image asset path
- `backgroundImageProvider`: Background image provider
- `backgroundImageFit`: How background image fits (default: `BoxFit.cover`)

##### Styling
- `titleStyle`: Custom title text style
- `descriptionStyle`: Custom description text style
- `titleColor`: Title text color
- `descriptionColor`: Description text color
- `padding`: Content padding
- `margin`: Content margin
- `borderRadius`: Border radius
- `border`: Custom border
- `boxShadow`: Custom box shadow

##### Layout
- `mainAxisAlignment`: Vertical alignment (default: `MainAxisAlignment.center`)
- `crossAxisAlignment`: Horizontal alignment (default: `CrossAxisAlignment.center`)
- `spacing`: Space between elements (default: `16.0`)

### OnboardingController

Controller for managing onboarding state.

#### Properties

- `currentIndex`: Current step index
- `totalSteps`: Total number of steps
- `isFirstStep`: Whether currently on the first step
- `isLastStep`: Whether currently on the last step
- `progress`: Progress as a value between 0.0 and 1.0

#### Methods

- `nextStep()`: Move to next step
- `previousStep()`: Move to previous step
- `goToStep(int index)`: Jump to specific step
- `reset()`: Reset to first step

### OnboardingType

Enum defining the onboarding UI style.

- `OnboardingType.slide`: Classic slide onboarding with dots
- `OnboardingType.card`: Card-based onboarding with animations  
- `OnboardingType.fullScreen`: Full-screen immersive onboarding
- `OnboardingType.story`: Instagram-style story onboarding with progress bars
- `OnboardingType.liquid`: Liquid wave animations with fluid transitions
- `OnboardingType.vertical`: Vertical scrolling with snap animations
- `OnboardingType.floating`: Floating elements with parallax and particle effects

## Example

Check out the [example](example/) directory for a complete working example.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
