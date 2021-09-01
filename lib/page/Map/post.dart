///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021/7/13 11:46
///
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_locyin/data/api/apis_service.dart';
import 'package:flutter_locyin/page/Map/selected_assets_list_view.dart';
import 'package:flutter_locyin/utils/toast.dart';
import 'package:flutter_locyin/widgets/loading_dialog.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import 'picker_method.dart';
import 'package:get/get.dart' as getx;


class DynamicPostPage extends StatefulWidget {

  /*String? _position = getx.Get.parameters['position'];
  String? _latitude = getx.Get.parameters['latitude'];
  String? _longitude = getx.Get.parameters['longitude'];*/

  final String? position;
  final String? latitude;
  final String? longitude;
  final PanelController panelController;

  const DynamicPostPage({Key? key, this.position, this.latitude, this.longitude, required this.panelController}) : super(key: key);

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
  List<Map<String,String>> assetsMapList = [];

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
    print(widget.position);
    print(widget.latitude);
    print(widget.longitude);
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 16.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 30,
                height: 5,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.all(Radius.circular(12.0))),
              ),
            ],
          ),
          SizedBox(
            height: 8.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "发布游记",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _contentController,
                maxLines: 16,
                keyboardType: TextInputType.multiline,
                autofocus: false,
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: getx.Get.theme.accentColor,
                ),
                Text(
                  /*"乌镇南浔水乡"*/
                  widget.position==null?"选择一个位置吧~":widget.position.toString(),
                  style: TextStyle(
                    color: getx.Get.theme.accentColor,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
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
              ),
              IconButton(
                  onPressed: _post,
                  icon: Icon(Icons.send)
              ),
            ],
          ),

        ],
      ),
    );
  }
  Future<void> _uploadAssets(int i) async {
    if(i<0){
      return ;
    }
    print(assets[i].mimeType);
    await apiService.uploadImage((Response response){
      String _entityType = assets[i].type.toString();
      assetsMapList.add({
        "type": _entityType.substring(_entityType.lastIndexOf(".") + 1, _entityType.length),
        "url": response.data["src"].toString()
      });
      print("上传成功${assets[i].id}");
    }, (DioError error) {
      print(error);
    },assets[i].file).then((value) => _uploadAssets(i-1));
  }
  Future<void> _post() async {
    //关闭键盘
    _closeKeyboard(context);
    //打开加载
    _showDialog();
    //等待所有图片上传完成
    await _uploadAssets(assets.length-1);
    //获取到图片数组
    print(assetsMapList);
    //发布游记
    apiService.publishDynamic((Response response){
      print("发布成功");
      ToastUtils.toast("发布成功");
      _contentController.text = "";
      assets.clear();
      widget.panelController.close();
      getx.Get.back();
    }, (DioError error) {
      print(error);
      getx.Get.back();
    },_contentController.text,widget.position,widget.latitude,widget.longitude,assetsMapList);
  }
  void _showDialog(){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return LoadingDialog(
            showContent: false,
            backgroundColor: getx.Get.theme.dialogBackgroundColor,
            loadingView: SpinKitCircle(color: getx.Get.theme.accentColor),
          );
        });
  }
  void _closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(blankNode);
  }
}
