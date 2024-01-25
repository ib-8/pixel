import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:super_pixel/controller/asset_detail_controller.dart';
import 'package:super_pixel/model/event.dart';
import 'package:super_pixel/model/expenses.dart';
import 'package:super_pixel/ui/sheets/association_form.dart';
import 'package:super_pixel/ui/sheets/dissociation_form.dart';
import 'package:super_pixel/ui/state_builder.dart';
import 'package:super_pixel/ui/widget/app_sheet.dart';
import 'package:super_pixel/ui/widget/app_text.dart';
import 'package:super_pixel/utils/asset_status.dart';
import 'package:super_pixel/utils/asset_expense_type.dart';
import 'package:super_pixel/utils/event_type.dart';
import 'package:url_launcher/url_launcher.dart';

class AssetDetailsPage extends StatelessWidget {
  final List<List<String>> rowsData;

  AssetDetailsPage({required this.rowsData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asset Details'),
      ),
      body: ListView.builder(
        itemCount: rowsData.length,
        itemBuilder: (context, index) {
          List<String> rowData = rowsData[index];

          return Card(
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: rowData.map((cellData) {
                  return Text(
                    cellData,
                    style: const TextStyle(fontSize: 16.0),
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}

class AssetDetail extends StatefulWidget {
  const AssetDetail(
      {required this.assetId, this.showForWeb = false, super.key});

  final String assetId;
  final bool showForWeb;
  @override
  State<AssetDetail> createState() => _AssetDetailState();
}

class _AssetDetailState extends State<AssetDetail>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    AssetDetailController.init(widget.assetId);
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    print('<<<<object>>>>');
    AssetDetailController.getInstance(widget.assetId).getDetail();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    AssetDetailController.close(widget.assetId);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StateBuilder(
      controller: AssetDetailController.getInstance(widget.assetId),
      builder: (context, data) {
        if (data.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (data.asset == null) {
          return const Scaffold(
            body: Center(
              child: AppText(
                '404',
                weight: FontWeight.bold,
                size: 150,
                color: Color.fromARGB(255, 77, 56, 81),
              ),
            ),
          );
        }

        var asset = data.asset!;

        print('events length ${data.events.length}');

        if (widget.showForWeb) {
          return Scaffold(
            // appBar: AppBar(
            //   title: AppText('Product Details'),
            // ),
            body: Center(
              child: Card(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppText(
                        'Product Details',
                        weight: FontWeight.bold,
                        size: 20,
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppText('Product Name: '),
                          SizedBox(width: 20),
                          AppText(
                            asset.model,
                            weight: FontWeight.bold,
                            size: 18,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppText('Product Owner: '),
                          SizedBox(width: 20),
                          AppText(
                            asset.owner,
                            weight: FontWeight.bold,
                            size: 18,
                          ),
                        ],
                      ),
                      SizedBox(height: 50),
                      AppText(
                        'This product belongs to Superops Technologies',
                        weight: FontWeight.bold,
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppText(
                            'Contact Details',
                            weight: FontWeight.bold,
                            align: TextAlign.center,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () async {
                                final Uri launchUri = Uri(
                                  scheme: 'tel',
                                  path: '9790943238',
                                );
                                await launchUrl(launchUri);
                              },
                              icon: Icon(Icons.phone)),
                          IconButton(
                              onPressed: () async {
                                final Uri launchUri = Uri(
                                  scheme: 'mailto',
                                  path: 'contact@superops.ai',
                                );
                                await launchUrl(launchUri);
                              },
                              icon: Icon(Icons.mail)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            actions: [
              // IconButton(
              //   icon: Icon(Icons.refresh),
              //   onPressed: () {
              //     AssetDetailController.getInstance(widget.assetId).getDetail();
              //   },
              // )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        AppText(
                          asset.model,
                          size: 20,
                          weight: FontWeight.bold,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Builder(builder: (context) {
                              var isExpired =
                                  DateTime.tryParse(asset.warrantyEndDate)
                                      ?.difference(DateTime.now());

                              print('expise ${isExpired?.inDays}');

                              if (isExpired != null) {
                                return Card(
                                  margin: EdgeInsets.zero,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 10.0),
                                    child: AppText(
                                      isExpired.isNegative
                                          ? 'Warranty Expired'
                                          : 'Warranty Expire in ${isExpired.inDays.toString()} days',
                                      weight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              }

                              return const SizedBox();
                            }),
                            const SizedBox(width: 20),
                            Card(
                              margin: EdgeInsets.zero,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10.0),
                                child: AppText(
                                  asset.status,
                                  weight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    if (asset.owner.isNotEmpty)
                      const AppText(
                        'Owner: ',
                      ),
                    const SizedBox(width: 20),
                    AppText(
                      asset.owner,
                      weight: FontWeight.bold,
                    ),
                  ],
                ),
                SizedBox(
                  height: 80,
                  width: 80,
                  child: PrettyQrView.data(
                    data: 'https://superpixelapp.web.app/${widget.assetId}',
                    decoration: const PrettyQrDecoration(),
                  ),
                ),
                const SizedBox(height: 10),
                TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(
                      child: AppText('Events'),
                    ),
                    Tab(
                      child: AppText('Expenses'),
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      AssetEvents(events: data.events),
                      AssetExpenses(expenses: data.expenses),
                    ],
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: Builder(
            builder: (context) {
              if (data.asset!.status == AssetStatus.inStock ||
                  data.asset!.status == AssetStatus.inUse) {
                return FloatingActionButton(
                  onPressed: () async {
                    await AppSheet.show(
                      context: context,
                      builder: (context) {
                        if (data.asset!.status == AssetStatus.inUse) {
                          return DissociationForm(assetId: data.asset!.id);
                        } else {
                          return AssociationForm(assetId: data.asset!.id);
                        }
                      },
                    );

                    AssetDetailController.getInstance(widget.assetId)
                        .getDetail();
                  },
                  child: const Icon(Icons.account_tree),
                );
              }

              return const SizedBox();
            },
          ),
        );
      },
    );
  }
}

class AssetEvents extends StatefulWidget {
  const AssetEvents({
    required this.events,
    super.key,
  });

  final List<Event> events;

  @override
  State<AssetEvents> createState() => _AssetEventsState();
}

class _AssetEventsState extends State<AssetEvents> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.events.length,
      itemBuilder: (context, index) {
        var event = widget.events[index];
        var eventLog = '';
        switch (event.type) {
          case EvenType.purchased:
            eventLog = '${EvenType.purchased} from ${event.vendor}';
            break;
          case EvenType.associated:
            eventLog = '${EvenType.associated} to ${event.employee}';
            break;
          case EvenType.dissociated:
            eventLog = '${EvenType.dissociated} from ${event.employee}';
            break;
          case EvenType.disposed:
            eventLog = '${EvenType.disposed}';
            break;
          case EvenType.missed:
            eventLog = '${EvenType.missed}';
            break;
          case EvenType.sentToService:
            eventLog = '${EvenType.sentToService}';
            break;
          case EvenType.receivedFromService:
            eventLog = '${EvenType.receivedFromService}';
            break;
        }
        return Card(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Row(
              children: [
                AppText(event.eventTime?.getDayAndMonth() ?? ''),
                const SizedBox(width: 20),
                AppText(eventLog),
              ],
            ),
          ),
        );
      },
    );
  }
}

extension DateTimeExtension on DateTime {
  String getDayAndMonth() {
    return DateFormat('yyy, MMM dd').format(this);
  }
}

class AssetExpenses extends StatefulWidget {
  const AssetExpenses({
    required this.expenses,
    super.key,
  });

  final List<Expenses> expenses;

  @override
  State<AssetExpenses> createState() => _AssetExpensesState();
}

class _AssetExpensesState extends State<AssetExpenses> {
  @override
  Widget build(BuildContext context) {
    var isMobile = Platform.isAndroid || Platform.isIOS;

    var total = 0;
    for (var element in widget.expenses) {
      total = total + int.parse(element.amount);
    }
    return Column(
      children: [
        SizedBox(height: 10),
        AppText(
          'Total Expense so far \n ₹$total',
          size: 20,
          weight: FontWeight.bold,
          align: TextAlign.center,
          color: Color.fromARGB(255, 77, 56, 81),
        ),
        SizedBox(height: 10),
        Flexible(
          child: ListView.builder(
            itemCount: widget.expenses.length,
            itemBuilder: (context, index) {
              var expenses = widget.expenses[index];
              var expenseLog = '';
              switch (expenses.type) {
                case AssetExpenseType.newPurchase:
                  expenseLog =
                      '${EvenType.purchased} - amount ${expenses.amount}';
                  break;
                case AssetExpenseType.repair:
                  expenseLog =
                      '${AssetExpenseType.repair} Reason - ${expenses.note} amount spent ${expenses.amount}';
                  break;
                case AssetExpenseType.replacement:
                  expenseLog =
                      '${AssetExpenseType.replacement} Reason - ${expenses.note}  amount spent ${expenses.amount}';
                  break;
              }

              if (isMobile) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                AppText(expenses.date?.getDayAndMonth() ?? ''),
                                const SizedBox(width: 20),
                                AppText(
                                  expenses.type,
                                  weight: FontWeight.bold,
                                ),
                                const SizedBox(width: 20),
                              ],
                            ),
                            AppText(expenses.note),
                            AppText(
                              '₹ ${expenses.amount}',
                              weight: FontWeight.bold,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const SizedBox(width: 20),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  barrierDismissible: true,
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      backgroundColor: Colors.transparent,
                                      child: Image.network(
                                        'https://img.freepik.com/free-vector/minimal-yellow-invoice-template-vector-design_1017-12070.jpg',
                                        // height: 50,
                                        // width: 50,
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Image.network(
                                'https://img.freepik.com/free-vector/minimal-yellow-invoice-template-vector-design_1017-12070.jpg',
                                height: 50,
                                width: 50,
                              ),
                            ),
                            const SizedBox(width: 20),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          AppText(expenses.date?.getDayAndMonth() ?? ''),
                          SizedBox(width: 20),
                          AppText(
                            expenses.type,
                            weight: FontWeight.bold,
                          ),
                          SizedBox(width: 20),
                          AppText(expenses.note),
                        ],
                      ),
                      Row(
                        children: [
                          AppText(
                            '₹ ${expenses.amount}',
                            weight: FontWeight.bold,
                          ),
                          SizedBox(width: 20),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                  barrierDismissible: true,
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      backgroundColor: Colors.transparent,
                                      child: Image.network(
                                        'https://img.freepik.com/free-vector/minimal-yellow-invoice-template-vector-design_1017-12070.jpg',
                                        // height: 50,
                                        // width: 50,
                                      ),
                                    );
                                  });
                            },
                            child: Image.network(
                              'https://img.freepik.com/free-vector/minimal-yellow-invoice-template-vector-design_1017-12070.jpg',
                              height: 50,
                              width: 50,
                            ),
                          ),
                          SizedBox(width: 20),
                        ],
                      ),
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
}
