import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/estate_request.dart';
import '../providers/estate_provider.dart';
import '../screens/propertyDetails.dart';

Widget estateCards(
    List<Estate> estates,
    double Function(double) r,
    void Function(int index) onFavouriteToggle,
    Axis direction,
    int count,
    ) {
  int itemCount = count > estates.length ? estates.length : count;

  return SizedBox(
    height: r(210),
    child: ListView.builder(
      scrollDirection: direction,
      itemCount: itemCount,
      padding: EdgeInsets.symmetric(horizontal: r(10)),
      itemBuilder: (context, i) {
        final estate = estates[i];

        return Container(
          width: r(310),
          margin: EdgeInsets.only(right: r(15), top: r(10), bottom: r(10)),
          child: InkWell(
            borderRadius: BorderRadius.circular(r(16)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PropertyDetails(estate: estate),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.all(r(10)),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F4F8),
                borderRadius: BorderRadius.circular(r(16)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: r(130),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(r(15)),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(estate.image, fit: BoxFit.cover),

                          Positioned(
                            top: r(8),
                            left: r(8),
                            child: GestureDetector(
                              onTap: () => onFavouriteToggle(i),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                width: r(30),
                                height: r(30),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: estate.isFav ? Colors.green : Colors.white.withOpacity(0.9),
                                ),
                                child: Icon(
                                  estate.isFav ? Icons.favorite : Icons.favorite_border,
                                  size: r(18),
                                  color: estate.isFav ? Colors.white : Colors.pink,
                                ),
                              ),
                            ),
                          ),

                          Positioned(
                            bottom: r(8),
                            left: r(8),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: r(8), vertical: r(4)),
                              decoration: BoxDecoration(
                                color: const Color(0xFF234F68).withOpacity(0.9),
                                borderRadius: BorderRadius.circular(r(8)),
                              ),
                              child: Text(
                                estate.type,
                                style: TextStyle(color: Colors.white, fontSize: r(10), fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(width: r(12)),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          estate.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: r(14),
                            color: const Color(0xFF252B5C),
                          ),
                        ),
                        SizedBox(height: r(5)),
                        Row(
                          children: [
                            Icon(Icons.star, size: r(14), color: Colors.amber),
                            SizedBox(width: r(4)),
                            Text(
                              "${estate.rate}",
                              style: TextStyle(fontSize: r(12), color: const Color(0xFF252B5C), fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        SizedBox(height: r(5)),
                        Row(
                          children: [
                            Icon(Icons.location_on, size: r(14), color: Colors.grey),
                            Expanded(
                              child: Text(
                                estate.location,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: r(11), color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          "\$${context.read<EstateProvider>().formatPrice(estate.price)}",
                          style: TextStyle(
                            fontSize: r(18),
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFF252B5C),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}