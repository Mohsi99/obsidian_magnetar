import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';

class SelectCategoryScreen extends StatefulWidget {
  const SelectCategoryScreen({super.key});

  @override
  State<SelectCategoryScreen> createState() => _SelectCategoryScreenState();
}

class _SelectCategoryScreenState extends State<SelectCategoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<CategoryItem> _expenseCategories = [
    CategoryItem(
        title: 'Food & Dining',
        icon: Icons.restaurant,
        color: Colors.orange,
        isSelected: true),
    CategoryItem(
        title: 'Transportation',
        icon: Icons.directions_car,
        color: Colors.blue,
        isSelected: false),
    CategoryItem(
        title: 'Utilities',
        icon: Icons.lightbulb,
        color: Colors.yellow,
        isSelected: true),
    CategoryItem(
        title: 'Shopping',
        icon: Icons.shopping_bag,
        color: Colors.pink,
        isSelected: false),
    CategoryItem(
        title: 'Health',
        icon: Icons.medical_services,
        color: Colors.red,
        isSelected: true),
    CategoryItem(
        title: 'Education',
        icon: Icons.school,
        color: Colors.indigo,
        isSelected: false),
  ];

  final List<CategoryItem> _incomeCategories = [
    CategoryItem(
        title: 'Salary',
        icon: Icons.work,
        color: Colors.green,
        isSelected: true),
    CategoryItem(
        title: 'freelance',
        icon: Icons.computer,
        color: Colors.purple,
        isSelected: false),
    CategoryItem(
        title: 'Investments',
        icon: Icons.trending_up,
        color: Colors.teal,
        isSelected: true),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF0F172A) : AppColors.gray50;
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
        leading: BackButton(
          color: textColor,
        ),
        bottom: TabBar(
          dividerColor: Colors.transparent,
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
      body: TabBarView(

          controller: _tabController, children: [
        _buildCategoryList(_expenseCategories, isDark),
        _buildCategoryList(_incomeCategories, isDark)
      ]),
    );
  }

  Widget _buildCategoryList(List<CategoryItem> categories, bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: Container(
            decoration: BoxDecoration(
                color: isDark ? Color(0xff1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.5),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ]),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: category.color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  category.icon,
                  color: category.color,
                  size: 24,
                ),
              ),
              title: Text(
                category.title,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : AppColors.gray900,
                ),
              ),
              trailing: Transform.scale(
                scale: 0.9,
                child: Checkbox(
                  value: category.isSelected,
                  activeColor: AppColors.primary500,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  onChanged: (bool? value) {
                    setState(() {
                      category.isSelected = value ?? false;
                    });
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

class CategoryItem {
  final String title;
  final IconData icon;
  final Color color;
  bool isSelected;

  CategoryItem({
    required this.title,
    required this.icon,
    required this.color,
    required this.isSelected,
  });
}
