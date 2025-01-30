import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OptionButton extends StatelessWidget {
  final String text;
  final bool isCorrect;
  final bool isSelected;
  final VoidCallback onTap;

  const OptionButton({
    super.key,
    required this.text,
    required this.isCorrect,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color backgroundColor = theme.cardColor;
    Color textColor = theme.textTheme.bodyLarge!.color!;

    if (isSelected) {
      backgroundColor = isCorrect ? Colors.green : Colors.red;
      textColor = Colors.white;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: isSelected ? null : onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              if (!isSelected)
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 18,
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (isSelected)
                Icon(
                  isCorrect ? Icons.check_circle : Icons.cancel,
                  color: Colors.white,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
