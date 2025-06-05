import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_challenge/features/task/presentation/blocs/task_bloc/task_bloc.dart';
import 'package:todo_list_challenge/features/task/presentation/widgets/task_item.dart';

import 'package:intl/intl.dart';

class TodayPage extends StatelessWidget {
  const TodayPage({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final todayString = DateFormat('yyyy-MM-dd').format(today);
    // Formatear la fecha para mostrarla en el AppBar
    final todayFormatted = DateFormat('MMMM dd').format(today);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Hoy',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.grey.shade50,
        elevation: 0,
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TaskLoaded) {
            // Filtrar tareas por la fecha de hoy
            final todayTasks =
                state.tasks.where((task) {
                  final taskDateString = DateFormat(
                    'yyyy-MM-dd',
                  ).format(task.dueDate);
                  return taskDateString == todayString;
                }).toList();

            if (todayTasks.isEmpty) {
              return Column(
                children: [
                  // Fecha actual
                  Row(
                    children: [
                      Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        todayFormatted,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                                        ),
                    ],
                  ),
                  const Spacer(flex: 1),
              
                  const Icon(Icons.task_alt, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'No hay tareas pendientes',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Agrega una nueva tarea para comenzar',
                    style: TextStyle(color: Colors.grey),
                  ),

                  const Spacer(flex: 1),
                ],
              );
            }

            final completedTasks =
                todayTasks.where((task) => task.isCompleted).toList();
            final pendingTasks =
                todayTasks.where((task) => !task.isCompleted).toList();

            return RefreshIndicator(
              onRefresh: () async {
                context.read<TaskBloc>().add(LoadTasks());
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Fecha actual
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          todayFormatted,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Lista de tareas
                  if (pendingTasks.isNotEmpty) ...[
                    Text(
                      'Pendientes (${pendingTasks.length})',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: pendingTasks.length,
                        itemBuilder: (context, index) {
                          return TaskItem(
                            task: pendingTasks[index],
                            isCalendarView: true,
                          );
                        },
                      ),
                    ),
                  ],
                  if (completedTasks.isNotEmpty) ...[
                    Text(
                      'Completadas (${completedTasks.length})',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: completedTasks.length,
                        itemBuilder: (context, index) {
                          return TaskItem(
                            task: completedTasks[index],
                            isCalendarView: true,
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            );
          } else if (state is TaskError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${state.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<TaskBloc>().add(LoadTasks()),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
