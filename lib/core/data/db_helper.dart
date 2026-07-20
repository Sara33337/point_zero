import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  // Singleton Pattern
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('point_zero.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    // تحديد مسار حفظ الداتابيز في الويندوز
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await databaseFactoryFfi.openDatabase(
      path,
      options: OpenDatabaseOptions(version: 1, onCreate: _createDB),
    );
  }

  // هنا بنكريت كل الجداول بتاعتنا
  Future _createDB(Database db, int version) async {
    // 1. جدول المستخدمين (للمدير والكاشير)
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        role TEXT NOT NULL
      )
    ''');

    // 2. جدول المنتجات (للمخزن)
    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        code TEXT UNIQUE NOT NULL,
        name TEXT NOT NULL,
        category TEXT NOT NULL,
        wholesale_price REAL NOT NULL,
        selling_price REAL NOT NULL,
        stock_quantity INTEGER NOT NULL
      )
    ''');

    // 3. جدول المبيعات (الفاتورة الأساسية)
    await db.execute('''
      CREATE TABLE bills (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        total_amount REAL NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    // 4. جدول تفاصيل الفاتورة (المنتجات المباعة)
    await db.execute('''
      CREATE TABLE bill_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        bill_id INTEGER NOT NULL,
        product_code TEXT NOT NULL,
        product_name TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        
        -- بنسجل سعر الجملة والبيع وقت الفاتورة عشان حساب الأرباح يكون دقيق
        wholesale_price REAL NOT NULL, 
        unit_price REAL NOT NULL,      
        
        subtotal REAL NOT NULL,
        
        -- ربط هذا الجدول بجدول الفواتير (Foreign Key)
        FOREIGN KEY (bill_id) REFERENCES bills (id) ON DELETE CASCADE
      )
    ''');

    // 5. جدول المصروفات )
    await db.execute('''
  CREATE TABLE expenses (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    amount REAL NOT NULL,
    date TEXT NOT NULL
  )
''');

    // 6. جدول حركات الاستبدال (للتوثيق والجرد)
    await db.execute('''
  CREATE TABLE exchanges (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    old_bill_id INTEGER NOT NULL,
    old_product_code TEXT NOT NULL,
    old_product_name TEXT NOT NULL,
    returned_qty INTEGER NOT NULL,
    
    -- إجمالي الفلوس اللي العميل دفعها كفرق (ممكن تكون صفر)
    difference_paid REAL NOT NULL, 
    created_at TEXT NOT NULL
  )
''');
  }
}
