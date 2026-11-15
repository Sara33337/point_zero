import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:point_zero/core/theme/app_colors.dart';
import 'package:point_zero/core/utils/activation_service.dart';

class ActivationScreen extends StatefulWidget {
  const ActivationScreen({super.key});

  @override
  State<ActivationScreen> createState() => _ActivationScreenState();
}

class _ActivationScreenState extends State<ActivationScreen> {
  String _deviceId = "جاري قراءة كود الجهاز...";
  final TextEditingController _keyController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchDeviceId();
  }

  // دالة لجلب كود الجهاز عند فتح الشاشة
  Future<void> _fetchDeviceId() async {
    final id = await ActivationService.getHardwareId();
    setState(() {
      _deviceId = id;
    });
  }

  // دالة تفعيل التطبيق
  Future<void> _activateApp() async {
    if (_keyController.text.trim().isEmpty) {
      setState(() => _errorMessage = "الرجاء إدخال كود التفعيل");
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final isSuccess = await ActivationService.activateApp(_keyController.text.trim());

    if (!mounted) return;

    if (isSuccess) {
      // نجاح التفعيل: التوجيه مباشرة إلى شاشة تسجيل الدخول أو الـ POS
      context.go('/');
    } else {
      // فشل التفعيل: عرض رسالة خطأ
      setState(() {
        _isLoading = false;
        _errorMessage = "كود التفعيل غير صحيح! تأكد من الكود وحاول مجدداً.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      body: Center(
        child: Container(
          width: 350.w, 
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha :0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            textDirection: TextDirection.rtl,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Icon(
                  Icons.shield_outlined,
                  size: 40.r,
                  color: AppColors.secondaryColor,
                ),
              ),
              SizedBox(height: 16.h),
              Center(
                child: Text(
                  "تفعيل نظام Point Zero",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Center(
                child: Text(
                  "يرجى إرسال كود الجهاز للمطور للحصول على مفتاح التفعيل الخاص بك.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: AppColors.greyColor,
                  ),
                ),
              ),
              SizedBox(height: 32.h),

              // قسم عرض كود الجهاز ونسخه
              Text(
                "كود الجهاز:",
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF374151),
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SelectableText(
                        _deviceId,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontFamily: 'monospace', // خط مناسب للأكواد
                          color: const Color(0xFF111827),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy, color: Colors.blueAccent),
                      tooltip: 'نسخ الكود',
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: _deviceId));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("تم نسخ كود الجهاز بنجاح!"),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // حقل إدخال مفتاح التفعيل
              TextField(
                controller: _keyController,
                decoration: InputDecoration(
                  labelText: "مفتاح التفعيل",
                  hintText: "أدخل الكود الذي استلمته من المطور هنا...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                  ),
                  errorText: _errorMessage.isEmpty ? null : _errorMessage,
                ),
              ),
              SizedBox(height: 32.h),

              // زر التفعيل
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  onPressed: _isLoading ? null : _activateApp,
                  child: _isLoading
                      ? SizedBox(
                          width: 24.r,
                          height: 24.r,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          "تفعيل الآن",
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _keyController.dispose();
    super.dispose();
  }
}