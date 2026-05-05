import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_real_estate/Widget/Navidation_bar.dart';
import '../Widget/responsive_function.dart';
import '../providers/estate_provider.dart';
import '../Widget/estate_card_2D.dart';
import '../providers/favourite_provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // نستخدم listen: true (الافتراضي مع watch) لتحديث الصفحة عند تغير نتائج البحث
    final estateProvider = context.watch<EstateProvider>();
    final resultsList = estateProvider.estates;

    return Scaffold(
      bottomNavigationBar: Bottom_Navigation_Bar(context, 1),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF252B5C)),
        ),
        title: const Text(
          "Search Results",
          style: TextStyle(color: Color(0xFF252B5C), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column( // قمنا بإزالة SingleChildScrollView واستبداله بـ Expanded للـ Grid لتحسين الأداء
        children: [
          // 🔍 حقل البحث
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F4F8),
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  // تحديث البحث في الـ Provider
                  estateProvider.searchEstates(value);
                },
                decoration: InputDecoration(
                  hintText: "Search modern house...",
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF252B5C)),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      estateProvider.searchEstates('');
                    },
                  )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ),

          // 📊 إحصائيات البحث
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Found ${resultsList.length} estates",
                  style: const TextStyle(
                    color: Color(0xFF252B5C),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // أيقونة لفلترة النتائج مستقبلاً
                const Icon(Icons.tune, color: Color(0xFF252B5C)),
              ],
            ),
          ),

          const SizedBox(height: 15),

          // 🏗️ شبكة عرض النتائج (Grid)
          Expanded( // التغيير هنا لضمان عمل الـ Grid بشكل سليم مع التمرير
            child: resultsList.isEmpty
                ? _buildEmptyState()
                : GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              itemCount: resultsList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: r(15, context),
                crossAxisSpacing: r(15, context),
                childAspectRatio: 0.72,
              ),
              itemBuilder: (context, i) {
                // نمرر الـ item فقط كما هو محدد في الـ Constructor الجديد لـ EstateCard2D
                return EstateCard2D(item: resultsList[i]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 10),
          const Text(
            "No results found",
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
          const SizedBox(height: 5),
          const Text(
            "Try searching for something else",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}