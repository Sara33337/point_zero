import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:point_zero/features/pos/presentation/cubit/exchange_cubit/exchange_cubit.dart';
import 'package:point_zero/features/pos/presentation/cubit/pos_cubit/pos_cubit.dart';
import 'package:point_zero/features/pos/presentation/screens/exchange_screen.dart'; // زرار الدفع بتاعك

void showExchangeDialog(BuildContext context) {
  final exchangeCubit = context.read<ExchangeCubit>();
  final posCubit = context.read<PosCubit>();
 showDialog(
    context: context,
    builder: (dialogContext) {
      return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: exchangeCubit),
          BlocProvider.value(value: posCubit),
        ],
        child: const ExchangeDialogWidget(),
      );
    },
  ).then((_) {
    // 👈 السطر ده سحري: بيشتغل أوتوماتيك أول ما النافذة تتقفل بأي شكل
    // وبيمسح كل الداتا القديمة عشان لما تفتحيها تاني تلاقيها نظيفة
    exchangeCubit.resetExchange();
  });
}




  