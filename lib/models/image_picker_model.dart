import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class ImagesPickerModel {
  String? media;
  String? url;
  String? state;
  double? percentUpload;
  AssetEntity? asset;

  ImagesPickerModel({
    this.media,
    this.url,
    this.state,
    this.percentUpload = 0.1,
    this.asset,
  });

  Map<String, dynamic> toJson() => {
        "media": media,
        "url": url,
        "state": state,
        "percent_upload": percentUpload,
      };
}
