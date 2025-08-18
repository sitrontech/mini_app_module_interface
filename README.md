# Mini App Module Interface - Project Structure

## 📁 Repository Structure

### **mini_app_module_interface** (Core Library)

```
flutter_module_interface/
├── lib/
│   ├── mini_app_module_interface.dart          # Main export file
│   └── src/
│       ├── core/
│       │   ├── module_config.dart             # Configuration model
│       │   ├── host_communication.dart        # Communication service
│       │   ├── module_lifecycle.dart          # Lifecycle mixin
│       │   └── module_base.dart               # Base module class
│       ├── models/
│       │   ├── module_user.dart               # User model
│       │   ├── module_event.dart              # Event model
│       │   └── module_result.dart             # Result model
│       ├── services/
│       │   ├── error_service.dart             # Error handling
│       │   └── navigation_service.dart        # Navigation service
│       └── utils/
│           └── module_logger.dart             # Logging utility
├── example/
│   └── lib/
│       └── main.dart                          # Example usage
├── test/
├── pubspec.yaml
├── README.md
├── CHANGELOG.md
└── LICENSE
```

---

## 📚 README.md for flutter_module_interface

````markdown
# Flutter Module Interface

A generic interface library for creating Flutter mini-applications that can be seamlessly integrated into host applications.

## 🚀 Features

- **State Management Agnostic**: Works with any state management solution (BLoC, Provider, Riverpod, etc.)
- **Generic Communication**: Event-based communication between modules and host apps
- **Lifecycle Management**: Built-in lifecycle hooks and state management
- **Error Handling**: Comprehensive error handling and reporting
- **Theme Integration**: Support for theme inheritance from host apps
- **Logging**: Built-in logging with module-specific context

## 📦 Installation

Add this to your module's `pubspec.yaml`:

```yaml
dependencies:
  mini_app_module_interface:
    git:
      url: https://github.com/your-org/mini_app_module_interface.git
      ref: main
```
````

## 🛠 Usage

### 1. Create a Module

```dart
import 'package:mini_app_module_interface/mini_app_module_interface.dart';

class MyModule extends MiniAppModuleBase {
  const MyModule({
    super.key,
    required super.config,
    super.onHostEvent,
  });

  @override
  Map<String, dynamic> get moduleMetadata => {
    'name': 'My Module',
    'version': '1.0.0',
    'description': 'A sample module',
  };

  @override
  bool canActivate() => config.hasUser;

  @override
  Widget buildModule(BuildContext context) {
    return MyModuleApp(config: config);
  }
}
```

### 2. Implement Module Logic

```dart
class MyModuleApp extends StatefulWidget {
  final ModuleConfig config;

  const MyModuleApp({super.key, required this.config});

  @override
  State<MyModuleApp> createState() => _MyModuleAppState();
}

class _MyModuleAppState extends State<MyModuleApp>
    with ModuleLifecycleMixin {

  @override
  void onModuleInit() {
    ModuleLogger.initialize(widget.config.moduleId);
    // Initialize your module
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Module'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => ModuleNavigationService.goBack(),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Text('Hello from ${widget.config.userName}!'),
            ElevatedButton(
              onPressed: () {
                HostCommunicationService.sendCustomEvent('button_pressed', {
                  'timestamp': DateTime.now().toIso8601String(),
                });
              },
              child: Text('Send Event to Host'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### 3. Integration in Host App

```dart
class MyModuleWrapper extends MiniAppModule {
  @override
  Widget createWidget({
    required ModuleConfig config,
    required AuthState authState,
    required ModuleEventBus eventBus,
    Map<String, dynamic>? initialData,
  }) {
    final moduleConfig = MiniAppModuleConfig(
      moduleId: 'my_module',
      userData: {
        'id': authState.user?.id,
        'name': authState.user?.name,
        'email': authState.user?.email,
      },
      ...config.setting,
      // ... other config
    );

    return MyModule(
      config: moduleConfig,
      onHostEvent: (eventType, data) {
        // Handle events from module
        _handleModuleEvent(eventType, data, eventBus);
      },
    );
  }
}
```

## 📡 Communication

### Sending Events from Module

```dart
// Navigation
ModuleNavigationService.goBack();
ModuleNavigationService.logout();

// Data requests
HostCommunicationService.requestData('user_preferences');

// Custom events
HostCommunicationService.sendCustomEvent('custom_action', {'data': 'value'});

// State changes
HostCommunicationService.notifyStateChange({'counter': 42});
```

### Handling Events in Host App

```dart
void _handleModuleEvent(String eventType, Map<String, dynamic> data, ModuleEventBus eventBus) {
  switch (eventType) {
    case 'navigation.request':
      // Handle navigation
      break;
    case 'data.request':
      // Handle data request
      break;
    case 'custom_action':
      // Handle custom events
      break;
  }
}
```

## 🧪 Testing

Run tests with:

```bash
flutter test
```

## 🎯 Benefits of This Architecture

1. **Modularity**: Each mini-app is independent
2. **Reusability**: Interface library can be used by multiple modules
3. **Maintainability**: Clear separation of concerns
4. **Scalability**: Easy to add new modules
5. **Testing**: Each component can be tested independently
6. **Version Control**: Separate versioning for library and implementations
