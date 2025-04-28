class ApiConstants {
  static const String baseUrl = 'http://192.168.66.151:8000/api/';
  static const String register = '${baseUrl}user/register';
  static const String login = '${baseUrl}user/login';
  static const String upload = '${baseUrl}add/file';
  static const String getFiles = '${baseUrl}getMyFile';
  static const String createGroup = '${baseUrl}CreateGroup';
  static const String deleteFile = '${baseUrl}delete/file';
  static const String getmygroups = '${baseUrl}getMyGroup';
  static const String getmyGroupFiles = '${baseUrl}getGroupFile';
  static const String addFileToGroup = '${baseUrl}AddFileToGroup';
  static const String deletefilefromgroup = '${baseUrl}deleteFileFromGroup';
  static const String allusersinsystem = '${baseUrl}getAllUserInSystem';
}
