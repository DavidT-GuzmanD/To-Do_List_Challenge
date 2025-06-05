import 'dart:io';

/// Script para ejecutar pruebas con diferentes niveles de verbosidad
void main(List<String> args) {
  print('🧪 FLUTTER TEST RUNNER');
  print('=' * 50);
  
  if (args.isEmpty) {
    _showUsage();
    return;
  }

  final mode = args[0].toLowerCase();
  
  switch (mode) {
    case 'detailed':
    case 'd':
      _runDetailedTests();
      break;
    case 'coverage':
    case 'c':
      _runWithCoverage();
      break;
    case 'watch':
    case 'w':
      _runWatchMode();
      break;
    case 'specific':
    case 's':
      if (args.length < 2) {
        print('❌ Especifica el archivo de prueba');
        return;
      }
      _runSpecificTest(args[1]);
      break;
    case 'quick':
    case 'q':
      _runQuickTests();
      break;
    default:
      print('❌ Modo no reconocido: $mode');
      _showUsage();
  }
}

void _showUsage() {
  print('''
📋 USO:
  dart test_runner.dart <modo>

🎯 MODOS DISPONIBLES:
  detailed, d    - Pruebas detalladas con información completa
  coverage, c    - Pruebas con reporte de cobertura
  watch, w       - Modo observación (re-ejecuta al cambiar archivos)
  specific, s    - Ejecuta un archivo específico
  quick, q       - Pruebas rápidas (menos detalles)

📝 EJEMPLOS:
  dart test_runner.dart detailed
  dart test_runner.dart coverage
  dart test_runner.dart specific test/task_bloc_test.dart
''');
}

void _runDetailedTests() {
  print('🔍 Ejecutando pruebas DETALLADAS...\n');
  
  final result = Process.runSync(
    'flutter',
    [
      'test',
      '--reporter=expanded',
      '--concurrency=1',
      '--coverage',
      
    ],
    runInShell: true,
  );
  
  _printResults(result, 'PRUEBAS DETALLADAS');
}

void _runWithCoverage() {
  print('📊 Ejecutando pruebas con COBERTURA...\n');
  
  // Ejecutar pruebas
  final testResult = Process.runSync(
    'flutter',
    ['test', '--coverage'],
    runInShell: true,
  );
  
  _printResults(testResult, 'PRUEBAS CON COBERTURA');
  
  // Generar reporte HTML de cobertura si está disponible
  print('\n📈 Generando reporte de cobertura HTML...');
  final coverageResult = Process.runSync(
    'genhtml',
    [
      'coverage/lcov.info',
      '-o',
      'coverage/html',
    ],
    runInShell: true,
  );
  
  if (coverageResult.exitCode == 0) {
    print('✅ Reporte HTML generado en: coverage/html/index.html');
  } else {
    print('⚠️  No se pudo generar reporte HTML (instala lcov: brew install lcov)');
  }
}

void _runWatchMode() {
  print('👀 Modo OBSERVACIÓN activado...');
  print('💡 Presiona Ctrl+C para salir\n');
  
  Process.start(
    'flutter',
    ['test', '--reporter=expanded'],
    runInShell: true,
  ).then((process) {
    process.stdout.listen((data) {
      stdout.add(data);
    });
    
    process.stderr.listen((data) {
      stderr.add(data);
    });
  });
}

void _runSpecificTest(String testFile) {
  print('🎯 Ejecutando prueba específica: $testFile\n');
  
  final result = Process.runSync(
    'flutter',
    [
      'test',
      testFile,
      '--reporter=expanded',
      '--plain-name',
    ],
    runInShell: true,
  );
  
  _printResults(result, 'PRUEBA ESPECÍFICA');
}

void _runQuickTests() {
  print('⚡ Ejecutando pruebas RÁPIDAS...\n');
  
  final result = Process.runSync(
    'flutter',
    [
      'test',
      '--reporter=compact',
      '--concurrency=4',
    ],
    runInShell: true,
  );
  
  _printResults(result, 'PRUEBAS RÁPIDAS');
}

void _printResults(ProcessResult result, String testType) {
  print('\n' + '=' * 60);
  print('📊 RESULTADOS - $testType');
  print('=' * 60);
  
  if (result.stdout.toString().isNotEmpty) {
    print('📤 SALIDA:');
    print(result.stdout);
  }
  
  if (result.stderr.toString().isNotEmpty) {
    print('❌ ERRORES:');
    print(result.stderr);
  }
  
  print('🏁 CÓDIGO DE SALIDA: ${result.exitCode}');
  
  if (result.exitCode == 0) {
    print('✅ TODAS LAS PRUEBAS PASARON');
  } else {
    print('❌ ALGUNAS PRUEBAS FALLARON');
  }
  
  print('=' * 60);
}