import 'package:eClassify/Ui/screens/Widgets/AnimatedRoutes/blur_page_route.dart';
import 'package:eClassify/Ui/screens/Widgets/Errors/something_went_wrong.dart';
import 'package:eClassify/Ui/screens/Widgets/shimmerLoadingContainer.dart';
import 'package:eClassify/Utils/Extensions/extensions.dart';
import 'package:eClassify/Utils/responsiveSize.dart';
import 'package:eClassify/Utils/ui_utils.dart';
import 'package:eClassify/data/cubits/Utility/fetch_history_detail_bid_cubit.dart';
import 'package:eClassify/data/model/item/item_detail_model.dart';
import 'package:eClassify/exports/main_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class TransactionHistoryBidDetailScreen extends StatefulWidget {
  final int id;
  final bool isBid;
  const TransactionHistoryBidDetailScreen({super.key, required this.id, required this.isBid});

  @override
  State<TransactionHistoryBidDetailScreen> createState() => _TransactionHistoryBidDetailScreenState();

  static Route route(RouteSettings routeSettings) {
    Map? args = routeSettings.arguments as Map?;
    return BlurredRouter(
      builder: (_) => TransactionHistoryBidDetailScreen(
        id: args?['id'],
        isBid: args?['isBid'] ?? true,
      ),
    );
  }
}

class _TransactionHistoryBidDetailScreenState extends State<TransactionHistoryBidDetailScreen> {
  @override
  void initState() {
    context.read<FetchHistoryDetailBidCubit>().fetchHistoryDetailBid(widget.id);
    super.initState();
  }

  bool compareDate(String date) {
    DateTime dateNow = DateTime.now();
    DateTime newDate = DateTime.parse(date);

    if (dateNow.compareTo(newDate) >= 0) {
      return true; //isexpired
    }
    return false; //not expired
  }

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
        child: BlocConsumer<FetchHistoryDetailBidCubit, FetchHistoryDetailBidState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is FetchHistoryDetailBidInProgress) {
              return historyShimmer();
            }
            if (state is FetchHistoryDetailBidFailure) {
              return const SomethingWentWrong();
            }
            if (state is FetchHistoryDetailBidSuccess) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  detailProduct(state.historyData),
                  (state.historyData.itemPayment != null)
                      ? detailPesanan(state.historyData.itemPayment!, state.historyData.bids ?? [])
                      : widget.isBid
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: UiUtils.buildButton(context, onPressed: () {
                                // int total = 0;
                                // total += state.historyData.itemBid?.bidPrice ?? 0;
                                if (!compareDate(state.historyData.expirePaymentAt ?? '2025-01-01')) {
                                  Navigator.pushNamed(
                                    context,
                                    Routes.transactionUpload,
                                    arguments: {
                                      'amount': state.historyData.buyerbillprice,
                                      'itemId': state.historyData.id.toString(),
                                      'ongkirOpts': state.historyData.ongkirOpts,
                                    },
                                  );
                                }
                              },
                                  buttonTitle: 'Upload Proof of Payment',
                                  height: 30.rh(context),
                                  width: 50.rw(context),
                                  radius: 2,
                                  fontSize: 14,
                                  padding: EdgeInsets.all(
                                    12,
                                  )),
                            )
                          : SizedBox.shrink(),
                  if (state.historyData.itemPayment != null && widget.isBid)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: UiUtils.buildButton(context, onPressed: () {
                        launchWhatsapp(
                          state.historyData.id.toString(),
                          state.historyData.itemPayment?.id.toString() ?? '',
                          state.historyData.name ?? '',
                          state.historyData.enddt ?? '',
                        );
                      },
                          buttonTitle: 'Complain',
                          height: 30.rh(context),
                          width: 50.rw(context),
                          radius: 2,
                          fontSize: 14,
                          padding: EdgeInsets.all(
                            12,
                          )),
                    ),
                  if (state.historyData.itemBid != null) detailAlamat(state.historyData.itemBid!),
                  if (!widget.isBid && state.historyData.itemPayment != null) pencairan(state.historyData.itemPayment!, state.historyData.totalcloseprice ?? 0),
                ],
              );
            }
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget historyShimmer() {
    return ListView.builder(
      itemCount: 4,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsetsDirectional.all(8),
          margin: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
          decoration: BoxDecoration(color: context.color.secondaryColor, border: Border.all(color: context.color.borderColor, width: 1.5), borderRadius: BorderRadius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomShimmer(height: 70, width: 70),
                  const SizedBox(width: 26),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomShimmer(height: 20, width: 40),
                        const SizedBox(height: 10),
                        CustomShimmer(height: 20),
                        const SizedBox(height: 10),
                        CustomShimmer(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CustomShimmer(height: 20, width: 80),
              const SizedBox(height: 10),
              CustomShimmer(height: 20),
              const SizedBox(height: 10),
              CustomShimmer(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget detailProduct(ItemDetailModel data) {
    int total = 0;

    // if (widget.isBid) {
    //   total = (data.closeprice ?? 0) + (data.servicefee ?? 0);
    // } else {
    //   total += data.itemBid?.bidPrice ?? 0;
    // }

    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 8, 0),
      margin: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
      decoration: BoxDecoration(color: context.color.secondaryColor, border: Border.all(color: context.color.borderColor, width: 1.5), borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: UiUtils.getImage(
                    data.image ?? '',
                    width: 70,
                    height: 70 /*statusButton != null ? 90 : 120*/,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: (widget.isBid)
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: context.color.territoryColor.withOpacity(0.1)),
                            padding: EdgeInsets.symmetric(vertical: 3, horizontal: 7),
                            child: Text(data.name ?? '').size(context.font.small).color(context.color.territoryColor),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              "Price : Rp. ${UiUtils().numberFormat(amount: data.price)}",
                              textAlign: TextAlign.end,
                            ).size(context.font.small).color(context.color.textDefaultColor),
                          ),
                          SizedBox(height: 6),
                          if (data.itemBid != null)
                            Align(
                              alignment: Alignment.topRight,
                              child: Text(
                                "Last Bid  : Rp. ${UiUtils().numberFormat(amount: data.itemBid?.bidPrice)}",
                                textAlign: TextAlign.end,
                              ).size(context.font.small).color(context.color.textDefaultColor).bold(),
                            ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: context.color.territoryColor.withOpacity(0.1)),
                            padding: EdgeInsets.symmetric(vertical: 3, horizontal: 7),
                            child: Text(data.name ?? '').size(context.font.small).color(context.color.territoryColor),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              "Price : Rp. ${UiUtils().numberFormat(amount: data.price)}",
                              textAlign: TextAlign.end,
                            ).size(context.font.small).color(context.color.textDefaultColor),
                          ),
                          SizedBox(height: 6),
                          Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              "Start Bid : Rp. ${UiUtils().numberFormat(amount: data.startbid)}",
                              textAlign: TextAlign.end,
                            ).size(context.font.small).color(context.color.textDefaultColor),
                          ),
                          SizedBox(height: 6),
                          Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              "Closed Proce  : Rp. ${UiUtils().numberFormat(amount: data.closeprice ?? 0)}",
                              textAlign: TextAlign.end,
                            ).size(context.font.small).color(context.color.textDefaultColor).bold(),
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
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text(
                //       'Subtotal',
                //     ).size(context.font.small).color(context.color.textDefaultColor),
                //     Text(
                //       'Rp. ${UiUtils().numberFormat(amount: data.itemBid?.bidPrice)}',
                //     ).size(context.font.small).color(context.color.textDefaultColor),
                //   ],
                // ),
                if (widget.isBid && data.itemPayment == null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Bayar sebelum',
                        ).size(context.font.small).color(context.color.textDefaultColor),
                        Text(
                          '${UiUtils().dateFormatter(data.expirePaymentAt ?? '2024-01-01', 11)}',
                        ).size(context.font.small),
                      ],
                    ),
                  ),
                if (widget.isBid && data.itemPayment == null && compareDate(data.expirePaymentAt ?? '2025-01-01'))
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          ' ',
                        ).size(context.font.small).color(context.color.textDefaultColor),
                        Text(
                          'Waktu pembayaran sudah lewat',
                        ).size(context.font.small).color(Colors.red).bold(),
                      ],
                    ),
                  ),
                if (!widget.isBid && data.itemPayment != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Service Type',
                        ).size(context.font.small).color(context.color.textDefaultColor),
                        Text(
                          '${data.itemPayment?.shippingservice}',
                        ).size(context.font.small),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Shipping Fee',
                      ).size(context.font.small).color(context.color.textDefaultColor),
                      Text(
                        'Rp. ${UiUtils().numberFormat(amount: data.shippingfee ?? 0)}',
                      ).size(context.font.small).color(context.color.textDefaultColor),
                    ],
                  ),
                ),

                if (widget.isBid)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Service Fee',
                        ).size(context.font.small).color(context.color.textDefaultColor),
                        Text(
                          'Rp. ${UiUtils().numberFormat(amount: data.servicefee ?? 0)}',
                        ).size(context.font.small).color(Colors.red),
                      ],
                    ),
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
                'Rp. ${UiUtils().numberFormat(amount: widget.isBid ? data.buyerbillprice : data.totalcloseprice)}',
              ).size(context.font.large).color(context.color.textDefaultColor).bold(),
            ],
          ),
          if (!widget.isBid && data.itemPayment == null)
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: EdgeInsets.only(top: 12, left: 8),
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: context.color.territoryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  "Payment Status :  Not yet paid by the buyer }",
                ).size(context.font.normal).color(context.color.textDefaultColor).size(10.rf(context)),
              ),
            ),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget detailPesanan(ItemPayment data, List<Bids> dataBids) {
    var status = '';
    Color statusColor = context.color.territoryColor;
    Color statusColorBg = context.color.territoryColor.withOpacity(0.1);
    if (data.status == 'review') {
      status = 'On Review';
    } else {
      status = data.status ?? '';
      statusColor = Colors.green;
      statusColorBg = Colors.green.withOpacity(0.1);
    }
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
                          '${data.id}',
                        ).size(context.font.small).color(context.color.textDefaultColor),
                        GestureDetector(
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: "${data.id}"));
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Copied to clipboard")));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            margin: EdgeInsets.only(left: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: context.color.textDefaultColor.withOpacity(0.4)),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Copy',
                            ).size(context.font.small).color(context.color.textDefaultColor),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                // SizedBox(
                //   height: 8,
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text(
                //       'Payment Method',
                //     ).size(context.font.small).color(context.color.textDefaultColor),
                //     Text(
                //       'BCA Bank Transfer',
                //     ).size(context.font.small).color(context.color.textDefaultColor),
                //   ],
                // ),
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
                      '${UiUtils().dateFormatter(dataBids.last.createdAt ?? '2024-01-01', 11)}',
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
                      '${UiUtils().dateFormatter(data.createdAt ?? '2024-01-01', 11)}',
                    ).size(context.font.small).color(context.color.textDefaultColor),
                  ],
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: statusColorBg),
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 7),
              margin: EdgeInsets.only(top: 12),
              child: Text(status.toUpperCase()).size(context.font.small).color(statusColor),
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  void launchWhatsapp(String id, String idPayment, String namaBarang, String tgl) async {
    String namePhone = '';

    String textWa = '';

    textWa = 'Hai admin. \nID Transaksi : $idPayment \nID Barang : $id \nNama Barang: $namaBarang \nTanggal Trx: $tgl \nMau melakukan komplain karena, \n';

    String url = "https://wa.me/6281389901460?text=$textWa";
    await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
  }

  Widget pencairan(ItemPayment data, int totalPrice) {
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
                      'Pencairan',
                    ).size(context.font.normal).color(context.color.textDefaultColor).bold(),
                    Text(
                      '${data.istransfered == 0 ? 'Menunggu Pencairan' : 'Sudah Lunas'}',
                    ).size(context.font.normal).color(context.color.textDefaultColor),
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
                      'Estimated payment date',
                    ).size(context.font.small).color(context.color.textDefaultColor),
                    Text(
                      '${UiUtils().dateFormatter(data.estimatePaymentAt ?? '2024-01-01', 3)}',
                    ).size(context.font.small).color(context.color.textDefaultColor),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total pencairan',
                    ).size(context.font.small).color(context.color.textDefaultColor),
                    Text(
                      '${UiUtils().numberFormat(amount: totalPrice)}',
                    ).size(context.font.small).color(context.color.textDefaultColor),
                  ],
                ),
                SizedBox(height: 8),
                if (data.istransfered == 1)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: UiUtils.getImage(
                      data.imgtransfer ?? '',
                      fit: BoxFit.cover,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget detailAlamat(ItemBid data) {
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
                            data.winnerUname ?? '',
                          ).size(context.font.normal).color(context.color.textDefaultColor),
                          // Text(
                          //   '(+62) 896-1234-1234',
                          // ).size(context.font.small).color(context.color.textDefaultColor.withOpacity(0.5)),
                          Text(
                            data.winnerAddress ?? '',
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
