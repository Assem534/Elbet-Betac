import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/estate_request.dart';
import '../providers/AuthProvider.dart';
import '../providers/estate_provider.dart';
import '../providers/favourite_provider.dart';
import '../Widget/responsive_function.dart';
import '../screens/propertyDetails.dart';

class EstateCard2D extends StatelessWidget {
  final Estate item;

  const EstateCard2D({
    super.key,
    required this.item,
    // تم إزالة المعاملات الزائدة لأننا نجلبها عبر context لضمان التحديث التلقائي
  });

  @override
  Widget build(BuildContext context) {
    // نراقب حالة المفضلة لهذا العنصر تحديداً
    final isFav = context.select<FavouriteProvider, bool>(
          (fav) => fav.isFavourite(item),
    );

    return InkWell(
      borderRadius: BorderRadius.circular(r(25, context)),
      onTap: () {
        // 🟢 الانتقال لصفحة التفاصيل عند الضغط على الكارد
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PropertyDetails(estate: item),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF5F4F8),
          borderRadius: BorderRadius.circular(r(25, context)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🖼️ IMAGE SECTION
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(r(20, context)),
                      child: Image.asset(item.image, fit: BoxFit.cover),
                    ),
                  ),

                  // ❤️ FAVORITE BUTTON
                  Positioned(
                    top: r(10, context),
                    right: r(10, context),
                    child: GestureDetector(
                      onTap: () {
                        final authProvider = context.read<AuthProvider>();
                        final favProvider = context.read<FavouriteProvider>();
                        final estateProvider = context.read<EstateProvider>();

                        // تبديل حالة المفضلة
                        favProvider.toggleFavourite(
                          item,
                          authProvider.userId,
                          estateProvider,
                        );
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: r(28, context),
                        height: r(28, context),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isFav
                              ? const Color(0xFF8BC34A)
                              : Colors.white.withOpacity(0.7),
                          boxShadow: [
                            if (!isFav)
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                              )
                          ],
                        ),
                        child: Icon(
                          isFav ? Icons.favorite : Icons.favorite_outline,
                          size: r(16, context),
                          color: isFav ? Colors.white : Colors.pink,
                        ),
                      ),
                    ),
                  ),

                  // 💰 PRICE TAG
                  Positioned(
                    bottom: r(10, context),
                    right: r(10, context),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: r(10, context),
                        vertical: r(5, context),
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF252B5C).withOpacity(0.8),
                        borderRadius: BorderRadius.circular(r(10, context)),
                      ),
                      child: Text(
                        "\$${context.read<EstateProvider>().formatPrice(item.price)}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: r(12, context),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 📝 INFO SECTION
            Padding(
              padding: EdgeInsets.all(r(12, context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: r(14, context),
                      color: const Color(0xFF252B5C),
                    ),
                  ),
                  SizedBox(height: r(8, context)),

                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: r(14, context)),
                      SizedBox(width: r(2, context)),
                      Text(
                        "${item.rate}",
                        style: TextStyle(
                          fontSize: r(11, context),
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF252B5C),
                        ),
                      ),
                      SizedBox(width: r(10, context)),
                      Icon(Icons.location_on, size: r(14, context), color: Colors.grey),
                      SizedBox(width: r(2, context)),
                      Expanded(
                        child: Text(
                          item.location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: r(10, context),
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}