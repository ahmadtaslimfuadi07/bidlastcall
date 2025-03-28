import 'dart:ui' as ui;

import 'package:eClassify/Ui/screens/widgets/blurred_dialoge_box.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../exports/main_export.dart';
import '../../../utils/AppIcon.dart';
import '../../../utils/Extensions/extensions.dart';
import '../../../utils/responsiveSize.dart';
import '../../../utils/ui_utils.dart';
import '../widgets/AnimatedRoutes/blur_page_route.dart';
import '../widgets/custom_text_form_field.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  ContactUsState createState() => ContactUsState();

  static Route route(RouteSettings routeSettings) {
    return BlurredRouter(builder: (_) => const ContactUs());
  }
}

class ContactUsState extends State<ContactUs> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, (() {
      if (context.read<CompanyCubit>().state is CompanyInitial || context.read<CompanyCubit>().state is CompanyFetchFailure) {
        context.read<CompanyCubit>().fetchCompany(context);
      } else {}
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.backgroundColor,
      appBar: UiUtils.buildAppBar(context, title: "contactUs".translate(context), showBackButton: true),
      body: BlocBuilder<CompanyCubit, CompanyState>(builder: (context, state) {
        if (state is CompanyFetchProgress) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is CompanyFetchSuccess) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("howCanWeHelp".translate(context)).color(context.color.textColorDark).size(context.font.larger).bold(weight: FontWeight.w700),
                SizedBox(
                  height: 10.rh(context),
                ),
                Text("itLooksLikeYouHasError".translate(context)).size(context.font.small).color(context.color.textLightColor),
                SizedBox(
                  height: 15.rh(context),
                ),
                customTile(context, title: "callBtnLbl".translate(context), onTap: () async {
                  var number1 = state.companyData.companyTel1;
                  var number2 = state.companyData.companyTel2;

                  UiUtils.showBlurredDialoge(context,
                      dialoge: BlurredDialogBox(
                        title: "chooseNumber".translate(context),
                        showCancleButton: false,
                        barrierDismissable: true,
                        acceptTextColor: context.color.buttonColor,
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ListTile(
                              title: Text(number1.toString()).centerAlign(),
                              onTap: () async {
                                await launchUrl(Uri.parse("tel:$number1"));
                              },
                            ),
                            ListTile(
                              title: Text(number2.toString()).centerAlign(),
                              onTap: () async {
                                await launchUrl(Uri.parse("tel:$number2"));
                              },
                            ),
                          ],
                        ),
                      ));
                }, svgImagePath: AppIcons.call),
                SizedBox(
                  height: 15.rh(context),
                ),
                customTile(context, title: "companyEmailLbl".translate(context), onTap: () {
                  var email = state.companyData.companyEmail;
                  showEmailDialoge(email);
                }, svgImagePath: AppIcons.message)
              ],
            ),
          );
        } else if (state is CompanyFetchFailure) {
          return Center(
            child: Text(state.errmsg),
          );
        } else {
          return const SizedBox.shrink();
        }
      }),
    );
  }

  showEmailDialoge(email) {
    Navigator.push(
        context,
        BlurredRouter(
          builder: (context) => EmailSendWidget(email: email),
        ));
  }

  Widget customTile(BuildContext context,
      {required String title, required String svgImagePath, bool? isSwitchBox, Function(dynamic value)? onTapSwitch, dynamic switchValue, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: context.color.territoryColor.withOpacity(
                0.10000000149011612,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: FittedBox(fit: BoxFit.none, child: UiUtils.getSvg(svgImagePath, color: context.color.territoryColor)),
          ),
          SizedBox(
            width: 25.rw(context),
          ),
          Text(title).bold(weight: FontWeight.w700).color(context.color.textColorDark),
          const Spacer(),
          if (isSwitchBox != true)
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                border: Border.all(color: context.color.borderColor, width: 1.5),
                color: context.color.secondaryColor.withOpacity(0.10000000149011612),
                borderRadius: BorderRadius.circular(10),
              ),
              child: FittedBox(
                fit: BoxFit.none,
                child: SizedBox(
                  width: 8,
                  height: 15,
                  child: UiUtils.getSvg(
                    AppIcons.arrowRight,
                    color: context.color.textColorDark,
                  ),
                ),
              ),
            ),
          if (isSwitchBox ?? false)
            Switch(
              value: switchValue ?? false,
              onChanged: (value) {
                onTapSwitch?.call(value);
              },
            )
        ],
      ),
    );
  }
}

class EmailSendWidget extends StatefulWidget {
  final String email;
  const EmailSendWidget({
    super.key,
    required this.email,
  });

  @override
  State<EmailSendWidget> createState() => _EmailSendWidgetState();
}

class _EmailSendWidgetState extends State<EmailSendWidget> {
  final TextEditingController _subject = TextEditingController();
  late final TextEditingController _email = TextEditingController(text: widget.email);
  final TextEditingController _text = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.0),
      body: Center(
        child: Container(
          clipBehavior: Clip.antiAlias,
          width: MediaQuery.of(context).size.width - 40,
          decoration: BoxDecoration(
            boxShadow: context.watch<AppThemeCubit>().state.appTheme == AppTheme.dark ? null : [BoxShadow(blurRadius: 3, color: ui.Color.fromARGB(255, 201, 201, 201))],
            color: context.color.secondaryColor,
            borderRadius: BorderRadius.circular(
              10,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(
              20,
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(
                            context,
                          );
                        },
                        child: Container(
                            decoration: BoxDecoration(
                              color: context.color.territoryColor.withOpacity(0.0),
                              shape: BoxShape.circle,
                            ),
                            width: 40,
                            height: 40,
                            child: FittedBox(fit: BoxFit.none, child: UiUtils.getSvg(AppIcons.arrowLeft))),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20.rh(context),
                  ),
                  Text("sendEmail".translate(context)),
                  SizedBox(
                    height: 15.rh(context),
                  ),
                  CustomTextFormField(
                    controller: _subject,
                    hintText: "subject".translate(context),
                  ),
                  SizedBox(
                    height: 15.rh(context),
                  ),
                  CustomTextFormField(
                    controller: _email,
                    isReadOnly: true,
                    hintText: "companyEmailLbl".translate(context),
                  ),
                  SizedBox(
                    height: 15.rh(context),
                  ),
                  CustomTextFormField(
                    controller: _text,
                    maxLine: 100,
                    hintText: "writeSomething".translate(context),
                    minLine: 5,
                  ),
                  SizedBox(
                    height: 15.rh(context),
                  ),
                  UiUtils.buildButton(context, onPressed: () async {
                    Uri redirecturi = Uri(scheme: 'mailto', path: _email.text, query: 'subject=${_subject.text}&body=${_text.text}');
                    await launchUrl(redirecturi);
                  }, height: 50.rh(context), buttonTitle: "sendEmail".translate(context))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
