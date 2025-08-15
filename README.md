# Flutter Module Interface - Project Structure

## 📁 Repository Structure

### 1. **flutter_module_interface** (Core Library)

```
flutter_module_interface/
├── lib/
│   ├── flutter_module_interface.dart          # Main export file
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

### 2. **app2** (Example Implementation)

```
app2/
├── lib/
│   ├── app2.dart                              # Main export
│   └── src/
│       ├── pages/
│       │   ├── splash_page.dart               # Splash page
│       │   └── home_page.dart                 # Home page
│       └── providers/
│           └── user_provider.dart             # User state management
├── example/
├── test/
├── pubspec.yaml
├── README.md
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
  flutter_module_interface:
    git:
      url: https://github.com/your-org/flutter_module_interface.git
      ref: main
```
````

## 🛠 Usage

### 1. Create a Module

```dart
import 'package:flutter_module_interface/flutter_module_interface.dart';

class MyModule extends FlutterModuleBase {
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
class MyModuleWrapper extends FlutterModule {
  @override
  Widget createWidget({
    required ModuleConfig config,
    required AuthState authState,
    required ModuleEventBus eventBus,
    Map<String, dynamic>? initialData,
  }) {
    final moduleConfig = ModuleConfig(
      moduleId: 'my_module',
      userData: {
        'id': authState.user?.id,
        'name': authState.user?.name,
        'email': authState.user?.email,
      },
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

## 📖 Examples

See the `/example` folder for complete implementation examples.

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

````

---

## 📚 README.md for app2

```markdown
# App2 - Flutter Module Example

An example implementation of a Flutter mini-application using the `flutter_module_interface` library.

## 🚀 Features

- User authentication integration
- State management with Riverpod
- Navigation with GoRouter
- Host communication examples
- Error handling demonstrations

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.4.9
  go_router: ^14.1.0
  flutter_module_interface:
    git:
      url: https://github.com/your-org/flutter_module_interface.git
      ref: main
````

## 🛠 Usage as a Git Dependency

Add to your host app's `pubspec.yaml`:

```yaml
dependencies:
  app2:
    git:
      url: https://github.com/your-org/app2.git
      ref: main
```

## 🏗 Integration Example

```dart
import 'package:app2/app2.dart' as app2;
import 'package:flutter_module_interface/flutter_module_interface.dart';

class App2Module extends FlutterModule {
  @override
  Widget createWidget({
    required ModuleConfig config,
    required AuthState authState,
    required ModuleEventBus eventBus,
    Map<String, dynamic>? initialData,
  }) {
    final moduleConfig = ModuleConfig(
      moduleId: 'app2',
      initialRoute: '/',
      userData: {
        'id': authState.user?.id,
        'name': authState.user?.name,
        'email': authState.user?.email,
      },
    );

    return app2.App2(
      config: moduleConfig,
      onHostEvent: (eventType, data) {
        // Handle events from App2
      },
    );
  }
}
```

## 📱 Screenshots

[Add screenshots of your app here]

## 🧪 Testing

```bash
flutter test
```

## 📖 Documentation

For detailed documentation on the interface library, see:
[flutter_module_interface](https://github.com/your-org/flutter_module_interface)

## 🤝 Contributing

Contributions are welcome! Please read our contributing guidelines.

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

````

---

## 🚀 Getting Started Guide

### Step 1: Create Repositories

1. **Create `flutter_module_interface` repository**
   ```bash
   git clone https://github.com/your-org/flutter_module_interface.git
   cd flutter_module_interface
   # Add the library code
   flutter pub get
   flutter test
````

2. **Create `app2` repository**
   ```bash
   git clone https://github.com/your-org/app2.git
   cd app2
   # Add the app2 implementation
   flutter pub get
   flutter test
   ```

### Step 2: Test Integration

```dart
// In your host app (app1)
dependencies:
  app2:
    git:
      url: https://github.com/your-org/app2.git
      ref: main
```

### Step 3: Version Management

Use semantic versioning with git tags:

```bash
git tag v1.0.0
git push origin v1.0.0
```

Then reference specific versions:

```yaml
app2:
  git:
    url: https://github.com/your-org/app2.git
    ref: v1.0.0
```

---

## 🎯 Benefits of This Architecture

1. **Modularity**: Each mini-app is independent
2. **Reusability**: Interface library can be used by multiple modules
3. **Maintainability**: Clear separation of concerns
4. **Scalability**: Easy to add new modules
5. **Testing**: Each component can be tested independently
6. **Version Control**: Separate versioning for library and implementations
