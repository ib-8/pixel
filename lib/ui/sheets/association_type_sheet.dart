import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:super_pixel/ui/routes/app_route.dart';
import 'package:super_pixel/ui/widget/app_text.dart';
import 'package:super_pixel/utils/association_type.dart';

class AssociationTypeSheet extends StatefulWidget {
  const AssociationTypeSheet({super.key});

  @override
  State<AssociationTypeSheet> createState() => _AssociationTypeSheetState();
}

class _AssociationTypeSheetState extends State<AssociationTypeSheet> {
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
                  'Association Type',
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

class FormTile extends StatelessWidget {
  const FormTile({required this.onTap, required this.lable, super.key});

  final String lable;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: AppText(lable),
        ),
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

class FormNotesField extends StatelessWidget {
  const FormNotesField({
    required this.controller,
    required this.hint,
    super.key,
  });

  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return const Card(
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
    );
  }
}
