import 'package:flutter/material.dart';
import 'package:super_pixel/controller/requester_controller.dart';
import 'package:super_pixel/ui/state_builder.dart';
import 'package:super_pixel/ui/widget/app_text.dart';

class RequestsList extends StatefulWidget {
  const RequestsList({super.key});

  @override
  State<RequestsList> createState() => _RequestsListState();
}

class _RequestsListState extends State<RequestsList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Requests'),
      ),
      body: StateBuilder(
        controller: RequesterController.getInstance(),
        builder: (context, requesters) {
          print('employees ${requesters.length}');

          return ListView.builder(
            itemCount: requesters.length,
            itemBuilder: (context, index) {
              var requester = requesters[index];
              return GestureDetector(
                onTap: () {
                  //  AppRoute.push(context, EmployeeDetail(employeeName: requester.name));
                },
                child: Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10),
                    child: Column(
                      children: [
                        AppText(
                          requester.employee,
                          weight: FontWeight.bold,
                        ),
                        AppText(requester.assetType),
                        AppText(requester.model),
                        AppText(requester.notes),
                        AppText(requester.status),
                        AppText(requester.type)
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
