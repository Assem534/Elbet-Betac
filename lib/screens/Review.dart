import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/estate_request.dart';
import '../providers/estate_provider.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  String selectedFilter = "All";

  @override
  Widget build(BuildContext context) {
    final estate = ModalRoute.of(context)!.settings.arguments as Estate;

    final estateProvider = context.watch<EstateProvider>();
    final allReviews = estateProvider.getReviewsForProperty(estate.id.toString());

    final filteredReviews = selectedFilter == "All"
        ? allReviews
        : allReviews.where((r) => r.rating.toInt().toString() == selectedFilter).toList();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Reviews", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildPropertyHeader(estate),


          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ["All", "5", "4", "3", "2", "1"]
                    .map((star) => filterButton(star))
                    .toList(),
              ),
            ),
          ),

          Expanded(
            child: filteredReviews.isEmpty
                ? const Center(child: Text("No reviews found for this rating"))
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredReviews.length,
              itemBuilder: (context, index) {
                final review = filteredReviews[index];
                return _buildReviewCard(review);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyHeader(Estate estate) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(estate.image, width: 80, height: 80, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(estate.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.orange, size: 16),
                    Text(" ${estate.rate} (${estate.type})"),
                  ],
                ),
                Text(estate.location, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildReviewCard(dynamic review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: (review.reviewerImage != null && review.reviewerImage.isNotEmpty)
                    ? AssetImage(review.reviewerImage)
                    : const AssetImage('assets/images/images.png'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.reviewerName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(review.date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
              Row(
                children: List.generate(5, (i) => Icon(
                    Icons.star,
                    size: 14,
                    color: i < review.rating ? Colors.orange : Colors.grey[300]
                )),
              )
            ],
          ),
          const SizedBox(height: 10),
          Text(review.comment, style: const TextStyle(color: Colors.black87)),
        ],
      ),
    );
  }

  Widget filterButton(String text) {
    bool isSelected = selectedFilter == text;
    return GestureDetector(
      onTap: () => setState(() => selectedFilter = text),
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF252B5C) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? Colors.transparent : Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Icon(Icons.star, color: isSelected ? Colors.white : Colors.orange, size: 16),
            const SizedBox(width: 5),
            Text(text, style: TextStyle(color: isSelected ? Colors.white : Colors.black)),
          ],
        ),
      ),
    );
  }
}