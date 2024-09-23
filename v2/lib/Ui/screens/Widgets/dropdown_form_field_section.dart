import 'package:eClassify/Utils/Extensions/extensions.dart';
import 'package:flutter/material.dart';

class DropdownFormFieldSection extends StatefulWidget {
  final String label;
  final String hint;
  final List<String> items;
  String? selectionItem;
  final Function(String val) onCallback;
  final List<DropdownMenuItem>? widgetDropdown;

  DropdownFormFieldSection({Key? key, required this.label, required this.hint, required this.items, required this.selectionItem, required this.onCallback, this.widgetDropdown}) : super(key: key);

  @override
  State<DropdownFormFieldSection> createState() => _DropdownFormFieldSectionState();
}

class _DropdownFormFieldSectionState extends State<DropdownFormFieldSection> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      dropdownColor: Colors.white,
      icon: const Icon(
        Icons.keyboard_arrow_down,
        color: Color(0xFFE2E4E7),
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        labelText: widget.label,
        fillColor: Colors.white,
        filled: true,
        hintText: widget.hint,
        hintStyle: TextStyle(color: context.color.textDefaultColor.withOpacity(0.5), fontSize: context.font.large, height: 0.1),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE2E4E7), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1.5, color: context.color.territoryColor),
          borderRadius: BorderRadius.circular(10),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      items: widget.widgetDropdown ??
          widget.items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                // style: GoogleFonts.nunito(color: Colors.black),
              ),
            );
          }).toList(),
      onChanged: (value) {
        print("value $value");
        widget.onCallback(value ?? '');
        setState(() {
          widget.selectionItem = value;
        });
      },
    );
  }
}
