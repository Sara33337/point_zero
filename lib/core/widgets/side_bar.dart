import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:point_zero/core/theme/app_colors.dart';
import 'package:point_zero/core/theme/app_icons.dart';
import 'package:point_zero/core/theme/app_styles.dart';
import 'package:point_zero/core/utils/manager_login.dart';
import 'package:point_zero/core/widgets/category.dart';
import 'package:point_zero/core/widgets/active_role.dart';
import 'package:point_zero/features/auth/presentation/auth_cubit/auth_cubit.dart';
import 'package:point_zero/features/auth/presentation/auth_cubit/auth_state.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    final String currentPath = GoRouterState.of(context).uri.toString();
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        String currentRole = "cashier";
        if (state is AuthAuthenticated) {
          currentRole = state.user.role;
        }
        return Container(
          width: 90.w,
          color: AppColors.primaryColor,
          child: Padding(
            padding: EdgeInsets.all(20.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              textDirection: TextDirection.rtl,

              children: [
                Center(child: Text("Point Zero", style: AppStyles.brandName)),
                SizedBox(height: 20.h),
                Text("الإدارة", style: AppStyles.smallTitle),
                SizedBox(height: 10.h),

                if (currentRole == "manager") ...[
                  Category(
                    isSelected: currentPath == '/inventory_screen',
                    categoryName: "المخزن",
                    icon: AppIcons.storeIcon,
                    onTap: () {
                      context.go('/inventory_screen');
                    },
                  ),
                  Category(
                    isSelected: currentPath == '/finance_screen',
                    categoryName: "الأرباح & المصروفات",
                    icon: AppIcons.walletIcon,
                    onTap: () {
                      context.go('/finance_screen');
                    },
                  ),
                ],

                if (currentRole == "cashier")
                  Category(
                    isSelected: currentPath == '/',
                    categoryName: "نقاط البيع",
                    icon: AppIcons.posIcon,
                    onTap: () {
                      if (currentPath != '/') {
                        context.go('/');
                      }
                    },
                  ),

                const Spacer(),
                Center(
                  child: Text(
                    "ACTIVE ROLE",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 4.sp,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                Divider(color: AppColors.greyColor),
                SizedBox(height: 8.h),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      // زرار الكاشير
                      ActiveRoleButton(
                        currentRole: currentRole,
                        targetRole: 'cashier',
                        buttonText: "كاشير",
                        icon: AppIcons.cashierIcon,
                        onTap: () {
                          if (currentRole == 'manager') {
                            context.read<AuthCubit>().logout();
                            context.go('/');
                          }
                        },
                      ),

                      // زرار المدير
                      ActiveRoleButton(
                        currentRole: currentRole,
                        targetRole: 'manager',
                        buttonText: "مدير",
                        icon: AppIcons.managerIcon,
                        onTap: () {
                          if (currentRole == 'cashier') {
                            showManagerLoginDialog(context);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h,),
                Center(
                  child: Text(
                    textDirection: TextDirection.ltr,
                
                    "Copyright © 2026 Sarah. All Rights Reserved.",
                    style: AppStyles.copyRights,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
