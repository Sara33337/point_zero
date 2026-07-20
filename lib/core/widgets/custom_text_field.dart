import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:point_zero/core/theme/app_colors.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final TextAlign textAlign;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool readOnly;

  const CustomTextFormField({
    super.key,

    this.hintText,
    this.labelText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.textAlign = TextAlign.start,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
        height: 40.h,
        
        child: TextFormField(
          readOnly: readOnly,
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
          onChanged: onChanged,
          textAlign: textAlign,
        
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 3.5.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.greyColor,
            ),
        
            labelText: labelText,
            prefixIcon: prefixIcon,
            
            suffixIcon: suffixIcon,
            filled: true,
        
            labelStyle: TextStyle(
              fontSize: 4.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryColor,
            ),
        
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: AppColors.lightGreyColor),
            ),
        
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: AppColors.secondaryColor),
            ),
          ),
        ),
   
    );
  }
}
