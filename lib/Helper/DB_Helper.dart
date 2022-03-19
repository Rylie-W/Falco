import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/widgets.dart';


class DBHelper{

  static final DBHelper _instance = DBHelper.internal();

  factory DBHelper() => _instance;

  DBHelper.internal();

  static Database? _db  ;

  //Avoid errors cause by flutter upgrade.


  Future<Database> get db async{
    if(_db != null){
      return _db!;
    }else{
      _db ??= await initDb();
      return _db!;
    }
  }

  Future<Database> initDb() async{
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "dbhelper.db");

  return openDatabase(path,version: 1,onCreate: (Database db,int newerVersion) async{
      await db.execute('CREATE TABLE users(name TEXT PRIMARY KEY, positive INTEGER, negative INTEGER, primarystate TEXT, secondarystate TEXT, secondaryevent TEXT, thirdstate TEXT, state TEXT, species TEXT, childrennum INTEGER, fatherstate TEXT, motherstate TEXT, time INTEGER)', );
      await db.execute('CREATE TABLE foods(id INTEGER PRIMARY KEY, name TEXT, category TEXT, boughttime INTEGER, expiretime INTEGER, quantitytype TEXT, quantitynum INTEGER, state TEXT, consumestate REAL)');  
    });
  }

/*
  //Open the database and store the reference.
  final database = openDatabase(
    //Set the path to the database. Use the 'join' function from the 
    //'path' package is best practice to ensure the path is correctly 
    //constructed for each platform.
    join(getDatabasesPath(), 'project_database.db'),

    //when the database is first created, create a table to store foods.
    onCreate: (db, version) {
      //run the CREATE TABLE statement on the database
      db.execute('CREATE TABLE users(name TEXT PRIMARY KEY, positive INTEGER, negative INTEGER, primarystate TEXT, secondarystate TEXT, secondaryevent TEXT, thirdstate TEXT, state TEXT, species TEXT, childrennum INTEGER, fatherstate TEXT, motherstate TEXT, time INTEGER)',);
      return db.execute(  
        'CREATE TABLE foods(id INTEGER PRIMARY KEY, name TEXT, category TEXT, boughttime INTEGER, expiretime INTEGER, quantitytype TEXT, quantitynum INTEGER, state TEXT, consumestate REAL)',
          //'boughttime INTERGER DEFAULT (cast(strftime("%s","now") as int)),'
          //'expiretime INTERGER DEFAULT (cast(strftime("%s","now") as int)),'
      );
    },
    //Set the version, this executes the onCreate function and provides a
    //path to perform database upgrades and downgrades.
    version: 1,
  );
  */


  //Define the function that inserts food into the 'foods' table
  Future<void> insertFood(Food food) async{
    //Get a refenrence to the database
  
    Database dbHelper = await db; 

    //Insert the Food into the correct table. Also specify the 
    //'conflictAlgorithm' to use in case the same food is inserted
    //twice.

    //In this case, the quantity for this food should be added. How????
    //Or the backend should judge if the newly request tobe added food already exists in database
    await dbHelper.insert(
      'foods', 
      food.toMap(),
      );
  }

  //Define the function that inserts user into the 'users' table
  Future<void> insertUser(UserValue uservalue) async{
    //Get a refenrence to the database
    Database dbHelper = await db; 

    //Insert the UserValue into the correct table. Also specify the 
    //'conflictAlgorithm' to use in case the same food is inserted
    //twice.

    //In this case, replace any previous data.
    await dbHelper.insert(
      'users', 
      uservalue.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
      );
  }

  //Define method that retrieves all the foods from food table
  Future<List> queryAll(String object) async {
    //Get a reference to the database.
    Database dbHelper = await db; 
    //Query table for all the foods.
    if (object == "foods") {
      final List<Map<String, dynamic>> maps = await dbHelper.query('foods');
    //Convert the List<Map<String, dynamic> into a List<Food>

      return List.generate(maps.length, (i) {
        return Food(
          id: maps[i]['id'],
          name: maps[i]['name'],
          category: maps[i]['category'],
          boughttime: maps[i]['boughttime'],
          expiretime: maps[i]['expiretime'],
          quantitynum: maps[i]['quantitynum'],
          quantitytype: maps[i]['quantitytype'],
          state: maps[i]['state'],
          consumestate: maps[i]['consumestate'],
        );
      });
    } else if(object == "users"){
      //Query table for all the users.
      final List<Map<String, dynamic>> maps = await dbHelper.query('users');
      //Convert the List<Map<String, dynamic> into a List<Food>

      return List.generate(maps.length, (i) {
        return UserValue(
          name: maps[i]['name'],
          positive: maps[i]['positive'],
          negative: maps[i]['negative'],
          primarystate: maps[i]['primarystate'],
          secondarystate: maps[i]['secondarystate'],
          secondaryevent: maps[i]['secondaryevent'],
          thirdstate: maps[i]['thirdstate'],
          species: maps[i]['species'],
          childrennum: maps[i]['childrennum'],
          fatherstate: maps[i]['fatherstate'],
          motherstate: maps[i]['motherstate'],
          time: maps[i]['time'],
        );
      });
    }
    return List.empty();
  }

  Future<List> queryOne(String object, String specName) async {
    //Get a reference to the database.
    Database dbHelper = await db; 

    //Query table for all the foods.
    if (object == "foods") {
    
      final List<Map<String, dynamic>> maps = await dbHelper.rawQuery('SELECT * FROM foods WHERE name = ?', [specName]);
    //Convert the List<Map<String, dynamic> into a List<Food>

      //shoud be only one row, how to simplfy the code?
      return List.generate(maps.length,(i) {
        return Food(
          id: maps[0]['id'],
          name: maps[0]['name'],
          category: maps[0]['category'],
          boughttime: maps[0]['boughttime'],
          expiretime: maps[0]['expiretime'],
          quantitynum: maps[0]['quantitynum'],
          quantitytype: maps[0]['quantitytype'],
          state: maps[0]['state'],
          consumestate: maps[0]['consumestate'],
        );
      });
    } else if(object == "users"){
      //Query table for all the users.
      final List<Map<String, dynamic>> maps = await dbHelper.rawQuery('SELECT * FROM users WHERE name = ?', [specName]);
      //Convert the List<Map<String, dynamic> into a List<Food>

      return List.generate(maps.length, (i) {
        return UserValue(
          name: maps[i]['name'],
          positive: maps[i]['positive'],
          negative: maps[i]['negative'],
          primarystate: maps[i]['primarystate'],
          secondarystate: maps[i]['secondarystate'],
          secondaryevent: maps[i]['secondaryevent'],
          thirdstate: maps[i]['thirdstate'],
          species: maps[i]['species'],
          childrennum: maps[i]['childrennum'],
          fatherstate: maps[i]['fatherstate'],
          motherstate: maps[i]['motherstate'],
          time: maps[i]['time'],
        );
      });
    }
    return List.empty();
  }

      //Define method that retrieves one column if all the foods from food table
  Future<List<String>> getAllFoodStringValues(String value) async {
    //Get a reference to the database.
    Database dbHelper = await db; 
    //Query table for all the foods.
   
    final List<Map<String, dynamic>> maps = await dbHelper.query('foods', columns: [value]);

    //Convert the List<Map<String, dynamic> into a List<String>
    var foodsname = List<String>.generate(maps.length, (i) => maps[i][value]);

    return foodsname;

  }
        //Define method that retrieves all the foods from food table
  Future<List<int>> getAllFoodIntValues(String value) async {
    //Get a reference to the database.
    Database dbHelper = await db; 
    //Query table for all the foods.
   
    final List<Map<String, dynamic>> maps = await dbHelper.query('foods', columns: [value]);

    //Convert the List<Map<String, dynamic> into a List<String>
    var foodsname = List<int>.generate(maps.length, (i) => maps[i][value]);

    return foodsname;

  }

  Future<String> getOneFoodName(int id)async{
    //Get a reference to the database.
    Database dbHelper = await db; 
    //Query table for all the foods.
   
    final List<Map<String, dynamic>> maps = await dbHelper.query('foods', columns: ['name'], where: '"id" = ?', whereArgs: [id]);

    //Convert the List<Map<String, dynamic> into a String
    var foodname = maps[0]['name'];
    //var foodname = Food.fromMap(maps.first);

    return foodname;
  }

  Future<int> getMaxId()async{
    //Get a reference to the database.
    Database dbHelper = await db; 
    //Query table for all the foods.
   
    var maxId = await dbHelper.rawQuery('SELECT max(id) fROM foods');

    print('###################################$maxId############################');
    //Convert the List<Map<String, dynamic> into a String
    var maxID = maxId[0]['max(id)'];

    if(maxID == null){
        maxID = -1;
    }

    return maxID;

  }

  Future<List<Food>> queryByCategory(String category) async{
    //Get the refernce to the database
    Database dbHelper = await db;

    //final List<Map<String, dynamic>> maps = await dbHelper.query('foods',columns: ['name', 'expiretime', 'boughttime', 'quantitynum', 'quantitytype', 'state', 'consumestate'], where: '$category = ?', whereArgs: [category]);
    final List<Map<String, dynamic>> maps = await dbHelper.rawQuery('SELECT * FROM foods WHERE category = ?', [category]);

    //Convert the List<Map<String, dynamic> into a List

      return List.generate(maps.length, (i) {
        return Food(
          id: maps[i]['id'],
          name: maps[i]['name'],
          category: maps[i]['category'],
          boughttime: maps[i]['boughttime'],
          expiretime: maps[i]['expiretime'],
          quantitynum: maps[i]['quantitynum'],
          quantitytype: maps[i]['quantitytype'],
          state: maps[i]['state'],
          consumestate: maps[i]['consumestate'],
        );
      });
  } 
  
        //Define method that retrieves all the foods from food table
  Future<List<String>> getAllUncosumedFoodStringValues(String value) async {
    //Get a reference to the database.
    Database dbHelper = await db; 
    //Query table for all the foods.
   
    final List<Map<String, dynamic>> maps = await dbHelper.query('foods', columns: [value], where: 'consumestate < 1');

    //Convert the List<Map<String, dynamic> into a List<String>
    var foodsname = List<String>.generate(maps.length, (i) => maps[i][value]);

    return foodsname;

  }

         //Define method that retrieves all the foods from food table
  Future<List<int>> getAllUncosumedFoodIntValues(String value) async {
    //Get a reference to the database.
    Database dbHelper = await db; 
    //Query table for all the foods.
   
    final List<Map<String, dynamic>> maps = await dbHelper.query('foods', columns: [value], where: 'consumestate < 1');

    //Convert the List<Map<String, dynamic> into a List<String>
    var foodsname = List<int>.generate(maps.length, (i) => maps[i][value]);

    return foodsname;

  }

    Future<List<Food>> queryAllUnconsumedFood() async{
    //Get the refernce to the database
    Database dbHelper = await db;

    //final List<Map<String, dynamic>> maps = await dbHelper.query('foods',columns: ['name', 'expiretime', 'boughttime', 'quantitynum', 'quantitytype', 'state', 'consumestate'], where: '$category = ?', whereArgs: [category]);
    final List<Map<String, dynamic>> maps = await dbHelper.rawQuery('SELECT * FROM foods WHERE consumestate < ?', [1]);

    //Convert the List<Map<String, dynamic> into a List

      return List.generate(maps.length, (i) {
        return Food(
          id: maps[i]['id'],
          name: maps[i]['name'],
          category: maps[i]['category'],
          boughttime: maps[i]['boughttime'],
          expiretime: maps[i]['expiretime'],
          quantitynum: maps[i]['quantitynum'],
          quantitytype: maps[i]['quantitytype'],
          state: maps[i]['state'],
          consumestate: maps[i]['consumestate'],
        );
      });
  } 


  //Define method that updates food data 
  Future<void> updateFood(Food food) async{
    //Get the reference to the database
    Database dbHelper = await db;
    //update the food data

    await dbHelper.update(
      'foods',
      food.toMap(),
      //Ensure the food has a matching id
      where: 'id = ?',
      //Pass the Food's id as a whereArg to prevent SQL injection
      whereArgs: [food.id]
      );
  }

    //Define method that updates user data 
  Future<void> updateUser(UserValue uservalue) async{
    //Get the reference to the database
    Database dbHelper = await db;

    //update the food data
    await dbHelper.update(
      'users',
      uservalue.toMap(),
      //Ensure the food has a matching id
      where: 'name = ?',
      //Pass the Food's id as a whereArg to prevent SQL injection
      whereArgs: [uservalue.name]
      );
  }

    //Define method that updates user data 
  Future<void> updateUserPrimary(String newState) async{
    //Get the reference to the database
    Database dbHelper = await db;
    
    await dbHelper.rawUpdate('UPDATE users SET primarystate = ?', [newState]);
  }

  //Define method to delete food
  Future<void> deleteFood(int id) async {
    //Get a reference to the database
    Database dbHelper = await db;

    //Remove the Food from the database
    await dbHelper.delete(
      'foods',
      //Use a 'where' clause to delete a specific food -> id or name?
      where: 'id = ?',
      //Pass the Food's id as a whereArg to preveny SQL injection
      whereArgs: [id],
    );
  }

   //Define method to delete food
  Future<void> deleteUser(String name) async {
    //Get a reference to the database
    Database dbHelper = await db;

    //Remove the Food from the database
    await dbHelper.delete(
      'users',
      //Use a 'where' clause to delete a specific food -> id or name?
      where: 'name = ?',
      //Pass the Food's id as a whereArg to preveny SQL injection
      whereArgs: [name],
    );
  }

  Future close()async{
    Database dbhelper = await db;
    dbhelper.close();
  }

  

  //################Test Database###################

  testDB() async{

    DBHelper dbhelper = DBHelper();

    //Insert a new Food butter
    var butter = Food(id: 2, name: 'milk', category: 'MilkProduct', boughttime: 154893, expiretime: 156432, quantitytype: 'pieces', quantitynum: 3, consumestate: 0.50, state: 'good');   
    var egg = Food(id: 3, name: 'beaf', category: 'Meat', boughttime: 134554, expiretime: 1654757, quantitytype: 'number', quantitynum: 4, consumestate: 0, state: 'good');
    dbhelper.insertFood(butter);
    dbhelper.insertFood(egg);
    
    //Query all Foods
    //print(await dbhelper.queryAll("foods"));

    //Query one specific Food
    //print(await dbhelper.queryOne('foods','butter'));

    //Update butter's quantity number and expire time
    //butter = Food(id: butter.id, name: butter.name, category: butter.category, boughttime: butter.boughttime, expiretime: butter.expiretime + 7, quantitytype: butter.quantitytype, quantitynum: butter.quantitynum + 1, consumestate: butter.consumestate, state: butter.state);
    //await dbhelper.updateFood(butter);
   //print(await dbhelper.queryAll("foods"));

    //Delete the Food butter
    //await dbhelper.deleteFood(butter.id);
   // print(await dbhelper.queryAll("foods"));

    //Get all foods name
    print(await dbhelper.getAllFoodStringValues('name'));
    print(await dbhelper.getAllFoodIntValues('expiretime'));
    print(await dbhelper.getOneFoodName(1));

    //Insert a new UserValue instance
    var user1 = UserValue(name: "user1", negative: 2, positive: 25, primarystate: "nest", secondarystate: "satisfied", secondaryevent: "single", thirdstate: "move", species: "folca", childrennum: 1, fatherstate: "divorced", motherstate: "divorced", time: 1345443);
    await dbhelper.insertUser(user1);
    print(await dbhelper.queryAll("users"));

    //Query one specific UserValue
    print(await dbhelper.queryOne('users', 'user1'));

    //Update user1's primarystate and....
    user1 = UserValue(name: 'user1', negative: 6, positive: 25, primarystate: 'mate', secondarystate: "unsuccessful", secondaryevent: "single", thirdstate: "move", species: "folca", childrennum: 1, fatherstate: "divorced", motherstate: "divorced", time: 134654);
    await dbhelper.updateUser(user1);
    print(await dbhelper.queryAll('users'));

    //Deleter user1
    await dbhelper.deleteUser('user1');
    print(await dbhelper.queryAll('users'));
  }
  
}

class Food {
  int id;
  String name;
  String category;
  int boughttime;
  int expiretime;
  String quantitytype;
  int quantitynum;
  String state;
  double consumestate;

  Food({
    required this.id,
    required this.name,
    required this.category,
    required this.boughttime,
    required this.expiretime,
    required this.quantitytype,
    required this.quantitynum,
    required this.consumestate,
    required this.state
  });
  
  /*
  Food.fromMap(Map map){
    id = map[id];
    name = map[name];
    category = map[category];
    boughttime = map[boughttime];
    expiretime = map[expiretime];
    quantitytype = map[quantitytype];
    quantitynum = map[quantitynum];
    state = map[state];
    consumestate = map[consumestate];
  }
  */

  //Convert a Food into a Map. The keys must correspond to the names
  //of the columns in the databse.
  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'name': name,
      'category': category,
      'boughttime': boughttime,
      'expiretime': expiretime,
      'quantitytype': quantitytype,
      'quantitynum': quantitynum,
      'state': state,
      'consumestate': consumestate,
    };
  }

  //Implement toString tomake it easier to see information about
  //each food when using the print statement
  @override
    String toString() {
      return 'Food{id: $id, name: $name, category: $category, boughttime: $boughttime, expiretime: $expiretime, quantitytype: $quantitytype, quantitynum: $quantitynum, state: $state, consumestate: $consumestate}';
    
    }
}

class UserValue{
  final String name;
  final int positive;
  final int negative;
  final String primarystate;
  final String secondarystate;
  final String secondaryevent;
  final String thirdstate;
  final String species;
  final int childrennum;
  final String fatherstate;
  final String motherstate;
  final int time;

  UserValue({
    required this.name,
    required this.negative,
    required this.positive,
    required this.primarystate,
    required this.secondarystate,
    required this.secondaryevent,
    required this.thirdstate,
    required this.species,
    required this.childrennum,
    required this.fatherstate,
    required this.motherstate,
    required this.time,
  });

  //Convert a UserValue into a Map. The keys must correspond to the names
  //of the columns in the databse.
  Map<String, dynamic> toMap(){
    return {
      'name': name,
      'positive': positive,
      'negative': negative,
      'primarystate': primarystate,
      'secondarystate': secondarystate,
      'secondaryevent': secondaryevent,
      'thirdstate': thirdstate,
      'species': species,
      'childrennum': childrennum,
      'fatherstate': fatherstate,
      'motherstate': motherstate,
      'time': time,
    };
  }

  //Implement toString tomake it easier to see information about
  //each food when using the print statement
  @override
  String toString() {
    return 'Food{name: $name, positive: $positive, negative: $negative, primarystate: $primarystate, secondarystate: $secondarystate, secondaryevent: $secondaryevent, thirdstate: $thirdstate, species: $species, childrennum: $childrennum, fatherstate: $fatherstate, motherstate: $motherstate, time: $time}';
  }
}
