# 📊 Analytic Invest

Flutter aplikasi untuk analisis investasi yang dibangun dengan **Clean Architecture** + **Cubit** state management.

## 🚀 Tech Stack

- **Flutter** - Cross-platform framework
- **Clean Architecture** - Pemisahan concerns yang jelas
- **Cubit (BLoC)** - State management yang ringan
- **GetIt** - Dependency injection
- **Dio** - HTTP client
- **SharedPreferences** - Local storage
- **Dartz** - Functional programming
- **Equatable** - Value equality

## 📱 Features

- ✅ **Three-tab Navigation** (Home, Analytics, Profile)
- ✅ **Investment Analytics** dengan mock data
- ✅ **Responsive Design** dengan ScreenUtil
- ✅ **Local Caching** dengan SharedPreferences
- ✅ **Error Handling** yang comprehensive
- ✅ **Clean Architecture** implementation

## 🏗️ Architecture Overview

```
📱 Presentation Layer (UI)
    ↕️ Cubits, Pages, Widgets
🧠 Domain Layer (Business Logic)
    ↕️ Entities, Use Cases, Repository Contracts
💾 Data Layer (External Interface)
    ↕️ Models, Data Sources, Repository Implementation
```

### Layer Responsibilities:

- **Presentation**: UI components, state management (Cubits), user interactions
- **Domain**: Business logic, entities, use cases, repository contracts
- **Data**: External data handling, API calls, local storage, repository implementation

## 📁 Project Structure

```
lib/
├── main.dart                     # Entry point aplikasi
├── core/                         # Core utilities & shared components
│   ├── di/
│   │   └── injection_container.dart    # GetIt dependency injection setup
│   ├── constants/
│   │   └── app_constants.dart          # Application constants
│   ├── errors/
│   │   ├── exceptions.dart             # Custom exceptions
│   │   └── failures.dart               # Failure classes for error handling
│   ├── network/
│   │   └── network_info.dart           # Network connectivity checker
│   ├── theme/
│   │   └── app_theme.dart              # Application theming
│   └── utils/
│       └── usecase.dart                # Base use case class
└── features/                     # Feature-based modules
    ├── analytics/                # 📊 Analytics Feature
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   ├── analytics_datasource.dart           # Abstract data source
    │   │   │   ├── analytics_datasource_impl.dart     # API implementation
    │   │   │   └── mock_analytics_datasource.dart     # Mock implementation
    │   │   ├── models/
    │   │   │   └── investment_analysis_model.dart     # Data transfer object
    │   │   └── repositories/
    │   │       └── analytics_repository_impl.dart     # Repository implementation
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   └── investment_analysis.dart           # Business entity
    │   │   ├── repositories/
    │   │   │   └── analytics_repository.dart          # Repository contract
    │   │   └── usecases/
    │   │       └── get_analytics.dart                 # Business use case
    │   └── presentation/
    │       ├── cubit/
    │       │   ├── analytics_cubit.dart               # State management
    │       │   └── analytics_state.dart               # State definitions
    │       └── pages/
    │           └── analytics_page.dart                # UI page
    ├── home/                     # 🏠 Home Feature
    │   └── presentation/
    │       ├── cubit/
    │       │   ├── home_cubit.dart
    │       │   └── home_state.dart
    │       └── pages/
    │           └── home_page.dart
    ├── profile/                  # 👤 Profile Feature
    │   └── presentation/
    │       ├── cubit/
    │       │   ├── profile_cubit.dart
    │       │   └── profile_state.dart
    │       └── pages/
    │           └── profile_page.dart
    └── main_page/               # 🏗️ Main Navigation
        └── presentation/
            ├── cubit/
            │   ├── main_cubit.dart
            │   └── main_state.dart
            └── pages/
                └── main_page.dart
```

## 🔄 Data Flow

### Complete Analytics Feature Flow:

```
1. User Action (Pull to refresh)
   ↓
2. AnalyticsPage → AnalyticsCubit.loadAnalytics()
   ↓
3. AnalyticsCubit → GetAnalytics UseCase
   ↓
4. GetAnalytics → AnalyticsRepository
   ↓
5. AnalyticsRepositoryImpl checks NetworkInfo
   ↓
6a. If Connected:
    → RemoteDataSource (API/Mock)
    → Cache to LocalDataSource
    → Return data
   ↓
6b. If Offline:
    → LocalDataSource (SharedPreferences)
    → Return cached data
   ↓
7. Repository → UseCase → Cubit
   ↓
8. Cubit emits new state
   ↓
9. BlocBuilder rebuilds UI
```

## 🎯 State Management Flow

### Cubit Pattern:

```
User Interaction → Cubit Method → Emit State → UI Rebuild
```

### Example - Analytics Loading:

```dart
// 1. User action
onRefresh: () => context.read<AnalyticsCubit>().loadAnalytics(),

// 2. Cubit method
Future<void> loadAnalytics() async {
  emit(AnalyticsLoading());           // Loading state
  final result = await getAnalytics(NoParams());
  result.fold(
    (failure) => emit(AnalyticsError(failure.message)),  // Error state
    (analytics) => emit(AnalyticsLoaded(analytics)),     // Success state
  );
}

// 3. UI rebuild
BlocBuilder<AnalyticsCubit, AnalyticsState>(
  builder: (context, state) {
    if (state is AnalyticsLoading) return CircularProgressIndicator();
    if (state is AnalyticsLoaded) return AnalyticsList(state.analytics);
    if (state is AnalyticsError) return ErrorWidget(state.message);
    return Container();
  },
)
```

## 💉 Dependency Injection

### GetIt Registration:

```dart
Future<void> init() async {
  // 1. CUBITS (Factory - new instance setiap kali)
  sl.registerFactory(() => AnalyticsCubit(getAnalytics: sl()));
  sl.registerFactory(() => HomeCubit());
  sl.registerFactory(() => ProfileCubit());
  sl.registerFactory(() => MainCubit());

  // 2. USE CASES (Lazy Singleton - single instance)
  sl.registerLazySingleton(() => GetAnalytics(sl()));

  // 3. REPOSITORIES
  sl.registerLazySingleton<AnalyticsRepository>(
    () => AnalyticsRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // 4. DATA SOURCES
  sl.registerLazySingleton<AnalyticsRemoteDataSource>(
    () => MockAnalyticsRemoteDataSource(),
  );
  sl.registerLazySingleton<AnalyticsLocalDataSource>(
    () => AnalyticsLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // 5. EXTERNAL DEPENDENCIES
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
```

### Usage in main.dart:

```dart
MultiBlocProvider(
  providers: [
    BlocProvider<AnalyticsCubit>(
      create: (context) => di.sl<AnalyticsCubit>(),  // GetIt injection
    ),
    // ... other providers
  ],
  child: MaterialApp(/* ... */),
)
```

## 🧪 Key Classes Explained

### 1. Entity vs Model

**Entity (Domain Layer)**:
```dart
class InvestmentAnalysis extends Equatable {
  final String id;
  final String symbol;
  final String companyName;
  final double currentPrice;
  // ... business properties only
}
```

**Model (Data Layer)**:
```dart
class InvestmentAnalysisModel extends InvestmentAnalysis {
  // Inherits from entity + adds serialization
  factory InvestmentAnalysisModel.fromJson(Map<String, dynamic> json) {
    return InvestmentAnalysisModel(/* ... */);
  }
  
  Map<String, dynamic> toJson() {
    return {/* ... */};
  }
}
```

### 2. Repository Pattern

**Contract (Domain)**:
```dart
abstract class AnalyticsRepository {
  Future<Either<Failure, List<InvestmentAnalysis>>> getAnalytics();
}
```

**Implementation (Data)**:
```dart
class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final AnalyticsRemoteDataSource remoteDataSource;
  final AnalyticsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, List<InvestmentAnalysis>>> getAnalytics() async {
    if (await networkInfo.isConnected) {
      // Try remote first
      try {
        final remoteData = await remoteDataSource.getAnalytics();
        await localDataSource.cacheAnalytics(remoteData);
        return Right(remoteData);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      // Fallback to local cache
      try {
        final localData = await localDataSource.getCachedAnalytics();
        return Right(localData);
      } catch (e) {
        return Left(CacheFailure('No cached data available'));
      }
    }
  }
}
```

### 3. Use Case Pattern

```dart
class GetAnalytics implements UseCase<List<InvestmentAnalysis>, NoParams> {
  final AnalyticsRepository repository;

  GetAnalytics(this.repository);

  @override
  Future<Either<Failure, List<InvestmentAnalysis>>> call(NoParams params) async {
    return await repository.getAnalytics();
  }
}
```

### 4. Cubit State Management

```dart
class AnalyticsCubit extends Cubit<AnalyticsState> {
  final GetAnalytics getAnalytics;

  AnalyticsCubit({required this.getAnalytics}) : super(AnalyticsInitial());

  Future<void> loadAnalytics() async {
    try {
      emit(AnalyticsLoading());
      final result = await getAnalytics(NoParams());
      result.fold(
        (failure) => emit(AnalyticsError(failure.message ?? 'Unknown error')),
        (analytics) => emit(AnalyticsLoaded(analytics)),
      );
    } catch (e) {
      emit(AnalyticsError('Unexpected error: ${e.toString()}'));
    }
  }
}
```

## 🛠️ Memulai

### Prasyarat

- Flutter SDK ≥ 3.3.0
- Dart SDK ≥ 3.3.0

### Instalasi

1. **Clone repository:**
   ```bash
   git clone https://github.com/kidto1412/clean-architecture-cubit.git
   cd analytic_invest
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Jalankan aplikasi:**
   ```bash
   flutter run
   ```

### Dependencies

```yaml
dependencies:
  flutter_bloc: ^8.1.3          # State management
  get_it: ^7.6.4                # Dependency injection  
  dio: ^5.3.2                   # HTTP client
  shared_preferences: ^2.2.2    # Local storage
  dartz: ^0.10.1                # Functional programming
  equatable: ^2.0.5             # Value equality
  flutter_screenutil: ^5.9.3    # Responsive design
  retrofit: ^4.0.3              # Type-safe HTTP client
  pretty_dio_logger: ^1.3.1     # Network logging

dev_dependencies:
  build_runner: ^2.4.7          # Code generation
  retrofit_generator: ^8.0.4    # Retrofit code generation
  json_serializable: ^6.7.1     # JSON serialization
```

## 🧪 Panduan Development

### Menambah Fitur Baru

1. **Buat struktur fitur:**
   ```
   features/fitur_baru/
   ├── data/
   ├── domain/
   └── presentation/
   ```

2. **Implementasi layer (bottom-up):**
   - Data sources & models
   - Repository implementation
   - Entities & use cases
   - Cubit & UI

3. **Registrasi dependencies:**
   ```dart
   // Di injection_container.dart
   sl.registerFactory(() => FiturBaruCubit(useCase: sl()));
   sl.registerLazySingleton(() => FiturBaruUseCase(sl()));
   ```

### Strategi Testing

```dart
// Contoh Unit Test
group('AnalyticsCubit', () {
  late AnalyticsCubit cubit;
  late MockGetAnalytics mockGetAnalytics;

  setUp(() {
    mockGetAnalytics = MockGetAnalytics();
    cubit = AnalyticsCubit(getAnalytics: mockGetAnalytics);
  });

  test('harus emit AnalyticsLoaded ketika data berhasil dimuat', () async {
    // arrange
    when(mockGetAnalytics(any)).thenAnswer((_) async => Right(tAnalyticsList));

    // act
    cubit.loadAnalytics();

    // assert
    expectLater(cubit.stream, emitsInOrder([
      AnalyticsLoading(),
      AnalyticsLoaded(tAnalyticsList),
    ]));
  });
});
```

### Penanganan Error

```dart
// Custom Exceptions
class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}

// Custom Failures  
class ServerFailure extends Failure {
  ServerFailure(String message) : super(message);
}

// Penggunaan di Repository
try {
  final result = await remoteDataSource.getData();
  return Right(result);
} on ServerException catch (e) {
  return Left(ServerFailure(e.message));
} catch (e) {
  return Left(ServerFailure('Error tidak terduga: ${e.toString()}'));
}
```

## 📊 Keuntungan Arsitektur Ini

### ✅ Keuntungan Clean Architecture:
- **Separation of Concerns** - Pemisahan tanggung jawab yang jelas
- **Testability** - Mudah untuk unit test setiap layer
- **Maintainability** - Mudah untuk maintain dan update
- **Scalability** - Mudah menambah fitur baru
- **Independence** - Layer tidak bergantung satu sama lain

### ✅ Keuntungan Cubit:
- **Simplicity** - Lebih sederhana dari BLoC penuh
- **Performance** - State management yang ringan
- **Predictable** - Alur state yang jelas
- **Debuggable** - Mudah debug dengan BLoC Inspector

### ✅ Keuntungan GetIt:
- **Lightweight** - Tidak perlu code generation
- **Simple** - API yang mudah dipahami
- **Fast** - Performa yang baik
- **Flexible** - Dapat register berbagai tipe dependency

## 📚 Detailed Code Explanation

### 🎯 Main.dart - Entry Point

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();  // 1. Ensure Flutter is ready
  await di.init();                            // 2. Initialize dependencies
  runApp(const MyApp());                      // 3. Start the app
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(                    // 4. Responsive design setup
      designSize: const Size(375, 812),
      builder: (context, child) {
        return MultiBlocProvider(            // 5. Provide all Cubits
          providers: [
            BlocProvider<MainCubit>(
              create: (context) => di.sl<MainCubit>(),
            ),
            BlocProvider<HomeCubit>(
              create: (context) => di.sl<HomeCubit>()..loadHomeData(),
            ),
            BlocProvider<AnalyticsCubit>(
              create: (context) => di.sl<AnalyticsCubit>(),
            ),
            BlocProvider<ProfileCubit>(
              create: (context) => di.sl<ProfileCubit>(),
            ),
          ],
          child: MaterialApp(
            title: 'Analytic Invest',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            home: const MainPage(),          // 6. Navigate to main page
          ),
        );
      },
    );
  }
}
```

**Penjelasan Flow Main.dart:**
1. **WidgetsFlutterBinding** - Memastikan Flutter framework siap
2. **di.init()** - Setup semua dependencies dengan GetIt
3. **MultiBlocProvider** - Menyediakan semua Cubits ke widget tree
4. **ScreenUtilInit** - Setup responsive design untuk berbagai ukuran layar
5. **MainPage** - Halaman utama dengan bottom navigation

### 🏗️ Main Page - Navigation Hub

```dart
class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomePage(),        // Tab 0 - Home
      const AnalyticsPage(),   // Tab 1 - Analytics  
      const ProfilePage(),     // Tab 2 - Profile
    ];

    return BlocBuilder<MainCubit, MainState>(
      builder: (context, state) {
        int currentIndex = 0;
        if (state is MainTabChanged) {
          currentIndex = state.selectedIndex;
        }

        return Scaffold(
          body: IndexedStack(         // Maintain state across tabs
            index: currentIndex,
            children: pages,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) => context.read<MainCubit>().changeTab(index),
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.analytics_outlined),
                activeIcon: Icon(Icons.analytics),
                label: 'Analytics',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}
```

**Penjelasan Main Page:**
- **IndexedStack** - Mempertahankan state semua tab (tidak rebuild ulang)
- **BlocBuilder** - Mendengarkan perubahan state dari MainCubit
- **onTap** - Memicu MainCubit untuk mengganti tab
- **Three-tab navigation** - Navigasi tiga tab: Home, Analytics, Profile

### 🎯 MainCubit - Navigation State Management

```dart
class MainCubit extends Cubit<MainState> {
  MainCubit() : super(const MainTabChanged(0));

  void changeTab(int index) {
    emit(MainTabChanged(index));
  }

  int get currentIndex {
    if (state is MainTabChanged) {
      return (state as MainTabChanged).selectedIndex;
    }
    return 0;
  }
}

// Main States
abstract class MainState extends Equatable {
  const MainState();
  @override
  List<Object> get props => [];
}

class MainTabChanged extends MainState {
  final int selectedIndex;
  const MainTabChanged(this.selectedIndex);
  
  @override
  List<Object> get props => [selectedIndex];
}
```

### 🏠 Home Feature - Complete Implementation

#### HomeCubit State Management:
```dart
class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  Future<void> loadHomeData() async {
    try {
      emit(HomeLoading());
      
      // Simulate loading data (replace with real API call)
      await Future.delayed(const Duration(seconds: 1));
      
      emit(HomeLoaded(
        welcomeMessage: 'Welcome to Analytic Invest',
        recentActivity: [
          'Portfolio updated',
          'New analysis available',
          'Price alert triggered',
        ],
      ));
    } catch (e) {
      emit(HomeError('Failed to load home data: ${e.toString()}'));
    }
  }

  Future<void> refreshHomeData() async {
    await loadHomeData();
  }
}
```

#### HomeStates:
```dart
abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final String welcomeMessage;
  final List<String> recentActivity;

  const HomeLoaded({
    required this.welcomeMessage,
    required this.recentActivity,
  });

  @override
  List<Object> get props => [welcomeMessage, recentActivity];
}

class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);
  
  @override
  List<Object> get props => [message];
}
```

#### HomePage UI Implementation:
```dart
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        elevation: 0,
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Section with Gradient
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColor.withOpacity(0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state is HomeLoaded 
                            ? state.welcomeMessage 
                            : 'Welcome to Analytic Invest',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Track your investments and make informed decisions',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Quick Actions Section
                const Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Expanded(
                      child: _buildQuickActionCard(
                        context,
                        icon: Icons.analytics,
                        title: 'Analytics',
                        subtitle: 'View detailed analysis',
                        onTap: () => context.read<MainCubit>().changeTab(1),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildQuickActionCard(
                        context,
                        icon: Icons.person,
                        title: 'Profile',
                        subtitle: 'Manage your settings',
                        onTap: () => context.read<MainCubit>().changeTab(2),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Recent Activity Section
                const Text(
                  'Recent Activity',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Activity List
                if (state is HomeLoaded)
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.recentActivity.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              child: Icon(
                                Icons.notifications,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(state.recentActivity[index]),
                            subtitle: Text('Just now'),
                            trailing: Icon(Icons.arrow_forward_ios),
                          ),
                        );
                      },
                    ),
                  ),
                
                if (state is HomeLoading)
                  const Center(child: CircularProgressIndicator()),
                
                if (state is HomeError)
                  Center(
                    child: Column(
                      children: [
                        Text('Error: ${state.message}'),
                        ElevatedButton(
                          onPressed: () => context.read<HomeCubit>().refreshHomeData(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(
                icon,
                size: 32,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

### 📊 Analytics Feature - Clean Architecture Implementation

#### 1. Domain Layer (Business Logic)

**InvestmentAnalysis Entity:**
```dart
class InvestmentAnalysis extends Equatable {
  final String id;
  final String symbol;
  final String companyName;
  final double currentPrice;
  final double targetPrice;
  final String recommendation;  // BUY, SELL, HOLD
  final double riskScore;       // 1.0 - 5.0
  final DateTime lastUpdated;

  const InvestmentAnalysis({
    required this.id,
    required this.symbol,
    required this.companyName,
    required this.currentPrice,
    required this.targetPrice,
    required this.recommendation,
    required this.riskScore,
    required this.lastUpdated,
  });

  @override
  List<Object> get props => [
    id, symbol, companyName, currentPrice, 
    targetPrice, recommendation, riskScore, lastUpdated
  ];
}
```

**AnalyticsRepository Contract:**
```dart
abstract class AnalyticsRepository {
  Future<Either<Failure, List<InvestmentAnalysis>>> getAnalytics();
  Future<Either<Failure, InvestmentAnalysis>> getAnalysisById(String id);
}
```

**GetAnalytics UseCase:**
```dart
class GetAnalytics implements UseCase<List<InvestmentAnalysis>, NoParams> {
  final AnalyticsRepository repository;

  GetAnalytics(this.repository);

  @override
  Future<Either<Failure, List<InvestmentAnalysis>>> call(NoParams params) async {
    return await repository.getAnalytics();
  }
}
```

#### 2. Data Layer (External Interface)

**InvestmentAnalysisModel (DTO):**
```dart
class InvestmentAnalysisModel extends InvestmentAnalysis {
  const InvestmentAnalysisModel({
    required String id,
    required String symbol,
    required String companyName,
    required double currentPrice,
    required double targetPrice,
    required String recommendation,
    required double riskScore,
    required DateTime lastUpdated,
  }) : super(
    id: id,
    symbol: symbol,
    companyName: companyName,
    currentPrice: currentPrice,
    targetPrice: targetPrice,
    recommendation: recommendation,
    riskScore: riskScore,
    lastUpdated: lastUpdated,
  );

  factory InvestmentAnalysisModel.fromJson(Map<String, dynamic> json) {
    return InvestmentAnalysisModel(
      id: json['id'] as String,
      symbol: json['symbol'] as String,
      companyName: json['company_name'] as String,
      currentPrice: (json['current_price'] as num).toDouble(),
      targetPrice: (json['target_price'] as num).toDouble(),
      recommendation: json['recommendation'] as String,
      riskScore: (json['risk_score'] as num).toDouble(),
      lastUpdated: DateTime.parse(json['last_updated'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'symbol': symbol,
      'company_name': companyName,
      'current_price': currentPrice,
      'target_price': targetPrice,
      'recommendation': recommendation,
      'risk_score': riskScore,
      'last_updated': lastUpdated.toIso8601String(),
    };
  }
}
```

**MockAnalyticsRemoteDataSource:**
```dart
class MockAnalyticsRemoteDataSource implements AnalyticsRemoteDataSource {
  @override
  Future<List<InvestmentAnalysisModel>> getAnalytics() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    
    return [
      InvestmentAnalysisModel(
        id: '1',
        symbol: 'AAPL',
        companyName: 'Apple Inc.',
        currentPrice: 150.25,
        targetPrice: 175.00,
        recommendation: 'BUY',
        riskScore: 3.2,
        lastUpdated: DateTime.now(),
      ),
      InvestmentAnalysisModel(
        id: '2',
        symbol: 'GOOGL',
        companyName: 'Alphabet Inc.',
        currentPrice: 2750.80,
        targetPrice: 3000.00,
        recommendation: 'BUY',
        riskScore: 3.5,
        lastUpdated: DateTime.now(),
      ),
      InvestmentAnalysisModel(
        id: '3',
        symbol: 'TSLA',
        companyName: 'Tesla Inc.',
        currentPrice: 850.50,
        targetPrice: 900.00,
        recommendation: 'HOLD',
        riskScore: 4.2,
        lastUpdated: DateTime.now(),
      ),
      InvestmentAnalysisModel(
        id: '4',
        symbol: 'MSFT',
        companyName: 'Microsoft Corporation',
        currentPrice: 330.75,
        targetPrice: 350.00,
        recommendation: 'BUY',
        riskScore: 2.8,
        lastUpdated: DateTime.now(),
      ),
      InvestmentAnalysisModel(
        id: '5',
        symbol: 'AMZN',
        companyName: 'Amazon.com Inc.',
        currentPrice: 3200.25,
        targetPrice: 3100.00,
        recommendation: 'SELL',
        riskScore: 3.8,
        lastUpdated: DateTime.now(),
      ),
    ];
  }
}
```

**AnalyticsLocalDataSource Implementation:**
```dart
class AnalyticsLocalDataSourceImpl implements AnalyticsLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String analyticsKey = 'CACHED_ANALYTICS';

  AnalyticsLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<InvestmentAnalysisModel>> getCachedAnalytics() async {
    try {
      final jsonString = sharedPreferences.getString(analyticsKey);
      if (jsonString != null) {
        final List<dynamic> jsonList = json.decode(jsonString);
        return jsonList
            .map((json) => InvestmentAnalysisModel.fromJson(json))
            .toList();
      } else {
        throw CacheException('No cached analytics found');
      }
    } catch (e) {
      throw CacheException('Failed to load cached analytics: ${e.toString()}');
    }
  }

  @override
  Future<void> cacheAnalytics(List<InvestmentAnalysisModel> analytics) async {
    try {
      final jsonString = json.encode(
        analytics.map((analysis) => analysis.toJson()).toList(),
      );
      await sharedPreferences.setString(analyticsKey, jsonString);
    } catch (e) {
      throw CacheException('Failed to cache analytics: ${e.toString()}');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await sharedPreferences.remove(analyticsKey);
    } catch (e) {
      throw CacheException('Failed to clear cache: ${e.toString()}');
    }
  }
}
```

**AnalyticsRepositoryImpl:**
```dart
class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final AnalyticsRemoteDataSource remoteDataSource;
  final AnalyticsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AnalyticsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<InvestmentAnalysis>>> getAnalytics() async {
    if (await networkInfo.isConnected) {
      try {
        // Try to fetch from remote source
        final remoteAnalytics = await remoteDataSource.getAnalytics();
        
        // Cache the data locally
        await localDataSource.cacheAnalytics(remoteAnalytics);
        
        return Right(remoteAnalytics);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Unexpected error: ${e.toString()}'));
      }
    } else {
      try {
        // No internet, try to get cached data
        final localAnalytics = await localDataSource.getCachedAnalytics();
        return Right(localAnalytics);
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      } catch (e) {
        return Left(CacheFailure('Failed to load cached data: ${e.toString()}'));
      }
    }
  }

  @override
  Future<Either<Failure, InvestmentAnalysis>> getAnalysisById(String id) async {
    try {
      final analytics = await getAnalytics();
      return analytics.fold(
        (failure) => Left(failure),
        (analyticsList) {
          final analysis = analyticsList.firstWhere(
            (analysis) => analysis.id == id,
            orElse: () => throw Exception('Analysis not found'),
          );
          return Right(analysis);
        },
      );
    } catch (e) {
      return Left(ServerFailure('Analysis not found: ${e.toString()}'));
    }
  }
}
```

#### 3. Presentation Layer (UI)

**AnalyticsCubit:**
```dart
class AnalyticsCubit extends Cubit<AnalyticsState> {
  final GetAnalytics getAnalytics;

  AnalyticsCubit({required this.getAnalytics}) : super(AnalyticsInitial());

  Future<void> loadAnalytics() async {
    try {
      emit(AnalyticsLoading());
      
      final result = await getAnalytics(NoParams());
      
      result.fold(
        (failure) => emit(AnalyticsError(failure.message ?? 'Unknown error occurred')),
        (analytics) => emit(AnalyticsLoaded(analytics)),
      );
    } catch (e) {
      emit(AnalyticsError('An unexpected error occurred: ${e.toString()}'));
    }
  }

  Future<void> refreshAnalytics() async {
    await loadAnalytics();
  }

  void clearError() {
    if (state is AnalyticsError) {
      emit(AnalyticsInitial());
    }
  }
}
```

**AnalyticsStates:**
```dart
abstract class AnalyticsState extends Equatable {
  const AnalyticsState();

  @override
  List<Object> get props => [];
}

class AnalyticsInitial extends AnalyticsState {}

class AnalyticsLoading extends AnalyticsState {}

class AnalyticsLoaded extends AnalyticsState {
  final List<InvestmentAnalysis> analytics;

  const AnalyticsLoaded(this.analytics);

  @override
  List<Object> get props => [analytics];
}

class AnalyticsError extends AnalyticsState {
  final String message;

  const AnalyticsError(this.message);

  @override
  List<Object> get props => [message];
}
```

**AnalyticsPage UI:**
```dart
class AnalyticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Investment Analytics'),
        elevation: 0,
      ),
      body: BlocBuilder<AnalyticsCubit, AnalyticsState>(
        builder: (context, state) {
          // Loading State
          if (state is AnalyticsLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading analytics...'),
                ],
              ),
            );
          }

          // Error State
          if (state is AnalyticsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<AnalyticsCubit>().refreshAnalytics(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Success State with Data
          if (state is AnalyticsLoaded) {
            if (state.analytics.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.analytics_outlined,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No analytics data available',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<AnalyticsCubit>().loadAnalytics(),
                      child: const Text('Load Analytics'),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => context.read<AnalyticsCubit>().refreshAnalytics(),
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: state.analytics.length,
                itemBuilder: (context, index) {
                  final analysis = state.analytics[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    elevation: 2,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _getRecommendationColor(analysis.recommendation),
                        child: Text(
                          analysis.symbol.substring(0, 2).toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        analysis.companyName,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Symbol: ${analysis.symbol}'),
                          Text('Risk Score: ${analysis.riskScore.toStringAsFixed(1)}'),
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${analysis.currentPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            analysis.recommendation,
                            style: TextStyle(
                              color: _getRecommendationColor(analysis.recommendation),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        // Navigate to detail page
                        _showAnalysisDetail(context, analysis);
                      },
                    ),
                  );
                },
              ),
            );
          }

          // Initial State
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.analytics_outlined,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Welcome to Analytics',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tap the button below to load investment analytics',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.read<AnalyticsCubit>().loadAnalytics(),
                  child: const Text('Load Analytics'),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<AnalyticsCubit>().loadAnalytics(),
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Color _getRecommendationColor(String recommendation) {
    switch (recommendation.toUpperCase()) {
      case 'BUY':
        return Colors.green;
      case 'SELL':
        return Colors.red;
      case 'HOLD':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void _showAnalysisDetail(BuildContext context, InvestmentAnalysis analysis) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(analysis.companyName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Symbol: ${analysis.symbol}'),
            Text('Current Price: \$${analysis.currentPrice.toStringAsFixed(2)}'),
            Text('Target Price: \$${analysis.targetPrice.toStringAsFixed(2)}'),
            Text('Recommendation: ${analysis.recommendation}'),
            Text('Risk Score: ${analysis.riskScore.toStringAsFixed(1)}/5.0'),
            Text('Last Updated: ${analysis.lastUpdated.toString().split(' ')[0]}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
```

### 👤 Profile Feature Implementation

#### ProfileCubit:
```dart
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial()) {
    _loadProfile();
  }

  void _loadProfile() {
    emit(const ProfileLoaded(
      userName: 'John Doe',
      userEmail: 'john.doe@example.com',
      isDarkMode: false,
      isNotificationsEnabled: true,
    ));
  }

  void toggleDarkMode() {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      emit(currentState.copyWith(isDarkMode: !currentState.isDarkMode));
      // Here you would typically save to SharedPreferences
    }
  }

  void toggleNotifications() {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      emit(currentState.copyWith(
        isNotificationsEnabled: !currentState.isNotificationsEnabled
      ));
      // Here you would typically save to SharedPreferences
    }
  }

  void updateProfile(String name, String email) {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      emit(currentState.copyWith(
        userName: name,
        userEmail: email,
      ));
      // Here you would typically save to API/SharedPreferences
    }
  }

  void logout() {
    emit(ProfileInitial());
    // Here you would typically:
    // - Clear SharedPreferences
    // - Clear authentication tokens
    // - Navigate to login screen
  }
}
```

## 🔧 Error Handling Strategy

### Custom Exceptions:
```dart
// Core Exceptions
abstract class AppException implements Exception {
  final String message;
  AppException(this.message);
}

class ServerException extends AppException {
  ServerException(String message) : super(message);
}

class NetworkException extends AppException {
  NetworkException(String message) : super(message);
}

class CacheException extends AppException {
  CacheException(String message) : super(message);
}
```

### Custom Failures:
```dart
// Core Failures
abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure(String message) : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(String message) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure(String message) : super(message);
}
```

### Error Handling in Repository:
```dart
@override
Future<Either<Failure, List<InvestmentAnalysis>>> getAnalytics() async {
  try {
    if (await networkInfo.isConnected) {
      // Try remote first
      final remoteData = await remoteDataSource.getAnalytics();
      await localDataSource.cacheAnalytics(remoteData);
      return Right(remoteData);
    } else {
      // Fallback to cache
      final cachedData = await localDataSource.getCachedAnalytics();
      return Right(cachedData);
    }
  } on ServerException catch (e) {
    return Left(ServerFailure('Server error: ${e.message}'));
  } on NetworkException catch (e) {
    return Left(NetworkFailure('Network error: ${e.message}'));
  } on CacheException catch (e) {
    return Left(CacheFailure('Cache error: ${e.message}'));
  } catch (e) {
    return Left(ServerFailure('Unexpected error: ${e.toString()}'));
  }
}
```

## 🧪 Testing Strategy

### Unit Testing Cubit:
```dart
void main() {
  group('AnalyticsCubit', () {
    late AnalyticsCubit analyticsCubit;
    late MockGetAnalytics mockGetAnalytics;

    setUp(() {
      mockGetAnalytics = MockGetAnalytics();
      analyticsCubit = AnalyticsCubit(getAnalytics: mockGetAnalytics);
    });

    tearDown(() {
      analyticsCubit.close();
    });

    test('initial state should be AnalyticsInitial', () {
      expect(analyticsCubit.state, equals(AnalyticsInitial()));
    });

    group('loadAnalytics', () {
      const tAnalyticsList = [
        InvestmentAnalysis(
          id: '1',
          symbol: 'AAPL',
          companyName: 'Apple Inc.',
          currentPrice: 150.0,
          targetPrice: 175.0,
          recommendation: 'BUY',
          riskScore: 3.2,
          lastUpdated: DateTime(2023, 1, 1),
        ),
      ];

      test('should emit [AnalyticsLoading, AnalyticsLoaded] when data is gotten successfully',
          () async {
        // arrange
        when(mockGetAnalytics(any))
            .thenAnswer((_) async => const Right(tAnalyticsList));

        // assert later
        final expected = [
          AnalyticsLoading(),
          const AnalyticsLoaded(tAnalyticsList),
        ];
        expectLater(analyticsCubit.stream, emitsInOrder(expected));

        // act
        analyticsCubit.loadAnalytics();
      });

      test('should emit [AnalyticsLoading, AnalyticsError] when getting data fails',
          () async {
        // arrange
        when(mockGetAnalytics(any))
            .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));

        // assert later
        final expected = [
          AnalyticsLoading(),
          const AnalyticsError('Server Failure'),
        ];
        expectLater(analyticsCubit.stream, emitsInOrder(expected));

        // act
        analyticsCubit.loadAnalytics();
      });
    });
  });
}
```

### Widget Testing:
```dart
void main() {
  group('AnalyticsPage', () {
    late MockAnalyticsCubit mockAnalyticsCubit;

    setUp(() {
      mockAnalyticsCubit = MockAnalyticsCubit();
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: BlocProvider<AnalyticsCubit>.value(
          value: mockAnalyticsCubit,
          child: const AnalyticsPage(),
        ),
      );
    }

    testWidgets('should show progress indicator when state is loading',
        (WidgetTester tester) async {
      // arrange
      when(() => mockAnalyticsCubit.state).thenReturn(AnalyticsLoading());

      // act
      await tester.pumpWidget(createWidgetUnderTest());

      // assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should show error message when state is error',
        (WidgetTester tester) async {
      // arrange
      when(() => mockAnalyticsCubit.state)
          .thenReturn(const AnalyticsError('Something went wrong'));

      // act
      await tester.pumpWidget(createWidgetUnderTest());

      // assert
      expect(find.text('Error: Something went wrong'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });
  });
}
```

## 🎯 Mengapa Arsitektur Ini Efektif

### 1. **Skalabilitas**
- Mudah menambah fitur baru dengan mengikuti pola yang sama
- Setiap fitur bersifat independen dan mandiri
- Pemisahan tanggung jawab yang jelas

### 2. **Testabilitas**
- Setiap layer dapat ditest secara independen
- Mudah untuk mock dependencies
- Input/output yang jelas untuk setiap komponen

### 3. **Maintainability**
- Perubahan di satu layer tidak mempengaruhi layer lain
- Struktur kode yang mudah dipahami
- Pola yang konsisten di seluruh fitur

### 4. **Pengembangan Tim**
- Beberapa developer dapat bekerja pada fitur berbeda secara bersamaan
- Kontrak yang jelas antar layer
- Onboarding mudah untuk anggota tim baru

### 5. **Performa**
- State management yang efisien dengan Cubit
- Strategi local caching
- Minimal rebuild dengan state management yang tepat

---

## 🤝 Berkontribusi

1. Fork repository ini
2. Buat feature branch (`git checkout -b feature/fitur-amazing`)
3. Commit perubahan Anda (`git commit -m 'Tambah fitur amazing'`)
4. Push ke branch (`git push origin feature/fitur-amazing`)
5. Buka Pull Request

## 📄 Lisensi

Proyek ini dilisensikan di bawah MIT License - lihat file [LICENSE](LICENSE) untuk detailnya.

## 🙏 Penghargaan

- Tim Flutter untuk framework yang luar biasa
- Maintainer library BLoC
- Prinsip Clean Architecture oleh Uncle Bob

---

**Dibuat dengan ❤️ menggunakan Flutter & Clean Architecture**

---

# 📚 DOKUMENTASI LENGKAP: FLUTTER CLEAN ARCHITECTURE + CUBIT

## 📋 DAFTAR ISI

1. [Pengantar Proyek](#-pengantar-proyek)
2. [Arsitektur Clean Architecture](#️-arsitektur-clean-architecture)  
3. [State Management dengan Cubit](#-state-management-dengan-cubit)
4. [Dependency Injection dengan GetIt](#-dependency-injection-dengan-getit)
5. [Struktur Proyek](#-struktur-proyek)
6. [Flow Pengerjaan](#-flow-pengerjaan)
7. [Penjelasan Kode per Layer](#-penjelasan-kode-per-layer)
8. [Panduan Development](#️-panduan-development)

---

## 🎯 PENGANTAR PROYEK

**Analytic Invest** adalah aplikasi Flutter untuk analisis investasi yang dibangun menggunakan:
- **Clean Architecture** - Pemisahan concerns yang jelas
- **Cubit (BLoC)** - State management yang ringan
- **GetIt** - Dependency injection yang sederhana
- **Three-tab Navigation** - Home, Analytics, Profile

### Teknologi Utama:
```yaml
dependencies:
  flutter_bloc: ^8.1.3    # State management
  get_it: ^7.6.4          # Dependency injection
  dio: ^5.3.2             # HTTP client
  shared_preferences: ^2.2.2  # Local storage
  dartz: ^0.10.1          # Functional programming
  equatable: ^2.0.5       # Value equality
  flutter_screenutil: ^5.9.3  # Responsive design
```

---

## 🏗️ ARSITEKTUR CLEAN ARCHITECTURE

Clean Architecture membagi kode menjadi 3 layer utama:

### 1. **PRESENTATION LAYER** (UI)
- **Cubits** - Mengelola state UI
- **Pages** - Tampilan utama
- **Widgets** - Komponen UI reusable

### 2. **DOMAIN LAYER** (Business Logic)
- **Entities** - Model bisnis murni
- **Use Cases** - Logika bisnis aplikasi
- **Repositories** - Kontrak/interface

### 3. **DATA LAYER** (External Interface)
- **Models** - Data transfer objects
- **Data Sources** - API & Local storage
- **Repository Implementation** - Implementasi kontrak

```
📱 UI (Presentation)
    ↕️
🧠 Business Logic (Domain)
    ↕️
💾 Data (Data)
```

---

## 🔄 STATE MANAGEMENT DENGAN CUBIT

Cubit adalah versi sederhana dari BLoC yang menggunakan methods instead of events.

### Alur State Management:

```
UI Widget → Cubit Method → Emit State → UI Rebuild
```

### Contoh AnalyticsCubit:

```dart
class AnalyticsCubit extends Cubit<AnalyticsState> {
  final GetAnalytics getAnalytics;

  AnalyticsCubit({required this.getAnalytics}) : super(AnalyticsInitial());

  Future<void> loadAnalytics() async {
    try {
      emit(AnalyticsLoading());           // 1. Loading state
      final result = await getAnalytics(NoParams());
      
      result.fold(
        (failure) => emit(AnalyticsError(failure.message)),  // 2. Error state
        (analytics) => emit(AnalyticsLoaded(analytics)),     // 3. Success state
      );
    } catch (e) {
      emit(AnalyticsError('Unexpected error: ${e.toString()}'));
    }
  }
}
```

### Analytics States:
```dart
abstract class AnalyticsState extends Equatable {}

class AnalyticsInitial extends AnalyticsState {}    // Initial state
class AnalyticsLoading extends AnalyticsState {}    // Loading state
class AnalyticsLoaded extends AnalyticsState {      // Success state
  final List<InvestmentAnalysis> analytics;
}
class AnalyticsError extends AnalyticsState {       // Error state
  final String message;
}
```

---

## 💉 DEPENDENCY INJECTION DENGAN GETIT

GetIt mengelola semua dependencies aplikasi secara terpusat.

### Registrasi Dependencies:

```dart
Future<void> init() async {
  // 1. CUBITS (Factory - new instance setiap kali)
  sl.registerFactory(() => AnalyticsCubit(getAnalytics: sl()));
  sl.registerFactory(() => HomeCubit());
  sl.registerFactory(() => ProfileCubit());
  sl.registerFactory(() => MainCubit());

  // 2. USE CASES (Lazy Singleton - single instance)
  sl.registerLazySingleton(() => GetAnalytics(sl()));

  // 3. REPOSITORIES
  sl.registerLazySingleton<AnalyticsRepository>(
    () => AnalyticsRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // 4. DATA SOURCES
  sl.registerLazySingleton<AnalyticsRemoteDataSource>(
    () => MockAnalyticsRemoteDataSource(),
  );
  
  // 5. EXTERNAL DEPENDENCIES
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
```

### Penggunaan di main.dart:
```dart
MultiBlocProvider(
  providers: [
    BlocProvider<AnalyticsCubit>(
      create: (context) => di.sl<AnalyticsCubit>(),  // GetIt injection
    ),
    // ... other providers
  ],
  child: MaterialApp(/* ... */),
)
```

---

## 📁 STRUKTUR PROYEK

```
lib/
├── main.dart                     # Entry point aplikasi
├── core/                         # Core utilities
│   ├── di/
│   │   └── injection_container.dart    # GetIt setup
│   ├── constants/
│   │   └── app_constants.dart          # App constants
│   ├── errors/
│   │   ├── exceptions.dart             # Custom exceptions
│   │   └── failures.dart               # Failure classes
│   ├── network/
│   │   └── network_info.dart           # Network connectivity
│   ├── theme/
│   │   └── app_theme.dart              # App theming
│   └── utils/
│       └── usecase.dart                # Base use case
└── features/
    ├── analytics/                # 📊 Analytics Feature
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   ├── analytics_datasource.dart
    │   │   │   ├── analytics_datasource_impl.dart
    │   │   │   └── mock_analytics_datasource.dart
    │   │   ├── models/
    │   │   │   └── investment_analysis_model.dart
    │   │   └── repositories/
    │   │       └── analytics_repository_impl.dart
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   └── investment_analysis.dart
    │   │   ├── repositories/
    │   │   │   └── analytics_repository.dart
    │   │   └── usecases/
    │   │       └── get_analytics.dart
    │   └── presentation/
    │       ├── cubit/
    │       │   ├── analytics_cubit.dart
    │       │   └── analytics_state.dart
    │       └── pages/
    │           └── analytics_page.dart
    ├── home/                     # 🏠 Home Feature
    ├── profile/                  # 👤 Profile Feature
    └── main_page/               # 🏗️ Main Navigation
```

---

## 🔄 FLOW PENGERJAAN

### 1. **APPLICATION STARTUP**
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();    // Initialize dependencies
  runApp(const MyApp());
}
```

### 2. **DEPENDENCY INJECTION FLOW**
```
GetIt Registration → Cubit Creation → UI Injection
```

### 3. **NAVIGATION FLOW**
```
main.dart → MainPage → Bottom Navigation → [Home|Analytics|Profile]
```

### 4. **DATA FLOW (Analytics Feature)**
```
Analytics Page → AnalyticsCubit → GetAnalytics UseCase → 
AnalyticsRepository → RemoteDataSource → API/Mock Data → 
LocalDataSource → SharedPreferences → UI Update
```

### 5. **STATE MANAGEMENT FLOW**
```
User Action → Cubit Method → Emit State → BlocBuilder → UI Rebuild
```

---

## 📝 PENJELASAN KODE PER LAYER

### 🎯 **MAIN.dart - Entry Point**

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();                    // 1. Initialize dependencies
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(           // 2. Responsive design setup
      designSize: const Size(375, 812),
      builder: (context, child) {
        return MultiBlocProvider(    // 3. Provide all Cubits
          providers: [
            BlocProvider<MainCubit>(create: (context) => di.sl<MainCubit>()),
            BlocProvider<HomeCubit>(create: (context) => di.sl<HomeCubit>()..loadHomeData()),
            BlocProvider<AnalyticsCubit>(create: (context) => di.sl<AnalyticsCubit>()),
            BlocProvider<ProfileCubit>(create: (context) => di.sl<ProfileCubit>()),
          ],
          child: MaterialApp(
            home: const MainPage(),  // 4. Navigate to main page
          ),
        );
      },
    );
  }
}
```

**Penjelasan:**
1. **WidgetsFlutterBinding** - Memastikan Flutter framework siap
2. **di.init()** - Setup semua dependencies dengan GetIt
3. **MultiBlocProvider** - Menyediakan semua Cubits ke widget tree
4. **MainPage** - Halaman utama dengan bottom navigation

---

### 🏗️ **MAIN PAGE - Navigation Hub**

```dart
class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomePage(),        // Tab 0
      const AnalyticsPage(),   // Tab 1  
      const ProfilePage(),     // Tab 2
    ];

    return BlocBuilder<MainCubit, MainState>(
      builder: (context, state) {
        int currentIndex = 0;
        if (state is MainTabChanged) {
          currentIndex = state.selectedIndex;
        }

        return Scaffold(
          body: IndexedStack(         // Maintain state across tabs
            index: currentIndex,
            children: pages,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) => context.read<MainCubit>().changeTab(index),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Analytics'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            ],
          ),
        );
      },
    );
  }
}
```

**Penjelasan:**
- **IndexedStack** - Mempertahankan state semua tab
- **BlocBuilder** - Mendengarkan perubahan MainCubit  
- **onTap** - Memicu MainCubit untuk mengganti tab

---

### 🏠 **HOME FEATURE**

#### HomeCubit:
```dart
class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  Future<void> loadHomeData() async {
    try {
      emit(HomeLoading());
      
      // Simulate loading data
      await Future.delayed(const Duration(seconds: 1));
      
      emit(HomeLoaded(
        welcomeMessage: 'Welcome to Analytic Invest',
        recentActivity: [
          'Portfolio updated',
          'New analysis available',
          'Price alert triggered',
        ],
      ));
    } catch (e) {
      emit(HomeError('Failed to load home data: ${e.toString()}'));
    }
  }
}
```

#### HomePage UI:
```dart
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is HomeLoaded) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Welcome Section
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(/* gradient */),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(state.welcomeMessage),
                  ),
                  
                  // Quick Actions
                  Row(
                    children: [
                      _buildQuickActionCard('Analytics'),
                      _buildQuickActionCard('Portfolio'),
                    ],
                  ),
                  
                  // Recent Activity
                  ListView.builder(
                    itemCount: state.recentActivity.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(state.recentActivity[index]),
                      );
                    },
                  ),
                ],
              ),
            );
          }
          
          return Container(); // Error handling
        },
      ),
    );
  }
}
```

---

### 📊 **ANALYTICS FEATURE (CLEAN ARCHITECTURE)**

#### 1. **DOMAIN LAYER**

**Entity (Business Model):**
```dart
class InvestmentAnalysis extends Equatable {
  final String id;
  final String symbol;
  final String companyName;
  final double currentPrice;
  final double targetPrice;
  final String recommendation;
  final double riskScore;
  final DateTime lastUpdated;

  const InvestmentAnalysis({
    required this.id,
    required this.symbol,
    required this.companyName,
    required this.currentPrice,
    required this.targetPrice,
    required this.recommendation,
    required this.riskScore,
    required this.lastUpdated,
  });

  @override
  List<Object> get props => [id, symbol, companyName, currentPrice, targetPrice, recommendation, riskScore, lastUpdated];
}
```

**Repository Contract:**
```dart
abstract class AnalyticsRepository {
  Future<Either<Failure, List<InvestmentAnalysis>>> getAnalytics();
  Future<Either<Failure, InvestmentAnalysis>> getAnalysisById(String id);
}
```

**Use Case:**
```dart
class GetAnalytics implements UseCase<List<InvestmentAnalysis>, NoParams> {
  final AnalyticsRepository repository;

  GetAnalytics(this.repository);

  @override
  Future<Either<Failure, List<InvestmentAnalysis>>> call(NoParams params) async {
    return await repository.getAnalytics();
  }
}
```

#### 2. **DATA LAYER**

**Model (Data Transfer Object):**
```dart
class InvestmentAnalysisModel extends InvestmentAnalysis {
  const InvestmentAnalysisModel({
    required String id,
    required String symbol,
    required String companyName,
    required double currentPrice,
    required double targetPrice,
    required String recommendation,
    required double riskScore,
    required DateTime lastUpdated,
  }) : super(
    id: id,
    symbol: symbol,
    companyName: companyName,
    currentPrice: currentPrice,
    targetPrice: targetPrice,
    recommendation: recommendation,
    riskScore: riskScore,
    lastUpdated: lastUpdated,
  );

  factory InvestmentAnalysisModel.fromJson(Map<String, dynamic> json) {
    return InvestmentAnalysisModel(
      id: json['id'],
      symbol: json['symbol'],
      companyName: json['company_name'],
      currentPrice: json['current_price'].toDouble(),
      targetPrice: json['target_price'].toDouble(),
      recommendation: json['recommendation'],
      riskScore: json['risk_score'].toDouble(),
      lastUpdated: DateTime.parse(json['last_updated']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'symbol': symbol,
      'company_name': companyName,
      'current_price': currentPrice,
      'target_price': targetPrice,
      'recommendation': recommendation,
      'risk_score': riskScore,
      'last_updated': lastUpdated.toIso8601String(),
    };
  }
}
```

**Remote Data Source:**
```dart
abstract class AnalyticsRemoteDataSource {
  Future<List<InvestmentAnalysisModel>> getAnalytics();
}

class MockAnalyticsRemoteDataSource implements AnalyticsRemoteDataSource {
  @override
  Future<List<InvestmentAnalysisModel>> getAnalytics() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    
    return [
      InvestmentAnalysisModel(
        id: '1',
        symbol: 'AAPL',
        companyName: 'Apple Inc.',
        currentPrice: 150.25,
        targetPrice: 175.00,
        recommendation: 'BUY',
        riskScore: 3.2,
        lastUpdated: DateTime.now(),
      ),
      // ... more mock data
    ];
  }
}
```

**Local Data Source:**
```dart
abstract class AnalyticsLocalDataSource {
  Future<List<InvestmentAnalysisModel>> getCachedAnalytics();
  Future<void> cacheAnalytics(List<InvestmentAnalysisModel> analytics);
}

class AnalyticsLocalDataSourceImpl implements AnalyticsLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String analyticsKey = 'CACHED_ANALYTICS';

  AnalyticsLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<InvestmentAnalysisModel>> getCachedAnalytics() async {
    final jsonString = sharedPreferences.getString(analyticsKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => InvestmentAnalysisModel.fromJson(json)).toList();
    } else {
      throw CacheException('No cached data found');
    }
  }

  @override
  Future<void> cacheAnalytics(List<InvestmentAnalysisModel> analytics) async {
    final jsonString = json.encode(analytics.map((analysis) => analysis.toJson()).toList());
    await sharedPreferences.setString(analyticsKey, jsonString);
  }
}
```

**Repository Implementation:**
```dart
class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final AnalyticsRemoteDataSource remoteDataSource;
  final AnalyticsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AnalyticsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<InvestmentAnalysis>>> getAnalytics() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteAnalytics = await remoteDataSource.getAnalytics();
        await localDataSource.cacheAnalytics(remoteAnalytics);
        return Right(remoteAnalytics);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      try {
        final localAnalytics = await localDataSource.getCachedAnalytics();
        return Right(localAnalytics);
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }
}
```

#### 3. **PRESENTATION LAYER**

**AnalyticsCubit:**
```dart
class AnalyticsCubit extends Cubit<AnalyticsState> {
  final GetAnalytics getAnalytics;

  AnalyticsCubit({required this.getAnalytics}) : super(AnalyticsInitial());

  Future<void> loadAnalytics() async {
    try {
      emit(AnalyticsLoading());
      
      final result = await getAnalytics(NoParams());
      
      result.fold(
        (failure) => emit(AnalyticsError(failure.message ?? 'Unknown error occurred')),
        (analytics) => emit(AnalyticsLoaded(analytics)),
      );
    } catch (e) {
      emit(AnalyticsError('An unexpected error occurred: ${e.toString()}'));
    }
  }

  Future<void> refreshAnalytics() async {
    await loadAnalytics();
  }

  void clearError() {
    if (state is AnalyticsError) {
      emit(AnalyticsInitial());
    }
  }
}
```

**Analytics Page:**
```dart
class AnalyticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Investment Analytics')),
      body: BlocBuilder<AnalyticsCubit, AnalyticsState>(
        builder: (context, state) {
          if (state is AnalyticsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AnalyticsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${state.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<AnalyticsCubit>().refreshAnalytics(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is AnalyticsLoaded) {
            return RefreshIndicator(
              onRefresh: () => context.read<AnalyticsCubit>().refreshAnalytics(),
              child: ListView.builder(
                itemCount: state.analytics.length,
                itemBuilder: (context, index) {
                  final analysis = state.analytics[index];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _getRecommendationColor(analysis.recommendation),
                        child: Text(analysis.symbol.substring(0, 2).toUpperCase()),
                      ),
                      title: Text(analysis.companyName),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Symbol: ${analysis.symbol}'),
                          Text('Risk Score: ${analysis.riskScore.toStringAsFixed(1)}'),
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('\$${analysis.currentPrice.toStringAsFixed(2)}'),
                          Text(
                            analysis.recommendation,
                            style: TextStyle(
                              color: _getRecommendationColor(analysis.recommendation),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }

          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<AnalyticsCubit>().loadAnalytics(),
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Color _getRecommendationColor(String recommendation) {
    switch (recommendation.toUpperCase()) {
      case 'BUY':
        return Colors.green;
      case 'SELL':
        return Colors.red;
      case 'HOLD':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
```

---

### 👤 **PROFILE FEATURE**

ProfileCubit mengelola pengaturan user dan preferensi aplikasi:

```dart
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial()) {
    _loadProfile();
  }

  void _loadProfile() {
    emit(const ProfileLoaded(
      userName: 'John Doe',
      userEmail: 'john.doe@example.com',
      isDarkMode: false,
      isNotificationsEnabled: true,
    ));
  }

  void toggleDarkMode() {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      emit(currentState.copyWith(isDarkMode: !currentState.isDarkMode));
    }
  }

  void toggleNotifications() {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      emit(currentState.copyWith(isNotificationsEnabled: !currentState.isNotificationsEnabled));
    }
  }

  void logout() {
    emit(ProfileInitial());
    // Navigate to login screen
  }
}
```

---

## 🛠️ PANDUAN DEVELOPMENT

### 1. **Menambah Feature Baru**

Untuk menambah feature baru, ikuti struktur Clean Architecture:

```
features/new_feature/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── cubit/
    └── pages/
```

### 2. **Registrasi Dependencies**

Tambahkan di `injection_container.dart`:

```dart
// Cubit
sl.registerFactory(() => NewFeatureCubit(useCase: sl()));

// Use Case
sl.registerLazySingleton(() => NewFeatureUseCase(sl()));

// Repository
sl.registerLazySingleton<NewFeatureRepository>(
  () => NewFeatureRepositoryImpl(dataSource: sl()),
);

// Data Source
sl.registerLazySingleton<NewFeatureDataSource>(
  () => NewFeatureDataSourceImpl(),
);
```

### 3. **Testing Strategy**

```dart
// Unit Test - Cubit
void main() {
  group('AnalyticsCubit', () {
    late AnalyticsCubit cubit;
    late MockGetAnalytics mockGetAnalytics;

    setUp(() {
      mockGetAnalytics = MockGetAnalytics();
      cubit = AnalyticsCubit(getAnalytics: mockGetAnalytics);
    });

    test('should emit AnalyticsLoaded when data is loaded successfully', () async {
      // arrange
      when(mockGetAnalytics(any)).thenAnswer((_) async => Right(tAnalyticsList));

      // act
      cubit.loadAnalytics();

      // assert
      expect(cubit.stream, emitsInOrder([
        AnalyticsLoading(),
        AnalyticsLoaded(tAnalyticsList),
      ]));
    });
  });
}
```

### 4. **Error Handling**

```dart
// Custom Exceptions
class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}

// Custom Failures
class ServerFailure extends Failure {
  ServerFailure(String message) : super(message);
}

// Repository Implementation
try {
  final result = await remoteDataSource.getData();
  return Right(result);
} on ServerException catch (e) {
  return Left(ServerFailure(e.message));
} catch (e) {
  return Left(ServerFailure('Unexpected error: ${e.toString()}'));
}
```

### 5. **Performance Tips**

1. **Use const constructors** untuk widgets yang tidak berubah
2. **Implement Equatable** untuk state classes
3. **Use ListView.builder** untuk list panjang
4. **Cache data** dengan SharedPreferences
5. **Lazy loading** dengan registerLazySingleton

---

## 📊 KEUNTUNGAN ARSITEKTUR INI

### ✅ **Clean Architecture Benefits:**
- **Separation of Concerns** - Setiap layer punya tanggung jawab jelas
- **Testability** - Mudah di-unit test
- **Maintainability** - Mudah maintenance dan update
- **Scalability** - Mudah ditambah feature baru
- **Independent** - Layer tidak bergantung satu sama lain

### ✅ **Cubit Benefits:**
- **Simplicity** - Lebih sederhana dari BLoC
- **Performance** - Lightweight state management
- **Predictable** - State flow yang jelas
- **Debuggable** - Mudah debug dengan BLoC Inspector

### ✅ **GetIt Benefits:**
- **Lightweight** - Tidak perlu code generation
- **Simple** - API yang mudah dipahami
- **Fast** - Performance yang baik
- **Flexible** - Bisa register berbagai tipe dependency

---

## 🎯 KESIMPULAN

Proyek ini mendemonstrasikan implementasi **Clean Architecture** yang proper dengan:

1. **State Management** yang efficient menggunakan Cubit
2. **Dependency Injection** yang clean dengan GetIt  
3. **Three-layer architecture** yang terstruktur
4. **Error handling** yang comprehensive
5. **Responsive design** dengan ScreenUtil
6. **Navigation** yang smooth dengan bottom tabs

Arsitektur ini cocok untuk:
- ✅ **Small to medium projects**
- ✅ **Teams yang ingin arsitektur clean tapi simple** 
- ✅ **Projects yang butuh maintainability tinggi**
- ✅ **Rapid development dengan structure yang jelas**

---

**Untuk menyimpan dokumentasi ini dalam bentuk PDF:**
1. Copy seluruh konten di atas
2. Paste ke Google Docs atau Microsoft Word
3. Format dengan heading dan styling yang sesuai
4. Export/Download sebagai PDF

*Dokumentasi ini memberikan pemahaman lengkap tentang struktur kode, flow pengerjaan, dan best practices untuk pengembangan Flutter dengan Clean Architecture + Cubit.*
