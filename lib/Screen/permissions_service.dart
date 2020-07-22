import 'package:design_app/main.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsService {
  final PermissionHandler _permissionHandler = PermissionHandler();

  Future<bool> requestPermission(PermissionGroup permission) async {
    var result = await _permissionHandler.requestPermissions([permission]);
    if (result[permission] == PermissionStatus.granted) {
      isGranted = true;
      print(isGranted);
      return true;
    }
    else {
      isGranted = false;
      print(isGranted);
      return false;
    }
  }

  Future<bool> requestContactsPermission({Function onPermissionDenied}) async {
    var granted = await requestPermission(PermissionGroup.camera);
    if (!granted) {
      onPermissionDenied();
    }
    return granted;
  }

  Future<bool> hasPermission(PermissionGroup permission) async {
    var permissionStatus = await _permissionHandler.checkPermissionStatus(permission);
    print(PermissionStatus.granted);
    return permissionStatus == PermissionStatus.granted;
  }

  Future<bool> hasContactsPermission() async {
    print(PermissionStatus.granted);
    return hasPermission(PermissionGroup.camera);
  }
}
