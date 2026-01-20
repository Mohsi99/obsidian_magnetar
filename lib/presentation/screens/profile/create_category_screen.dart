import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart' as uuid_lib;

import '../../../core/constants/app_colors.dart';
import '../../../core/data/model/category_model.dart';
import '../../../providers/category_provider.dart';


class CreateCategoryScreen extends StatefulWidget {
  final CategoryModel? category; // Optional category for editing

  const CreateCategoryScreen({super.key, this.category});

  @override
  State<CreateCategoryScreen> createState() => _CreateCategoryScreenState();
}

class _CreateCategoryScreenState extends State<CreateCategoryScreen> {
  late TextEditingController _nameController;
  bool _isGlobalLoading = false;

  late IconData _selectedIcon;
  late Color _selectedColor;

  // Predefined icons
  final List<IconData> _icons = [
    Icons.shopping_bag_outlined,
    Icons.restaurant_menu,
    Icons.movie_creation_outlined,
    Icons.flight,
    Icons.directions_car,
    Icons.home_outlined,
    Icons.school_outlined,
    Icons.medical_services_outlined,
    Icons.pets,
    Icons.wifi,
    Icons.phone_iphone,
    Icons.laptop,
    Icons.sports_basketball,
    Icons.card_giftcard,
    Icons.savings_outlined,
    Icons.work_outline,
    Icons.local_grocery_store,
    Icons.local_cafe,
    Icons.fitness_center,
    Icons.build,
  ];

  // Predefined colors
  final List<Color> _colors = [
    const Color(0xFFEF4444), // Red
    const Color(0xFFF97316), // Orange
    const Color(0xFFF59E0B), // Amber
    const Color(0xFF10B981), // Emerald
    const Color(0xFF06B6D4), // Cyan
    const Color(0xFF3B82F6), // Blue
    const Color(0xFF6366F1), // Indigo
    const Color(0xFF8B5CF6), // Violet
    const Color(0xFFEC4899), // Pink
    const Color(0xFF6B7280), // Gray
  ];

  @override
  void initState() {
    super.initState();
    // Initialize state based on whether we are editing or creating
    if (widget.category != null) {
      _nameController = TextEditingController(text: widget.category!.name);
      _selectedIcon = IconData(widget.category!.iconCode, fontFamily: 'MaterialIcons');
      _selectedColor = Color(widget.category!.colorValue);
    } else {
      _nameController = TextEditingController();
      _selectedIcon = Icons.shopping_bag_outlined;
      _selectedColor = const Color(0xFF8B5CF6);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveCategory() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a category name')),
      );
      return;
    }

    setState(() => _isGlobalLoading = true);

    try {

      if (widget.category != null) {
        // Update existing category
        final updatedCategory = CategoryModel(
          id: widget.category!.id,
          name: name,
          iconCode: _selectedIcon.codePoint,
          colorValue: _selectedColor.value,
        );
        await Provider.of<CategoryProvider>(context, listen: false).updateCategory(updatedCategory);
      } else {
        // Create new category
        final newCategory = CategoryModel(
          id: const uuid_lib.Uuid().v4(),
          name: name,
          iconCode: _selectedIcon.codePoint,
          colorValue: _selectedColor.value,
        );
        await Provider.of<CategoryProvider>(context, listen: false).addCategory(newCategory);
      }

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving category: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isGlobalLoading = false);
      }
    }
  }

  Future<void> _deleteCategory() async {
    if (widget.category == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category?'),
        content: const Text('Are you sure you want to delete this category? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isGlobalLoading = true);
    try {
      await Provider.of<CategoryProvider>(context, listen: false).deleteCategory(widget.category!.id);
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting category: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isGlobalLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEditing = widget.category != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Category' : 'Create Category',
          style: GoogleFonts.inter(
            color: AppColors.gray900,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.gray900),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNameField(),
                const SizedBox(height: 32),
                _buildIconSelector(),
                const SizedBox(height: 32),
                _buildColorSelector(),
                const SizedBox(height: 32),
                _buildActionButtons(isEditing),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category Name',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.gray500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _nameController,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.gray900,
          ),
          decoration: InputDecoration(
            hintText: 'e.g. Groceries',
            hintStyle: GoogleFonts.inter(color: AppColors.gray400),
            filled: true,
            fillColor: AppColors.gray50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  Widget _buildIconSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Icon',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.gray500,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1,
          ),
          itemCount: _icons.length,
          itemBuilder: (context, index) {
            final icon = _icons[index];
            final isSelected = _selectedIcon.codePoint == icon.codePoint;
            return GestureDetector(
              onTap: () => setState(() => _selectedIcon = icon),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? _selectedColor.withOpacity(0.1) : AppColors.gray50,
                  border: isSelected ? Border.all(color: _selectedColor, width: 2) : null,
                ),
                child: Icon(
                  icon,
                  color: isSelected ? _selectedColor : AppColors.gray400,
                  size: 24,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildColorSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pick Color',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.gray500,
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _colors.map((color) {
              final isSelected = _selectedColor.value == color.value;
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedColor = color),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color,
                      border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
                      boxShadow: isSelected
                          ? [
                        BoxShadow(
                          color: color.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                          : [],
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 24)
                        : null,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(bool isEditing) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isGlobalLoading ? null : _saveCategory,
            style: ElevatedButton.styleFrom(
              backgroundColor: _selectedColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: _isGlobalLoading
                ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
            )
                : Text(
              isEditing ? 'Save Changes' : 'Create Category',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        if (isEditing) ...[
          const SizedBox(height: 16),
          TextButton(
            onPressed: _isGlobalLoading ? null : _deleteCategory,
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: Text(
              'Delete Category',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

