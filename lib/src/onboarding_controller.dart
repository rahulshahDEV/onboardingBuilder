import 'package:flutter/material.dart';

class OnboardingController extends ChangeNotifier {
  int _currentIndex = 0;
  final int _totalSteps;

  OnboardingController({required int totalSteps}) : _totalSteps = totalSteps;

  int get currentIndex => _currentIndex;
  int get totalSteps => _totalSteps;
  bool get isFirstStep => _currentIndex == 0;
  bool get isLastStep => _currentIndex == _totalSteps - 1;

  void nextStep() {
    if (!isLastStep) {
      _currentIndex++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (!isFirstStep) {
      _currentIndex--;
      notifyListeners();
    }
  }

  void goToStep(int index) {
    if (index >= 0 && index < _totalSteps) {
      _currentIndex = index;
      notifyListeners();
    }
  }

  void reset() {
    _currentIndex = 0;
    notifyListeners();
  }

  double get progress => (_currentIndex + 1) / _totalSteps;
}