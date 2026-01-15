import 'package:flutter/material.dart';

enum PrimaryButtonVariant { primary, secondary, outline }

class PrimaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool disabled;
  final PrimaryButtonVariant variant;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.disabled = false,
    this.variant = PrimaryButtonVariant.primary,
  });

  Color _backgroundColor() {
    if (disabled) return const Color(0xFFE2E8F0);

    switch (variant) {
      case PrimaryButtonVariant.primary:
        return const Color(0xFF0D9488);
      case PrimaryButtonVariant.secondary:
        return const Color(0xFF4F46E5);
      case PrimaryButtonVariant.outline:
        return Colors.transparent;
    }
  }

  Color _textColor() {
    if (disabled) return const Color(0xFF94A3B8);

    switch (variant) {
      case PrimaryButtonVariant.primary:
      case PrimaryButtonVariant.secondary:
        return Colors.white;
      case PrimaryButtonVariant.outline:
        return const Color(0xFF475569);
    }
  }

  BoxBorder? _border() {
    if (variant == PrimaryButtonVariant.outline) {
      return Border.all(color: const Color(0xFFE2E8F0), width: 2);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disabled ? null : onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: _backgroundColor(),
          borderRadius: BorderRadius.circular(24),
          border: _border(),
          boxShadow: disabled || variant == PrimaryButtonVariant.outline
              ? null
              : const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _textColor(),
            ),
          ),
        ),
      ),
    );
  }
}
