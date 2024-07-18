import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../_utils/device_info.dart';
import '../../_utils/logger.dart';
import '../../commands/app/set_current_user_command.dart';
import '../../commands/files/pick_file_command.dart';
import '../../models/app_user/app_user.dart';
import '../../models/course_model.dart';
import 'firebase_service_firedart.dart';
import 'firebase_service_native.dart';

// CollectionKeys
class FireIds {
  static const String users = "users";
  static const String books = "books";
  static const String pages = "pages";
  static const String pageBoxes = "boxes";
  static const String scraps = "scraps";
}

// Returns the correct Firebase instance depending on platform
class FirebaseFactory {
  static bool _initComplete = false;

  // Determine which platforms we can use the native sdk on
  static bool get useNative =>
      DeviceOS.isMobileOrWeb; // || UniversalPlatform.isMacOS;

  static FirebaseService create() {
    FirebaseService service =
        useNative ? NativeFirebaseService() : DartFirebaseService();
    if (_initComplete == false) {
      _initComplete = true;
      service.init();
    }
    print("firestore-${useNative ? "NATIVE" : "DART"} Initialized");
    return service;
  }
}

// Interface / Base class
// Combination of abstract methods that must be implemented, and concrete methods that are shared.
abstract class FirebaseService {
  /// /////////////////////////////////////////////////
  /// Concrete Methods
  /// //////////////////////////////////////////////////

  /// shared setUserId method
  late Stream<AppUser?> onUserChanged;
  final StreamController<AppUser?> _controller =
      StreamController<AppUser?>.broadcast();
  AppUser? get currentUser => _currentUser;
  String? get currentUid => _currentUser!.uid;
  set seCurrentUser(AppUser? newUser) => _currentUser = newUser;
  AppUser? _currentUser;
  bool isDesktopAuth = false;
  FirebaseService() {
    onUserChanged = _controller.stream;
  }
  CourseModel? userCourse;
  String? get userId => currentUser!.uid;
  List<String> get userPath => [FireIds.users, userId ?? ""];
  /////////////////////////////////////////////////////////
  // USERS
  /////////////////////////////////////////////////////////
  Future<AppUser?> getUserData() async {
    try {
      Map<String, dynamic>? data = await getDoc([]);
      return data == null ? null : AppUser.fromJson(data);
    } catch (e) {
      print(e);
      return null;
    }
  }

  ///////////////////////////////////////////////////
  // Abstract Methods
  //////////////////////////////////////////////////
  void init();

  // Auth
  Future<bool> signInWithMicrosoft([bool reauthenticate = false]) async {
    return _currentUser != null;
  }

  bool get isSignedIn;
  @mustCallSuper
  Future<void> signOut() async {
    seCurrentUser = null;
    userChange();
  }

  void streamUserChange() {
    log("Streaming current user");
    _controller.add(currentUser);
    log("Done streaming current user");
  }

  /// check if is authentication for desktop
  /// if so: send the id token to the desktop app
  /// if not: set the current user on app model
  /// then Stream user change anyway;
  void userChange() {
    if (isDesktopAuth) {
      // AuthenticateDesktopCommand().run();
    } else {
      SetCurrentUserCommand().run();
    }
    streamUserChange();
  }

  Future<String?> getAccessToken() async {
    return "get access token base method";
  }

  String? get getRefreshToken => "get refresh token base method";

  ///////////////////////////////////////////////////
  // Course Details
  //////////////////////////////////////////////////
  Future<CourseModel?> getCourseDetails() async {
    return null;
  }

  ///////////////////////////////////////////////////
  // Files - Starts
  //////////////////////////////////////////////////
  Future<bool> addBook() async {
    return true;
  }

  Future<Map<String, dynamic>?> getDoc(List<String> keys);
  Future<List<Map<String, dynamic>>?> getCollection(List<String> keys);

  // Future<String> addDoc(List<String> keys, Map<String, dynamic> json,
  //     {String documentId, bool addUserPath = true});
  Future<void> updateDoc(List<String> keys, Map<String, dynamic> json);
  Future<void> deleteDoc(List<String> keys);

  ///////////////////////////////////////////////////
  // Files - uploads
  //////////////////////////////////////////////////
  Future<void> uploadFile(PickedFile file) async {}
}

bool checkKeysForNull(List<String> keys) {
  if (keys.contains(null)) {
    print("ERROR: invalid key was passed to firestore: $keys");
    return false;
  }
  return true;
}
