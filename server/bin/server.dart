import 'dart:convert';
import 'dart:io';
import 'package:postgres/postgres.dart';

class Server {
  final int port = 228;
  final String dbHost;
  final int dbPort;
  final String dbName;
  final String dbUser;
  final String dbPassword;

  late HttpServer _server;
  late PostgreSQLConnection _dbConnection;

  Server({
    required this.dbHost,
    required this.dbPort,
    required this.dbName,
    required this.dbUser,
    required this.dbPassword,
  });

  Future<void> start() async {
    // Инициализация подключения к базе данных
    _dbConnection = PostgreSQLConnection(
      dbHost,
      dbPort,
      dbName,
      username: dbUser,
      password: dbPassword,
    );

    await _dbConnection.open();

    // Создание HTTP сервера
    _server = await HttpServer.bind('127.0.0.1', port);
    print('Server running on port $port');

    await for (HttpRequest request in _server) {
      _handleRequest(request);
    }
  }

  Future<void> _handleRequest(HttpRequest request) async {
    try {
      // Парсинг URL для определения маршрута
      final path = request.uri.path;
      final method = request.method;

      // Обработка CORS
      _setCorsHeaders(request.response);

      if (method == 'OPTIONS') {
        await request.response.close();
        return;
      }

      // Обработка разных маршрутов
      switch (path) {
        case '/api/equipment':
          await _handleEquipmentRequest(request);
          break;
        case '/api/production':
          await _handleProductionRequest(request);
          break;
        case '/api/logs':
          await _handleLogsRequest(request);
          break;
        case '/api/user':
          await _handleUserRequest(request);
          break;
        default:
          request.response
            ..statusCode = HttpStatus.notFound
            ..write('Not Found');
          await request.response.close();
      }
    } catch (e) {
      print('Error handling request: $e');
      request.response
        ..statusCode = HttpStatus.internalServerError
        ..write('Internal Server Error');
      await request.response.close();
    }
  }

  void _setCorsHeaders(HttpResponse response) {
    response.headers.add('Access-Control-Allow-Origin', '*');
    response.headers.add('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
    response.headers.add('Access-Control-Allow-Headers', 'Content-Type');
  }

  // Обработчики для разных таблиц
  Future<void> _handleEquipmentRequest(HttpRequest request) async {
    try {
      switch (request.method) {
        case 'GET':
          // Получение списка оборудования
          final results = await _dbConnection.query('SELECT * FROM "Equipment"');
          final equipmentList =
              results.map((row) {
                return {'equipmentId': row[0], 'status': row[1], 'name': row[2], 'class': row[3]};
              }).toList();

          request.response
            ..statusCode = HttpStatus.ok
            ..write(jsonEncode(equipmentList));
          await request.response.close();
          break;

        case 'POST':
        case 'PUT':
          // Добавление или обновление оборудования
          final body = await utf8.decoder.bind(request).join();
          final data = jsonDecode(body) as Map<String, dynamic>;

          if (request.method == 'POST') {
            await _dbConnection.execute(
              'INSERT INTO "Equipment" ("Status", "Name", "Class") VALUES (@status, @name, @class)',
              substitutionValues: {
                'status': data['status'],
                'name': data['name'],
                'class': data['class'],
              },
            );
          } else {
            await _dbConnection.execute(
              'UPDATE "Equipment" SET "Status" = @status, "Name" = @name, "Class" = @class WHERE "Equipment ID" = @id',
              substitutionValues: {
                'id': data['equipmentId'],
                'status': data['status'],
                'name': data['name'],
                'class': data['class'],
              },
            );
          }

          request.response
            ..statusCode = HttpStatus.ok
            ..write('Equipment ${request.method == 'POST' ? 'added' : 'updated'} successfully');
          await request.response.close();
          break;

        case 'DELETE':
          // Удаление оборудования
          final id = request.uri.queryParameters['id'];
          if (id == null) {
            request.response
              ..statusCode = HttpStatus.badRequest
              ..write('Missing equipment ID');
            await request.response.close();
            return;
          }

          await _dbConnection.execute(
            'DELETE FROM "Equipment" WHERE "Equipment ID" = @id',
            substitutionValues: {'id': int.parse(id)},
          );

          request.response
            ..statusCode = HttpStatus.ok
            ..write('Equipment deleted successfully');
          await request.response.close();
          break;

        default:
          request.response
            ..statusCode = HttpStatus.methodNotAllowed
            ..write('Method Not Allowed');
          await request.response.close();
      }
    } catch (e) {
      print('Error handling equipment request: $e');
      request.response
        ..statusCode = HttpStatus.internalServerError
        ..write('Error processing equipment request');
      await request.response.close();
    }
  }

  Future<void> _handleProductionRequest(HttpRequest request) async {
    try {
      if (request.method == 'GET') {
        // Получение данных о производстве с join'ами для связанных данных
        final results = await _dbConnection.query('''
          SELECT p."Production ID", p."Name", 
                 m."Name" as material_name, 
                 e."Name" as equipment_name, 
                 pr."Name" as process_name, 
                 u."Username"
          FROM "Production" p
          JOIN "Materials" m ON p."Material ID" = m."Material ID"
          JOIN "Equipment" e ON p."Equipment ID" = e."Equipment ID"
          JOIN "Process" pr ON p."Process ID" = pr."Process ID"
          JOIN "User" u ON p."User ID" = u."User ID"
        ''');

        final productionList =
            results.map((row) {
              return {
                'productionId': row[0],
                'name': row[1],
                'material': row[2],
                'equipment': row[3],
                'process': row[4],
                'user': row[5],
              };
            }).toList();

        request.response
          ..statusCode = HttpStatus.ok
          ..write(jsonEncode(productionList));
        await request.response.close();
      } else {
        request.response
          ..statusCode = HttpStatus.methodNotAllowed
          ..write('Method Not Allowed');
        await request.response.close();
      }
    } catch (e) {
      print('Error handling production request: $e');
      request.response
        ..statusCode = HttpStatus.internalServerError
        ..write('Error processing production request');
      await request.response.close();
    }
  }

  Future<void> _handleLogsRequest(HttpRequest request) async {
    try {
      if (request.method == 'GET') {
        // Получение логов с возможностью фильтрации по productionId
        final productionId = request.uri.queryParameters['productionId'];
        String query = 'SELECT * FROM "Logs"';
        List<dynamic> params = [];

        if (productionId != null) {
          query += ' WHERE "Production ID" = @productionId ORDER BY "Timestamp" DESC';
          params.add(int.parse(productionId));
        } else {
          query += ' ORDER BY "Timestamp" DESC LIMIT 100';
        }

        final results = await _dbConnection.query(
          query,
          substitutionValues:
              productionId != null ? {'productionId': int.parse(productionId)} : null,
        );

        final logsList =
            results.map((row) {
              return {
                'logId': row[0],
                'timestamp': row[1].toString(),
                'content': row[2],
                'type': row[3],
                'productionId': row[4],
              };
            }).toList();

        request.response
          ..statusCode = HttpStatus.ok
          ..write(jsonEncode(logsList));
        await request.response.close();
      } else {
        request.response
          ..statusCode = HttpStatus.methodNotAllowed
          ..write('Method Not Allowed');
        await request.response.close();
      }
    } catch (e) {
      print('Error handling logs request: $e');
      request.response
        ..statusCode = HttpStatus.internalServerError
        ..write('Error processing logs request');
      await request.response.close();
    }
  }

  Future<void> _handleUserRequest(HttpRequest request) async {
    try {
      if (request.method == 'POST') {
        // Добавление или обновление пользователя
        final body = await utf8.decoder.bind(request).join();
        final data = jsonDecode(body) as Map<String, dynamic>;

        await _dbConnection.execute(
          'INSERT INTO "User" ("Username", "Password", "Position", "System Entry", "System Exit") '
          'VALUES (@username, @password, @position, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)',
          substitutionValues: {
            'username': data['username'],
            'password': data['password'], // В реальной системе пароль должен быть хеширован
            'position': data['position'],
          },
        );

        request.response
          ..statusCode = HttpStatus.ok
          ..write('User added successfully');
        await request.response.close();
      } else {
        request.response
          ..statusCode = HttpStatus.methodNotAllowed
          ..write('Method Not Allowed');
        await request.response.close();
      }
    } catch (e) {
      print('Error handling user request: $e');
      request.response
        ..statusCode = HttpStatus.internalServerError
        ..write('Error processing user request');
      await request.response.close();
    }
  }

  Future<void> stop() async {
    await _server.close();
    await _dbConnection.close();
    print('Server stopped');
  }
}

void main() async {
  final server = Server(
    dbHost: 'localhost',
    dbPort: 5432,
    dbName: 'dry_mix_production',
    dbUser: 'postgres',
    dbPassword: 'password',
  );

  await server.start();
}
