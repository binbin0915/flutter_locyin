import 'package:flutter_locyin/generated/json/base/json_convert_content.dart';
import 'package:flutter_locyin/generated/json/base/json_field.dart';

class DynamicDetailEntity with JsonConvert<DynamicDetailEntity> {
	late DynamicDetailData data;
}

class DynamicDetailData with JsonConvert<DynamicDetailData> {
	late int id;
	@JSONField(name: "user_id")
	late int userId;
	@JSONField(name: "thumb_count")
	late int thumbCount;
	late int thumbed;
	late int collected;
	@JSONField(name: "collect_count")
	late int collectCount;
	@JSONField(name: "comment_count")
	late int commentCount;
	@JSONField(name: "created_at")
	late String createdAt;
	@JSONField(name: "updated_at")
	late String updatedAt;
	late String content;
	late String location;
	late DynamicDetailDataUser user;
	late List<DynamicDetailDataImages> images;
}

class DynamicDetailDataUser with JsonConvert<DynamicDetailDataUser> {
	late int id;
	late String username;
	late String nickname;
	late String avatar;
	late String email;
	late String introduction;
	@JSONField(name: "notification_count")
	late int notificationCount;
	late int status;
	@JSONField(name: "created_at")
	late String createdAt;
	@JSONField(name: "updated_at")
	late String updatedAt;
}

class DynamicDetailDataImages with JsonConvert<DynamicDetailDataImages> {
	late int id;
	@JSONField(name: "user_id")
	late int userId;
	@JSONField(name: "dynamic_id")
	late int dynamicId;
	late String type;
	late String path;
}
