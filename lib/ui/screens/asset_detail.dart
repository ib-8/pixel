import 'package:flutter/material.dart';
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

class AssetDetailsPage extends StatelessWidget {
  final List<List<String>> rowsData;

  AssetDetailsPage({required this.rowsData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Asset Details>>'),
      ),
      body: ListView.builder(
        itemCount: rowsData.length,
        itemBuilder: (context, index) {
          List<String> rowData = rowsData[index];

          return Card(
            margin: EdgeInsets.all(8.0),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: rowData.map((cellData) {
                  return Text(
                    cellData,
                    style: TextStyle(fontSize: 16.0),
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
  const AssetDetail({required this.assetId, super.key});

  final String assetId;
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
  void dispose() {
    AssetDetailController.close(widget.assetId);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StateBuilder(
      controller: AssetDetailController(widget.assetId),
      builder: (context, data) {
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
        return Scaffold(
          appBar: AppBar(),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      asset.model,
                      size: 20,
                      weight: FontWeight.bold,
                    ),
                    Card(
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
                Row(
                  children: [
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
                )
              ],
            ),
          ),
          floatingActionButton: Builder(builder: (context) {
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

                  AssetDetailController.getInstance(widget.assetId).getDetail();
                },
              );
            }

            return const SizedBox();
          }),
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
              eventLog = '${EvenType.associated} with ${event.employee}';
              break;
            case EvenType.dissociated:
              eventLog = '${EvenType.dissociated} by ${event.employee}';
              break;
            case EvenType.disposed:
              eventLog = '${EvenType.disposed} by ${event.employee}';
              break;
            case EvenType.missed:
              eventLog = '${event.assetId} is ${EvenType.missed}';
              break;
            case EvenType.sentToService:
              eventLog = '${event.assetId} is ${EvenType.sentToService}';
              break;
            case EvenType.receivedFromService:
              eventLog = '${event.assetId} is ${EvenType.sentToService}';
              break;
          }
          return AppText(eventLog);
        });
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
    return ListView.builder(
        itemCount: widget.expenses.length,
        itemBuilder: (context, index) {
          var expenses = widget.expenses[index];
          var expenseLog = '';
          switch (expenses.type) {
            case AssetExpenseType.newPurchase:
              expenseLog = '${EvenType.purchased} - amount ${expenses.amount}';
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
          return AppText(expenseLog);
        });
  }
}
