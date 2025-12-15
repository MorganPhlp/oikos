import 'package:flutter/material.dart';
import 'package:oikos/core/theme/app_colors.dart';

class OikosSelectionButton extends StatelessWidget {
  final String label;
  final String? sublabel;
  final bool isSelected;
  final VoidCallback onTap;

  const OikosSelectionButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.sublabel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(50),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            color: isSelected 
                ? AppColors.gradientGreenEnd.withOpacity(0.1) 
                : Colors.transparent,
            border: Border.all(
              color: isSelected 
                  ? AppColors.gradientGreenEnd 
                  : AppColors.lightInputBorder,
              width: isSelected ? 2.0 : 1.0,
            ),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        color: AppColors.lightTextPrimary,
                        fontSize: 16,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                    if (sublabel != null)
                      Text(
                        sublabel!, 
                        style: TextStyle(
                          color: AppColors.lightTextPrimary.withOpacity(0.6),
                          fontSize: 14
                        )
                      ),
                  ],
                ),
              ),
              if (isSelected)
                const Padding(
                  padding: EdgeInsets.only(left: 12.0),
                  child: Icon(Icons.check_circle, color: AppColors.gradientGreenEnd, size: 24),
                ),
            ],
          ),
        ),
      ),
    );
  }
}