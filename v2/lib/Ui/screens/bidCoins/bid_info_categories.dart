import 'package:eClassify/Ui/screens/Widgets/AnimatedRoutes/blur_page_route.dart';
import 'package:eClassify/Utils/AppIcon.dart';
import 'package:eClassify/Utils/Extensions/extensions.dart';
import 'package:eClassify/Utils/responsiveSize.dart';
import 'package:eClassify/Utils/ui_utils.dart';
import 'package:eClassify/exports/main_export.dart';
import 'package:flutter/material.dart';

class BidInfoCategories extends StatefulWidget {
  const BidInfoCategories({super.key});

  @override
  State<BidInfoCategories> createState() => _BidInfoCategoriesState();
  static Route route(RouteSettings routeSettings) {
    // Map? args = routeSettings.arguments as Map?;
    return BlurredRouter(
      builder: (_) => BidInfoCategories(),
    );
  }
}

class _BidInfoCategoriesState extends State<BidInfoCategories> {
  Widget buildSearchIcon() {
    return Padding(padding: EdgeInsetsDirectional.only(start: 16.0, end: 16), child: UiUtils.getSvg(AppIcons.search, color: context.color.territoryColor));
  }

  @override
  void initState() {
    context.read<FetchCategoryCubit>().searchData('');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiUtils.buildAppBar(
        context,
        showBackButton: true,
        // onBackPress: () {},
        title: "Info",
      ),
      body: BlocConsumer<FetchCategoryCubit, FetchCategoryState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is FetchCategorySuccess) {
            return Column(
              children: [
                Container(
                    margin: EdgeInsets.all(12),
                    width: context.screenWidth,
                    height: 56.rh(
                      context,
                    ),
                    alignment: AlignmentDirectional.center,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: context.color.borderColor.darken(30)), borderRadius: const BorderRadius.all(Radius.circular(10)), color: context.color.secondaryColor),
                    child: TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none, //OutlineInputBorder()
                          fillColor: Theme.of(context).colorScheme.secondaryColor,
                          hintText: "searchHintLbl".translate(context),
                          hintStyle: TextStyle(color: context.color.textDefaultColor.withOpacity(0.5)),
                          prefixIcon: buildSearchIcon(),
                          prefixIconConstraints: const BoxConstraints(minHeight: 5, minWidth: 5),
                        ),
                        enableSuggestions: true,
                        onEditingComplete: () {
                          FocusScope.of(context).unfocus();
                        },
                        onChanged: (value) {
                          context.read<FetchCategoryCubit>().searchData(value);
                        },
                        onTap: () {
                          //change prefix icon color to primary
                        })),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.categoriesSearch.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${state.categoriesSearch[index].name}",
                                  ).size(context.font.large).color(context.color.textDefaultColor).bold(),
                                  Text(
                                    "Price Coins",
                                  ).size(context.font.normal).color(context.color.textDefaultColor),
                                ],
                              ),
                              Divider(thickness: 0.5),
                              if (state.categoriesSearch[index].children?.isNotEmpty ?? [].isEmpty)
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: state.categoriesSearch[index].children?.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index2) {
                                    var data = state.categoriesSearch[index].children?[index2];
                                    return Padding(
                                      padding: const EdgeInsets.fromLTRB(12.0, 8, 8, 8),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 40,
                                            width: 40,
                                            margin: EdgeInsets.only(right: 8),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(18),
                                              child: Container(
                                                height: 70,
                                                width: double.infinity,
                                                color: context.color.secondaryColor,
                                                child: UiUtils.imageType(data?.url ?? '', fit: BoxFit.cover),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              "${data?.name}",
                                            ).size(context.font.large).color(context.color.textDefaultColor),
                                          ),
                                          Text(
                                            "${data?.cost}",
                                          ).size(context.font.large).color(context.color.textDefaultColor).bold(),
                                        ],
                                      ),
                                    );
                                  },
                                )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
