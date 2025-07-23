import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class TestShimmerScreen extends StatelessWidget {
  const TestShimmerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Shimmer Test')),
      body: ListView.builder(
        itemCount: 6,
        padding: const EdgeInsets.all(8.0),
        itemBuilder: (context, index) {
          return const RoundTripFlightShimmer(); // ✅ a single shimmer card
        },
      ),
    );
  }
}

class RoundTripFlightShimmer extends StatelessWidget {
  const RoundTripFlightShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              // top row (airline & fare)

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 18),
                  Container(
                    width: 50,
                    height: 16,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 50,
                    height: 16,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 50,
                    height: 16,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 50,
                    height: 16,
                    color: Colors.white,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(height: 1, color: Colors.white),
              const SizedBox(height: 12),
              // flight number & layover
              Row(
                children: [
                  Container(width: 60, height: 16, color: Colors.white),
                  const SizedBox(width: 10),
                  Expanded(child: Container(height: 14, color: Colors.white)),
                ],
              ),
              const SizedBox(height: 16),
              // bottom row (city/time)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(3, (i) {
                  return Column(
                    children: [
                      Container(width: 40, height: 14, color: Colors.white),
                      const SizedBox(height: 4),
                      Container(width: 30, height: 14, color: Colors.white),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
