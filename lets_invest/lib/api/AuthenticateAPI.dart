import 'package:flutter/services.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';

class AuthenticationAPI {
    static final _authentication = LocalAuthentication();

	static Future<List<BiometricType>> getBiometrics() async {
		try {
			return await _authentication.getAvailableBiometrics();
		} catch (e) {
			return <BiometricType>[];
		}
	}

    static Future<bool> hasBiometrics() async {
        try {
          	return await _authentication.canCheckBiometrics;
        } on PlatformException {
          	return false;
        }
    }

    static Future<bool> authenticate() async {
    	try {
			return await _authentication.authenticate(
				localizedReason: "Authenticate to see all content",
				options: const AuthenticationOptions(
				useErrorDialogs: true,
				stickyAuth: true,
				)
			);
    	} on PlatformException {
			return false;
    	}     
    }

	static Future<bool> isDeviceSuppoerted() async {
    	try {
			return await _authentication.isDeviceSupported();
    	} on PlatformException {
			return false;
    	}     
    }
}