import 'package:eClassify/Ui/screens/Widgets/Errors/no_internet.dart';
import 'package:eClassify/Ui/screens/Widgets/Errors/something_went_wrong.dart';
import 'package:eClassify/Ui/screens/bidCoins/widget/bid_coin_shimmer.dart';
import 'package:eClassify/Ui/screens/bidCoins/widget/bid_coins_primary.dart';
import 'package:eClassify/Utils/Extensions/extensions.dart';
import 'package:eClassify/Utils/api.dart';
import 'package:eClassify/data/cubits/bidCoins/fetch_bid_coins_cubit.dart';
import 'package:eClassify/exports/main_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BidCoinsScreen extends StatefulWidget {
  const BidCoinsScreen({super.key});

  @override
  State<BidCoinsScreen> createState() => _BidCoinsScreenState();
}

class _BidCoinsScreenState extends State<BidCoinsScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FetcBidCoinsCubit>().fetchHistory();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: primaryColor_,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.transparent),
          backgroundColor: territoryColor_,
          elevation: 0.0,
        ),
        body: BlocConsumer<FetcBidCoinsCubit, FetchBidCoinsCubitState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is FetchBidCoinsInProgress) {
                return BidCoinShimmer();
              }
              if (state is FetchBidCoinsFailure) {
                if (state.errorMessage is ApiException) {
                  if (state.errorMessage == "no-internet") {
                    return NoInternet(
                      onRetry: () {
                        context.read<FetcBidCoinsCubit>().fetchHistory();
                      },
                    );
                  }
                }
                return const SomethingWentWrong();
              }
              if (state is FetchBidCoinsSuccess) {
                return BidCoinsPrimary(state: state);
              }

              return const SizedBox.square();
            }),
      ),
    );
  }
}
