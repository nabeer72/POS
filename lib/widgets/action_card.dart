import 'package:flutter/material.dart';

class QuickActionCard extends StatelessWidget {
  final String title;
  final num? price;
  final IconData icon;
  final Color color;
  final double cardSize;
  final Function()? onTap;
  final bool showFavorite; // ❤️ sirf FavoritesScreen me show hoga
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;

  const QuickActionCard({
    super.key,
    required this.title,
    this.price,
    required this.icon,
    required this.color,
    required this.cardSize,
    this.onTap,
    this.showFavorite = false,
    this.isFavorite = false,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFFB3E5FC).withOpacity(0.4),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: InkWell(
          onTap: showFavorite ? onFavoriteToggle : onTap, // ✅ FavoritesScreen → toggle
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icon,
                      size: cardSize * 0.35,
                      color: color,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ) ??
                          const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (price != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        '\$${price!.toDouble().toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: cardSize * 0.1,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              if (showFavorite) // ✅ Sirf FavoritesScreen me show hoga
                Positioned(
                  top: 8,
                  right: 8,
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey,
                    size: cardSize * 0.19,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
