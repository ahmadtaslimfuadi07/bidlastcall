import 'package:eClassify/data/model/history_model.dart';
import 'package:flutter/material.dart';

import '../../../data/cubits/Utility/fetch_transactions_cubit.dart';
import '../../../data/model/transaction_model.dart';
import '../../../exports/main_export.dart';
import '../../../utils/Extensions/extensions.dart';
import '../../../utils/ui_utils.dart';
import '../Widgets/intertitial_ads_screen.dart';
import '../widgets/AnimatedRoutes/blur_page_route.dart';
import '../widgets/Errors/no_data_found.dart';
import '../widgets/Errors/something_went_wrong.dart';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({super.key});

  static Route route(RouteSettings settings) {
    return BlurredRouter(
      builder: (context) {
        return BlocProvider(
          create: (context) {
            return FetchTransactionsCubit();
          },
          child: const TransactionHistory(),
        );
      },
    );
  }

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  late final ScrollController _pageScrollController = ScrollController();
  final PageController _pageController = PageController();
  /* ..addListener(_pageScrollListener);*/

  List<Map> sections = [];
  int offset = 0, total = 0;
  int selectTab = 0;

  @override
  void initState() {
    AdHelper.loadInterstitialAd();
    context.read<FetchTransactionsCubit>().fetchTransactions();
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
        "title": "Open",
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
          title: "Sales History",
          bottomHeight: 49,
          bottom: [
            SizedBox(
              width: context.screenWidth,
              height: 45,
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsetsDirectional.fromSTEB(18, 5, 18, 2),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  Map section = sections[index];
                  return customTab(
                    context,
                    isSelected: (selectTab == index),
                    onTap: () {
                      selectTab = index;
                      //itemScreenCurrentPage = index;
                      setState(() {});
                      _pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.linear);
                    },
                    name: section['title'],
                    onDoubleTap: () {},
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    width: 8,
                  );
                },
                itemCount: sections.length,
              ),
            ),
          ],
        ),
        body: BlocBuilder<FetchTransactionsCubit, FetchTransactionsState>(
          builder: (context, state) {
            if (state is FetchTransactionsInProgress) {
              return Center(
                child: UiUtils.progress(),
              );
            }
            if (state is FetchTransactionsFailure) {
              return const SomethingWentWrong();
            }
            if (state is FetchTransactionsSuccess) {
              List<TransactionModel> transactionmodel = [
                TransactionModel(
                    amount: 100,
                    createdAt: '2024-05-01',
                    id: 01,
                    orderId: '10/20/K/0120',
                    paymentGateway: 'BCA Transfer',
                    paymentId: '10029100294029910',
                    paymentSignature: '-',
                    paymentStatus: 'Close',
                    updatedAt: '2024-05-01',
                    userId: 10203),
              ];
              return PageView(
                controller: _pageController,
                onPageChanged: (value) {
                  selectTab = value;
                  setState(() {});
                },
                children: [
                  bodyHistory(state.transactionmodel.all ?? []),
                  bodyHistory(state.transactionmodel.open ?? []),
                  bodyHistory(state.transactionmodel.closed ?? []),
                ],
              );
            }

            return Container();
          },
        ),
      ),
    );
  }

  Widget bodyHistory(List<ItemHistoryModel> data) {
    if (data.isEmpty) {
      return NoDataFound(
        onTap: () {
          context.read<FetchTransactionsCubit>().fetchTransactions();
        },
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _pageScrollController,
              // itemCount: state.transactionmodel.length,
              itemCount: data.length,
              itemBuilder: (context, index) {
                // TransactionModel transaction = state.transactionmodel[index];

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
                        decoration: BoxDecoration(color: context.color.secondaryColor, border: Border.all(color: context.color.borderColor, width: 1.5), borderRadius: BorderRadius.circular(10)),
                        child: customTransactionItem(context, data[index])),
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

  Widget customTransactionItem(BuildContext context, ItemHistoryModel data) {
    var badgeTitle = '';
    var harga = '';
    if (!(data.hasclosed ?? false)) {
      badgeTitle = 'Open';
    } else if (data.hasclosed ?? false) {
      if (data.haswinner ?? false) {
        badgeTitle = 'Tidak Terjual';
      } else {
        badgeTitle = 'Terjual';
      }
    }

    if (data.winnerBidPrice == null && (!(data.hasclosed ?? false))) {
      harga = 'Belum ada bid';
    } else if (data.winnerBidPrice == null && (data.hasclosed ?? false)) {
      harga = 'Tidak ada Bid';
    } else {
      harga = "${Constant.currencySymbol} ${UiUtils().numberFormat(amount: data.winnerBidPrice)} ";
    }

    return Builder(builder: (context) {
      return Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 16, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              // borderRadius: BorderRadius.only(topRight: Radius.circular(12), bottomRight: Radius.circular(12)),
              borderRadius: BorderRadius.circular(10),
              child: UiUtils.getImage(
                width: 100,
                height: 100 /*statusButton != null ? 90 : 120*/,
                data.image ?? '',
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text(
                        "${data.name}",
                        maxLines: 4,
                      ).bold()),
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: context.color.territoryColor.withOpacity(0.1)),
                          padding: EdgeInsets.symmetric(vertical: 3, horizontal: 7),
                          child: Text(
                            "${badgeTitle}",
                          ).size(context.font.small).color(context.color.territoryColor),
                        ),
                      ),
                    ],
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
                              const SizedBox(height: 4),
                              Text(
                                data.enddt.toString().formatDate(),
                              ).size(context.font.small),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "$harga",
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
