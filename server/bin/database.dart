import 'package:postgres/postgres.dart';

class DatabaseInitializer {
  final PostgreSQLConnection connection;

  DatabaseInitializer({required this.connection});

  Future<void> initializeDatabase() async {
    await connection.open();

    // Создание таблиц, если они не существуют
    await _createTables();
  }

  Future<void> _createTables() async {
    await connection.transaction((ctx) async {
      // Таблица User
      await ctx.execute('''
        CREATE TABLE IF NOT EXISTS "User" (
          "User ID" SERIAL PRIMARY KEY,
          "Username" VARCHAR(64) NOT NULL,
          "Password" VARCHAR(64) NOT NULL,
          "Position" VARCHAR(20) NOT NULL,
          "System Entry" TIMESTAMP NOT NULL,
          "System Exit" TIMESTAMP NOT NULL
        )
      ''');

      // Таблица Process
      await ctx.execute('''
        CREATE TABLE IF NOT EXISTS "Process" (
          "Process ID" SERIAL PRIMARY KEY,
          "Name" VARCHAR(20) NOT NULL,
          "Status" INTEGER NOT NULL,
          "Duration" INTEGER NOT NULL
        )
      ''');

      // Таблица Materials
      await ctx.execute('''
        CREATE TABLE IF NOT EXISTS "Materials" (
          "Material ID" SERIAL PRIMARY KEY,
          "Name" VARCHAR(64) NOT NULL,
          "Count" INTEGER NOT NULL
        )
      ''');

      // Таблица Equipment
      await ctx.execute('''
        CREATE TABLE IF NOT EXISTS "Equipment" (
          "Equipment ID" SERIAL PRIMARY KEY,
          "Status" VARCHAR(20) NOT NULL,
          "Name" VARCHAR(64) NOT NULL,
          "Class" VARCHAR(64) NOT NULL
        )
      ''');

      // Таблица Production
      await ctx.execute('''
        CREATE TABLE IF NOT EXISTS "Production" (
          "Production ID" SERIAL PRIMARY KEY,
          "Material ID" INTEGER NOT NULL REFERENCES "Materials"("Material ID"),
          "Name" VARCHAR(64) NOT NULL,
          "Equipment ID" INTEGER NOT NULL REFERENCES "Equipment"("Equipment ID"),
          "Process ID" INTEGER NOT NULL REFERENCES "Process"("Process ID"),
          "User ID" INTEGER NOT NULL REFERENCES "User"("User ID")
        )
      ''');

      // Таблица Logs
      await ctx.execute('''
        CREATE TABLE IF NOT EXISTS "Logs" (
          "Logs ID" SERIAL PRIMARY KEY,
          "Timestamp" TIMESTAMP NOT NULL,
          "Content" VARCHAR(256) NOT NULL,
          "Type" VARCHAR(32) NOT NULL,
          "Production ID" INTEGER NOT NULL REFERENCES "Production"("Production ID")
        )
      ''');
    });
  }
}
