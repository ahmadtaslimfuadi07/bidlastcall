import 'package:eClassify/Utils/Extensions/extensions.dart';
import 'package:eClassify/Utils/sliver_grid_delegate_with_fixed_cross_axis_count_and_fixed_height.dart';
import 'package:eClassify/data/cubits/bidCoins/fetch_bid_coins_package_cubit.dart';
import 'package:eClassify/utils/AppIcon.dart';
import 'package:eClassify/utils/ui_utils.dart';
import 'package:flutter/material.dart';

class BidCoindPackage extends StatelessWidget {
  final FetchBidCoinsPackageSuccess state;
  const BidCoindPackage({super.key, required this.state});

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
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: state.total,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    height: 170,
                  ),
                  itemBuilder: (context, index) {
                    var data = state.bidCoinsPackageModel[index];
                    return InkWell(
                      onTap: () {
                        UiUtils.infoPriceCoin(context, data: data);
                        // UiUtils.infoPriceCoin(context, data);
                      },
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: context.color.secondaryColor,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x000000).withOpacity(0.31),
                              offset: Offset(5, 12),
                              blurRadius: 13,
                              spreadRadius: -10,
                            )
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(child: UiUtils.getSvg(AppIcons.bidCoin, height: 40)),
                            Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: Row(
                                children: [
                                  UiUtils.getSvg(AppIcons.bidCoin, height: 15),
                                  SizedBox(
                                    width: 6,
                                  ),
                                  Text("${UiUtils().numberFormat(amount: data.bidcoin)}").size(context.font.large).setMaxLines(lines: 2).color(territoryColor_).bold(weight: FontWeight.w700),
                                ],
                              ),
                            ),
                            Text('Pembelian: ${data.normalbidcoin}').setMaxLines(lines: 1).size(context.font.small).color(context.color.textDefaultColor.withOpacity(0.5)),
                            Text('Gratis: ${data.bonusbidcoin}').setMaxLines(lines: 1).size(context.font.small).color(context.color.textDefaultColor.withOpacity(0.5)),
                            SizedBox(
                              height: 12,
                            ),
                            Text('IDR  ${UiUtils().numberFormat(amount: data.price)}')
                                .size(context.font.large)
                                .setMaxLines(lines: 2)
                                .color(context.color.textDefaultColor)
                                .bold(weight: FontWeight.w700),
                          ],
                        ),
                      ),
                    );
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
