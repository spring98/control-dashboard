import 'dart:convert';
import '../common/common_service.dart';
import 'package:http/http.dart' as http;

class CarService {
  Session session = Session();

  Future<String> fetchCars() async {
    String url = Session.BASEURL + 'v1/cars';
    http.Response response = await http.get(
      Uri.parse(Uri.encodeFull(url)),
      headers: Session.headers,
    );

    print(jsonDecode(response.body));

    // access token 이 만료되었다면 token 을 새로 발급해서 다시 요청합니다.
    if (response.statusCode == 401) {
      await session.refreshTokenHandler();
      http.Response response = await http.get(
        Uri.parse(Uri.encodeFull(url)),
        headers: Session.headers,
      );
      return response.body;
    } else {
      return response.body;
    }
  }

  // Future<Uint8List> fetchMyInfoThumbnail(String thumbnailID) async {
  //   String url = Session.BASEURL + 'v1/downloads/$thumbnailID';
  //   http.Response response = await http.get(
  //     Uri.parse(Uri.encodeFull(url)),
  //     headers: Session.headers,
  //   );
  //
  //   if (response.statusCode == 401) {
  //     await session.refreshTokenHandler();
  //     http.Response response = await http.get(
  //       Uri.parse(Uri.encodeFull(url)),
  //       headers: Session.headers,
  //     );
  //
  //     return response.bodyBytes;
  //   } else {
  //     return response.bodyBytes;
  //   }
  // }
  //
  // Future<void> updateProfileImage(String path) async {
  //   String url = Session.BASEURL + 'v1/users/my-info/profile';
  //
  //   Map<String, String> header = Session.headers;
  //   header['Content-Type'] = 'multipart/form-data';
  //
  //   MultipartRequest request = http.MultipartRequest(
  //     'PATCH',
  //     Uri.parse(Uri.encodeFull(url)),
  //   );
  //   request.headers.addAll(header);
  //   request.files.add(await http.MultipartFile.fromPath(
  //     'file',
  //     path,
  //     contentType: MediaType('image', 'png'),
  //   ));
  //
  //   http.Response response =
  //   await http.Response.fromStream(await request.send());
  //
  //   print('patch in');
  //   print(response.body);
  //
  //   if (response.statusCode == 401) {
  //     await session.refreshTokenHandler();
  //     MultipartRequest request = http.MultipartRequest(
  //       'PATCH',
  //       Uri.parse(Uri.encodeFull(url)),
  //     );
  //     request.headers.addAll(header);
  //     request.files.add(await http.MultipartFile.fromPath(
  //       'file',
  //       path,
  //       contentType: MediaType('image', 'png'),
  //     ));
  //
  //     http.Response response =
  //     await http.Response.fromStream(await request.send());
  //   }
  // }
}
