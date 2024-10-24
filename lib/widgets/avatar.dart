import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final String imageUrl;
  final double radius;

  Avatar({required this.imageUrl, required this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(imageUrl),
      ),
    );
  }
}
