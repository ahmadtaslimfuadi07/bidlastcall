import 'package:eClassify/data/cubits/Utility/fetch_history_bid_cubit.dart';
import 'package:eClassify/data/model/item/item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../data/cubits/Utility/fetch_transactions_cubit.dart';
import '../../../data/model/transaction_model.dart';
import '../../../exports/main_export.dart';
import '../../../utils/Extensions/extensions.dart';
import '../../../utils/ui_utils.dart';
import '../Widgets/intertitial_ads_screen.dart';
import '../widgets/AnimatedRoutes/blur_page_route.dart';
import '../widgets/Errors/no_data_found.dart';
import '../widgets/Errors/something_went_wrong.dart';

class TransactionHistoryBidScreen extends StatefulWidget {
  const TransactionHistoryBidScreen({super.key});

  static Route route(RouteSettings settings) {
    return BlurredRouter(
      builder: (context) {
        return BlocProvider(
          create: (context) {
            return FetchTransactionsCubit();
          },
          child: const TransactionHistoryBidScreen(),
        );
      },
    );
  }

  @override
  State<TransactionHistoryBidScreen> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistoryBidScreen> {
  late final ScrollController _pageScrollController = ScrollController();
  final PageController _pageController = PageController();
  /* ..addListener(_pageScrollListener);*/

  List<Map> sections = [];
  int offset = 0, total = 0;
  int selectTab = 0;

  @override
  void initState() {
    AdHelper.loadInterstitialAd();
    context.read<FetchHistoryBidCubit>().fetchHistoryBid();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    sections = [
      {
        "title": "All Trans".translate(context),
        "status": "",
      },
      {
        "title": "On going",
        "status": "ongoing",
      },
      {
        "title": "Close",
        "status": "close",
      },
    ];

    return AnnotatedRegion(
      value: UiUtils.getSystemUiOverlayStyle(context: context, statusBarColor: context.color.secondaryColor),
      child: Scaffold(
        backgroundColor: context.color.primaryColor,
        appBar: UiUtils.buildAppBar(
          context,
          title: "Bid Transaction",
          // bottomHeight: 49,
          // bottomHeight: 49,
          // bottom: [
          //   SizedBox(
          //     width: context.screenWidth,
          //     height: 45,
          //     child: ListView.separated(
          //       shrinkWrap: true,
          //       padding: const EdgeInsetsDirectional.fromSTEB(18, 5, 18, 2),
          //       scrollDirection: Axis.horizontal,
          //       itemBuilder: (context, index) {
          //         Map section = sections[index];
          //         return customTab(
          //           context,
          //           isSelected: (selectTab == index),
          //           onTap: () {
          //             selectTab = index;
          //             //itemScreenCurrentPage = index;
          //             setState(() {});
          //             _pageController.jumpToPage(index);
          //           },
          //           name: section['title'],
          //           onDoubleTap: () {},
          //         );
          //       },
          //       separatorBuilder: (context, index) {
          //         return const SizedBox(
          //           width: 8,
          //         );
          //       },
          //       itemCount: sections.length,
          //     ),
          //   ),
          // ],
        ),
        body: BlocBuilder<FetchHistoryBidCubit, FetchHistoryBidState>(
          builder: (context, state) {
            if (state is FetchHistoryBidInProgress) {
              return Center(
                child: UiUtils.progress(),
              );
            }
            if (state is FetchHistoryBidFailure) {
              return const SomethingWentWrong();
            }
            if (state is FetchHistoryBidSuccess) {
              if (state.historyData.isEmpty) {
                return NoDataFound(
                  onTap: () {
                    context.read<FetchTransactionsCubit>().fetchTransactions();
                  },
                );
              }

              // List<TransactionModel> transactionmodel = [
              //   TransactionModel(
              //       amount: 100,
              //       createdAt: '2024-05-01',
              //       id: 01,
              //       orderId: '10/20/K/0120',
              //       paymentGateway: 'BCA Transfer',
              //       paymentId: '10029100294029910',
              //       paymentSignature: '-',
              //       paymentStatus: 'Close',
              //       updatedAt: '2024-05-01',
              //       userId: 10203),
              // ];
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: _pageScrollController,
                        // itemCount: state.transactionmodel.length,
                        itemCount: state.historyData.length,
                        itemBuilder: (context, index) {
                          // TransactionModel transaction = state.transactionmodel[index];
                          var data = state.historyData[index];

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 16),
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  Routes.transactionDetail,
                                );
                              },
                              child: Container(
                                  // height: 100,
                                  decoration:
                                      BoxDecoration(color: context.color.secondaryColor, border: Border.all(color: context.color.borderColor, width: 1.5), borderRadius: BorderRadius.circular(10)),
                                  child: customTransactionItem(context, data)),
                            ),
                          );
                        },
                      ),
                    ),
                    // if (state.isLoadingMore) UiUtils.progress()
                  ],
                ),
              );
            }

            return Container();
          },
        ),
      ),
    );
  }

  Widget customTransactionItem(BuildContext context, ItemModel transaction) {
    return Builder(builder: (context) {
      return Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 16, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container(
            //   width: 4,
            //   height: 41,
            //   decoration: BoxDecoration(
            //     color: context.color.territoryColor,
            //     borderRadius: const BorderRadiusDirectional.only(
            //       topEnd: Radius.circular(4),
            //       bottomEnd: Radius.circular(4),
            //     ),
            //   ),
            //   // padding: const EdgeInsets.symmetric(vertical: 2.0),
            //   // margin: EdgeInsets.all(4),
            //   // height:,
            // ),
            ClipRRect(
              // borderRadius: BorderRadius.only(topRight: Radius.circular(12), bottomRight: Radius.circular(12)),
              borderRadius: BorderRadius.circular(10),
              child: UiUtils.getImage(
                width: 100,
                height: 100 /*statusButton != null ? 90 : 120*/,
                transaction.image ?? '',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              width: 4,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: context.color.territoryColor.withOpacity(0.1)),
                    padding: EdgeInsets.symmetric(vertical: 3, horizontal: 7),
                    child: Text(
                      "${(transaction.iswinner ?? false) ? 'WIN' : 'LOSE'} - ${Constant.currencySymbol} ${UiUtils().numberFormat(amount: transaction.winnerBidPrice)}",
                    ).size(context.font.small).color(context.color.territoryColor),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minHeight: 60, maxHeight: 200),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("${transaction.name}").bold(),
                              const SizedBox(height: 4),
                              Text(
                                transaction.enddt.toString().formatDate(),
                              ).size(context.font.small),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "${Constant.currencySymbol}\t ${UiUtils().numberFormat(amount: transaction.myBidPrice)} ",
                          ).bold(weight: FontWeight.w700).color(context.color.territoryColor).size(12),

                          // Text(transaction.paymentStatus!.toString().firstUpperCase()),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // GestureDetector(
            //   onTap: () async {
            //     await HapticFeedback.vibrate();
            //     var clipboardData = ClipboardData(text: transaction.orderId ?? "");
            //     Clipboard.setData(clipboardData).then((_) {
            //       ScaffoldMessenger.of(context).showSnackBar(
            //         SnackBar(
            //           content: Text("copied".translate(context)),
            //         ),
            //       );
            //     });
            //   },
            //   child: Container(
            //     height: 30,
            //     width: 30,
            //     decoration: BoxDecoration(color: context.color.secondaryColor, borderRadius: BorderRadius.circular(8), border: Border.all(color: context.color.borderColor, width: 1.5)),
            //     child: Padding(
            //       padding: const EdgeInsets.all(5.0),
            //       child: Icon(
            //         Icons.copy,
            //         size: context.font.larger,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      );
    });
  }

  Widget customTab(
    BuildContext context, {
    required bool isSelected,
    required String name,
    required Function() onTap,
    required Function() onDoubleTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      child: Container(
        constraints: const BoxConstraints(
          minWidth: 110,
        ),
        height: 40,
        decoration: BoxDecoration(
            color: (isSelected ? (context.color.territoryColor) : Colors.transparent),
            border: Border.all(
              color: isSelected ? context.color.territoryColor : context.color.textLightColor,
            ),
            borderRadius: BorderRadius.circular(11)),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(name).size(context.font.large).color(isSelected ? context.color.buttonColor : context.color.textColorDark),
          ),
        ),
      ),
    );
  }
}
