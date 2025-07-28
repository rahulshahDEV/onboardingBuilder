import 'package:flutter/material.dart';

enum OnboardingType {
  slide,
  card,
  fullScreen,
  story,
  liquid,
  vertical,
  floating,
}

class OnboardingTheme {
  final Color? primaryColor;
  final Color? secondaryColor;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? buttonColor;
  final Color? buttonTextColor;
  final Color? progressIndicatorColor;
  final Color? skipButtonColor;
  final TextStyle? titleStyle;
  final TextStyle? descriptionStyle;
  final TextStyle? buttonTextStyle;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BoxShadow? shadow;

  const OnboardingTheme({
    this.primaryColor,
    this.secondaryColor,
    this.backgroundColor,
    this.textColor,
    this.buttonColor,
    this.buttonTextColor,
    this.progressIndicatorColor,
    this.skipButtonColor,
    this.titleStyle,
    this.descriptionStyle,
    this.buttonTextStyle,
    this.borderRadius,
    this.padding,
    this.margin,
    this.shadow,
  });

  OnboardingTheme copyWith({
    Color? primaryColor,
    Color? secondaryColor,
    Color? backgroundColor,
    Color? textColor,
    Color? buttonColor,
    Color? buttonTextColor,
    Color? progressIndicatorColor,
    Color? skipButtonColor,
    TextStyle? titleStyle,
    TextStyle? descriptionStyle,
    TextStyle? buttonTextStyle,
    double? borderRadius,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    BoxShadow? shadow,
  }) {
    return OnboardingTheme(
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      buttonColor: buttonColor ?? this.buttonColor,
      buttonTextColor: buttonTextColor ?? this.buttonTextColor,
      progressIndicatorColor: progressIndicatorColor ?? this.progressIndicatorColor,
      skipButtonColor: skipButtonColor ?? this.skipButtonColor,
      titleStyle: titleStyle ?? this.titleStyle,
      descriptionStyle: descriptionStyle ?? this.descriptionStyle,
      buttonTextStyle: buttonTextStyle ?? this.buttonTextStyle,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      shadow: shadow ?? this.shadow,
    );
  }
}