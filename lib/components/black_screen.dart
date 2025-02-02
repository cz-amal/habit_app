import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habit_app/pages/home_page.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
class BlackScreen extends StatefulWidget {
  const BlackScreen({super.key});

  @override
  State<BlackScreen> createState() => _BlackScreenState();
}

class _BlackScreenState extends State<BlackScreen> with WidgetsBindingObserver{

  late final LocalAuthentication auth;
  late bool _state = false;
  bool _isAuthenticated = false; // Track authentication state
  DateTime? _lastAuthenticatedTime; // Track the last successful authentication time

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addObserver(this); // Listen for app lifecycle changes
    auth = LocalAuthentication();
    auth.isDeviceSupported().then((bool isSupported) {
      setState(() {
        _state = isSupported;
      });
    });

    // Initialize authentication state to false
    _isAuthenticated = false;

    // Trigger authentication on launch
    authenticate();
  }

  @override
  void dispose() {
    // WidgetsBinding.instance.removeObserver(this); // Remove observer
    super.dispose();
  }

  Future<void> authenticate() async {
    final prefs = await SharedPreferences.getInstance();
    bool isFingerprintEnabled = prefs.getBool('fingerprint_enabled') ?? false;

    if (!isFingerprintEnabled) {
      // Skip authentication if fingerprint is disabled
      setState(() {
        _isAuthenticated = true;
      });
      print("finger print disabled");
      return;
    }
    print("finger print enabled");

    try {
      bool authenticated = await auth.authenticate(
        localizedReason: "Authenticate to access your habits",
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      setState(() {
        _isAuthenticated = authenticated;
        if (authenticated) {
          _lastAuthenticatedTime = DateTime.now(); // Update last authenticated time
        }
      });

      if (!authenticated) {
        SystemNavigator.pop(); // Exit the app if authentication fails
      }
    } on PlatformException catch (e) {
      print("Error during authentication: $e");
      setState(() {
        _isAuthenticated = false; // Ensure the app locks if authentication fails
      });
      SystemNavigator.pop(); // Exit the app if there's an error
    }
  }

  Future<void> getBiometrics() async {
    List<BiometricType> bio = await auth.getAvailableBiometrics();
    if (!mounted) {
      return;
    }
  }



  @override
  Widget build(BuildContext context) {
    if (_isAuthenticated) {
      return Scaffold(
        body: HomePage(),
      );
    }else{
      return Scaffold(
      );
    }
  }
}
