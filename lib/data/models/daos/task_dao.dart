import 'package:flutter/material.dart';
import 'package:nosso_primeiro_projeto/components/task.dart';
import 'package:nosso_primeiro_projeto/data/database.dart';
import 'package:sqflite/sqflite.dart';

class TaskDao {
  static const String _tableName = 'taskTable';
  static const String _name = 'name';
  static const String _difficulty = 'difficulty';
  static const String _imageUrl = 'imageUrl';

  static const String tableSql = 'CREATE TABLE $_tableName('
      '$_name TEXT, '
      '$_difficulty INTEGER, '
      '$_imageUrl TEXT)';

  Map<String, dynamic> _toMap(Task task) {
    print('estamos convertendo a task: $task');
    final Map<String, dynamic> tasksMap = {};
    tasksMap[_name] = task.nome;
    tasksMap[_difficulty] = task.dificuldade;
    tasksMap[_imageUrl] = task.foto;
    return tasksMap;
  }

  Future<void> post(Task taskToSave) async {
    final Database database = await getDatabase();
    try {
      database.insert(_tableName, _toMap(taskToSave));
    } catch (e) {
      throw Exception();
    }
  }

  Future<void> update(Task taskToUpdate) async {
    final Database database = await getDatabase();
    try {
      database.update(_tableName, _toMap(taskToUpdate),
          where: '$_name = ?', whereArgs: [taskToUpdate.nome]);
    } catch (e) {
      throw Exception();
    }
  }

  Future<bool> createOrUpdate(Task toSaveTask) async {
    print('Iniciando o save:');
    final List<Task> taskAlreadyExists =
        await findByName(taskName: toSaveTask.nome);
    if (taskAlreadyExists.isNotEmpty) await update(toSaveTask);
    await post(toSaveTask);
    return true;
  }

  List<Task> _toList({required List<Map<String, dynamic>> taskList}) {
    final List<Task> tarefas = [];
    for (Map<String, dynamic> task in taskList) {
      final Task buildedTask =
          Task(task[_name], task[_imageUrl], task[_difficulty]);
      tarefas.add(buildedTask);
    }
    return tarefas;
  }

  Future<List<Task>> findAll() async {
    print('acessando o find all:');
    final Database database = await getDatabase();
    final List<Map<String, dynamic>> result = await database.query(_tableName);
    print('procurando resultados no banco de dados... encontrado: $result');
    return _toList(taskList: result);
  }

  Future<List<Task>> findByName({required String taskName}) async {
    print('acessando task espeifica');
    final Database bancoDeDados = await getDatabase();
    final List<Map<String, dynamic>> foundTask = await bancoDeDados
        .query(_tableName, where: '$_name = ?', whereArgs: [taskName]);
    print('tarefa encontrada! ${_toList(taskList: foundTask)}');
    return _toList(taskList: foundTask);
  }

  void delete({required String taskName}) async {
    final Database database = await getDatabase();
    await database.delete(_tableName, where: '$_name = ?', whereArgs: [taskName]);
  }
}
