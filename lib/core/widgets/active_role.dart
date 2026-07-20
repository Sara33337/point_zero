import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:point_zero/core/theme/app_styles.dart';

class ActiveRoleButton extends StatelessWidget {
  const ActiveRoleButton({
    super.key,
    required this.currentRole,
    required this.targetRole, 
    required this.buttonText,
    required this.icon,       
    required this.onTap,      
  });

  final String currentRole;
  final String targetRole; 
  final String buttonText;
  final String icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
   
    final isActive = currentRole == targetRole;

    return Expanded(
      child: InkWell(
        onTap: onTap, 
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 6.h),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF2C2C2C) : Colors.transparent,
            borderRadius: BorderRadius.circular(8.r),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset( 
                icon,
                width: 8.w,
                height: 8.w,
                 color: isActive ? Colors.white : Colors.grey,),
            
              SizedBox(width: 2.w),
              Text(
                buttonText,
                
                style: AppStyles.buttonText.copyWith(color: isActive ? Colors.white : Colors.grey,)
                
              ),
            ],
          ),
        ),
      ),
    );
  }
}