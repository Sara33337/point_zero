import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDropDownMenu extends StatelessWidget {
  final String? selectedItem; 
  final List<String> items;
  final String labelText; 
  final void Function(String?) onChanged; 

  const CustomDropDownMenu({
    super.key,
    required this.selectedItem,
    required this.items,
    required this.onChanged,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedItem,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 15.h),
      ),
      items: items.map((item) {
        return DropdownMenuItem(value: item, child: Text(item));
      }).toList(),
      onChanged: onChanged, // الشاشة الأب هي التي ستنفذ الـ setState
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "من فضلك اختر $labelText";
        }
        return null;
      },
    );
  }
}