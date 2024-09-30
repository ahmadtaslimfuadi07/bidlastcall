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
import 'package:eClassify/data/cubits/subscription/fetch_transaction_upload_cubit.dart';
import 'package:eClassify/data/cubits/subscription/get_payment_cubit.dart';
import 'package:eClassify/data/helper/widgets.dart';
import 'package:eClassify/data/model/item/item_detail_model.dart';
import 'package:eClassify/data/model/pgsModel.dart';
import 'package:eClassify/exports/main_export.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

class TransactionUploadScreen extends StatefulWidget {
  final int? amount;
  final String? itemId;
  final OngkirOpts? ongkirOpts;
  const TransactionUploadScreen({super.key, this.amount, this.itemId, this.ongkirOpts});

  @override
  State<TransactionUploadScreen> createState() => _TransactionUploadScreenState();
  static Route route(RouteSettings routeSettings) {
    Map? args = routeSettings.arguments as Map?;
    return BlurredRouter(
      builder: (_) => TransactionUploadScreen(
        amount: args?['amount'],
        itemId: args?['itemId'],
        ongkirOpts: args?['ongkirOpts'],
      ),
    );
  }
}

class _TransactionUploadScreenState extends State<TransactionUploadScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final PickImage _pickTitleImage = PickImage();
  String packageId = '1';
  String titleImageURL = "";
  TextEditingController accountNameCtrl = TextEditingController();
  TextEditingController accountNumberCtrl = TextEditingController();
  TextEditingController accountBankCtrl = TextEditingController();
  TextEditingController amountkCtrl = TextEditingController();

  List<PGSModel> pgsData = [];
  String pgId = '';

  DateTime? startDate;

  List ekspedisi = ['JNE', 'POS', 'TIKI'];
  String ekpdisiSelect = '';
  String serviceId = '';
  String shippingetd = '';
  int shippingfee = 0;
  String shippingservice = '';
  List<KurirModel>? kurir = [];

  @override
  void initState() {
    context.read<GetPaymentCubit>().getPayment();
    amountkCtrl.text = UiUtils().numberFormat(amount: widget.amount);
    super.initState();
  }

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
      body: BlocConsumer<FetcTransactionUploadCubit, FetchBidTransactionUploadState>(
        listener: (context, state) {
          if (state is FetchTransactionUploadInProgress) {
            Widgets.showLoader(context);
          }
          if (state is FetchTransactionUploadSuccess) {
            Widgets.hideLoder(context);
            Future.delayed(Duration(milliseconds: 500), () {
              if (mounted) {
                Navigator.pushNamed(context, Routes.successTransactionScreen);
              }
            });
          }

          if (state is FetchTransactionFailure) {
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
                  dropDown(
                    false,
                    'Ekspedisi',
                    ekspedisi.map((item) {
                      return DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            "${item}",
                          ));
                    }).toList(),
                    ekpdisiSelect,
                    (val) {
                      setState(
                        () {
                          ekpdisiSelect = val;
                          serviceId = '';
                          shippingetd = '';
                          shippingfee = 0;
                          shippingservice = '';
                          kurir = [];
                          if (val == 'JNE') {
                            kurir?.addAll(widget.ongkirOpts?.jNE ?? []);
                          } else if (val == 'POS') {
                            kurir?.addAll(widget.ongkirOpts?.pOS ?? []);
                          } else {
                            kurir?.addAll(widget.ongkirOpts?.tIKI ?? []);
                          }
                        },
                      );
                    },
                  ),
                  if (kurir?.isNotEmpty ?? [].isNotEmpty)
                    dropDown(
                        false,
                        'Ekspedisi',
                        kurir?.map((item) {
                          return DropdownMenuItem<String>(
                            value: item.serviceid,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${item.service}",
                                ).size(context.font.smaller).setMaxLines(lines: 2).bold().color(context.color.primary),
                                Text("Rp. ${UiUtils().numberFormat(amount: item.cost)}")
                                    .size(context.font.smaller)
                                    .setMaxLines(lines: 2)
                                    .size(context.font.small)
                                    .color(context.color.textDefaultColor.withOpacity(0.9)),
                                Text("Estimasi Tiba: ${item.etd}").size(context.font.smaller).setMaxLines(lines: 2).size(context.font.small).color(context.color.textDefaultColor.withOpacity(0.9)),
                                Divider(),
                              ],
                            ),
                          );
                        }).toList(),
                        serviceId, (val) {
                      setState(
                        () {
                          serviceId = val;
                          int index = kurir?.indexWhere((element) => element.serviceid == val) ?? 0;
                          shippingetd = kurir?[index].etd ?? '';
                          shippingfee = kurir?[index].cost ?? 0;
                          shippingservice = val;
                          int newAmount = (widget.amount ?? 0) + shippingfee;
                          amountkCtrl.text = UiUtils().numberFormat(amount: newAmount);
                        },
                      );
                    }, selectedItemBuilder: (BuildContext context) {
                      return kurir!.map<Widget>((item) {
                        // This is the widget that will be shown when you select an item.
                        // Here custom text style, alignment and layout size can be applied
                        // to selected item string.
                        return Container(
                          alignment: Alignment.centerLeft,
                          constraints: const BoxConstraints(minWidth: 100),
                          child: Text("${item.serviceid}").size(context.font.smaller).setMaxLines(lines: 2).size(context.font.small).color(context.color.textDefaultColor),
                        );
                      }).toList();
                    }),

                  BlocConsumer<GetPaymentCubit, GetPaymentState>(
                    listener: (context, state) {
                      if (state is GetPaymentInSuccess) {}
                    },
                    builder: (context, state) {
                      if (state is GetPaymentInProgress) {
                        return dropDown(
                          true,
                          'Payment Methode',
                          [].map((item) {
                            return DropdownMenuItem<String>(
                              value: item.id.toString(),
                              child: Column(
                                children: [
                                  Text(
                                    "${item.bank}",
                                    // style: GoogleFonts.nunito(color: Colors.black),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          '',
                          (val) {},
                        );
                      }
                      if (state is GetPaymentInSuccess) {
                        return Column(
                          children: [
                            dropDown(
                                false,
                                'Payment Methode',
                                state.pgsModel.map((item) {
                                  return DropdownMenuItem<String>(
                                    value: item.id.toString(),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${item.bank}",
                                        ).size(context.font.smaller).setMaxLines(lines: 2).bold().color(context.color.primary),
                                        Text("${item.accnum} -  ${item.accname}")
                                            .size(context.font.smaller)
                                            .setMaxLines(lines: 2)
                                            .size(context.font.small)
                                            .color(context.color.textDefaultColor.withOpacity(0.5)),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                pgId, (val) {
                              setState(
                                () {
                                  pgId = val;
                                },
                              );
                            }, selectedItemBuilder: (BuildContext context) {
                              return state.pgsModel.map<Widget>((item) {
                                // This is the widget that will be shown when you select an item.
                                // Here custom text style, alignment and layout size can be applied
                                // to selected item string.
                                return Container(
                                  alignment: Alignment.centerLeft,
                                  constraints: const BoxConstraints(minWidth: 100),
                                  child: Text("${item.bank} - ${item.accnum} - ${item.accname} ")
                                      .size(context.font.smaller)
                                      .setMaxLines(lines: 2)
                                      .size(context.font.small)
                                      .color(context.color.textDefaultColor),
                                );
                              }).toList();
                            }),
                            SizedBox(height: 12)
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
                          'Amount',
                        ).size(context.font.small).color(context.color.textDefaultColor),
                      ],
                    ),
                  ),
                  CustomTextFormField(
                    controller: amountkCtrl,
                    // controller: _itemNameController,
                    validator: CustomTextFieldValidator.nullCheck,
                    action: TextInputAction.next,
                    isReadOnly: true,
                    hintText: "Bank Account Name",
                    hintTextStyle: TextStyle(color: context.color.textDefaultColor.withOpacity(0.5), fontSize: context.font.large),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Text(
                  //         'Bank Name',
                  //       ).size(context.font.small).color(context.color.textDefaultColor),
                  //       Text(
                  //         '*required',
                  //       ).size(context.font.smaller).color(context.color.textDefaultColor).italic(),
                  //     ],
                  //   ),
                  // ),
                  // CustomTextFormField(
                  //   controller: accountBankCtrl,
                  //   // controller: _itemNameController,
                  //   validator: CustomTextFieldValidator.nullCheck,
                  //   action: TextInputAction.next,
                  //   hintText: "Bank Account Name",
                  //   hintTextStyle: TextStyle(color: context.color.textDefaultColor.withOpacity(0.5), fontSize: context.font.large),
                  // ),
                  // SizedBox(
                  //   height: 12,
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Text(
                  //         'Account name',
                  //       ).size(context.font.small).color(context.color.textDefaultColor),
                  //       Text(
                  //         '*required',
                  //       ).size(context.font.smaller).color(context.color.textDefaultColor).italic(),
                  //     ],
                  //   ),
                  // ),
                  // CustomTextFormField(
                  //   controller: accountNameCtrl,
                  //   validator: CustomTextFieldValidator.nullCheck,
                  //   action: TextInputAction.next,
                  //   hintText: "Account name",
                  //   hintTextStyle: TextStyle(color: context.color.textDefaultColor.withOpacity(0.5), fontSize: context.font.large),
                  // ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Payment Date',
                        ).size(context.font.small).color(context.color.textDefaultColor),
                        Text(
                          '*required',
                        ).size(context.font.smaller).color(context.color.textDefaultColor).italic(),
                      ],
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      dateTimePickerWidget(context, false);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.fromLTRB(8, 16, 8, 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: context.color.secondaryColor,
                        border: Border.all(
                          color: context.color.textDefaultColor.withOpacity(0.2),
                        ),
                      ),
                      child: Text(
                        "${(startDate == null) ? 'End Date Option' : UiUtils().dateFormatter(startDate.toString(), 13)}",
                        style: TextStyle(
                          fontSize: context.font.large,
                          color: context.color.textDefaultColor.withOpacity(startDate == null ? 0.4 : 1),
                        ),
                      ),
                    ),
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

  Future dateTimePickerWidget(
    BuildContext context,
    isStart,
  ) async {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(3101),
    ).then((selectedDate) {
      // After selecting the date, display the time picker.
      if (selectedDate != null) {
        DateTime? selectedDateTime;
        selectedDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
        );

        startDate = selectedDateTime;
        setState(() {});
        return selectedDateTime;
      }
      return null;
    });
  }

  Widget loadingDropdown() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFFE2E4E7), width: 1),
      ),
      child: Text('Loading....'),
    );
  }

  Widget dropDown(bool isloading, String title, List<DropdownMenuItem<String>>? items, String selected, Function(String) function, {List<Widget> Function(BuildContext)? selectedItemBuilder}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10.rh(context),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
            ).size(context.font.small).color(context.color.textDefaultColor),
            Text(
              '*required',
            ).size(context.font.smaller).color(context.color.textDefaultColor).italic(),
          ],
        ),
        SizedBox(
          height: 10.rh(context),
        ),
        isloading
            ? loadingDropdown()
            : DropdownButtonFormField<String>(
                dropdownColor: Colors.white,
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Color(0xFFE2E4E7),
                ),
                value: selected == '' ? null : selected,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  fillColor: Colors.white,
                  filled: true,
                  hintText: title,
                  alignLabelWithHint: false,
                  hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, height: 0),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFE2E4E7), width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                items: items,
                selectedItemBuilder: selectedItemBuilder,
                onChanged: (String? value) {
                  function.call(value ?? '');
                  setState(() {
                    selected = value ?? '';
                  });
                },
              ),
      ],
    );
  }

  Widget bottomButtonWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: UiUtils.buildButton(context, onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              if (pgId == '') {
                UiUtils.showBlurredDialoge(
                  context,
                  dialoge: BlurredDialogBox(
                    title: "Payment Methode is Required".translate(context),
                    content: Text("Please select Payment Methode"),
                  ),
                );
                return;
              }
              if (startDate == null) {
                UiUtils.showBlurredDialoge(
                  context,
                  dialoge: BlurredDialogBox(
                    title: "Payment Date is Required".translate(context),
                    content: Text("Please input Payment Date"),
                  ),
                );
                return;
              }
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

              context.read<FetcTransactionUploadCubit>().uploadProff(
                    id: widget.itemId ?? '',
                    amount: widget.amount.toString(),
                    paymentdate: startDate.toString(),
                    pgId: pgId,
                    accountNumber: accountNumberCtrl.text,
                    shippingetd: shippingetd,
                    shippingfee: shippingfee.toString(),
                    shippingservice: shippingservice,
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
                  FocusScope.of(context).unfocus();

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
                    "Add Picture".translate(context),
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
