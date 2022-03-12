import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/widgets.dart';


void main() async {

  //Avoid errors cause by flutter upgrade.
  WidgetsFlutterBinding.ensureInitialized();

  //Open the database and store the reference.
  final database = openDatabase(
    //Set the path to the database. Use the 'join' function from the 
    //'path' package is best practice to ensure the path is correctly 
    //constructed for each platform.
    join(await getDatabasesPath(), 'project_database.db'),

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


  //Define the function that inserts food into the 'foods' table
  Future<void> insertFood(Food food) async{
    //Get a refenrence to the database
    final db = await database;

    //Insert the Food into the correct table. Also specify the 
    //'conflictAlgorithm' to use in case the same food is inserted
    //twice.

    //In this case, the quantity for this food should be added. How????
    //Or the backend should judge if the newly request tobe added food already exists in database
    await db.insert(
      'foods', 
      food.toMap(),
      );
  }

  //Define the function that inserts user into the 'users' table
  Future<void> insertUser(UserValue uservalue) async{
    //Get a refenrence to the database
    final db = await database;

    //Insert the UserValue into the correct table. Also specify the 
    //'conflictAlgorithm' to use in case the same food is inserted
    //twice.

    //In this case, replace any previous data.
    await db.insert(
      'users', 
      uservalue.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
      );
  }

  //Define method that retrieves all the foods from food table
  Future<List> queryAll(String object) async {
    //Get a reference to the database.
    final  db = await database;

    //Query table for all the foods.
    if (object == "foods") {
      final List<Map<String, dynamic>> maps = await db.query('foods');
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
      final List<Map<String, dynamic>> maps = await db.query('users');
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
    final  db = await database;

    //Query table for all the foods.
    if (object == "foods") {
    
      final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT * FROM foods WHERE name = ?', [specName]);
    //Convert the List<Map<String, dynamic> into a List<Food>

      //shoud be only one row, how to simplfy the code?
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
      final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT * FROM users WHERE name = ?', [specName]);
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

  /*
  //Define method that query one specific food
  Future<List<Food>> queryFood(String specFood) async {
    //Get a reference to the database
    final db = await database;

    //Query table for one specific food
    final List<Map<String, dynamic>> maps = await db.query('SELECT * FROM foods WHERE name = $specFood');
    //Convert the List<Map<String, dynamic> into a List<Food>

    //shoud be only one row, how to simplfy the code?
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
*/

  //Define method that updates food data 
  Future<void> updateFood(Food food) async{
    //Get the reference to the database
    final db = await database;

    //update the food data
    await db.update(
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
    final db = await database;

    //update the food data
    await db.update(
      'users',
      uservalue.toMap(),
      //Ensure the food has a matching id
      where: 'name = ?',
      //Pass the Food's id as a whereArg to prevent SQL injection
      whereArgs: [uservalue.name]
      );
  }

  //Define method to delete food
  Future<void> deleteFood(int id) async {
    //Get a reference to the database
    final db = await database;

    //Remove the Food from the database
    await db.delete(
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
    final db = await database;

    //Remove the Food from the database
    await db.delete(
      'users',
      //Use a 'where' clause to delete a specific food -> id or name?
      where: 'name = ?',
      //Pass the Food's id as a whereArg to preveny SQL injection
      whereArgs: [name],
    );
  }

  //################Test Database###################

  //Insert a new Food butter
  var butter = Food(id: 1, name: 'butter', category: 'MilkProduct', boughttime: 154893, expiretime: 156432, quantitytype: 'pieces', quantitynum: 3, consumestate: 0.50, state: 'good'); 
  await insertFood(butter);
  print(await queryAll("foods"));

  //Query one specific Food
  print(await queryOne('foods','butter'));

  //Update butter's quantity number and expire time
  butter = Food(id: butter.id, name: butter.name, category: butter.category, boughttime: butter.boughttime, expiretime: butter.expiretime + 7, quantitytype: butter.quantitytype, quantitynum: butter.quantitynum + 1, consumestate: butter.consumestate, state: butter.state);
  await updateFood(butter);
  print(await queryAll("foods"));

  //Delete the Food butter
  await deleteFood(butter.id);
  print(await queryAll("foods"));

  //Insert a new UserValue instance
  var user1 = UserValue(name: "user1", negative: 2, positive: 25, primarystate: "nest", secondarystate: "satisfied", secondaryevent: "single", thirdstate: "move", species: "folca", childrennum: 1, fatherstate: "divorced", motherstate: "divorced", time: 1345443);
  await insertUser(user1);
  print(await queryAll("users"));

  //Query one specific UserValue
  print(await queryOne('users', 'user1'));

  //Update user1's primarystate and....
  user1 = UserValue(name: 'user1', negative: 6, positive: 25, primarystate: 'mate', secondarystate: "unsuccessful", secondaryevent: "single", thirdstate: "move", species: "folca", childrennum: 1, fatherstate: "divorced", motherstate: "divorced", time: 134654);
  await updateUser(user1);
  print(await queryAll('users'));

  //Deleter user1
  await deleteUser('user1');
  print(await queryAll('users'));
  
}

class Food {
  final int id;
  final String name;
  final String category;
  final int boughttime;
  final int expiretime;
  final String quantitytype;
  final int quantitynum;
  final String state;
  final double consumestate;

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
/*
class DBHelper{

  static final DBHelper _instance = DBHelper.internal();

  factory DBHelper() => _instance;

  Database _db;

  Future<Database> get db async{
    if(_db != null){
      return _db;
    }else{
      _db = await initDb();
      return _db;
    }
  }
  Future<Database> initDb()async{
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "dbfood.db");

  return await openDatabase(path,version: 1,onCreate: (Database db,int newerVersion)async{
      await db.execute(
        "CREATE TABLE $foodTABLE(" 
        "$idColumn INTEGER PRIMARY KEY,"
        "$category TEXT"
        )"
            
      );
    });
  }
}

class Food{

  final int id;
  final String name;
  double valor;
  String category;
  String descricao;

  Food();

  Food.fromMap(Map map){
    id = map[idColumn];
    valor = map[valorColumn];
    data = map[dataColumn];
    tipo = map[tipoColumn];
    descricao = map[descricaoColumn];
    
  }
 

  Map toMap(){
    Map<String,dynamic> map ={
      valorColumn :valor,
      dataColumn : data,
      tipoColumn : tipo,
      descricaoColumn : descricao,
      
    };
    if(id != null){
      map[idColumn] = id;
    }
    return map;
  }

  String toString(){
    return "Movimentaoes(id: $id, valor: $valor, data: $data, tipo: $tipo, desc: $descricao, )";
  }
}

*/