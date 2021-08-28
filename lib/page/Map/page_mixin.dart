///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021/7/13 11:46
///
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_locyin/utils/toast.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:flutter_locyin/widgets/lists//selected_assets_list_view.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import 'picker_method.dart';
import 'package:get/get.dart' as getx;


class DynamicPostPage extends StatefulWidget {

  String? _position = getx.Get.parameters['position'];
  String? _latitude = getx.Get.parameters['latitude'];
  String? _longitude = getx.Get.parameters['longitude'];

  @override
  _DynamicPostPageState createState() => _DynamicPostPageState();
}

class _DynamicPostPageState extends State<DynamicPostPage>{

  final ValueNotifier<bool> isDisplayingDetail = ValueNotifier<bool>(true);

  @override
  void dispose() {
    isDisplayingDetail.dispose();
    super.dispose();
  }

  int get maxAssetsCount => 9;

  List<AssetEntity> assets = <AssetEntity>[];

  int get assetsLength => assets.length;


  /// These fields are for the keep scroll position feature.
  late DefaultAssetPickerProvider keepScrollProvider =
  DefaultAssetPickerProvider();
  DefaultAssetPickerBuilderDelegate? keepScrollDelegate;

  Future<void> selectAssets(PickMethod model) async {
    final List<AssetEntity>? result = await model.method(context, assets);
    if (result != null) {
      assets = List<AssetEntity>.from(result);
      if (mounted) {
        setState(() {});
      }
    }
  }

  FocusNode blankNode = FocusNode();

  TextEditingController _contentController = TextEditingController();

  void removeAsset(int index) {
    assets.removeAt(index);
    if (assets.isEmpty) {
      isDisplayingDetail.value = false;
    }
    setState(() {});
  }

  void onResult(List<AssetEntity>? result) {
    if (result != null && result != assets) {
      assets = List<AssetEntity>.from(result);
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
          Container(
          height: 48,
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  getx.Get.back();
                },
                child: Icon(Icons.arrow_back_ios),
              ),
              Text(
                "发布游记",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                ),
              ),
              InkWell(
                onTap: () {
                  ToastUtils.toast("发布按钮");
                  //_scaffoldKey.currentState.openDrawer();
                },
                child: Icon(Icons.send),
              ),
            ],
          ),
        ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _contentController,
                  maxLines: 16,
                  keyboardType: TextInputType.multiline,
                  autofocus: true,
                  decoration: InputDecoration.collapsed(
                    hintText: "身未动，心已远",
                  ),
                ),
              ),
            ),
            if (assets.isNotEmpty)
              SelectedAssetsListView(
                assets: assets,
                isDisplayingDetail: isDisplayingDetail,
                onResult: onResult,
                onRemoveAsset: removeAsset,
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 8,
                ),
                IconButton(
                    onPressed: (){selectAssets(PickMethod.cameraAndStay( maxAssetsCount: maxAssetsCount ));},
                    icon: Icon(Icons.picture_in_picture)
                ),
                SizedBox(
                  width: 16,
                ),
                IconButton(
                    onPressed: (){ selectAssets(PickMethod.video( maxAssetsCount ));},
                    icon: Icon(Icons.video_call)
                ),
                SizedBox(
                  width: 16,
                ),
                IconButton(
                    onPressed: (){ selectAssets(PickMethod.audio( maxAssetsCount ));},
                    icon: Icon(Icons.music_note_outlined)
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
