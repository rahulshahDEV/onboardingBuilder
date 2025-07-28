import 'package:flutter/material.dart';

class OnboardingStep {
  final String title;
  final String description;
  final Widget? icon;
  final String? imagePath;
  final ImageProvider? imageProvider;
  final Color? backgroundColor;
  final Gradient? backgroundGradient;
  final String? backgroundImagePath;
  final ImageProvider? backgroundImageProvider;
  final BoxFit? backgroundImageFit;
  final TextStyle? titleStyle;
  final TextStyle? descriptionStyle;
  final Color? titleColor;
  final Color? descriptionColor;
  final double? iconSize;
  final Color? iconColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final Border? border;
  final List<BoxShadow>? boxShadow;
  final Widget? customContent;
  final MainAxisAlignment? mainAxisAlignment;
  final CrossAxisAlignment? crossAxisAlignment;
  final double? spacing;

  const OnboardingStep({
    required this.title,
    required this.description,
    this.icon,
    this.imagePath,
    this.imageProvider,
    this.backgroundColor,
    this.backgroundGradient,
    this.backgroundImagePath,
    this.backgroundImageProvider,
    this.backgroundImageFit = BoxFit.cover,
    this.titleStyle,
    this.descriptionStyle,
    this.titleColor,
    this.descriptionColor,
    this.iconSize,
    this.iconColor,
    this.padding,
    this.margin,
    this.borderRadius,
    this.border,
    this.boxShadow,
    this.customContent,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.spacing = 16.0,
  });

  Widget? get displayIcon {
    if (icon != null) return icon;
    if (imagePath != null) {
      return Image.asset(
        imagePath!,
        width: iconSize ?? 80,
        height: iconSize ?? 80,
        fit: BoxFit.contain,
      );
    }
    if (imageProvider != null) {
      return Image(
        image: imageProvider!,
        width: iconSize ?? 80,
        height: iconSize ?? 80,
        fit: BoxFit.contain,
      );
    }
    return null;
  }

  Decoration? get backgroundDecoration {
    if (backgroundGradient != null || backgroundColor != null || backgroundImageProvider != null || backgroundImagePath != null) {
      return BoxDecoration(
        color: backgroundColor,
        gradient: backgroundGradient,
        image: _getBackgroundImage(),
        borderRadius: borderRadius != null ? BorderRadius.circular(borderRadius!) : null,
        border: border,
        boxShadow: boxShadow,
      );
    }
    return null;
  }

  DecorationImage? _getBackgroundImage() {
    if (backgroundImageProvider != null) {
      return DecorationImage(
        image: backgroundImageProvider!,
        fit: backgroundImageFit ?? BoxFit.cover,
      );
    }
    if (backgroundImagePath != null) {
      return DecorationImage(
        image: AssetImage(backgroundImagePath!),
        fit: backgroundImageFit ?? BoxFit.cover,
      );
    }
    return null;
  }
}