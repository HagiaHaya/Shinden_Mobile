import 'dart:async';

import 'package:http/http.dart' as http;

void main() {
  var list = new List<String>();
  //list.add("https://www.facebook.com/video/embed?video_id=116276245151494");
  list.add("https://www.facebook.com/video/embed?video_id=116336701812115");

  getFacebookUploadVideo(list);
}

Future<String> getFacebookUploadVideo(List<String> links) async {
  for (var link in links) {
    http.Response response = await http.get(link);
    var videoURL = new RegExp("hd_src\":\"([^\"]*)").firstMatch(response.body);
  }
}
