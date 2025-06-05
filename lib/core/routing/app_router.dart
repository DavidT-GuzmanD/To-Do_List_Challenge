import 'package:go_router/go_router.dart';
import 'package:todo_list_challenge/features/todo/domain/entities/task.dart';
import 'package:todo_list_challenge/features/todo/presentation/pages/add_task_page.dart';
import 'package:todo_list_challenge/features/todo/presentation/pages/task_list_page.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'task_list',
      builder: (context, state) => const TaskListPage(),
      routes: [
        GoRoute(
          path: 'add-task',
          name: 'add_task',
          builder: (context, state) {
            final task = state.extra as Task?;
            return AddTaskPage(task: task);
          },
        ),
      ],
    ),
  ],
  debugLogDiagnostics: true, // Solo para desarrollo
);
