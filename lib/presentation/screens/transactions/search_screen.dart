import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:obsidian_magnetar/core/constants/app_colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: TextField(
          controller: SearchController(),
          autofocus: true,
          decoration: InputDecoration(
            hintText: "Search transactions...",
            hintStyle: GoogleFonts.inter(color: AppColors.gray400),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
          style: GoogleFonts.inter(
            color: AppColors.gray900,
            fontSize: 16,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search, size: 64, color: AppColors.gray200),
            const SizedBox(height: 16),
            Text(
              'Search for transactions',
              style: GoogleFonts.inter(
                color: AppColors.gray400,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
