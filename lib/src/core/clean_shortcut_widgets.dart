import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'clean_shortcut_interfaces.dart';

/// Clean shortcut button ที่ไม่ผูกติดกับ specific navigation
class CleanShortcutButton extends StatelessWidget {
  final NavigationAction action;
  final String title;
  final IconData icon;
  final ShortcutStyle style;

  const CleanShortcutButton({
    super.key,
    required this.action,
    required this.title,
    required this.icon,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: style.width ?? double.infinity,
      height: style.height,
      child: ElevatedButton.icon(
        onPressed: () => action.execute(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: style.backgroundColor ?? Theme.of(context).primaryColor,
          foregroundColor: style.textColor ?? Colors.white,
          padding: style.padding ?? const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: style.borderRadius ?? BorderRadius.circular(8)),
        ),
        icon: Icon(icon),
        label: Text(title),
      ),
    );
  }
}

/// Clean shortcut card
class CleanShortcutCard extends StatelessWidget {
  final NavigationAction action;
  final String title;
  final String? subtitle;
  final IconData icon;

  const CleanShortcutCard({super.key, required this.action, required this.title, this.subtitle, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () => action.execute(context),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48, color: Theme.of(context).primaryColor),
              const SizedBox(height: 8),
              Text(title, style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(subtitle!, style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
