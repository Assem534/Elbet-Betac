import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_real_estate/Widget/estate_card_2D.dart';
import '../providers/estate_provider.dart';
import '../Widget/responsive_function.dart';
import '../providers/favourite_provider.dart';

class FeatureList extends StatefulWidget {
  const FeatureList({super.key});

  @override
  State<FeatureList> createState() => _FeatureListState();
}

class _FeatureListState extends State<FeatureList> {
  final TextEditingController ctrl = TextEditingController();

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final estateProvider = context.watch<EstateProvider>();
    final data = estateProvider.estates;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: r(20, context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 TOP NAV
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios, size: 18)),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.tune, size: 24)),
                  ],
                ),

                // 🔹 GALLERY (Clickable Images)
                GestureDetector(
                  onTap: () => print("Open Full Gallery"),
                  child: SizedBox(
                    height: r(250, context),
                    child: Row(
                      children: [
                        Expanded(flex: 2, child: _buildGalleryImage("assets/images/real_estate.png")),
                        SizedBox(width: r(10, context)),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Expanded(child: _buildGalleryImage("assets/images/loginOptionalPage/Rectangle_9.png")),
                              SizedBox(height: r(10, context)),
                              Expanded(child: _buildGalleryImage("assets/images/loginOptionalPage/Rectangle_10.png")),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: r(25, context)),
                Text("Featured Estates", style: TextStyle(fontSize: r(24, context), fontWeight: FontWeight.bold, color: const Color(0xFF252B5C))),
                Text("Our recommended real estates exclusive for you.", style: TextStyle(fontSize: r(12, context), color: Colors.grey)),

                SizedBox(height: r(20, context)),

                // 🔹 SEARCH BAR (Functional)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: r(15, context)),
                  decoration: BoxDecoration(color: const Color(0xFFF5F4F8), borderRadius: BorderRadius.circular(r(20, context))),
                  child: TextField(
                    controller: ctrl,
                    onChanged: (val) => estateProvider.searchEstates(val),
                    decoration: InputDecoration(
                      hintText: "Search in featured estate",
                      border: InputBorder.none,
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: ctrl.text.isNotEmpty
                          ? IconButton(icon: Icon(Icons.clear), onPressed: () { ctrl.clear(); estateProvider.searchEstates(''); })
                          : null,
                    ),
                  ),
                ),

                SizedBox(height: r(25, context)),

                // 🔹 GRID
                data.isEmpty
                    ? Center(child: Text("No estates found"))
                    : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 25,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: r(15, context),
                    crossAxisSpacing: r(15, context),
                    childAspectRatio: 0.72,
                  ),
                  itemBuilder: (context, i) => EstateCard2D(item: data[i]),
                ),
                SizedBox(height: r(20, context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGalleryImage(String path) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(r(20, context)),
      child: Image.asset(path, fit: BoxFit.cover, width: double.infinity),
    );
  }


}
