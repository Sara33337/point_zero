import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:point_zero/core/theme/app_styles.dart';
import 'package:point_zero/core/widgets/primary_button.dart';
import 'package:point_zero/core/widgets/secondary_button.dart';
import 'package:point_zero/features/auth/presentation/auth_cubit/auth_cubit.dart';
import 'package:point_zero/core/widgets/custom_text_field.dart';

void showManagerLoginDialog(BuildContext context) {
  final TextEditingController passwordController = TextEditingController();

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (dialogContext) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        title: Text(
          "صلاحيات الإدارة",
          style: AppStyles.largeTitle,
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("برجاء إدخال كلمة المرور:", style: AppStyles.smallTitle),
            SizedBox(height: 16.h),
            CustomTextFormField(
              controller: passwordController,
              obscureText: true,
              keyboardType: TextInputType.number,
              hintText: "****",
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          PrimaryButton(
            buttonText: "دخول",
            onTap: () {
              final password = passwordController.text.trim();

              if (password == '1234') {
                context.read<AuthCubit>().loginAsManager(password);
                Navigator.pop(dialogContext);
                context.go('/inventory_screen');
              } else {
                Navigator.pop(dialogContext); 
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'كلمة المرور غير صحيحة!',
                      textAlign: TextAlign.center,
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 4),

          SecondaryButton(
            buttonText: "إلغاء",
            onTap: () {
              Navigator.pop(dialogContext);
            },
          ),
        ],
      );
    },
  );
}
