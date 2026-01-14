import 'dart:io';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;

class GoogleDriveService {
  GoogleDriveService({GoogleSignIn? signIn})
      : _googleSignIn = signIn ??
            GoogleSignIn(
              scopes: [
                drive.DriveApi.driveFileScope,
              ],
            );

  final GoogleSignIn _googleSignIn;

  Future<GoogleSignInAccount?> signIn() async {
    return _googleSignIn.signIn();
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }

  Future<String?> uploadFile(File file, {String? name}) async {
    final account = await _googleSignIn.signInSilently();
    if (account == null) {
      return null;
    }
    final authHeaders = await account.authHeaders;
    final client = _GoogleAuthClient(authHeaders);
    final api = drive.DriveApi(client);
    final driveFile = drive.File()..name = name ?? file.uri.pathSegments.last;
    final media = drive.Media(file.openRead(), file.lengthSync());
    final result = await api.files.create(driveFile, uploadMedia: media);
    client.close();
    return result.id;
  }
}

class _GoogleAuthClient extends http.BaseClient {
  _GoogleAuthClient(this._headers);

  final Map<String, String> _headers;
  final http.Client _client = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _client.send(request);
  }

  @override
  void close() {
    _client.close();
  }
}
