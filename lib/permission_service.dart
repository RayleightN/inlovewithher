import 'package:permission_handler/permission_handler.dart';

class PermissionsService {
  // final Permission _permission;

  Future<PermissionStatus> requestPermission(Permission permission) async {
    final status = await permission.request();
    return status;
  }

  Future<PermissionStatus> listenForPermissionStatus(Permission permission, bool needRequest) async {
    final status = await permission.status;
    if (needRequest) {
      if (status == PermissionStatus.denied) {
        return requestPermission(permission);
      }
    }
    return status;
  }
}
