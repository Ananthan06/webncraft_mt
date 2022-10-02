

// ignore_for_file: unnecessary_null_comparison, prefer_conditional_assignment

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:webncraft_mt/database/table_and_columns.dart';
import 'package:webncraft_mt/models/employee_model.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper; // Singleton DatabaseHelper
  static Database? _database; // Singleton Database

  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper
  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper
          ._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper!;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();

    String path = "";
    if (Platform.isIOS) {
      directory = await getApplicationSupportDirectory();
      if (!directory.parent.path.endsWith('/')) {
        path = '${directory.parent.path}/webncraft.db';
      } else {
        path = '${directory.parent.path}webncraft.db';
      }
    } else {
      path = '${directory.parent.path}/databases/webncraft.db';
      debugPrint("pathtest : $path");
    }

    var notesDatabase = await openDatabase(path,
        version: 1,
        onCreate: _createDb,
        );
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {

    var state = await db.execute(
        'CREATE TABLE $tableEmployee($id INT, $name TEXT, $userName TEXT, $email TEXT, $profileImage TEXT,'
            '$streetAddress TEXT, $suiteAddress TEXT, $cityAddress TEXT, $zipCodeAddress TEXT, $latGeoAddress TEXT,'
            '$lngGeoAddress TEXT, $phone TEXT, $website TEXT, $companyName TEXT, $companyCatchPhrase TEXT, $companyBse TEXT)');
  }

  // Future<int> insertLeadChannel(LeadChannel leadChannel) async {
  //   Database db = await this.database;
  //   var result = await db.insert(TABLE_LEAD_CHANNEL, leadChannel.toJson());
  //   return result;
  // }

  Future<int> insertReferral(EmployeeData employeeData) async {
    Database db = await database;
    var result = await db.rawInsert(
        "INSERT Into $tableEmployee($id, $name, $userName, $email, $profileImage, $streetAddress,"
            " $suiteAddress, $cityAddress, $zipCodeAddress, $latGeoAddress, $lngGeoAddress,"
            " $phone, $website, $companyName, $companyCatchPhrase, $companyBse)"
            " VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
        [
         employeeData.id,
          employeeData.name,
          employeeData.username,
          employeeData.email,
          employeeData.profileImage,
          employeeData.address!.street,
          employeeData.address!.suite,
          employeeData.address!.city,
          employeeData.address!.zipcode,
          employeeData.address!.geo!.lat,
          employeeData.address!.geo!.lng,
          employeeData.phone,
          employeeData.website,
          employeeData.company?.name,
          employeeData.company?.catchPhrase,
          employeeData.company?.bs

        ]);
    return result;
  }

  Future<int?> getCountInTable(String table) async {
    Database db = await database;
    List<Map<String, dynamic>> x =
    await db.rawQuery('SELECT COUNT (*) from $table');
    int? result = Sqflite.firstIntValue(x);
    return result;
  }


  Future<List<Map<String, dynamic>>> getFromDb() async{
    Database db = await database;
    String query =
        "select * from employee";
    var result = await db.rawQuery(query);
    return result;
  }


  }