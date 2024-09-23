import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart' as awesome;
import 'package:dotted_border/dotted_border.dart';
import 'package:eClassify/Ui/screens/Widgets/AnimatedRoutes/blur_page_route.dart';
import 'package:eClassify/Ui/screens/Widgets/custom_text_form_field.dart';
import 'package:eClassify/Ui/screens/widgets/blurred_dialoge_box.dart';
import 'package:eClassify/Utils/Extensions/extensions.dart';
import 'package:eClassify/Utils/imagePicker.dart';
import 'package:eClassify/Utils/responsiveSize.dart';
import 'package:eClassify/Utils/ui_utils.dart';
import 'package:eClassify/data/cubits/bidCoins/fetch_bid_coins_package_cubit.dart';
import 'package:eClassify/data/cubits/bidCoins/fetch_bid_coins_upload_cubit.dart';
import 'package:eClassify/data/helper/widgets.dart';
import 'package:eClassify/exports/main_export.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

class BidCoindUploadScreen extends StatefulWidget {
  const BidCoindUploadScreen({super.key});

  @override
  State<BidCoindUploadScreen> createState() => _BidCoindUploadScreenState();
  static Route route(RouteSettings routeSettings) {
    // Map? args = routeSettings.arguments as Map?;
    return BlurredRouter(
      builder: (_) => BidCoindUploadScreen(),
    );
  }
}

class _BidCoindUploadScreenState extends State<BidCoindUploadScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final PickImage _pickTitleImage = PickImage();
  String packageId = '1';
  String titleImageURL = "";
  TextEditingController accountNameCtrl = TextEditingController();
  TextEditingController accountNumberCtrl = TextEditingController();
  TextEditingController accountBankCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiUtils.buildAppBar(
        context,
        showBackButton: true,
        // onBackPress: () {},
        title: "Upload proof of payment",
      ),
      bottomNavigationBar: Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), child: bottomButtonWidget()),
      body: BlocConsumer<FetcBidCoinsUploadCubit, FetchBidCoinsCubitUploadState>(
        listener: (context, state) {
          if (state is FetchBidCoinsUploadInProgress) {
            Widgets.showLoader(context);
          }
          if (state is FetchBidCoinsUploadSuccess) {
            Widgets.hideLoder(context);
            Future.delayed(Duration(milliseconds: 500), () {
              if (mounted) {
                Navigator.pushNamed(context, Routes.successBidCoinsScreen);
              }
            });
          }

          if (state is FetchBidCoinsFailure) {
            Widgets.hideLoder(context);
            myShowDialog('Error', state.errorMessage.toString(), isError: true);
          }
        },
        builder: (context, state) => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocConsumer<FetcBidCoinsPackageCubit, FetchBidCoinsPackageCubitState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      if (state is FetchBidCoinsPackageSuccess) {
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Coin Package',
                                  ).size(context.font.small).color(context.color.textDefaultColor),
                                  Text(
                                    '*required',
                                  ).size(context.font.smaller).color(context.color.textDefaultColor).italic(),
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                              margin: EdgeInsets.fromLTRB(0, 8, 0, 9),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: context.color.secondaryColor,
                                border: Border.all(
                                  color: context.color.textDefaultColor.withOpacity(0.2),
                                ),
                              ),
                              child: DropdownButton<String>(
                                value: packageId,
                                elevation: 16,
                                icon: const SizedBox.shrink(),
                                style: TextStyle(fontSize: context.font.large, color: context.color.textDefaultColor),
                                underline: Container(
                                  height: 0,
                                  color: Colors.transparent,
                                ),
                                onChanged: (String? value) {
                                  setState(() {
                                    packageId = value ?? '';
                                  });
                                },
                                items: state.bidCoinsPackageModel.map<DropdownMenuItem<String>>((value) {
                                  return DropdownMenuItem<String>(
                                    value: value.id.toString(),
                                    child: Text("${value.bidcoin} Coins"),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        );
                      }
                      return SizedBox.shrink();
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Bank Name',
                        ).size(context.font.small).color(context.color.textDefaultColor),
                        Text(
                          '*required',
                        ).size(context.font.smaller).color(context.color.textDefaultColor).italic(),
                      ],
                    ),
                  ),
                  CustomTextFormField(
                    controller: accountBankCtrl,
                    // controller: _itemNameController,
                    validator: CustomTextFieldValidator.nullCheck,
                    action: TextInputAction.next,
                    hintText: "Bank Account Name",
                    hintTextStyle: TextStyle(color: context.color.textDefaultColor.withOpacity(0.5), fontSize: context.font.large),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Account name',
                        ).size(context.font.small).color(context.color.textDefaultColor),
                        Text(
                          '*required',
                        ).size(context.font.smaller).color(context.color.textDefaultColor).italic(),
                      ],
                    ),
                  ),
                  CustomTextFormField(
                    controller: accountNameCtrl,
                    validator: CustomTextFieldValidator.nullCheck,
                    action: TextInputAction.next,
                    hintText: "Account name",
                    hintTextStyle: TextStyle(color: context.color.textDefaultColor.withOpacity(0.5), fontSize: context.font.large),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Account Number',
                        ).size(context.font.small).color(context.color.textDefaultColor),
                        Text(
                          '*required',
                        ).size(context.font.smaller).color(context.color.textDefaultColor).italic(),
                      ],
                    ),
                  ),
                  CustomTextFormField(
                    controller: accountNumberCtrl,
                    validator: CustomTextFieldValidator.nullCheck,
                    action: TextInputAction.next,
                    keyboard: TextInputType.number,
                    hintText: "Account Number",
                    hintTextStyle: TextStyle(color: context.color.textDefaultColor.withOpacity(0.5), fontSize: context.font.large),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Text("Proof of transaction".translate(context)),
                      const SizedBox(
                        width: 3,
                      ),
                      Text("maxSize".translate(context)).italic().size(context.font.small),
                    ],
                  ),
                  SizedBox(
                    height: 10.rh(context),
                  ),
                  Wrap(
                    children: [
                      if (_pickTitleImage.pickedFile != null) ...[] else ...[],
                      titleImageListener(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget bottomButtonWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: UiUtils.buildButton(context, onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              if (_pickTitleImage.pickedFile == null && titleImageURL == "") {
                UiUtils.showBlurredDialoge(
                  context,
                  dialoge: BlurredDialogBox(
                    title: "imageRequired".translate(context),
                    content: Text("Please select proof of payment transaction image"),
                  ),
                );
                return;
              }

              context.read<FetcBidCoinsUploadCubit>().uploadProff(
                    id: packageId,
                    accountName: accountNameCtrl.text,
                    accountNumber: accountNumberCtrl.text,
                    bank: accountBankCtrl.text,
                    imageFile: _pickTitleImage.pickedFile ?? File(''),
                  );
            }
          },
              buttonTitle: 'Submit',
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

  Widget titleImageListener() {
    return _pickTitleImage.listenChangesInUI((context, List<File>? files) {
      Widget currentWidget = Container();
      File? file = files?.isNotEmpty == true ? files![0] : null;

      if (file != null) {
        currentWidget = GestureDetector(
          onTap: () {
            UiUtils.showFullScreenImage(context, provider: FileImage(file));
          },
          child: Column(
            children: [
              Container(
                width: 100,
                height: 100,
                margin: const EdgeInsets.all(5),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: Image.file(
                  file,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        );
      }

      return Wrap(
        children: [
          if (file == null)
            DottedBorder(
              color: context.color.textLightColor,
              borderType: BorderType.RRect,
              radius: const Radius.circular(12),
              child: GestureDetector(
                onTap: () {
                  showImageSourceDialog(context, (source) {
                    _pickTitleImage.resumeSubscription();
                    _pickTitleImage.pick(
                      pickMultiple: false,
                      context: context,
                      source: source,
                    );
                    _pickTitleImage.pauseSubscription();
                    titleImageURL = "";
                    setState(() {});
                  });
                },
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  alignment: AlignmentDirectional.center,
                  height: 48.rh(context),
                  child: Text(
                    "addMainPicture".translate(context),
                    style: TextStyle(
                      color: context.color.textDefaultColor,
                      fontSize: context.font.large,
                    ),
                  ),
                ),
              ),
            ),
          Stack(
            children: [
              currentWidget,
              closeButton(context, () {
                _pickTitleImage.clearImage();
                titleImageURL = "";
                setState(() {});
              })
            ],
          ),
          if (file != null || titleImageURL.isNotEmpty)
            uploadPhotoCard(context, onTap: () {
              showImageSourceDialog(context, (source) {
                _pickTitleImage.resumeSubscription();
                _pickTitleImage.pick(
                  pickMultiple: false,
                  context: context,
                  source: source,
                );
                _pickTitleImage.pauseSubscription();
                titleImageURL = "";
                setState(() {});
              });
            })
        ],
      );
    });
  }

  Future<void> showImageSourceDialog(BuildContext context, Function(ImageSource) onSelected) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('selectImageSource'.translate(context)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text('camera'.translate(context)),
                  onTap: () {
                    Navigator.of(context).pop();
                    onSelected(ImageSource.camera);
                  },
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: Text('gallery'.translate(context)),
                  onTap: () {
                    Navigator.of(context).pop();
                    onSelected(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget closeButton(BuildContext context, Function onTap) {
    return PositionedDirectional(
      top: 6,
      end: 6,
      child: GestureDetector(
        onTap: () {
          onTap.call();
        },
        child: Container(
          decoration: BoxDecoration(color: context.color.primaryColor.withOpacity(0.7), borderRadius: BorderRadius.circular(10)),
          child: const Padding(
            padding: EdgeInsets.all(4.0),
            child: Icon(
              Icons.close,
              size: 24,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget uploadPhotoCard(BuildContext context, {required Function onTap}) {
    return GestureDetector(
      onTap: () {
        onTap.call();
      },
      child: Container(
        width: 100,
        height: 100,
        margin: const EdgeInsets.all(5),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: DottedBorder(
            color: context.color.textColorDark.withOpacity(0.5),
            borderType: BorderType.RRect,
            radius: const Radius.circular(10),
            child: Container(
              alignment: AlignmentDirectional.center,
              child: Text("uploadPhoto".translate(context)),
            )),
      ),
    );
  }

  void myShowDialog(String title, String desc, {bool isError = false}) {
    awesome.AwesomeDialog(
      context: context,
      customHeader: !isError
          ? Material(
              borderRadius: BorderRadius.circular(55),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Positioned(
                    top: -35,
                    left: -44,
                    child: Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: 150,
                        child: Lottie.asset("assets/lottie/${Constant.successItemLottieFile}", repeat: false, alignment: Alignment.center),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : null,
      animType: awesome.AnimType.leftSlide,
      headerAnimationLoop: false,
      dialogType: awesome.DialogType.error,
      showCloseIcon: true,
      title: title,
      desc: desc,
      btnOkOnPress: () {
        debugPrint('OnClcik');
      },
      btnOkIcon: isError ? Icons.close : Icons.check,
      onDismissCallback: (type) {
        debugPrint('Dialog Dissmiss from callback $type');
      },
      btnOkColor: isError ? Colors.red : context.color.territoryColor,
    ).show();
  }
}
