import 'package:eClassify/Ui/screens/main_activity.dart';
import 'package:eClassify/Ui/screens/widgets/AnimatedRoutes/blur_page_route.dart';
import 'package:eClassify/Utils/Extensions/extensions.dart';
import 'package:eClassify/data/model/item/item_model.dart';
import 'package:eClassify/exports/main_export.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SuccessBidCoinsScreen extends StatefulWidget {
  const SuccessBidCoinsScreen({
    super.key,
  });

  static Route route(RouteSettings settings) {
    return BlurredRouter(
      builder: (context) {
        return SuccessBidCoinsScreen();
      },
    );
  }

  @override
  _SuccessBidCoinsScreenState createState() => _SuccessBidCoinsScreenState();
}

class _SuccessBidCoinsScreenState extends State<SuccessBidCoinsScreen> with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  bool _isSuccessShown = false;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  bool isBack = false;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1), // Adjust duration as needed
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 1.5), // Off-screen initially
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    ));

    // Simulate loading time
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted)
        setState(() {
          _isLoading = false;
        });
      // Show success animation after loading animation completes
      Future.delayed(const Duration(seconds: 0), () {
        if (mounted)
          setState(() {
            _isSuccessShown = true;
            Future.delayed(const Duration(seconds: 1), () {
              _slideController.forward();
            }); // Start slide animation
          });
      });
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  void _handleBackButtonPressed() {
    if (_isSuccessShown && _slideController.isAnimating) {
      setState(() {
        isBack = false;
      });
      // Don't allow popping while the animation is playing
      return;
    } else {
      // Navigate back to the home screen
      _navigateBackToHome();
      return;
    }
  }

  void _navigateBackToHome() {
    if (mounted)
      Future.delayed(
        Duration(milliseconds: 500),
        () {
          if (mounted) Navigator.popUntil(context, (route) => route.isFirst);
          MainActivity.globalKey.currentState?.onItemTapped(0);
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: isBack,
      onPopInvoked: (didPop) async {
        // Handle back button press
        _handleBackButtonPressed();
      },
      child: Scaffold(
        body: Center(
          child: _isLoading
              ? Lottie.asset("assets/lottie/${Constant.loadingSuccessLottieFile}") // Replace with your loading animation
              : _isSuccessShown
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset("assets/lottie/${Constant.successItemLottieFile}", repeat: false),
                        SlideTransition(
                          position: _slideAnimation,
                          child: Column(
                            children: [
                              SizedBox(height: 50),
                              Text(
                                'congratulations'.translate(context),
                              ).size(context.font.extraLarge).color(context.color.territoryColor).bold(weight: FontWeight.w600),
                              SizedBox(height: 12),
                              Center(
                                child: Text(
                                  "Coins will be received within 1x2 hours for admin verification",
                                  textAlign: TextAlign.center,
                                ).size(context.font.normal).color(context.color.territoryColor).bold(weight: FontWeight.w600),
                              ),
                              SizedBox(height: 60),
                              SizedBox(height: 15),
                              InkWell(
                                onTap: () {
                                  _navigateBackToHome();
                                  //pageCntrlr.jumpToPage(3);
                                  /*  Navigator.pushReplacementNamed(
                                      context,
                                      Routes.main,
                                      arguments: {"from": "successItem"},
                                    ).then((_) {
                                      context
                                          .read<NavigationCubit>()
                                          .navigateToMyItems();
                                    });*/
                                  /*  Navigator.pushNamed(
                                      context,
                                      Routes.myItemScreen,
                                    );*/
                                },
                                child: Container(
                                  height: 48,
                                  alignment: AlignmentDirectional.center,
                                  margin: EdgeInsets.symmetric(horizontal: 65, vertical: 10),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: context.color.territoryColor), color: context.color.secondaryColor),
                                  child: Text("backToHome".translate(context)).centerAlign().size(context.font.larger).color(context.color.territoryColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : SizedBox(), // Placeholder
        ),
      ),
    );
  }
}
