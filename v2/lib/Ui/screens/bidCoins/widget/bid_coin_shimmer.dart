import 'package:eClassify/Ui/screens/Widgets/shimmerLoadingContainer.dart';
import 'package:eClassify/Utils/Extensions/extensions.dart';
import 'package:flutter/material.dart';

class BidCoinShimmer extends StatelessWidget {
  const BidCoinShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width * 0.43,
          decoration: const BoxDecoration(
            color: territoryColor_,
          ),
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Total Coins').size(context.font.small).color(secondaryColor_),
                          CustomShimmer(
                            height: 30,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Divider(color: secondaryColor_.withOpacity(0.5)),
                  SizedBox(height: 12),
                  Text('Your Coins History').size(context.font.normal).color(secondaryColor_).bold(weight: FontWeight.w700),
                  SizedBox(height: 12),
                ],
              ),
            ),
            Expanded(
                child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return Container(
                    margin: EdgeInsets.only(bottom: 12, left: 12, right: 12),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: secondaryColor_, boxShadow: [
                      BoxShadow(
                        color: Color(0x000000).withOpacity(0.62),
                        offset: Offset(1, 0),
                        blurRadius: 10,
                        spreadRadius: -6,
                      )
                    ]),
                    child: CustomShimmer(
                      height: 50,
                    ));
              },
            )),
          ],
        ),
      ],
    );
  }
}
