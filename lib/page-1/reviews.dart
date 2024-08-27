import 'package:flutter/material.dart';

class AllReviewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Reviews'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Example reviews
            ReviewTile(review: 'Review 1: This artist is amazing!'),
            ReviewTile(review: 'Review 2: Great performance.'),
            ReviewTile(review: 'Review 3: Absolutely fantastic experience.'),
            // Add more reviews here
          ],
        ),
      ),
    );
  }
}

class ReviewTile extends StatelessWidget {
  final String review;

  ReviewTile({required this.review});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 8.0),
      title: Text(review),
      // You can customize the review tile further if needed
    );
  }
}