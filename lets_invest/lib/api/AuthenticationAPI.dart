import 'package:flutter/services.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';

class AuthenticationAPI {
  final _authentication = LocalAuthentication();

  Future<List<BiometricType>> getBiometrics() async {
    try {
      return await _authentication.getAvailableBiometrics();
    } catch (e) {
      return <BiometricType>[];
    }
  }

  Future<bool> hasBiometrics() async {
    try {
      return await _authentication.canCheckBiometrics;
    } on PlatformException {
      return false;
    }
  }

  Future<bool> authenticate() async {
    try {
      return await _authentication.authenticate(
          localizedReason: "Authenticate to see all content",
          options: const AuthenticationOptions(
            useErrorDialogs: true,
            stickyAuth: true,
          ));
    } on PlatformException {
      return false;
    }
  }

  Future<bool> isDeviceSuppoerted() async {
    try {
      return await _authentication.isDeviceSupported();
    } on PlatformException {
      return false;
    }
  }
}
