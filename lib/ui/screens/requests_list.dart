import 'dart:math';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:super_pixel/controller/requester_controller.dart';
import 'package:super_pixel/database_table.dart';
import 'package:super_pixel/model/asset.dart';
import 'package:super_pixel/model/expenses.dart';
import 'package:super_pixel/model/requester.dart';
import 'package:super_pixel/ui/state_builder.dart';
import 'package:super_pixel/ui/widget/app_text.dart';


class YourForm extends StatefulWidget {
  @override
  _YourFormState createState() => _YourFormState();
}

enum RequestType { Service, New, Replacement }

class _YourFormState extends State<YourForm> {
  final TextEditingController nameController = TextEditingController();
 final TextEditingController assetTypeController = TextEditingController();

  String requestType = '';
  

  RequestType selectedRequestType = RequestType.Service;




  Future<void> insertData(String selectedString) async {
    var requester = Requester(
      id: '7',
      type: selectedString,
      model: '',
      status: 'Open',
      employee: nameController.text,
     notes:'',
    assetType:assetTypeController.text,
      
    );
    
    await DatabaseTable.requesters.insert(requester.toMap());
  }

  Widget buildServiceForm() {
    return Column(
      children: [
        TextField(
          controller: nameController,
          decoration: InputDecoration(labelText: 'Employee Name'),
        ),
        // Other fields specific to the Service request
        
        TextField(
          controller: assetTypeController,
          decoration: InputDecoration(labelText: 'Asset Type'),
        ),
      ],
    );
  }





  @override
  Widget build(BuildContext context) {
    Widget selectedForm;
    if (selectedRequestType == RequestType.Service) {
      requestType="Service";
    } else if (selectedRequestType == RequestType.New) {
       requestType="New";
    } else if (selectedRequestType == RequestType.Replacement) {
      requestType="Replacement";
    } else {
      // Default to an empty container if none of the types match
      selectedForm = Container();
    }
selectedForm = buildServiceForm();
    return AlertDialog(
      title: Text('Add Request'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<RequestType>(
            value: selectedRequestType,
            onChanged: (RequestType? value) {
              setState(() {
                selectedRequestType = value!;
              });
            },
            items: RequestType.values.map<DropdownMenuItem<RequestType>>((RequestType value) {
              return DropdownMenuItem<RequestType>(
                value: value,
                child: Text(value.toString().split('.').last),
              );
            }).toList(),
            decoration: InputDecoration(
              labelText: 'Select Request Type',
            ),
          ),
          selectedForm,
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the form
          },
          child: Text('Close'),
        ),
        TextButton(
          onPressed: () async {
            await insertData(requestType);
            Navigator.of(context).pop(); // Close the form
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}





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
         actions: [
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding:
                  EdgeInsets.only(top: 8.0, right: 40.0), // Adjust as needed
              child: IconButton(
                icon: Icon(Icons.person_add, color: Colors.white),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return YourForm();
                    },
                  );
                },
              ),
            ),
          ),
        ],
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
