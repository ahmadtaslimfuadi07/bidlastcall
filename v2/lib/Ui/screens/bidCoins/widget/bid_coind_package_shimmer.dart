import 'package:eClassify/Ui/screens/Widgets/shimmerLoadingContainer.dart';
import 'package:eClassify/Utils/sliver_grid_delegate_with_fixed_cross_axis_count_and_fixed_height.dart';
import 'package:flutter/material.dart';

class BidCoindPackageShimmer extends StatelessWidget {
  const BidCoindPackageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: 100,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    height: 170,
                  ),
                  itemBuilder: (context, index) {
                    return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x000000).withOpacity(0.31),
                              offset: Offset(5, 12),
                              blurRadius: 13,
                              spreadRadius: -10,
                            )
                          ],
                        ),
                        child: CustomShimmer());
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
