import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:eClassify/Ui/screens/Item/add_item_screen/Widgets/ImageAdapter.dart';
import 'package:eClassify/Ui/screens/Item/add_item_screen/select_category.dart';
import 'package:eClassify/Ui/screens/Widgets/dropdown_form_field_section.dart';
import 'package:eClassify/Ui/screens/widgets/blurred_dialoge_box.dart';
import 'package:eClassify/Utils/Extensions/extensions.dart';
import 'package:eClassify/Utils/responsiveSize.dart';

import 'package:eClassify/data/model/item/item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:number_text_input_formatter/number_text_input_formatter.dart';

import '../../../../Utils/cloudState/cloud_state.dart';
import '../../../../Utils/helper_utils.dart';
import '../../../../Utils/imagePicker.dart';
import '../../../../Utils/ui_utils.dart';
import '../../../../data/cubits/CustomField/fetch_custom_fields_cubit.dart';
import '../../../../data/model/category_model.dart';
import '../../../../exports/main_export.dart';
import '../../Widgets/AnimatedRoutes/blur_page_route.dart';
import '../../Widgets/DynamicField/dynamic_field.dart';
import '../../Widgets/custom_text_form_field.dart';

class AddItemDetails extends StatefulWidget {
  final List<CategoryModel>? breadCrumbItems;
  final bool? isEdit;

  const AddItemDetails({
    super.key,
    this.breadCrumbItems,
    required this.isEdit,
  });

  static Route route(RouteSettings settings) {
    Map<String, dynamic>? arguments = settings.arguments as Map<String, dynamic>?;
    return BlurredRouter(
      builder: (context) {
        return BlocProvider(
          create: (context) => FetchCustomFieldsCubit(),
          child: AddItemDetails(
            breadCrumbItems: arguments?['breadCrumbItems'],
            isEdit: arguments?['isEdit'],
          ),
        );
      },
    );
  }

  @override
  CloudState<AddItemDetails> createState() => _AddItemDetailsState();
}

class _AddItemDetailsState extends CloudState<AddItemDetails> {
  final PickImage _pickTitleImage = PickImage();
  final PickImage itemImagePicker = PickImage();
  String titleImageURL = "";
  List<dynamic> mixedItemImageList = [];
  List<int> deleteItemImageList = [];
  final GlobalKey<FormState> _formKey = GlobalKey();

  DateTime? startDate;
  DateTime? endDate;

  //Text Controllers
  final TextEditingController adTitleController = TextEditingController();
  final TextEditingController adSlugController = TextEditingController();
  final TextEditingController adDescriptionController = TextEditingController();
  final TextEditingController adPriceController = TextEditingController();
  final TextEditingController adBidStartController = TextEditingController();
  final TextEditingController adMinBidController = TextEditingController();
  final TextEditingController adPhoneNumberController = TextEditingController();
  final TextEditingController adAdditionalDetailsController = TextEditingController();
  final TextEditingController adEndDateController = TextEditingController();

  List<String> conditionData = ['New', "Second-hand"];

  List<String> durationData = [d1x3, d1x6, d1x24, d2x24, d3x24];
  // List<String> durationData = [];
  List minBidData = [25000, 50000, 100000, 150000, 200000, 250000, 300000];

  String condition = '';
  String duration = '';
  int minBid = 0;

  void _onBreadCrumbItemTap(int index) {
    int popTimes = (widget.breadCrumbItems!.length - 1) - index;
    int current = index;
    int length = widget.breadCrumbItems!.length;

    for (int i = length - 1; i >= current + 1; i--) {
      widget.breadCrumbItems!.removeAt(i);
    }

    for (int i = 0; i < popTimes; i++) {
      Navigator.pop(context);
    }
    setState(() {});
  }

  late List selectedCategoryList;
  ItemModel? item;

  @override
  void initState() {
    AbstractField.fieldsData.clear();
    AbstractField.files.clear();
    // generateList();
    if (widget.isEdit == true) {
      item = getCloudData('edit_request') as ItemModel;

      clearCloudData("item_details");
      clearCloudData("with_more_details");
      context.read<FetchCustomFieldsCubit>().fetchCustomFields(
            categoryIds: item!.allCategoryIds!,
          );
      adTitleController.text = item?.name ?? "";
      adSlugController.text = item?.slug ?? "";
      adDescriptionController.text = item?.description ?? "";
      adPriceController.text = item?.price.toString() ?? "";
      adPhoneNumberController.text = item?.contact ?? "";
      adAdditionalDetailsController.text = item?.videoLink ?? "";
      titleImageURL = item?.image ?? "";

      List<String?>? list = item?.galleryImages?.map((e) => e.image).toList();
      mixedItemImageList.addAll([...list ?? []]);

      setState(() {});
    } else {
      List<int> ids = widget.breadCrumbItems!.map((item) => item.id!).toList();

      context.read<FetchCustomFieldsCubit>().fetchCustomFields(categoryIds: ids.join(','));
      selectedCategoryList = ids;
      adPhoneNumberController.text = HiveUtils.getUserDetails().mobile ?? "";
    }

    _pickTitleImage.listener((p0) {
      titleImageURL = "";
      WidgetsBinding.instance.addPersistentFrameCallback((timeStamp) {
        if (mounted) setState(() {});
      });
    });

    itemImagePicker.listener((images) {
      try {
        mixedItemImageList.addAll(List<dynamic>.from(images));
      } catch (e) {}

      setState(() {});
    });

    super.initState();
  }

  void generateList() {
    for (var i = 0; i < 72; i++) {
      durationData.add('${i + 1} Hour');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: UiUtils.getSystemUiOverlayStyle(context: context, statusBarColor: context.color.secondaryColor),
      child: PopScope(
        canPop: true,
        onPopInvoked: (didPop) {
          //Navigator.pop(context, true);
          return;
        },
        /*onWillPop: () async {
          Navigator.pop(context, true);
          return false;
        },*/
        child: SafeArea(
          child: Scaffold(
            appBar: UiUtils.buildAppBar(context, showBackButton: true, title: "AdDetails".translate(context)),
            bottomNavigationBar: Container(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: UiUtils.buildButton(context, onPressed: () {
                  ///File to
                  ///

                  if (_formKey.currentState?.validate() ?? false) {
                    List<File>? galleryImages = mixedItemImageList.where((element) => element != null && element is File).map((element) => element as File).toList();

                    if (_pickTitleImage.pickedFile == null && titleImageURL == "") {
                      UiUtils.showBlurredDialoge(
                        context,
                        dialoge: BlurredDialogBox(
                          title: "imageRequired".translate(context),
                          content: Text(
                            "selectImageYourItem".translate(context),
                          ),
                        ),
                      );
                      return;
                    }
                    // print("kondisi $condition");
                    if (condition == '') {
                      UiUtils.showBlurredDialoge(
                        context,
                        dialoge: BlurredDialogBox(
                          title: "Condition Required".translate(context),
                          content: Text(
                            "Please select Item Condition".translate(context),
                          ),
                        ),
                      );
                      return;
                    }
                    if (minBid == 0) {
                      UiUtils.showBlurredDialoge(
                        context,
                        dialoge: BlurredDialogBox(
                          title: "Minimum Bid Required".translate(context),
                          content: Text(
                            "Please select Minimum bid".translate(context),
                          ),
                        ),
                      );
                      return;
                    }
                    if (startDate == null) {
                      UiUtils.showBlurredDialoge(
                        context,
                        dialoge: BlurredDialogBox(
                          title: "Start Date Required".translate(context),
                          content: Text(
                            "Please input Start date".translate(context),
                          ),
                        ),
                      );
                      return;
                    }
                    if (endDate == '') {
                      UiUtils.showBlurredDialoge(
                        context,
                        dialoge: BlurredDialogBox(
                          title: "End date Required".translate(context),
                          content: Text(
                            "Please select 'End date option'".translate(context),
                          ),
                        ),
                      );
                      return;
                    }
                    // print("haha ${adBidStartController.text}");

                    int startBid = int.parse(adBidStartController.text.replaceAll(".", ""));
                    int price = int.parse(adPriceController.text.replaceAll(".", ""));
                    if (startBid > price) {
                      UiUtils.showBlurredDialoge(
                        context,
                        dialoge: BlurredDialogBox(
                          title: "Price Error".translate(context),
                          content: Text(
                            "'Open bid' cannot be greater than the 'Buy now'".translate(context),
                          ),
                        ),
                      );
                      return;
                    }

                    /* if (galleryImages.isEmpty && mixedItemImageList.isEmpty) {
                      UiUtils.showBlurredDialoge(context,
                          dialoge: BlurredDialogBox(
                            title: "atLeastOneImageRequired".translate(context),
                            content: Text(
                              "selectUpTOOneImage".translate(context),
                            ),
                          ));
                      return;
                    }*/
                    DateTime a = startDate ?? DateTime.now();
                    DateTime b = endDate ?? DateTime.now();

                    Duration durationd = b.difference(a);
                    // print("duration ${durationd.inHours} ");
                    if (durationd.inHours > 72) {
                      UiUtils.showBlurredDialoge(
                        context,
                        dialoge: BlurredDialogBox(
                          title: "End date".translate(context),
                          content: Text(
                            "'End date' max 72 hours".translate(context),
                          ),
                        ),
                      );
                    }

                    if (durationd.inHours < 1) {
                      UiUtils.showBlurredDialoge(
                        context,
                        dialoge: BlurredDialogBox(
                          title: "End date".translate(context),
                          content: Text(
                            "'End date' min 1 hours".translate(context),
                          ),
                        ),
                      );
                    }

                    addCloudData("item_details", {
                      "name": adTitleController.text,
                      "slug": adSlugController.text,
                      "description": adDescriptionController.text,
                      if (widget.isEdit != true) "category_id": selectedCategoryList.last,
                      if (widget.isEdit == true) "id": item?.id,
                      "price": price,
                      "contact": adPhoneNumberController.text,
                      // "video_link": adAdditionalDetailsController.text,
                      if (widget.isEdit == true) "delete_item_image_id": deleteItemImageList.join(','),
                      "all_category_ids": widget.isEdit == true ? item!.allCategoryIds : selectedCategoryList.join(','),
                      "startdt": startDate,
                      "enddt": endDate, // hours,
                      "minbid": minBid,
                      "startbid": startBid,
                      "goodscondition": condition == 'New' ? 'baru' : 'bekas',
                      // "image": _pickTitleImage.pickedFile,
                      // "gallery_images": galleryImages,
                    });

                    screenStack++;
                    if (context.read<FetchCustomFieldsCubit>().isEmpty()!) {
                      addCloudData("with_more_details", {
                        "name": adTitleController.text,
                        "slug": adSlugController.text,
                        "description": adDescriptionController.text,
                        if (widget.isEdit != true) "category_id": selectedCategoryList.last,
                        if (widget.isEdit == true) "id": item?.id,
                        "price": price,
                        "contact": adPhoneNumberController.text,
                        // "video_link": adAdditionalDetailsController.text,
                        "all_category_ids": widget.isEdit == true ? item!.allCategoryIds : selectedCategoryList.join(','),
                        if (widget.isEdit == true) "delete_item_image_id": deleteItemImageList.join(','),
                        "startdt": startDate,
                        "enddt": endDate, //hours,
                        "goodscondition": condition == 'New' ? 'baru' : 'bekas',
                        "minbid": minBid,
                        "startbid": startBid,
                        //missing in API
                        /* "image": _pickTitleImage.pickedFile,
                        "gallery_images": galleryImages,*/
                      });

                      // print("_pickTitleImage.pickedFile***${_pickTitleImage.pickedFile}");
                      // print("otherImage***${galleryImages}");
                      Navigator.pushNamed(context, Routes.confirmLocationScreen, arguments: {"isEdit": widget.isEdit, "mainImage": _pickTitleImage.pickedFile, "otherImage": galleryImages});
                    } else {
                      // print("_pickTitleImage.pickedFile11***${_pickTitleImage.pickedFile}");
                      // print("otherImage11***${galleryImages}");
                      Navigator.pushNamed(context, Routes.addMoreDetailsScreen,
                          arguments: {"context": context, "isEdit": widget.isEdit == true, "mainImage": _pickTitleImage.pickedFile, "otherImage": galleryImages}).then((value) {
                        screenStack--;
                      });
                    }
                  }
                }, height: 48.rh(context), fontSize: context.font.large, buttonTitle: "next".translate(context)),
              ),
            ),
            body: Form(
              key: _formKey,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("youAreAlmostThere".translate(context)).size(context.font.large).bold(weight: FontWeight.w600).color(context.color.textColorDark),
                      SizedBox(
                        height: 16.rh(context),
                      ),
                      if (widget.breadCrumbItems != null)
                        SizedBox(
                          height: 20,
                          width: context.screenWidth,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  bool isNotLast = (widget.breadCrumbItems!.length - 1) != index;

                                  return Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          _onBreadCrumbItemTap(index);
                                        },
                                        child: Text(widget.breadCrumbItems![index].name!).firstUpperCaseWidget().color(
                                              isNotLast ? context.color.textColorDark : context.color.territoryColor,
                                            ),
                                      ),
                                      if (index < widget.breadCrumbItems!.length - 1) const Text(" > ").color(context.color.territoryColor),

                                      /*InkWell(
                                    onTap: () {
                                      _onBreadCrumbItemTap(index);
                                    },
                                    child: Text(widget
                                            .breadCrumbItems[index].name)
                                        .firstUpperCaseWidget()
                                        .color(
                                          isNotLast
                                              ? context.color.teritoryColor
                                              : context.color.textColorDark,
                                        ),
                                  ),

                                  ///if it is not last
                                  if (isNotLast)
                                    const Text(" > ")
                                        .color(context.color.teritoryColor)*/
                                    ],
                                  );
                                },
                                itemCount: widget.breadCrumbItems!.length),
                          ),
                        ),
                      SizedBox(
                        height: 18.rh(context),
                      ),
                      Text("adTitle".translate(context)),
                      SizedBox(
                        height: 10.rh(context),
                      ),
                      CustomTextFormField(
                        controller: adTitleController,
                        // controller: _itemNameController,
                        validator: CustomTextFieldValidator.nullCheck,
                        action: TextInputAction.next,
                        capitalization: TextCapitalization.sentences,
                        hintText: "adTitleHere".translate(context),
                        hintTextStyle: TextStyle(color: context.color.textDefaultColor.withOpacity(0.5), fontSize: context.font.large),
                      ),
                      SizedBox(
                        height: 15.rh(context),
                      ),
                      Text("${"adSlug".translate(context)}\t(${"englishOnlyLbl".translate(context)})"),
                      SizedBox(
                        height: 10.rh(context),
                      ),
                      CustomTextFormField(
                        controller: adSlugController,
                        // controller: _itemNameController,
                        validator: CustomTextFieldValidator.slug,
                        action: TextInputAction.next,
                        hintText: "adSlugHere".translate(context),
                        hintTextStyle: TextStyle(color: context.color.textDefaultColor.withOpacity(0.5), fontSize: context.font.large),
                      ),
                      SizedBox(
                        height: 10.rh(context),
                      ),
                      Text("Item condition"),
                      DropdownFormFieldSection(
                        label: '',
                        hint: 'Item Condition',
                        items: conditionData,
                        selectionItem: condition,
                        onCallback: (val) {
                          setState(() {
                            condition = val;
                          });
                        },
                      ),

                      SizedBox(
                        height: 10.rh(context),
                      ),
                      SizedBox(
                        height: 15.rh(context),
                      ),
                      Text("descriptionLbl".translate(context)),
                      SizedBox(
                        height: 15.rh(context),
                      ),
                      CustomTextFormField(
                        controller: adDescriptionController,

                        action: TextInputAction.newline,
                        // controller: _descriptionController,
                        validator: CustomTextFieldValidator.nullCheck,
                        capitalization: TextCapitalization.sentences,
                        hintText: "writeSomething".translate(context),
                        maxLine: 100,
                        minLine: 6,

                        hintTextStyle: TextStyle(color: context.color.textDefaultColor.withOpacity(0.5), fontSize: context.font.large),
                      ),
                      SizedBox(
                        height: 15.rh(context),
                      ),
                      Row(
                        children: [
                          Text("mainPicture".translate(context)),
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
                      SizedBox(
                        height: 10.rh(context),
                      ),
                      Row(
                        children: [
                          Text("otherPictures".translate(context)),
                          const SizedBox(
                            width: 3,
                          ),
                          Text("(Max 10 Images)".translate(context)).italic().size(context.font.small),
                        ],
                      ),
                      SizedBox(
                        height: 10.rh(context),
                      ),
                      itemImagesListener(),
                      SizedBox(
                        height: 10.rh(context),
                      ),
                      Text("Buy now".translate(context)),
                      SizedBox(
                        height: 10.rh(context),
                      ),
                      CustomTextFormField(
                        controller: adPriceController,
                        action: TextInputAction.next,
                        prefix: Text("Rp "),

                        // controller: _priceController,
                        formaters: [
                          FilteringTextInputFormatter.digitsOnly,
                          NumberTextInputFormatter(
                            integerDigits: 10,
                            decimalDigits: 0,
                            // maxValue: '1000000000.00',
                            decimalSeparator: ',',
                            groupDigits: 3,
                            groupSeparator: '.',
                            allowNegative: false,
                            overrideDecimalPoint: true,
                            insertDecimalPoint: false,
                            insertDecimalDigits: true,
                          ),
                        ],
                        isReadOnly: false,
                        keyboard: TextInputType.number,
                        validator: CustomTextFieldValidator.nullCheck,
                        hintText: "00",
                        hintTextStyle: TextStyle(color: context.color.textDefaultColor.withOpacity(0.5), fontSize: context.font.large),
                      ),
                      SizedBox(
                        height: 10.rh(context),
                      ),
                      Text("Open bid".translate(context)),
                      SizedBox(
                        height: 10.rh(context),
                      ),
                      CustomTextFormField(
                        controller: adBidStartController,
                        action: TextInputAction.next,
                        prefix: Text("Rp "),
                        formaters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
                          NumberTextInputFormatter(
                            integerDigits: 10,
                            decimalDigits: 0,
                            // maxValue: '1000000000.00',
                            decimalSeparator: ',',
                            groupDigits: 3,
                            groupSeparator: '.',
                            allowNegative: false,
                            overrideDecimalPoint: true,
                            insertDecimalPoint: false,
                            insertDecimalDigits: true,
                          ),
                        ],
                        isReadOnly: false,
                        keyboard: TextInputType.number,
                        validator: CustomTextFieldValidator.nullCheck,
                        hintText: "00",
                        hintTextStyle: TextStyle(color: context.color.textDefaultColor.withOpacity(0.5), fontSize: context.font.large),
                      ),
                      SizedBox(
                        height: 10.rh(context),
                      ),
                      Text("Minimum Bid"),
                      SizedBox(
                        height: 10.rh(context),
                      ),
                      DropdownFormFieldSection(
                        label: '',
                        hint: 'Minimum bid',
                        items: [],
                        widgetDropdown: minBidData.map((item) {
                          return DropdownMenuItem<String>(
                            value: "$item",
                            child: Text(
                              "${UiUtils().numberFormat(amount: item)}",
                              // style: GoogleFonts.nunito(color: Colors.black),
                            ),
                          );
                        }).toList(),
                        selectionItem: duration,
                        onCallback: (val) {
                          setState(() {
                            minBid = int.parse(val);
                          });
                        },
                      ),

                      SizedBox(
                        height: 10.rh(context),
                      ),
                      Text("Start date option".translate(context)),
                      SizedBox(
                        height: 10.rh(context),
                      ),
                      GestureDetector(
                        onTap: () {
                          dateTimePickerWidget(context, true);
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
                            "${(startDate == null) ? 'Start Date Option' : UiUtils().dateFormatter(startDate.toString(), 2)}",
                            style: TextStyle(
                              fontSize: context.font.large,
                              color: context.color.textDefaultColor.withOpacity(startDate == null ? 0.4 : 1),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.rh(context),
                      ),
                      Row(
                        children: [
                          Text("End date option"),
                          const SizedBox(
                            width: 3,
                          ),
                          Text("(max 3x24 Hours)".translate(context)).italic().size(context.font.small),
                        ],
                      ),
                      SizedBox(
                        height: 10.rh(context),
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
                            "${(endDate == null) ? 'End Date Option' : UiUtils().dateFormatter(endDate.toString(), 2)}",
                            style: TextStyle(
                              fontSize: context.font.large,
                              color: context.color.textDefaultColor.withOpacity(endDate == null ? 0.4 : 1),
                            ),
                          ),
                        ),
                      ),

                      // DropdownFormFieldSection(
                      //   label: '',
                      //   hint: 'Duration',
                      //   items: durationData,
                      //   selectionItem: duration,
                      //   onCallback: (val) {
                      //     setState(() {
                      //       duration = val;
                      //     });
                      //   },
                      // ),

                      // Text("phoneNumber".translate(context)),
                      // SizedBox(
                      //   height: 10.rh(context),
                      // ),

                      // SizedBox(
                      //   height: 10.rh(context),
                      // ),
                      // Text("videoLink".translate(context)),
                      // SizedBox(
                      //   height: 10.rh(context),
                      // ),
                      // CustomTextFormField(
                      //   controller: adAdditionalDetailsController,
                      //   validator: CustomTextFieldValidator.url,
                      //   // prefix: Text("${Constant.currencySymbol} "),
                      //   // controller: _videoLinkController,
                      //   // isReadOnly: widget.properyDetails != null,
                      //   hintText: "http://example.com/video.mp4",
                      //   hintTextStyle: TextStyle(color: context.color.textDefaultColor.withOpacity(0.5), fontSize: context.font.large),
                      // ),
                      SizedBox(
                        height: 15.rh(context),
                      ),
                    ],
                  ),
                ),
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
      firstDate: DateTime.now(),
      lastDate: DateTime(3101),
    ).then((selectedDate) {
      // After selecting the date, display the time picker.
      if (selectedDate != null) {
        DateTime? selectedDateTime;
        showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        ).then((selectedTime) {
          // Handle the selected date and time here.
          if (selectedTime != null) {
            selectedDateTime = DateTime(
              selectedDate.year,
              selectedDate.month,
              selectedDate.day,
              selectedTime.hour,
              selectedTime.minute,
            );
            if (isStart) {
              startDate = selectedDateTime;
            } else {
              endDate = selectedDateTime;
            }
            setState(() {});
            return selectedDateTime;
          }
        }).whenComplete(
          () {
            return selectedDateTime;
          },
        );
      }
      return null;
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

  /*Widget titleImageListener() {
    return _pickTitleImage.listenChangesInUI((context, file) {
      Widget currentWidget = Container();
      if (titleImageURL != "") {
        currentWidget = GestureDetector(
          onTap: () {
            UiUtils.showFullScreenImage(context,
                provider: NetworkImage(titleImageURL));
          },
          child: Container(
              width: 100,
              height: 100,
              margin: const EdgeInsets.all(5),
              clipBehavior: Clip.antiAlias,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: UiUtils.getImage(
                titleImageURL,
                fit: BoxFit.cover,
              )),
        );
      }
      if (file is File) {
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
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: Image.file(
                    file,
                    fit: BoxFit.cover,
                  )),
            ],
          ),
        );
      }

      return Wrap(
        children: [
          if (file == null && titleImageURL == "")
            DottedBorder(
              color: context.color.textLightColor,
              borderType: BorderType.RRect,
              radius: const Radius.circular(12),
              child: GestureDetector(
                onTap: () {
                  showImageSourceDialog(context, (source) {
                    _pickTitleImage.resumeSubscription();
                    _pickTitleImage.pick(
                        pickMultiple: false, context: context, source: source);
                    _pickTitleImage.pauseSubscription();
                    titleImageURL = "";
                    setState(() {});
                  });
                  */ /* _pickTitleImage.resumeSubscription();
                  _pickTitleImage.pick(
                      pickMultiple: false,
                      context: context,
                      source: ImageSource.gallery);
                  _pickTitleImage.pauseSubscription();
                  titleImageURL = "";
                  setState(() {});*/ /*
                },
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  alignment: AlignmentDirectional.center,
                  height: 48.rh(context),
                  child: Text(
                    "addMainPicture".translate(context),
                    style: TextStyle(
                        color: context.color.textDefaultColor,
                        fontSize: context.font.large),
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
          if (file != null || titleImageURL != "")
            uploadPhotoCard(context, onTap: () {
              showImageSourceDialog(context, (source) {
                _pickTitleImage.resumeSubscription();
                _pickTitleImage.pick(
                    pickMultiple: false, context: context, source: source);
                _pickTitleImage.pauseSubscription();
                titleImageURL = "";
                setState(() {});
              });
            })
        ],
      );
    });
  }*/

  Widget titleImageListener() {
    return _pickTitleImage.listenChangesInUI((context, List<File>? files) {
      Widget currentWidget = Container();
      File? file = files?.isNotEmpty == true ? files![0] : null;

      if (titleImageURL.isNotEmpty) {
        currentWidget = GestureDetector(
          onTap: () {
            UiUtils.showFullScreenImage(context, provider: NetworkImage(titleImageURL));
          },
          child: Container(
            width: 100,
            height: 100,
            margin: const EdgeInsets.all(5),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: UiUtils.getImage(
              titleImageURL,
              fit: BoxFit.cover,
            ),
          ),
        );
      }

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
          if (file == null && titleImageURL.isEmpty)
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

  Widget itemImagesListener() {
    return itemImagePicker.listenChangesInUI((context, files) {
      Widget current = Container();

      current = Wrap(
        children: List.generate(mixedItemImageList.length, (index) {
          final image = mixedItemImageList[index];
          return Stack(
            children: [
              GestureDetector(
                onTap: () {
                  HelperUtils.unfocus();
                  if (image is String) {
                    UiUtils.showFullScreenImage(context, provider: NetworkImage(image));
                  } else {
                    UiUtils.showFullScreenImage(context, provider: FileImage(image));
                  }
                },
                child: Container(
                  width: 100.rw(context),
                  height: 100.rw(context),
                  margin: EdgeInsets.all(4.rw(context)),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ImageAdapter(image: image),
                ),
              ),
              closeButton(context, () {
                if (image is String) {
                  deleteItemImageList.add(item!.galleryImages![index].id!);
                }
                mixedItemImageList.removeAt(index);
                setState(() {});
              }),
            ],
          );
        }),
      );

      return Wrap(
        runAlignment: WrapAlignment.start,
        children: [
          if ((files == null || files.isEmpty) && mixedItemImageList.isEmpty)
            DottedBorder(
              color: context.color.textLightColor,
              borderType: BorderType.RRect,
              radius: const Radius.circular(12),
              child: GestureDetector(
                onTap: () {
                  showImageSourceDialog(context, (source) {
                    itemImagePicker.pick(pickMultiple: source == ImageSource.gallery, context: context, imageLimit: 10, maxLength: mixedItemImageList.length, source: source);
                  });
                },
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  alignment: AlignmentDirectional.center,
                  height: 48.rh(context),
                  child: Text("addOtherPicture".translate(context), style: TextStyle(color: context.color.textDefaultColor, fontSize: context.font.large)),
                ),
              ),
            ),
          current,
          if (mixedItemImageList.length < 10)
            if (files != null && files.isNotEmpty || mixedItemImageList.isNotEmpty)
              uploadPhotoCard(context, onTap: () {
                showImageSourceDialog(context, (source) {
                  itemImagePicker.pick(pickMultiple: source == ImageSource.gallery, context: context, imageLimit: 10, maxLength: mixedItemImageList.length, source: source);
                });
              })
        ],
      );
    });
  }

  /* Widget itemImagesListener() {
    return itemImagePicker.listenChangesInUI((context, file) {
      Widget current = Container();

      current = Wrap(
        children: List.generate(mixedItemImageList.length, (index) {
          final image = mixedItemImageList[index];
          return Stack(
            children: [
              GestureDetector(
                onTap: () {
                  HelperUtils.unfocus();
                  if (image is String) {
                    UiUtils.showFullScreenImage(context,
                        provider: NetworkImage(image));
                  } else {
                    UiUtils.showFullScreenImage(context,
                        provider: FileImage(image));
                  }
                },
                child: Container(
                  width: 100,
                  height: 100,
                  margin: const EdgeInsets.all(5),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ImageAdapter(image: image),
                ),
              ),
              closeButton(context, () {
                print("image is string***${image is String}");
                if (image is String) {
                  deleteItemImageList.add(item!.galleryImages![index].id!);
                }

                mixedItemImageList.removeAt(index);
                setState(() {});
              }),
            ],
          );
        }),
      );

      return Wrap(
        runAlignment: WrapAlignment.start,
        children: [
          if (file == null && mixedItemImageList.isEmpty)
            DottedBorder(
              color: context.color.textLightColor,
              borderType: BorderType.RRect,
              radius: const Radius.circular(12),
              child: GestureDetector(
                onTap: () {
                  //showImageSourceDialog(context, (source) {
                  itemImagePicker.pick(
                      pickMultiple: true,
                      context: context,
                      imageLimit: 5,
                      maxLength: mixedItemImageList.length,
                      source: ImageSource.gallery);
                  //});
                },
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  alignment: AlignmentDirectional.center,
                  height: 48.rh(context),
                  child: Text("addOtherPicture".translate(context),
                      style: TextStyle(
                          color: context.color.textDefaultColor,
                          fontSize: context.font.large)),
                ),
              ),
            ),
          current,
          if (mixedItemImageList.length < 5)
            if (file != null || titleImageURL != "")
              uploadPhotoCard(context, onTap: () {
                //showImageSourceDialog(context, (source) {
                itemImagePicker.pick(
                    pickMultiple: true,
                    context: context,
                    imageLimit: 5,
                    maxLength: mixedItemImageList.length,
                    source: ImageSource.gallery);
                //});
              })
        ],
      );
    });
  }*/

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
}
