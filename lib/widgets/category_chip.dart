import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/category.dart';

/// 🏷️ CategoryChip
/// Toggleable chip for category filtering
class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  final Category category;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? TmColors.primary : TmColors.white,
          borderRadius: BorderRadius.circular(TmRadius.full),
          border: Border.all(
            color: isSelected ? TmColors.primary : TmColors.grey300,
            width: 1.5,
          ),
          boxShadow: isSelected ? [TmShadows.card] : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Icon(
              _getIconData(category.iconName),
              color: isSelected ? TmColors.white : TmColors.grey700,
              size: 18,
            ),

            const SizedBox(width: 8),

            // Label
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TmTheme.light.textTheme.labelLarge!.copyWith(
                color: isSelected ? TmColors.white : TmColors.grey700,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
              child: Text(category.name),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'beach':
        return Icons.beach_access;
      case 'mountain':
        return Icons.terrain;
      case 'ruins':
        return Icons.account_balance;
      case 'cenote':
        return Icons.pool;
      case 'food':
        return Icons.restaurant;
      case 'city':
        return Icons.location_city;
      default:
        return Icons.place;
    }
  }
}

/// 📋 CategoryChipList
/// Horizontal scrollable list of category chips
class CategoryChipList extends StatefulWidget {
  const CategoryChipList({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  final List<Category> categories;
  final int? selectedCategoryId;
  final ValueChanged<int?> onCategorySelected;

  @override
  State<CategoryChipList> createState() => _CategoryChipListState();
}

class _CategoryChipListState extends State<CategoryChipList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: widget.categories.length + 1, // +1 for "All" chip
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          if (index == 0) {
            // "All" chip
            return CategoryChip(
              category: const Category(
                id: -1,
                name: 'Todos',
                iconName: 'all',
              ),
              isSelected: widget.selectedCategoryId == null || widget.selectedCategoryId == -1,
              onTap: () => widget.onCategorySelected(-1),
            );
          }

          final category = widget.categories[index - 1];
          return CategoryChip(
            category: category,
            isSelected: widget.selectedCategoryId == category.id,
            onTap: () => widget.onCategorySelected(category.id),
          );
        },
      ),
    );
  }
}