# onboarding_builder

A highly customizable Flutter package for building beautiful onboarding flows with multiple UI styles and extensive customization options.

## Features

- **3 Built-in Onboarding Types**: Slide, Card, and Full-Screen styles
- **Extensive Customization**: Colors, gradients, images, fonts, and more
- **Rich Animation Support**: Smooth transitions with customizable curves and durations
- **Gesture Support**: Swipe navigation (full-screen type)
- **Image Support**: Asset images, network images, and custom image providers
- **Theme System**: Comprehensive theming with OnboardingTheme
- **Progress Indicators**: Dots, bars, and custom progress displays
- **Skip Functionality**: Optional skip button with customization
- **Custom Builders**: Override any component with custom widgets
- **Material Design 3**: Full compatibility with Material 3

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
- `type`: Onboarding type (`OnboardingType.slide`, `card`, or `fullScreen`)
- `theme`: Global theme configuration (`OnboardingTheme`)
- `controller`: Optional `OnboardingController` for custom control
- `onComplete`: Callback when onboarding is completed
- `customStepBuilder`: Custom builder for step content
- `customNavigationBuilder`: Custom builder for navigation controls
- `padding`: Padding around the content (default: `EdgeInsets.all(24.0)`)
- `showProgressIndicator`: Whether to show progress indicator (default: `true`)
- `showSkipButton`: Whether to show skip button (default: `true`)
- `animationDuration`: Duration for animations (default: `300ms`)
- `animationCurve`: Animation curve (default: `Curves.easeInOut`)
- `cardElevation`: Card elevation for card type (default: `8.0`)
- `cardBorderRadius`: Card border radius for card type (default: `16.0`)
- `enableSwipeGesture`: Enable swipe navigation for full-screen type (default: `true`)
- `backgroundWidget`: Custom background widget for full-screen type

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

## Example

Check out the [example](example/) directory for a complete working example.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.