import 'package:flutter/material.dart';
import 'package:nosso_primeiro_projeto/components/task.dart';
import 'package:nosso_primeiro_projeto/data/models/daos/task_dao.dart';
import 'package:nosso_primeiro_projeto/screens/form_screen.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({Key? key}) : super(key: key);

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  Widget _buildDone(List<Task>? items) {
    if (items != null && items.isNotEmpty) {
      return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            final Task task = items[index];
            return task;
          },
          itemCount: items.length);
    }
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Icon(
              Icons.error_outline,
              size: 128,
            ),
            Text(
              'Não há nenhuma Tarefa',
              style: TextStyle(fontSize: 32),
            ),
          ],
        ));
  }

  Widget _buildNoData() {
    return Center(
      child: Column(
        children: const [
          CircularProgressIndicator(),
          Text('Carregando'),
        ],
      ),
    );
  }

  Widget _buildApplication(ConnectionState state, List<Task>? items) {
    final Map<ConnectionState, dynamic> buildCases = {
      ConnectionState.done: _buildDone(items),
      ConnectionState.none: _buildNoData(),
      ConnectionState.waiting: _buildNoData(),
      ConnectionState.active: _buildNoData(),
    };

    return buildCases[state];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        actions: [
          IconButton(onPressed: () {
            setState(() {

            });
          }, icon: const Icon(Icons.refresh),)
        ],
        title: const Text('Tarefas'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 70),
        child: FutureBuilder<List<Task>>(
          future: TaskDao().findAll(),
          builder: (context, snapShot) {
            List<Task>? items = snapShot.data;
            return _buildApplication(snapShot.connectionState, items);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (contextNew) =>
                  FormScreen(
                    taskContext: context,
                  ),
            ),
          ).then((value) => setState(() {}));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
