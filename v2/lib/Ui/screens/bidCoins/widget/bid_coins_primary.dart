import 'package:eClassify/Utils/Extensions/extensions.dart';
import 'package:eClassify/app/routes.dart';
import 'package:eClassify/data/cubits/bidCoins/fetch_bid_coins_cubit.dart';
import 'package:eClassify/data/model/bid_coins_history_model.dart';
import 'package:flutter/material.dart';

class BidCoinsPrimary extends StatelessWidget {
  final FetchBidCoinsSuccess state;
  const BidCoinsPrimary({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    BidcoinsHistoryModel data = state.bidCoinsHistoryModel;
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
                          Text(data.currbalance.toString()).size(context.font.xxLarge).color(secondaryColor_).bold(weight: FontWeight.w700),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            Routes.addBidCoins,
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: territoryColor_.darken(26),
                          ),
                          child: Text('+ Add Coins').color(secondaryColor_),
                        ),
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
              itemCount: state.bidCoinsHistoryModel.balances?.length,
              itemBuilder: (context, index) {
                var dataList = data.balances?[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 12, left: 12, right: 12),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: secondaryColor_, boxShadow: [
                    BoxShadow(
                      color: Color(0x000000).withOpacity(0.62),
                      offset: Offset(1, 0),
                      blurRadius: 10,
                      spreadRadius: -6,
                    )
                  ]),
                  child: Row(
                    children: [
                      // Image.network(
                      //   'https://dynamic.zacdn.com/e0QXmHvLf2slatY8pdjKdlEAqBE=/filters:quality(70):format(webp)/https://static-id.zacdn.com/p/yonex-0053-9484344-1.jpg',
                      //   height: 50,
                      //   fit: BoxFit.cover,
                      // ),
                      // SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(dataList?.notes ?? '').size(context.font.small).color(territoryColor_).setMaxLines(lines: 3),
                          SizedBox(height: 12),
                          Text(dataList?.createdAt ?? '').size(context.font.small).color(lightTextColor),
                        ],
                      ),
                      Expanded(child: Container()),
                      Center(child: Text("${(dataList?.debit != 0 ? '+${dataList?.debit}' : '-${dataList?.credit}')}").size(context.font.larger).color(territoryColor_).setMaxLines(lines: 3)),
                    ],
                  ),
                );
              },
            )),
          ],
        ),
      ],
    );
  }
}
