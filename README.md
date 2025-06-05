# 📝 Todo List Challenge

Una aplicación móvil construida con Flutter que implementa una lista de tareas intuitiva y funcional.

## 🚀 Instrucciones de Ejecución

Este proyecto utiliza **FVM (Flutter Version Management)** para el manejo de versiones de Flutter.

### Prerrequisitos

1. **Instalar FVM**
   ```bash
   dart pub global activate fvm
   ```

### Ejecución del Proyecto

1. **Clonar el repositorio**
   ```bash
   git clone https://github.com/DavidT-GuzmanD/To-Do_List_Challenge.git
   ```
   ```bash
   cd todo_list_challenge
   ```

2. **Configurar la versión de Flutter**
   ```bash
   fvm use 3.29.3
   ```

3. **Instalar dependencias**
   ```bash
   fvm flutter pub get
   ```

4. **Generar código necesario:**
    Ejecuta el siguiente comando para iniciar el build_runner
   ```bash
   dart run build_runner build
   ```
   Si estás usando Flutter, puedes usar el siguiente:
   ```bash
   fvm flutter pub run build_runner buildbuild
   ```

5. **Ejecutar la aplicación**
   ```bash
   fvm flutter run
   ```

## 📦 Dependencias y Versiones

### Entorno
- **Flutter**: `3.29.3`
- **Dart**: `3.7.2`

### Dependencias Principales

| Paquete | Versión | Propósito |
|---------|---------|-----------|
| `flutter_bloc` | 9.1.1 | Gestión de estado con patrón BLoC |
| `isar` | 3.1.0+1 | Base de datos local NoSQL |
| `isar_flutter_libs` | 3.1.0+1 | Librerías nativas de Isar para Flutter |
| `go_router` | 15.1.2 | Navegación declarativa |
| `formz` | 0.8.0 | Validación de formularios |
| `equatable` | 2.0.7 | Comparación de objetos |
| `path_provider` | 2.1.5 | Acceso a directorios del sistema |
| `uuid` | 4.5.1 | Generación de identificadores únicos |
| `intl` | 0.20.2 | Internacionalización y formateo |
| `alert_info` | 0.0.3 | Componente de alertas informativas |

### Dependencias de Desarrollo

| Paquete | Versión | Propósito |
|---------|---------|-----------|
| `build_runner` | 2.4.13 | Generación de código |
| `isar_generator` | 3.1.0+1 | Generador de código para Isar |
| `flutter_lints` | 5.0.0 | Reglas de linting para Flutter |
| `flutter_test` | SDK | Testing framework de Flutter |

## 🏗️ Arquitectura

El proyecto implementa **Clean Architecture (Arquitectura Limpia)**, siguiendo los principios de Robert C. Martin para crear un código mantenible, testeable y escalable.

### Capas de la Arquitectura
```
└── 📁lib
    └── 📁core
        └── 📁routing
            └── app_router.dart
        └── 📁theme
            └── app_colors.dart
    └── 📁features
        └── 📁task
            └── 📁data
                └── 📁datasources
                    └── task_local_datasource.dart
                └── 📁models
                    └── task_model.dart
                    └── task_model.g.dart
                └── 📁repositories
                    └── calendar_repository_impl.dart
                    └── task_repository_impl.dart
            └── 📁domain
                └── 📁entities
                    └── task_priority.dart
                    └── task.dart
                └── 📁repositories
                    └── calendar_repository.dart
                    └── task_repository.dart
                └── 📁usecases
                    └── add_task.dart
                    └── delete_task.dart
                    └── get_tasks_for_date_usecase.dart
                    └── get_tasks_for_month_usecase.dart
                    └── get_tasks.dart
                    └── update_task.dart
                    └── usecases_domain.dart
            └── 📁presentation
                └── 📁blocs
                    └── 📁calendar_bloc
                        └── calendar_bloc.dart
                        └── calendar_event.dart
                        └── calendar_state.dart
                    └── 📁task_bloc
                        └── task_bloc.dart
                        └── task_event.dart
                        └── task_state.dart
                └── 📁cubit
                    └── add_task_cubit.dart
                    └── add_task_state.dart
                └── 📁forms
                    └── task_form_inputs.dart
                └── 📁helpers
                    └── time_picker_helper.dart
                └── 📁pages
                    └── add_task_page.dart
                    └── calendar_page.dart
                    └── main_page.dart
                    └── task_list_page.dart
                    └── today_page.dart
                └── 📁utils
                    └── calendar_utils.dart
                └── 📁widgets
                    └── custom_bottom_nav_bar.dart
                    └── custom_calendar_widget.dart
                    └── custom_save_button.dart
                    └── custom_selector_tile.dart
                    └── custom_text_field.dart
                    └── icon_picker_dialog.dart
                    └── priority_bottom_sheet.dart
                    └── task_item.dart
    └── main.dart
```

### Principios Aplicados

- **Separación de responsabilidades**: Cada capa tiene una responsabilidad específica
- **Inversión de dependencias**: Las capas externas dependen de las internas
- **Independencia de frameworks**: La lógica de negocio es independiente de Flutter
- **Testabilidad**: Cada capa puede ser testeada de forma aislada


### Gestión de Estado

Utiliza **BLoC (Business Logic Component)** para:
- Separar la lógica de negocio de la UI
- Facilitar el testing
- Manejar estados de forma predecible
- Implementar arquitectura reactiva
