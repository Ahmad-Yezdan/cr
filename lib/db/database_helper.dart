import 'package:cr/models/message_model.dart';
import 'package:cr/models/task.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseHelper {
  static const _databaseName = "cr_database.db";
  static const _databaseVersion = 1;
  static const _tableName1 = 'tasks';
  static const _tableName2 = 'messages';

  DataBaseHelper._privateConstrutor();

  static final DataBaseHelper instance = DataBaseHelper._privateConstrutor();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    //device/data/databasename.db
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName1 (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        teacher TEXT NOT NULL,
        task TEXT NOT NULL,
        deadline TEXT NOT NULL,
        createdDate TEXT NOT NULL
      )      
    ''');
    await db.execute('''
      CREATE TABLE $_tableName2 (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        groups TEXT NOT NULL,
        message TEXT NOT NULL,
        time TEXT NOT NULL,
        createdDate TEXT NOT NULL
      )   
    ''');
  }

  Future<int> insertTask(Task task) async {
    Database db = await instance.database;
    return await db.insert(_tableName1, task.toJson());
  }

  Future<List<Task>> readAllTasks() async {
    Database db = await instance.database;
    var tasks = await db.query(_tableName1);
    return tasks.isNotEmpty
        ? tasks
            .map(
              (taskData) => Task.fromJsonDatabase(taskData),
            )
            .toList()
        : [];
  }

  Future<int> deleteTask(int id) async {
    Database db = await instance.database;
    return await db.delete(_tableName1, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateTask(Task task) async {
    Database db = await instance.database;
    return await db.update(_tableName1,
        {'teacher': task.teacher, 'task': task.task, 'deadline': task.deadline},
        where: 'id = ?', whereArgs: [task.id]);
  }

  // Pending implentaion of SearchTasks
  // Future<List<Task>> searchTasks(String query) async {
  //   Database db = await instance.database;
  //   var searchTasks =
  //       await db.query(_tableName1, where: 'task like', whereArgs: [query]);

  //   return searchTasks.isNotEmpty
  //       ? searchTasks.map((taskData) => Task.fromJsonDatabase(taskData)).toList()
  //       : [];
  // }

  Future<int> insertMessage(MessageModel message) async {
    Database db = await instance.database;
    return await db.insert(_tableName2, message.toJson());
  }

  Future<List<MessageModel>> readAllMessages() async {
    Database db = await instance.database;
    var messages = await db.query(_tableName2);
    return messages.isNotEmpty
        ? messages
            .map(
              (messageData) => MessageModel.fromJsonDatabase(messageData),
            )
            .toList()
        : [];
  }

  Future<int> deleteMessage(int id) async {
    Database db = await instance.database;
    return await db.delete(_tableName2, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateMessage(MessageModel message) async {
    Database db = await instance.database;
    return await db.update(
        _tableName2,
        {
          'groups': message.groups,
          'message': message.message,
          'time': message.time
        },
        where: 'id = ?',
        whereArgs: [message.id]);
  }

  // Pending implentaion of SearchUpdates
  // Future<List<UpdatesModel>> searchTasks(String query) async {
  //   Database db = await instance.database;
  //   var searchUpdates =
  //       await db.query(_tableName2, where: 'update like', whereArgs: [query]);

  //   return searchUpdates.isNotEmpty
  //       ? searchTasks.map((updateData) => UpdatesModel.fromJsonDatabase(updateData)).toList()
  //       : [];
  // }
}
