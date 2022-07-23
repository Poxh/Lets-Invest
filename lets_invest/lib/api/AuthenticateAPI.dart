import 'package:flutter/services.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';

class AuthenticationAPI {
    static final _authentication = LocalAuthentication();

    static Future<bool> hasBiometrics() async {
		try {
			return await _authentication.canCheckBiometrics;
		} on PlatformException {
			return false;
		}
    }

    static Future<bool> authenticate() async {
    	try {
			if(!await hasBiometrics()) return false;
        	final bool didAuthenticate = await _authentication.authenticate(
				localizedReason: 'Please authenticate to show account balance',
				options: const AuthenticationOptions(biometricOnly: true));
        	return didAuthenticate;
    	} on PlatformException {
			return false;
    	}     
    }
}