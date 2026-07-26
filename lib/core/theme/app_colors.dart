import 'dart:ui';
class AppColors {
  // using static to not get instance from the AppColors class so you can use colors like this AppColors.primaryColor not AppColors().primaryColor
  static const Color primaryColor = Color(0xFF262626);
  static const Color secondaryColor = Color(0xFFD46D25);
  static const Color lightFontColor = Color(0xFFDDDDDD);
  static const Color greyColor = Color(0xFF686D76);
  static const Color lightGreyColor = Color(0xFFC5C7BC);
  static const Color backGroundColor = Color(0xFFEEEEEE);
  static const Color redColor = Color.fromARGB(255, 179, 11, 11);
}

// import 'dart:ui';

// class AppColors {
// static const Color primaryColor = Color(0xFF3F4A70);
// static const Color secondaryColor = Color(0xFF9CA3AF); 
//   static const Color lightFontColor = Color(0xFFF8F8F8);    
//   static const Color greyColor = Color(0xFF7B8498);         
//   static const Color lightGreyColor = Color(0xFFE7EAF1);   
//   static const Color backGroundColor = Color(0xFFF5F6F8);  
//   static const Color redColor = Color(0xFFD32F2F);          
// }