import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final String userName;
  final String userEmail;
  final bool isDarkMode;
  final bool isNotificationsEnabled;

  const ProfileLoaded({
    required this.userName,
    required this.userEmail,
    required this.isDarkMode,
    required this.isNotificationsEnabled,
  });

  @override
  List<Object> get props =>
      [userName, userEmail, isDarkMode, isNotificationsEnabled];

  ProfileLoaded copyWith({
    String? userName,
    String? userEmail,
    bool? isDarkMode,
    bool? isNotificationsEnabled,
  }) {
    return ProfileLoaded(
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      isNotificationsEnabled:
          isNotificationsEnabled ?? this.isNotificationsEnabled,
    );
  }
}
