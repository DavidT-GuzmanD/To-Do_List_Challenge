import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_list_challenge/core/routing/app_router.dart';
import 'package:todo_list_challenge/features/task/data/datasources/task_local_datasource.dart';
import 'package:todo_list_challenge/features/task/data/models/task_model.dart';
import 'package:todo_list_challenge/features/task/data/repositories/calendar_repository_impl.dart';
import 'package:todo_list_challenge/features/task/data/repositories/task_repository_impl.dart';
import 'package:todo_list_challenge/features/task/domain/usecases/get_tasks_for_date_usecase.dart';
import 'package:todo_list_challenge/features/task/domain/usecases/get_tasks_for_month_usecase.dart';
import 'package:todo_list_challenge/features/task/domain/usecases/usecases_domain.dart';
import 'package:todo_list_challenge/features/task/presentation/blocs/calendar_bloc/calendar_bloc.dart';
import 'package:todo_list_challenge/features/task/presentation/blocs/task_bloc/task_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Isar
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open([TaskModelSchema], directory: dir.path);

  // Initialize dependencies
  final taskLocalDataSource = TaskLocalDataSourceImpl(isar);
  final taskRepository = TaskRepositoryImpl(taskLocalDataSource);
  final calendarRepository = CalendarRepositoryImpl(taskLocalDataSource);

  final getTasks = GetTasks(taskRepository);
  final addTask = AddTask(taskRepository);
  final updateTask = UpdateTask(taskRepository);
  final deleteTask = DeleteTask(taskRepository);
  final getTasksForMonth = GetTasksForMonthUseCase(calendarRepository);
  final getTasksForDate = GetTasksForDateUseCase(calendarRepository);

  runApp(
    MyApp(
      getTasks: getTasks,
      addTask: addTask,
      updateTask: updateTask,
      deleteTask: deleteTask,
      getTasksForMonth: getTasksForMonth,
      getTasksForDate: getTasksForDate,
    ),
  );
}

class MyApp extends StatelessWidget {
  final GetTasks getTasks;
  final AddTask addTask;
  final UpdateTask updateTask;
  final DeleteTask deleteTask;
  final GetTasksForMonthUseCase getTasksForMonth;
  final GetTasksForDateUseCase getTasksForDate;

   const MyApp({
    super.key,
    required this.getTasks,
    required this.addTask,
    required this.updateTask,
    required this.deleteTask,
    required this.getTasksForMonth,
    required this.getTasksForDate,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) => TaskBloc(
                getTasks: getTasks,
                addTask: addTask,
                updateTask: updateTask,
                deleteTask: deleteTask,
              )..add(LoadTasks()),
        ),
        BlocProvider(create: (context) => CalendarBloc(
          getTasksForMonthUseCase: getTasksForMonth,
          getTasksForDateUseCase: getTasksForDate,
        )),
      ],
      child: MaterialApp.router(
        title: 'Todo App',
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        routerConfig: appRouter,
        // home: const TaskListPage(),
      ),
    );
  }
}
