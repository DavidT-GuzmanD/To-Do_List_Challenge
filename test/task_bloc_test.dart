import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:todo_list_challenge/features/task/domain/entities/task.dart';
import 'package:todo_list_challenge/features/task/domain/entities/task_priority.dart';
import 'package:todo_list_challenge/features/task/domain/usecases/usecases_domain.dart';
import 'package:todo_list_challenge/features/task/presentation/blocs/task_bloc/task_bloc.dart';

import 'task_bloc_test.mocks.dart';

// Genera los mocks automáticamente con build_runner
@GenerateMocks([
  GetTasks,
  AddTask,
  UpdateTask,
  DeleteTask,
])
void main() {
  group('TaskBloc', () {
    late TaskBloc taskBloc;
    late MockGetTasks mockGetTasks;
    late MockAddTask mockAddTask;
    late MockUpdateTask mockUpdateTask;
    late MockDeleteTask mockDeleteTask;

    // Datos de prueba
    final testTask1 = Task(
      id: '1',
      title: 'Test Task 1',
      description: 'Description 1',
      isCompleted: false,
      createdAt: DateTime.now(), 
      dueDate: DateTime(2023, 10, 1),
      priority: TaskPriority.medium,
    );

    final testTask2 = Task(
      id: '2',
      title: 'Test Task 2',
      description: 'Description 2',
      isCompleted: true,
      createdAt: DateTime.now(),
      dueDate: DateTime(2023, 10, 2),
      priority: TaskPriority.high,
    );

    final testTasks = [testTask1, testTask2];

    setUp(() {
      mockGetTasks = MockGetTasks();
      mockAddTask = MockAddTask();
      mockUpdateTask = MockUpdateTask();
      mockDeleteTask = MockDeleteTask();

      taskBloc = TaskBloc(
        getTasks: mockGetTasks,
        addTask: mockAddTask,
        updateTask: mockUpdateTask,
        deleteTask: mockDeleteTask,
      );
    });

    tearDown(() {
      taskBloc.close();
    });

    test('estado inicial debe ser TaskInitial', () {
      expect(taskBloc.state, equals(TaskInitial()));
    });

    group('LoadTasks', () {
      blocTest<TaskBloc, TaskState>(
        'emite [TaskLoading, TaskLoaded] cuando LoadTasks es exitoso',
        build: () {
          when(mockGetTasks()).thenAnswer((_) async => testTasks);
          return taskBloc;
        },
        act: (bloc) => bloc.add(LoadTasks()),
        expect: () => [
          TaskLoading(),
          TaskLoaded(testTasks),
        ],
        verify: (_) {
          verify(mockGetTasks()).called(1);
        },
      );

      blocTest<TaskBloc, TaskState>(
        'emite [TaskLoading, TaskError] cuando LoadTasks falla',
        build: () {
          when(mockGetTasks()).thenThrow(Exception('Error al cargar tareas'));
          return taskBloc;
        },
        act: (bloc) => bloc.add(LoadTasks()),
        expect: () => [
          TaskLoading(),
          TaskError('Exception: Error al cargar tareas'),
        ],
        verify: (_) {
          verify(mockGetTasks()).called(1);
        },
      );

      blocTest<TaskBloc, TaskState>(
        'emite [TaskLoading, TaskLoaded] con lista vacía cuando no hay tareas',
        build: () {
          when(mockGetTasks()).thenAnswer((_) async => []);
          return taskBloc;
        },
        act: (bloc) => bloc.add(LoadTasks()),
        expect: () => [
          TaskLoading(),
          TaskLoaded([]),
        ],
        verify: (_) {
          verify(mockGetTasks()).called(1);
        },
      );
    });

    group('AddTaskEvent', () {
      blocTest<TaskBloc, TaskState>(
        'llama addTask y luego LoadTasks cuando AddTaskEvent es exitoso',
        build: () {
          when(mockAddTask(any)).thenAnswer((_) async => {});
          when(mockGetTasks()).thenAnswer((_) async => [testTask1]);
          return taskBloc;
        },
        act: (bloc) => bloc.add(AddTaskEvent(testTask1)),
        expect: () => [
          TaskLoading(),
          TaskLoaded([testTask1]),
        ],
        verify: (_) {
          verify(mockAddTask(testTask1)).called(1);
          verify(mockGetTasks()).called(1);
        },
      );

      blocTest<TaskBloc, TaskState>(
        'emite TaskError cuando AddTaskEvent falla',
        build: () {
          when(mockAddTask(any)).thenThrow(Exception('Error al agregar tarea'));
          return taskBloc;
        },
        act: (bloc) => bloc.add(AddTaskEvent(testTask1)),
        expect: () => [
          TaskError('Exception: Error al agregar tarea'),
        ],
        verify: (_) {
          verify(mockAddTask(testTask1)).called(1);
          verifyNever(mockGetTasks());
        },
      );
    });

    group('UpdateTaskEvent', () {
      blocTest<TaskBloc, TaskState>(
        'llama updateTask y luego LoadTasks cuando UpdateTaskEvent es exitoso',
        build: () {
          when(mockUpdateTask(any)).thenAnswer((_) async => {});
          when(mockGetTasks()).thenAnswer((_) async => [testTask1]);
          return taskBloc;
        },
        act: (bloc) => bloc.add(UpdateTaskEvent(testTask1)),
        expect: () => [
          TaskLoading(),
          TaskLoaded([testTask1]),
        ],
        verify: (_) {
          verify(mockUpdateTask(testTask1)).called(1);
          verify(mockGetTasks()).called(1);
        },
      );

      blocTest<TaskBloc, TaskState>(
        'emite TaskError cuando UpdateTaskEvent falla',
        build: () {
          when(mockUpdateTask(any)).thenThrow(Exception('Error al actualizar tarea'));
          return taskBloc;
        },
        act: (bloc) => bloc.add(UpdateTaskEvent(testTask1)),
        expect: () => [
          TaskError('Exception: Error al actualizar tarea'),
        ],
        verify: (_) {
          verify(mockUpdateTask(testTask1)).called(1);
          verifyNever(mockGetTasks());
        },
      );
    });

    group('DeleteTaskEvent', () {
      blocTest<TaskBloc, TaskState>(
        'llama deleteTask y luego LoadTasks cuando DeleteTaskEvent es exitoso',
        build: () {
          when(mockDeleteTask(any)).thenAnswer((_) async => {});
          when(mockGetTasks()).thenAnswer((_) async => [testTask2]);
          return taskBloc;
        },
        act: (bloc) => bloc.add(DeleteTaskEvent('1')),
        expect: () => [
          TaskLoading(),
          TaskLoaded([testTask2]),
        ],
        verify: (_) {
          verify(mockDeleteTask('1')).called(1);
          verify(mockGetTasks()).called(1);
        },
      );

      blocTest<TaskBloc, TaskState>(
        'emite TaskError cuando DeleteTaskEvent falla',
        build: () {
          when(mockDeleteTask(any)).thenThrow(Exception('Error al eliminar tarea'));
          return taskBloc;
        },
        act: (bloc) => bloc.add(DeleteTaskEvent('1')),
        expect: () => [
          TaskError('Exception: Error al eliminar tarea'),
        ],
        verify: (_) {
          verify(mockDeleteTask('1')).called(1);
          verifyNever(mockGetTasks());
        },
      );
    });

    group('ToggleTaskCompletion', () {
      blocTest<TaskBloc, TaskState>(
        'cambia el estado de completado y llama updateTask cuando ToggleTaskCompletion es exitoso',
        build: () {
          when(mockUpdateTask(any)).thenAnswer((_) async => {});
          when(mockGetTasks()).thenAnswer((_) async => [testTask1.copyWith(isCompleted: true)]);
          return taskBloc;
        },
        act: (bloc) => bloc.add(ToggleTaskCompletion(testTask1)),
        expect: () => [
          TaskLoading(),
          TaskLoaded([testTask1.copyWith(isCompleted: true)]),
        ],
        verify: (_) {
          final capturedTask = verify(mockUpdateTask(captureAny)).captured.first as Task;
          expect(capturedTask.isCompleted, equals(true));
          expect(capturedTask.id, equals(testTask1.id));
          expect(capturedTask.title, equals(testTask1.title));
          verify(mockGetTasks()).called(1);
        },
      );

      blocTest<TaskBloc, TaskState>(
        'cambia de completado a no completado cuando la tarea ya estaba completada',
        build: () {
          when(mockUpdateTask(any)).thenAnswer((_) async => {});
          when(mockGetTasks()).thenAnswer((_) async => [testTask2.copyWith(isCompleted: false)]);
          return taskBloc;
        },
        act: (bloc) => bloc.add(ToggleTaskCompletion(testTask2)),
        expect: () => [
          TaskLoading(),
          TaskLoaded([testTask2.copyWith(isCompleted: false)]),
        ],
        verify: (_) {
          final capturedTask = verify(mockUpdateTask(captureAny)).captured.first as Task;
          expect(capturedTask.isCompleted, equals(false));
          expect(capturedTask.id, equals(testTask2.id));
          verify(mockGetTasks()).called(1);
        },
      );

      blocTest<TaskBloc, TaskState>(
        'emite TaskError cuando ToggleTaskCompletion falla',
        build: () {
          when(mockUpdateTask(any)).thenThrow(Exception('Error al cambiar estado de tarea'));
          return taskBloc;
        },
        act: (bloc) => bloc.add(ToggleTaskCompletion(testTask1)),
        expect: () => [
          TaskError('Exception: Error al cambiar estado de tarea'),
        ],
        verify: (_) {
          verify(mockUpdateTask(any)).called(1);
          verifyNever(mockGetTasks());
        },
      );
    });

    group('Múltiples eventos', () {
      blocTest<TaskBloc, TaskState>(
        'maneja múltiples eventos correctamente',
        build: () {
          when(mockGetTasks()).thenAnswer((_) async => testTasks);
          when(mockAddTask(any)).thenAnswer((_) async => {});
          when(mockDeleteTask(any)).thenAnswer((_) async => {});
          return taskBloc;
        },
        act: (bloc) {
          bloc.add(LoadTasks());
          bloc.add(AddTaskEvent(testTask1));
          bloc.add(DeleteTaskEvent('1'));
        },
        expect: () => [
          TaskLoading(),
          TaskLoaded(testTasks),
          TaskLoading(),
          TaskLoaded(testTasks),
          TaskLoading(),
          TaskLoaded(testTasks),
        ],
        verify: (_) {
          verify(mockGetTasks()).called(3);
          verify(mockAddTask(testTask1)).called(1);
          verify(mockDeleteTask('1')).called(1);
        },
      );
    });

    group('Estados', () {
      test('TaskInitial props está vacío', () {
        expect(TaskInitial().props, equals([]));
      });

      test('TaskLoading props está vacío', () {
        expect(TaskLoading().props, equals([]));
      });

      test('TaskLoaded props contiene las tareas', () {
        final state = TaskLoaded(testTasks);
        expect(state.props, equals([testTasks]));
        expect(state.tasks, equals(testTasks));
      });

      test('TaskError props contiene el mensaje', () {
        const errorMessage = 'Error de prueba';
        const state = TaskError(errorMessage);
        expect(state.props, equals([errorMessage]));
        expect(state.message, equals(errorMessage));
      });

      test('Estados son iguales cuando tienen las mismas propiedades', () {
        final state1 = TaskLoaded(testTasks);
        final state2 = TaskLoaded(testTasks);
        expect(state1, equals(state2));

        const error1 = TaskError('Error');
        const error2 = TaskError('Error');
        expect(error1, equals(error2));
      });
    });

    group('Eventos', () {
      test('LoadTasks props está vacío', () {
        expect(LoadTasks().props, equals([]));
      });

      test('AddTaskEvent props contiene la tarea', () {
        final event = AddTaskEvent(testTask1);
        expect(event.props, equals([testTask1]));
        expect(event.task, equals(testTask1));
      });

      test('UpdateTaskEvent props contiene la tarea', () {
        final event = UpdateTaskEvent(testTask1);
        expect(event.props, equals([testTask1]));
        expect(event.task, equals(testTask1));
      });

      test('DeleteTaskEvent props contiene el ID de la tarea', () {
        const event = DeleteTaskEvent('1');
        expect(event.props, equals(['1']));
        expect(event.taskId, equals('1'));
      });

      test('ToggleTaskCompletion props contiene la tarea', () {
        final event = ToggleTaskCompletion(testTask1);
        expect(event.props, equals([testTask1]));
        expect(event.task, equals(testTask1));
      });

      test('Eventos son iguales cuando tienen las mismas propiedades', () {
        final event1 = AddTaskEvent(testTask1);
        final event2 = AddTaskEvent(testTask1);
        expect(event1, equals(event2));

        const deleteEvent1 = DeleteTaskEvent('1');
        const deleteEvent2 = DeleteTaskEvent('1');
        expect(deleteEvent1, equals(deleteEvent2));
      });
    });
  });
}