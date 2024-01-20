import 'package:flutter/material.dart';
import 'package:super_pixel/controller/requester_controller.dart';
import 'package:super_pixel/model/requester.dart';
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
        builder: (context, requests) {
          print('employees ${requests.length}');

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              var request = requests[index];

              return RequestCard(request: request);
            },
          );
        },
      ),
    );
  }
}

class RequestCard extends StatelessWidget {
  const RequestCard({required this.request, super.key});

  final Requester request;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //  AppRoute.push(context, EmployeeDetail(employeeName: requester.name));
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    '${request.type} request for ${request.assetType} by ${request.employee}',
                    weight: FontWeight.bold,
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AppText(request.status),
                    ),
                  )
                ],
              ),
              // AppText(
              //   request.employee,
              //   weight: FontWeight.bold,
              // ),
              // AppText(request.assetType),
              // AppText(request.model),
              // AppText(request.notes),
              // AppText(request.status),
              // AppText(request.type)
            ],
          ),
        ),
      ),
    );
  }
}
