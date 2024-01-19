import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:super_pixel/ui/sheets/association_type_sheet.dart';
import 'package:super_pixel/ui/sheets/employee_sheet.dart';
import 'package:super_pixel/ui/widget/app_sheet.dart';
import 'package:super_pixel/ui/widget/app_text.dart';
import 'package:super_pixel/ui/widget/asset_scanner.dart';
import 'package:super_pixel/utils/association_type.dart';
import 'package:super_pixel/ui/sheets/association_type_sheet.dart';

class AssociationForm extends StatefulWidget {
  const AssociationForm({super.key});

  @override
  State<AssociationForm> createState() => _AssociationFormState();
}

class _AssociationFormState extends State<AssociationForm> {
  String? type;
  String? employee;
  String? notes;
  String? oldAsset;

  TextEditingController _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      maxChildSize: 0.8,
      minChildSize: 0.8,
      expand: false,
      builder: (context, contrioller) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(
                child: AppText(
                  'Association Form',
                  weight: FontWeight.bold,
                  size: 20,
                ),
              ),
              FormDropDown(
                value: type ?? 'Type',
                onTap: () async {
                  var _type = await AppSheet.show<String>(
                    context: context,
                    builder: (context) {
                      return AssociationTypeSheet();
                    },
                  );

                  setState(() {
                    type = _type;
                  });

                  print('typre is $type');
                },
              ),
              if (type == AssociationType.replacement)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FormTile(
                      onTap: () {
                        AppSheet.show(
                          context: context,
                          builder: (builder) {
                            return AssetScanner(
                              onTap: (asset) {
                                setState(() {
                                  oldAsset = asset.model;
                                  employee = asset.owner;
                                });
                              },
                            );
                          },
                        );
                      },
                      lable: 'Scan Old Asset',
                    ),
                    FormTile(
                      onTap: () {
                        AppSheet.show(
                            context: context,
                            builder: (context) {
                              return EmployeeSelectionSheet();
                            });
                      },
                      lable: employee ?? 'Employee',
                    ),
                  ],
                ),
              if (type != AssociationType.replacement)
                FormDropDown(
                  value: employee ?? 'Employee',
                  onTap: () {
                    AppSheet.show(
                      context: context,
                      builder: ((context) => EmployeeSelectionSheet()),
                    );
                  },
                ),
              const Card(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                  child: TextField(
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Notes',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              AppButton(
                lable: 'Associate',
                onTap: () {},
              ),
            ],
          ),
        );
      },
    );
  }
}

class AppButton extends StatelessWidget {
  const AppButton({required this.lable, required this.onTap, super.key});

  final String lable;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: EdgeInsets.symmetric(vertical: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onPressed: onTap,
      color: Color.fromARGB(255, 77, 56, 81),
      child: AppText(
        lable,
        color: Colors.white,
        weight: FontWeight.bold,
      ),
    );
  }
}

class FormDropDown extends StatelessWidget {
  const FormDropDown({required this.value, required this.onTap, super.key});

  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(value),
              const Icon(
                Icons.arrow_drop_down,
              )
            ],
          ),
        ),
      ),
    );
  }
}
