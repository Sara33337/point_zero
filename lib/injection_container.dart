
import 'package:get_it/get_it.dart';
import 'package:point_zero/core/data/db_helper.dart';
import 'package:point_zero/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:point_zero/features/auth/data/repo/auth_repo_impl.dart';
import 'package:point_zero/features/auth/domain/repo/auth_repo.dart';
import 'package:point_zero/features/auth/domain/useCases/login_useCase.dart';

import 'package:point_zero/features/auth/presentation/auth_cubit/auth_cubit.dart';
import 'package:point_zero/features/finance/data/data_sources/finance_local_data_source.dart';
import 'package:point_zero/features/finance/data/repo/finance_repo_impl.dart';
import 'package:point_zero/features/finance/domain/repo/finance_repo.dart';
import 'package:point_zero/features/finance/domain/useCases/add_expense_useCase.dart';
import 'package:point_zero/features/finance/domain/useCases/get_monthly_expense_data.dart';
import 'package:point_zero/features/finance/domain/useCases/get_monthly_sales_data.dart';
import 'package:point_zero/features/finance/presentation/finance_cubit/finance_cubit.dart';
import 'package:point_zero/features/inventory/data/data_source/inventory_local_data_source.dart';
import 'package:point_zero/features/inventory/data/repo/inventory_repo_impl.dart';
import 'package:point_zero/features/inventory/domain/repo/inventory_repo.dart';
import 'package:point_zero/features/inventory/domain/useCases/add_product_usecase.dart';
import 'package:point_zero/features/inventory/domain/useCases/delete_product_useCase.dart';
import 'package:point_zero/features/inventory/domain/useCases/edit_product_useCase.dart';
import 'package:point_zero/features/inventory/domain/useCases/generate_code_useCase.dart';
import 'package:point_zero/features/inventory/domain/useCases/get_products_usecase.dart';
import 'package:point_zero/features/inventory/presentation/inventory_cubit/inventory_cubit.dart';
import 'package:point_zero/features/pos/data/data_sources/exchange_local_datasource.dart';
import 'package:point_zero/features/pos/data/data_sources/pos_local_dataSource.dart';
import 'package:point_zero/features/pos/data/repo/exchange_repo_impl.dart';
import 'package:point_zero/features/pos/data/repo/pos_repo_impl.dart';
import 'package:point_zero/features/pos/domain/repo/exchange_rep.dart';
import 'package:point_zero/features/pos/domain/repo/pos_repo.dart';
import 'package:point_zero/features/pos/domain/useCases/checkout_useCase.dart';
import 'package:point_zero/features/pos/domain/useCases/process_exchange_useCase.dart';
import 'package:point_zero/features/pos/domain/useCases/search_past_sale_useCase.dart';
import 'package:point_zero/features/pos/domain/useCases/search_products_useCase.dart';
import 'package:point_zero/features/pos/presentation/cubit/exchange_cubit/exchange_cubit.dart';
import 'package:point_zero/features/pos/presentation/cubit/pos_cubit/pos_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async{
  //database
  sl.registerLazySingleton(() => DatabaseHelper.instance);

  //data sources (ADDED MISSING INTERFACES)
  sl.registerLazySingleton<InventoryLocalDataSource>(() => InventoryLocalDataSourceImpl(dbHelper: sl()));
  sl.registerLazySingleton<AuthLocalDataSource>(()=>AuthLocalDataSourceImpl(dbHelper: sl()));
  sl.registerLazySingleton<PosLocalDataSource>(()=>PosLocalDataSourceImpl(dbHelper: sl()));
  sl.registerLazySingleton<FinanceLocalDataSource>(() => FinancrLocalDataSourceImpl(dbHelper: sl()));
  sl.registerLazySingleton<ExchangeLocalDatasource>(()=>ExchangeLocalDatasourceImpl(dbHelper: sl()));
  

  //Repository
  sl.registerLazySingleton<InventoryRepository>(() => InventoryRepositoryImpl(
    localDataSource: sl(), 
  ));
  sl.registerLazySingleton<AuthRepository>(()=> AuthRepositoryImpl(localDataSource: sl()));
  sl.registerLazySingleton<PosRepository>(()=>PosRepositoryImpl(localDataSource: sl()));
  sl.registerLazySingleton<FinanceRepository>(()=>FinanceRepositoryImpl(localDataSource: sl()));
  sl.registerLazySingleton<ExchangeRepository>(()=>ExchangeRepositoryImpl(localDataSource: sl()));
  
   //usecases
  sl.registerLazySingleton(() => AddProductUseCase(sl()));
  sl.registerLazySingleton(()=> GetProductsUsecase(repository: sl()));
  sl.registerLazySingleton(()=>GenerateUniqueCodeUseCase(sl()));
  sl.registerLazySingleton(() => DeleteProductUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProductUseCase(sl()));
  sl.registerLazySingleton(()=> LoginUseCase(sl()));
  sl.registerLazySingleton(()=> CheckoutUseCase(sl()));
  sl.registerLazySingleton(()=> AddExpenseUseCase(repository: sl()));
  sl.registerLazySingleton(()=> GetMonthlyExpenseDataUseCase(repository: sl()));
  sl.registerLazySingleton(()=> GetMonthlySalesDataUseCase(repository: sl()));
  sl.registerLazySingleton(()=>SearchPastSalesUseCase(sl()));
  sl.registerLazySingleton(()=>ProcessExchangeUseCase(sl()));
  sl.registerLazySingleton(()=> SearchProductsUsecase(sl()));

  //cubit
  sl.registerFactory(()=>InventoryCubit(getProductsUsecase: sl(), addProductUseCase: sl(), generateUniqueCodeUseCase: sl(), deleteProductUseCase: sl() , updateProductUseCase: sl()));
  sl.registerLazySingleton(() => AuthCubit(loginUseCase: sl()));
  sl.registerFactory(()=>PosCubit(checkoutUseCase: sl(), getProductsUseCase: sl()));
  sl.registerFactory(()=>FinanceCubit(getMonthlySalesUseCase: sl(), getMonthlyExpensesUseCase: sl(), addExpenseUseCase: sl()));
  sl.registerFactory(()=>ExchangeCubit(searchPastSalesUseCase: sl(), processExchangeUseCase: sl() , searchProductsUsecase: sl()));
  
}