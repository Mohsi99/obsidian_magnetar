import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/data/model/category_model.dart';
import '../../../providers/category_provider.dart';

class SelectCategoryScreen extends StatefulWidget {
  final String? selectedCategoryId;

  const SelectCategoryScreen({
    super.key,
    this.selectedCategoryId,
  });

  @override
  State<SelectCategoryScreen> createState() => _SelectCategoryScreenState();
}

class _SelectCategoryScreenState extends State<SelectCategoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _selectedCategoryId = widget.selectedCategoryId;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? const Color(0xFF0F172A) : AppColors.gray50; // Slate-900 like
    final textColor = isDark ? Colors.white : AppColors.gray900;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          "Categories",
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: BackButton(color: textColor),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary500,
          unselectedLabelColor: isDark ? Colors.grey : AppColors.gray500,
          indicatorColor: AppColors.primary500,
          labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: "Expense"),
            Tab(text: "Income"),
          ],
        ),
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

          return TabBarView(
            controller: _tabController,
            children: [
              _buildCategoryList(provider.expenseCategories, isDark),
              _buildCategoryList(provider.incomeCategories, isDark),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCategoryList(List<CategoryModel> categories, bool isDark) {
    if (categories.isEmpty) {
      return Center(
        child: Text(
          "No categories in this section",
          style: GoogleFonts.inter(
            color: isDark ? Colors.white70 : AppColors.gray500,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final isSelected = category.id == _selectedCategoryId;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              // Slate-800
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
              trailing: Transform.scale(
                scale: 0.9,
                child: Checkbox(
                  value: isSelected,
                  activeColor: AppColors.primary500,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  onChanged: (bool? value) {
                    if (value == true) {
                      setState(() {
                        _selectedCategoryId = category.id;
                      });
                      Navigator.pop(context, category);
                    }
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
