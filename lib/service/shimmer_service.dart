import 'package:flutter/material.dart';
import 'package:product_app/core/extension/theme_extension.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerService {
  ShimmerService._();

  static Widget box({
    double? width,
    double? height,
    BorderRadius? borderRadius,
    EdgeInsetsGeometry? margin,
  }) {
    return Shimmer.fromColors(
      baseColor: AppColors.grey300,
      highlightColor: AppColors.grey100,
      child: Container(
        width: width,
        height: height,
        margin: margin,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius ?? BorderRadius.circular(12),
        ),
      ),
    );
  }

  static Widget banner({required double height}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: box(height: height, width: double.infinity),
    );
  }

  static Widget sliverGrid({
    int itemCount = 6,
    int crossAxisCount = 2,
    double crossAxisSpacing = 12,
    double mainAxisSpacing = 12,
    double childAspectRatio = 1,
  }) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
        childAspectRatio: childAspectRatio,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) => box(),
        childCount: itemCount,
      ),
    );
  }
}
