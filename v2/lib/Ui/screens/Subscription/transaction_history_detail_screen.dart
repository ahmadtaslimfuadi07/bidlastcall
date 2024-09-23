import 'package:eClassify/Ui/screens/Widgets/AnimatedRoutes/blur_page_route.dart';
import 'package:eClassify/Utils/Extensions/extensions.dart';
import 'package:eClassify/Utils/ui_utils.dart';
import 'package:flutter/material.dart';

class TransactionHistoryDetailScreen extends StatefulWidget {
  const TransactionHistoryDetailScreen({super.key});

  @override
  State<TransactionHistoryDetailScreen> createState() => _TransactionHistoryDetailScreenState();

  static Route route(RouteSettings routeSettings) {
    // Map? args = routeSettings.arguments as Map?;
    return BlurredRouter(
      builder: (_) => TransactionHistoryDetailScreen(),
    );
  }
}

class _TransactionHistoryDetailScreenState extends State<TransactionHistoryDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiUtils.buildAppBar(
        context,
        showBackButton: true,
        // onBackPress: () {},
        title: "Transaction Detail",
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            detailProduct(),
            detailPesanan(),
            detailAlamat(),
          ],
        ),
      ),
    );
  }

  Widget detailProduct() {
    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
      margin: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
      decoration: BoxDecoration(color: context.color.secondaryColor, border: Border.all(color: context.color.borderColor, width: 1.5), borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: UiUtils.getImage(
                  'https://img.lazcdn.com/g/p/4d6ecdcb03101eaddf11ab26951db1b2.jpg_720x720q80.jpg',
                  height: 70 /*statusButton != null ? 90 : 120*/,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: context.color.territoryColor.withOpacity(0.1)),
                      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 7),
                      child: Text(
                        'Sepatu nike kualitas super ajaib bonus dus dan booblewrap',
                      ).size(context.font.small).color(context.color.territoryColor),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Rp. 100",
                          textAlign: TextAlign.end,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Merchandise Subtotal',
                    ).size(context.font.small).color(context.color.textDefaultColor),
                    Text(
                      'Rp. 100',
                    ).size(context.font.small).color(context.color.textDefaultColor),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Shipping Fee',
                    ).size(context.font.small).color(context.color.textDefaultColor),
                    Text(
                      'Rp. 15.000',
                    ).size(context.font.small).color(context.color.textDefaultColor),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Service Fee',
                    ).size(context.font.small).color(context.color.textDefaultColor),
                    Text(
                      'Rp. 1.000',
                    ).size(context.font.small).color(context.color.textDefaultColor),
                  ],
                ),
              ],
            ),
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Order Total',
              ).size(context.font.normal).color(context.color.textDefaultColor),
              SizedBox(width: 8),
              Text(
                'Rp. 16.100',
              ).size(context.font.large).color(context.color.textDefaultColor).bold(),
            ],
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget detailPesanan() {
    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
      margin: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
      decoration: BoxDecoration(color: context.color.secondaryColor, border: Border.all(color: context.color.borderColor, width: 1.5), borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Order ID',
                    ).size(context.font.normal).color(context.color.textDefaultColor).bold(),
                    Row(
                      children: [
                        Text(
                          '29009189183402',
                        ).size(context.font.small).color(context.color.textDefaultColor),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          margin: EdgeInsets.only(left: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: context.color.textDefaultColor.withOpacity(0.4)),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Copy',
                          ).size(context.font.small).color(context.color.textDefaultColor),
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Payment Method',
                    ).size(context.font.small).color(context.color.textDefaultColor),
                    Text(
                      'BCA Bank Transfer',
                    ).size(context.font.small).color(context.color.textDefaultColor),
                  ],
                ),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Order Time',
                    ).size(context.font.small).color(context.color.textDefaultColor),
                    Text(
                      '08-08-2024 21:04',
                    ).size(context.font.small).color(context.color.textDefaultColor),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Payment Time',
                    ).size(context.font.small).color(context.color.textDefaultColor),
                    Text(
                      '08-08-2024 21:40',
                    ).size(context.font.small).color(context.color.textDefaultColor),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Ship Time',
                    ).size(context.font.small).color(context.color.textDefaultColor),
                    Text(
                      '09-08-2024 21:40',
                    ).size(context.font.small).color(context.color.textDefaultColor),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget detailAlamat() {
    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
      margin: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
      decoration: BoxDecoration(color: context.color.secondaryColor, border: Border.all(color: context.color.borderColor, width: 1.5), borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Delivery Information',
                    ).size(context.font.normal).color(context.color.textDefaultColor).bold(),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.location_pin),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Jimmny Lee',
                          ).size(context.font.normal).color(context.color.textDefaultColor),
                          Text(
                            '(+62) 896-1234-1234',
                          ).size(context.font.small).color(context.color.textDefaultColor.withOpacity(0.5)),
                          Text(
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                          ).size(context.font.small).color(context.color.textDefaultColor.withOpacity(0.5)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}
