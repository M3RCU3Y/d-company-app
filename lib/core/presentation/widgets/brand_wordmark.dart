import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';

class BrandWordmark extends StatelessWidget {
  const BrandWordmark({
    super.key,
    this.showTagline = true,
  });

  final bool showTagline;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'D Table',
          style: theme.textTheme.displaySmall?.copyWith(
            color: AppColors.brand,
            fontSize: 34,
          ),
        ),
        if (showTagline) ...[
          const SizedBox(height: 8),
          Text(
            'Restaurant reservations built for Trinidad and Tobago.',
            style: theme.textTheme.bodyLarge,
          ),
        ],
      ],
    );
  }
}
