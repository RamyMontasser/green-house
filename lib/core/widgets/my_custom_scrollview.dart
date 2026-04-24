import 'package:flutter/material.dart';
import 'package:green_house/core/widgets/custom_sliver_appbar.dart';

class CustomScrollViewWithAppBar extends StatelessWidget {
  const CustomScrollViewWithAppBar({
    super.key,
    required this.child,
    this.controller, required this.title,
  });

  final Widget child;
  final String title;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
        controller: controller,
        slivers: [

          CustomSliverAppbar(title: title,pinned: true,),

          SliverToBoxAdapter(child: child),
          
        ],
    );
  }
}
