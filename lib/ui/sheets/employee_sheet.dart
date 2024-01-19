import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:super_pixel/ui/routes/app_route.dart';
import 'package:super_pixel/ui/sheets/association_type_sheet.dart';
import 'package:super_pixel/ui/widget/app_text.dart';
import 'package:super_pixel/utils/association_type.dart';

class EmployeeSelectionSheet extends StatefulWidget {
  const EmployeeSelectionSheet({super.key});

  @override
  State<EmployeeSelectionSheet> createState() => _EmployeeSelectionSheetState();
}

class _EmployeeSelectionSheetState extends State<EmployeeSelectionSheet> {
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
                  'Select Employee',
                  weight: FontWeight.bold,
                  size: 20,
                ),
              ),
              FormTile(
                lable: AssociationType.newAsset,
                onTap: () => onSelect(AssociationType.newAsset),
              ),
              FormTile(
                lable: AssociationType.temporary,
                onTap: () => onSelect(AssociationType.temporary),
              ),
              FormTile(
                lable: AssociationType.replacement,
                onTap: () => onSelect(AssociationType.replacement),
              ),
            ],
          ),
        );
      },
    );
  }
}
