import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_real_estate/Widget/Navidation_bar.dart';
import '../providers/AuthProvider.dart';
import '../providers/estate_provider.dart';
import '../providers/favourite_provider.dart';

class FavouritePage extends StatelessWidget {
  const FavouritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final favProvider = context.watch<FavouriteProvider>();
    final estates = favProvider.favourites;

    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(size.width * 0.04),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${estates.length} estates",
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "My favorite",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () {
                      // جلب الـ Providers
                      final estateProv = Provider.of<EstateProvider>(context, listen: false);
                      final favProv = Provider.of<FavouriteProvider>(context, listen: false);
                      final authProv = Provider.of<AuthProvider>(context, listen: false);

                      if (authProv.isLoggedIn) {
                        favProv.clearAll(estateProv, authProv.userId);
                      }
                    },
                  ),
                ],
              ),

              SizedBox(height: size.height * 0.02),

              Expanded(
                child: estates.isEmpty
                    ? const Center(
                  child: Text(
                    "No favourites yet",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
                    : ListView.builder(
                  itemCount: estates.length,
                  itemBuilder: (context, index) {
                    final item = estates[index];

                    return Dismissible(
                      key: ValueKey(item.name),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      onDismissed: (_) {
                        final auth = context.read<AuthProvider>();
                        final favs = context.read<FavouriteProvider>();
                        final estates = context.read<EstateProvider>();

                        favs.toggleFavourite(item, auth.userId, estates);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F4F8),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 120,
                              height: 120,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.asset(
                                  item.image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF252B5C),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(Icons.star, size: 14, color: Colors.amber),
                                      Text(
                                        "${item.rate}",
                                        style: const TextStyle(color: Color(0xFF252B5C)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on, size: 14, color: Color(0xFF252B5C)),
                                      Expanded(
                                        child: Text(
                                          item.location,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(color: Color(0xFF252B5C)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "\$ ${Provider.of<EstateProvider>(context, listen: false).formatPrice(item.price)}",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF252B5C),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Bottom_Navigation_Bar(context, 2),
    );
  }
}