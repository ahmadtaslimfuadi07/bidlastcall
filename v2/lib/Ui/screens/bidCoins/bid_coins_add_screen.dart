import 'package:eClassify/Ui/screens/Widgets/AnimatedRoutes/blur_page_route.dart';
import 'package:eClassify/Ui/screens/Widgets/Errors/no_internet.dart';
import 'package:eClassify/Ui/screens/Widgets/Errors/something_went_wrong.dart';
import 'package:eClassify/Ui/screens/bidCoins/widget/bid_coind_package.dart';
import 'package:eClassify/Ui/screens/bidCoins/widget/bid_coind_package_shimmer.dart';
import 'package:eClassify/Utils/api.dart';
import 'package:eClassify/Utils/responsiveSize.dart';
import 'package:eClassify/Utils/ui_utils.dart';
import 'package:eClassify/data/cubits/bidCoins/fetch_bid_coins_package_cubit.dart';
import 'package:eClassify/exports/main_export.dart';
import 'package:flutter/material.dart';

class BidCoinsAddScreen extends StatefulWidget {
  const BidCoinsAddScreen({super.key});

  @override
  State<BidCoinsAddScreen> createState() => _BidCoinsAddScreenState();

  static Route route(RouteSettings routeSettings) {
    // Map? args = routeSettings.arguments as Map?;
    return BlurredRouter(
      builder: (_) => BidCoinsAddScreen(),
    );
  }
}

class _BidCoinsAddScreenState extends State<BidCoinsAddScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FetcBidCoinsPackageCubit>().fetchPackage();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiUtils.buildAppBar(
        context,
        showBackButton: true,
        // onBackPress: () {},
        title: "Add Bid Coins",
      ),
      bottomNavigationBar: Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), child: bottomButtonWidget()),
      body: BlocConsumer<FetcBidCoinsPackageCubit, FetchBidCoinsPackageCubitState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is FetchBidCoinsPackageInProgress) {
            return BidCoindPackageShimmer();
          }
          if (state is FetchBidCoinsPackageFailure) {
            if (state.errorMessage is ApiException) {
              if (state.errorMessage == "no-internet") {
                return NoInternet(
                  onRetry: () {
                    context.read<FetcBidCoinsPackageCubit>().fetchPackage();
                  },
                );
              }
            }
            return const SomethingWentWrong();
          }
          if (state is FetchBidCoinsPackageSuccess) {
            return BidCoindPackage(state: state);
          }

          return const SizedBox.square();
        },
      ),
    );
  }

  Widget bottomButtonWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: UiUtils.buildButton(context, onPressed: () {
            Navigator.pushNamed(
              context,
              Routes.bidCoinsUpload,
            );
          },
              buttonTitle: 'Upload Bukti Pembayaran',
              height: 30.rh(context),
              width: 50.rw(context),
              radius: 2,
              fontSize: 14,
              padding: EdgeInsets.all(
                12,
              )),
        ),
      ],
    );
  }
}
