import 'package:flutter/material.dart';
import 'package:super_pixel/controller/asset_detail_controller.dart';
import 'package:super_pixel/controller/assets_controller.dart';
import 'package:super_pixel/model/asset.dart';
import 'package:super_pixel/ui/routes/app_route.dart';
import 'package:super_pixel/ui/sheets/dissociation_type_sheet.dart';
import 'package:super_pixel/ui/widget/app_sheet.dart';
import 'package:super_pixel/ui/widget/app_text.dart';

class DissociationForm extends StatefulWidget {
  const DissociationForm({required this.assetId, super.key});

  final String assetId;

  @override
  State<DissociationForm> createState() => _DissociationFormState();
}

class _DissociationFormState extends State<DissociationForm> {
  String? type;
  String? employee;
  String? notes;
  Asset? oldAsset;

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
                  'Dissociation Form',
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
                      return const DissociationTypeSheet();
                    },
                  );

                  setState(() {
                    type = _type;
                  });

                  print('typre is $type');
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
              const SizedBox(height: 10),
              AppButton(
                lable: 'Dissociate',
                onTap: () async {
                  if (type != null) {
                    var asset = AssetsController.instance.value
                        .firstWhere((element) => element.id == widget.assetId);

                    await AssetDetailController.getInstance(widget.assetId)
                        .dissociate(
                      newasset: asset,
                    );

                    AppRoute.pop(context);
                  }
                },
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
      padding: const EdgeInsets.symmetric(vertical: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onPressed: onTap,
      color: const Color.fromARGB(255, 77, 56, 81),
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
