
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

class AccessibilityUtils {
  // Private constructor to prevent instantiation
  AccessibilityUtils._();
  
  // Constants for semantic labels
  static const String kWorkoutStartLabel = 'Start workout';
  static const String kWorkoutPauseLabel = 'Pause workout';
  static const String kWorkoutResumeLabel = 'Resume workout';
  static const String kWorkoutCompleteLabel = 'Complete workout';
  static const String kExerciseNextLabel = 'Next exercise';
  static const String kExercisePreviousLabel = 'Previous exercise';
  
  // Helper method to set semantic properties on widgets
  static Semantics withSemantics({
    required Widget child,
    required String label,
    String? hint,
    bool isButton = false,
    bool isImage = false,
    bool isTextField = false,
    bool isSlider = false,
    bool isLink = false,
    bool isChecked = false,
    VoidCallback? onTap,
    String? value,
    TextDirection? textDirection,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      button: isButton,
      image: isImage,
      textField: isTextField,
      slider: isSlider,
      link: isLink,
      checked: isChecked,
      onTap: onTap,
      value: value,
      textDirection: textDirection,
      child: child,
    );
  }
  
  // Create an ExcludeSemantics widget
  static ExcludeSemantics excludeFromSemantics(Widget child) {
    return ExcludeSemantics(child: child);
  }
  
  // Create a MergeSemantics widget
  static MergeSemantics mergeSemantics({required List<Widget> children}) {
    return MergeSemantics(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
  
  // Add screen reader announcement
  static void announce(BuildContext context, String message, [TextDirection textDirection = TextDirection.ltr]) {
    SemanticsService.announce(message, textDirection);
  }
  
  // Helper for creating accessible buttons
  static Widget accessibleButton({
    required BuildContext context,
    required VoidCallback onPressed,
    required Widget child,
    required String label,
    String? hint,
    bool enabled = true,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      button: true,
      enabled: enabled,
      onTap: enabled ? onPressed : null,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        child: child,
      ),
    );
  }
  
  // Helper for creating accessible icon buttons
  static Widget accessibleIconButton({
    required BuildContext context,
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    String? hint,
    Color? color,
    double size = 24.0,
    bool enabled = true,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      button: true,
      enabled: enabled,
      onTap: enabled ? onPressed : null,
      child: IconButton(
        icon: Icon(icon, color: color, size: size),
        onPressed: enabled ? onPressed : null,
      ),
    );
  }
  
  // Helper for creating accessible text
  static Widget accessibleText({
    required String text,
    required TextStyle? style,
    String? semanticLabel,
    TextAlign textAlign = TextAlign.start,
    TextOverflow overflow = TextOverflow.clip,
    int? maxLines,
  }) {
    return Semantics(
      label: semanticLabel ?? text,
      child: Text(
        text,
        style: style,
        textAlign: textAlign,
        overflow: overflow,
        maxLines: maxLines,
      ),
    );
  }
  
  // Helper for creating accessible images
  static Widget accessibleImage({
    required ImageProvider image,
    required String label,
    String? hint,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      image: true,
      child: Image(
        image: image,
        width: width,
        height: height,
        fit: fit,
      ),
    );
  }
  
  // Helper for creating accessible text field
  static Widget accessibleTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    int? maxLines = 1,
    ValueChanged<String>? onChanged,
    FormFieldValidator<String>? validator,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      textField: true,
      onTap: () {},
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
        ),
        obscureText: obscureText,
        keyboardType: keyboardType,
        maxLines: maxLines,
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
  
  // Helper for creating accessible checkboxes
  static Widget accessibleCheckbox({
    required bool value,
    required ValueChanged<bool?> onChanged,
    required String label,
    String? hint,
    bool enabled = true,
  }) {
    return MergeSemantics(
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: enabled ? onChanged : null,
          ),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: enabled ? null : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // Helper for creating custom accessible sliders
  static Widget accessibleSlider({
    required double value,
    required ValueChanged<double> onChanged,
    required String label,
    String? hint,
    double min = 0.0,
    double max = 1.0,
    int? divisions,
    String Function(double)? valueFormatter,
    bool enabled = true,
  }) {
    final formattedValue = valueFormatter != null ? valueFormatter(value) : value.toString();
    
    return Semantics(
      label: label,
      hint: hint,
      value: formattedValue,
      slider: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: enabled ? onChanged : null,
          ),
          Text(formattedValue),
        ],
      ),
    );
  }
  
  // Helper for large touch targets (improved accessibility)
  static Widget largeTouchTarget({
    required Widget child,
    required VoidCallback onTap,
    double minSize = 48.0,
    EdgeInsets padding = EdgeInsets.zero,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(
          minWidth: minSize,
          minHeight: minSize,
        ),
        padding: padding,
        child: child,
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

/// Utility class to handle accessibility features throughout the app
class AccessibilityUtils {
  // Private constructor to prevent instantiation
  AccessibilityUtils._();
  
  /// Check if screen reader is enabled
  static Future<bool> isScreenReaderEnabled() async {
    return await SemanticsBinding.instance.accessibilityFeatures.isAccessibilityEnabled;
  }
  
  /// Updates semantic properties for a widget to improve screen reader experience
  static Semantics improveSemanticLabel({
    required Widget child,
    required String label,
    String? hint,
    bool excludeSemantics = false,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      excludeSemantics: excludeSemantics,
      child: child,
    );
  }
  
  /// Provides a more descriptive label for buttons and interactive elements
  static Widget labelButton({
    required Widget button,
    required String label,
    String? hint,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      button: true,
      child: ExcludeSemantics(
        child: button,
      ),
    );
  }
  
  /// Makes sure images have proper accessibility descriptions
  static Widget accessibleImage({
    required ImageProvider image,
    required String description,
    BoxFit? fit,
    double? width,
    double? height,
  }) {
    return Semantics(
      image: true,
      label: description,
      child: ExcludeSemantics(
        child: Image(
          image: image,
          fit: fit,
          width: width,
          height: height,
        ),
      ),
    );
  }
  
  /// Helper method for creating accessible form fields
  static Widget accessibleFormField({
    required Widget field,
    required String label,
    String? error,
    bool isRequired = false,
  }) {
    String accessibilityLabel = label;
    if (isRequired) {
      accessibilityLabel += ", required field";
    }
    
    if (error != null && error.isNotEmpty) {
      accessibilityLabel += ", error: $error";
    }
    
    return Semantics(
      label: accessibilityLabel,
      textField: true,
      child: field,
    );
  }
  
  /// Enhances tab navigation with proper labels
  static Widget accessibleTabItem({
    required Widget tab,
    required String label,
    required bool isSelected,
  }) {
    return Semantics(
      label: label,
      selected: isSelected,
      child: tab,
    );
  }
  
  /// Helper to create accessibility-friendly list items
  static Widget accessibleListItem({
    required Widget child,
    required String label,
    VoidCallback? onTap,
  }) {
    return Semantics(
      label: label,
      button: onTap != null,
      enabled: onTap != null,
      child: InkWell(
        onTap: onTap,
        child: child,
      ),
    );
  }
  
  /// Increases tap target size for better accessibility
  static Widget enlargeTapArea({
    required Widget child,
    double minSize = 48.0,
  }) {
    return SizedBox(
      width: minSize,
      height: minSize,
      child: Center(
        child: child,
      ),
    );
  }
  
  /// Sets up proper accessibility ordering for a group of widgets
  static Widget createAccessibilityOrder({
    required List<Widget> children,
    required BuildContext context,
  }) {
    return Semantics(
      container: true,
      explicitChildNodes: true,
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.bodyMedium!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      ),
    );
  }
}
