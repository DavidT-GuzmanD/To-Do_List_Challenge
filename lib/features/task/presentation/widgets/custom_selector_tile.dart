
import 'package:flutter/material.dart';
import 'package:todo_list_challenge/core/theme/app_colors.dart';

class CustomSelectorTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback onTap;
  final VoidCallback? onClear;
  final String? errorText;
  final bool isRequired;

  const CustomSelectorTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    required this.onTap,
    this.onClear,
    this.errorText,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.inputBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: errorText != null ? AppColors.error : Colors.transparent,
              width: 1,
            ),
          ),
          child: ListTile(
            leading: Icon(icon, color: Colors.grey[600]),
            title: Text(
              isRequired ? '$title *' : title,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
            ),
            subtitle: subtitle != null
                ? Text(
                    subtitle!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  )
                : null,
            trailing: onClear != null
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (trailing != null) trailing!,
                      IconButton(
                        icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                        onPressed: onClear,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  )
                : trailing,
            onTap: onTap,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          ),
        ),
        if (errorText != null && errorText!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 16),
            child: Text(
              errorText!,
              style: const TextStyle(
                color: AppColors.error,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}