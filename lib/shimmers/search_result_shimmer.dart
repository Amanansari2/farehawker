import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerSearchResultFlightCard extends StatelessWidget {
  const ShimmerSearchResultFlightCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _shimmerCircle(size: 40),
                  const SizedBox(width: 12),
                  Expanded(child: _shimmerBox(height: 14)),
                  const SizedBox(width: 12),
                  _shimmerBox(height: 18, width: 60),
                ],
              ),
              const SizedBox(height: 16),
              Divider(color: Colors.grey.shade500, thickness: 1, height: 1),
              const SizedBox(height: 16),
              Row(
                children: [
                  _shimmerBox(height: 12, width: 80),
                  const SizedBox(width: 10),
                  Expanded(child: _shimmerBox(height: 12)),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _cityTimeColumn(),
                  _cityTimeColumn(),
                  _cityTimeColumn(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _shimmerBox({double? width, required double height, double borderRadius = 6}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }

  Widget _shimmerCircle({double size = 40}) {
    return Container(
      width: size,
      height: size,
      decoration:  BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.shade400,
      ),
    );
  }

  Widget _cityTimeColumn() {
    return Column(
      children: [
        _shimmerBox(width: 60, height: 12),
        const SizedBox(height: 6),
        _shimmerBox(width: 50, height: 12),
      ],
    );
  }
}