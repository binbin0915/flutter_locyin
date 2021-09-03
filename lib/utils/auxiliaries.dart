import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class Auxiliaries{

  static String AssetTypeToString(AssetType assetType){
    String _type = "other";
    switch (assetType){
      case AssetType.other:
      // TODO: Handle this case.
        _type = "other";
        break;
      case AssetType.image:
      // TODO: Handle this case.
        _type = "image";
        break;
      case AssetType.video:
      // TODO: Handle this case.
        _type = "video";
        break;
      case AssetType.audio:
      // TODO: Handle this case.
        _type = "audio";
        break;
    }
    return _type;
  }
}