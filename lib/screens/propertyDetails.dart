import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/estate_request.dart';
import '../providers/favourite_provider.dart';
import '../providers/AuthProvider.dart';
import '../providers/estate_provider.dart';

class PropertyDetails extends StatelessWidget {
  final Estate estate; // استقبال بيانات العقار

  const PropertyDetails({super.key, required this.estate});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    double s = (w / 375).clamp(0.85, 1.2);
    double r(double v) => v * s;

    final favProvider = context.watch<FavouriteProvider>();
    final estateProvider = context.watch<EstateProvider>();
    final authProvider = context.read<AuthProvider>();
    final isFav = favProvider.isFavourite(estate);
    final reviews = estateProvider.getReviewsForProperty(estate.id.toString());
    final displayedReviews = reviews.take(5).toList();

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // ─── Header Image Section ───
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(r(30)),
                ),
                child: Image.asset(
                  estate.image,
                  height: r(360),
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: r(45),
                left: r(20),
                right: r(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    iconBtn(
                      Icons.arrow_back_ios_new,
                      onTap: () => Navigator.pop(context),
                    ),
                    Row(
                      children: [
                        iconBtn(
                          Icons.ios_share,
                          onTap: () {
                            // منطق المشاركة هنا
                          },
                        ),
                        SizedBox(width: r(10)),
                        GestureDetector(
                          onTap: () => favProvider.toggleFavourite(
                            estate,
                            authProvider.userId,
                            context.read<EstateProvider>(),
                          ),
                          child: CircleAvatar(
                            radius: r(18),
                            backgroundColor: isFav ? Colors.red : Colors.white,
                            child: Icon(
                              Icons.favorite,
                              size: r(16),
                              color: isFav ? Colors.white : Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: r(25),
                left: r(20),
                child: Row(
                  children: [
                    tag(Icons.star, estate.rate.toString(), Colors.amber),
                    SizedBox(width: r(10)),
                    tag(null, estate.type, null),
                  ],
                ),
              ),
            ],
          ),

          Padding(
            padding: EdgeInsets.all(r(15)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─── Title & Price ───
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      estate.name,
                      style: TextStyle(
                        fontSize: r(20),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "\$${estate.price}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: r(18),
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: r(6)),
                Row(
                  children: [
                    Icon(Icons.location_on, size: r(14), color: Colors.grey),
                    Text(estate.location, style: TextStyle(color: Colors.grey)),
                  ],
                ),

                SizedBox(height: r(15)),
                const Divider(),

                // ─── Agent Card (Clickable) ───
                card(
                  r: r,
                  onTap: () {
                    // الانتقال لبروفايل الوكيل
                    if (estate.ownerId != null) {
                      Navigator.pushNamed(
                        context,
                        '/Profile',
                        arguments: estate.ownerId,
                      );
                    }
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage('assets/images/images.png'),
                    ),
                    title: Text(estate.ownerName ?? "Anderson"),
                    subtitle: Text("Real Estate Agent"),
                    trailing: iconBtn(
                      Icons.wechat_outlined,
                      color: Colors.green.shade100,
                      iconColor: Colors.green,
                    ),
                  ),
                ),

                SizedBox(height: r(15)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    info(Icons.bed, "${estate.rooms ?? 0} Bedroom"),
                    info(Icons.bathtub, "${estate.baths ?? 0} Bathroom"),
                  ],
                ),

                SizedBox(height: r(15)),
                title("Location & Public Facilities"),

                // ─── Location Card ───
                card(
                  r: r,
                  child: Column(
                    children: [
                      const ListTile(
                        leading: Icon(Icons.location_on, color: Colors.red),
                        title: Text("St. Cikokon Timur"),
                        subtitle: Text("Indonesia 12770"),
                      ),
                      InkWell(
                        onTap: () => print("Open Directions"),
                        child: Container(
                          margin: EdgeInsets.all(r(8)),
                          padding: EdgeInsets.all(r(10)),
                          decoration: BoxDecoration(
                            color: const Color(0xffECEDF3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.directions_walk),
                              Text("2.5km from your location"),
                              Icon(Icons.keyboard_arrow_down),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: r(15)),

                // ─── Map Preview (Clickable) ───
                GestureDetector(
                  onTap: () => print("Opening Full Map"),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        Image.asset(
                          'assets/images/2967129.jpg',
                          height: r(180),
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            width: w,
                            padding: EdgeInsets.all(r(10)),
                            color: Colors.white.withOpacity(0.9),
                            child: const Center(
                              child: Text(
                                "View all on map",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: r(15)),
                // ─── Reviews Header ───
                Row(
                  children: [
                    Text(
                      "Reviews",
                      style: TextStyle(
                        fontSize: r(18),
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF252B5C),
                      ),
                    ),
                    const Spacer(),
                    if (reviews.length >1)
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            "/Review",
                            arguments: estate, // Pass the estate object
                          );
                        },
                        child: const Text("view all"),
                      ),
                  ],
                ),

                // ─── Reviews List (First 5) ───
                if (reviews.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      "No reviews yet",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                else
                  Column(
                    spacing: 20,
                    children: displayedReviews
                        .map((rev) => _buildReviewItem(rev, r))
                        .toList(),
                  ),

                SizedBox(height: r(30)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildReviewItem(dynamic review, double Function(double) r) {
  return card(
    r: r,
    child: Padding(
      padding: EdgeInsets.all(r(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: r(15),
                backgroundImage:
                    (review.reviewerImage != null &&
                        review.reviewerImage.isNotEmpty)
                    ? AssetImage(review.reviewerImage)
                    : const AssetImage('assets/images/images.png'),
              ),
              SizedBox(width: r(10)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.reviewerName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: r(13),
                      ),
                    ),
                    Text(
                      review.date,
                      style: TextStyle(color: Colors.grey, fontSize: r(11)),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 14),
                  Text(
                    " ${review.rating}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: r(8), left: r(2)),
            child: Text(
              review.comment,
              style: TextStyle(fontSize: r(12), color: Colors.black87),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget iconBtn(
  IconData icon, {
  VoidCallback? onTap,
  Color? color,
  Color? iconColor,
}) {
  return GestureDetector(
    onTap: onTap,
    child: CircleAvatar(
      backgroundColor: color ?? Colors.white,
      child: Icon(icon, size: 16, color: iconColor ?? Colors.black),
    ),
  );
}

Widget card({
  required Widget child,
  required double Function(double) r,
  VoidCallback? onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.all(r(5)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    ),
  );
}

Widget tag(IconData? i, String t, Color? c) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(0.7),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      children: [
        if (i != null) Icon(i, color: c, size: 14),
        if (i != null) const SizedBox(width: 5),
        Text(t, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    ),
  );
}

Widget info(IconData i, String t) {
  return Row(
    children: [
      Icon(i, size: 20, color: Colors.green),
      const SizedBox(width: 8),
      Text(t),
    ],
  );
}

Widget title(String t) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Text(
      t,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    ),
  );
}
