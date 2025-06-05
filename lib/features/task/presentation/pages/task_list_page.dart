
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_list_challenge/core/theme/app_colors.dart';
import 'package:todo_list_challenge/features/task/presentation/blocs/task_bloc/task_bloc.dart';
import 'package:todo_list_challenge/features/task/presentation/widgets/task_item.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Mis Tareas',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          
        ),
        backgroundColor: Colors.grey.shade50,
        actions: [
          IconButton(
              icon: const Icon(Icons.add, color: Colors.black87, size: 28),
              tooltip: 'Agregar Tarea',
              onPressed: () {
                 context.pushNamed('add_task');
              },
            ),
        ],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TaskLoaded) {
            if (state.tasks.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.task_alt, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No hay tareas pendientes',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Agrega una nueva tarea para comenzar',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            final completedTasks = state.tasks.where((task) => task.isCompleted).toList();
            final pendingTasks = state.tasks.where((task) => !task.isCompleted).toList();
            

            return RefreshIndicator(
              onRefresh: () async {
                context.read<TaskBloc>().add(LoadTasks());
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  // Leyenda informativa
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.swipe_rounded, color: AppColors.textSecondary, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Desliza a la derecha para editar o izquierda para eliminar',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
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
                          return TaskItem(task: pendingTasks[index]);
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
                        return completedTasks.map((task) => TaskItem(task: task)).elementAt(index);
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