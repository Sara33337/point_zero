import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_zero/core/utils/activation_service.dart';
import 'package:point_zero/features/auth/presentation/auth_cubit/auth_cubit.dart';
import 'package:point_zero/injection_container.dart' as di;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'core/routing/routs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  await di.init();
  bool isAppActivated = await ActivationService.checkIsActivated();
  runApp(PointZero(isActivated: isAppActivated));
}

class PointZero extends StatelessWidget {
  final bool isActivated;
  const PointZero({super.key, required this.isActivated});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: BlocProvider(
            create: (context) => di.sl<AuthCubit>()..login("sara", "1234"),
            child: MaterialApp.router(
              routerConfig: appRouter(isActivated),
              debugShowCheckedModeBanner: false,
              title: 'Point Zero',
              theme: ThemeData(textTheme: GoogleFonts.cairoTextTheme()),
            ),
          ),
        );
      },
    );
  }
}
