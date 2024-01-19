import 'package:flutter/material.dart';
import 'package:super_pixel/ui/routes/app_route.dart';
import 'package:super_pixel/ui/sheets/association_type_sheet.dart';
import 'package:super_pixel/ui/widget/app_text.dart';
import 'package:super_pixel/utils/dissociation_type.dart';

class DissociationTypeSheet extends StatefulWidget {
  const DissociationTypeSheet({super.key});

  @override
  State<DissociationTypeSheet> createState() => _DissociationTypeSheetState();
}

class _DissociationTypeSheetState extends State<DissociationTypeSheet> {
  String? type;
  String? employee;
  String? notes;
  String? oldAsset;

  TextEditingController _noteController = TextEditingController();

  onSelect(String type) {
    AppRoute.pop(context, type);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      maxChildSize: 0.5,
      minChildSize: 0.5,
      expand: false,
      builder: (context, contrioller) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(
                child: AppText(
                  'Dissociation Type',
                  weight: FontWeight.bold,
                  size: 20,
                ),
              ),
              FormTile(
                lable: DissociationType.employeeExit,
                onTap: () => onSelect(DissociationType.employeeExit),
              ),
              FormTile(
                lable: DissociationType.badCondition,
                onTap: () => onSelect(DissociationType.badCondition),
              ),
            ],
          ),
        );
      },
    );
  }
}
