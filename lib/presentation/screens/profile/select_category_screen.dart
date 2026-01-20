import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';

import '../../../providers/category_provider.dart';
import 'create_category_screen.dart';

class SelectCategoryScreen extends StatefulWidget {
  final String? selectedCategoryId;

  const SelectCategoryScreen({
    super.key,
    this.selectedCategoryId,
  });

  @override
  State<SelectCategoryScreen> createState() => _SelectCategoryScreenState();
}

class _SelectCategoryScreenState extends State<SelectCategoryScreen> {
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = widget.selectedCategoryId;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF0F172A) : AppColors.gray50; // Slate-900 like
    final textColor = isDark ? Colors.white : AppColors.gray900;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          "Select Category",
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: BackButton(color: textColor),
        centerTitle: true,
      ),
      body: Consumer<CategoryProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.categories.isEmpty) {
            return Center(
              child: Text(
                "No categories found",
                style: GoogleFonts.inter(color: textColor),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.categories.length,
            itemBuilder: (context, index) {
              final category = provider.categories[index];
              final isSelected = category.id == _selectedCategoryId;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white, // Slate-800
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: isSelected
                        ? Border.all(color: AppColors.primary500, width: 2)
                        : null,
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    onTap: () {
                      setState(() {
                        _selectedCategoryId = category.id;
                      });
                      Navigator.pop(context, category);
                    },
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color(category.colorValue).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        IconData(category.iconCode, fontFamily: 'MaterialIcons'),
                        color: Color(category.colorValue),
                        size: 24,
                      ),
                    ),
                    title: Text(
                      category.name,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : AppColors.gray900,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit_outlined, color: AppColors.gray500),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateCategoryScreen(category: category),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateCategoryScreen()),
          );
        },
        backgroundColor: AppColors.primary500,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
