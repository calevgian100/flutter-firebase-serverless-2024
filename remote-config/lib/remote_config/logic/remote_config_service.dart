import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  static final _remoteConfig = FirebaseRemoteConfig.instance;

  static Future<void> initRemoteConfig() async {
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(seconds: 15),
      ),
    );

    await _remoteConfig.setDefaults(
      const {
        'logo':
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR-Ol_OkxZ3-TcIiFnlZXgdQrJXNLgHjh-_YA&s',
        'version': '0.0.0',
        'welcome_message': 'Hola!',
        'show_welcome_message': false,
      },
    );

    await _remoteConfig.fetchAndActivate();
  }

  static String getLogo() {
    return _remoteConfig.getString('logo');
  }

  static String getVersion() {
    return _remoteConfig.getString('version');
  }

  static bool shouldShowWelcomeMessage() {
    return _remoteConfig.getBool('show_welcome_message');
  }

  static String getWelcomeMessage() {
    return _remoteConfig.getString('welcome_message');
  }
}
