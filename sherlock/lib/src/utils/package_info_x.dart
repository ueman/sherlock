import 'package:package_info_plus/package_info_plus.dart';

extension PackageInfoX on PackageInfo {
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'packageName': packageName,
      'appName': appName,
      'buildNumber': buildNumber,
      'version': version,
    };
  }
}
