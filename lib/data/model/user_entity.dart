import 'package:flutter_locyin/generated/json/base/json_convert_content.dart';
import 'package:flutter_locyin/generated/json/base/json_field.dart';

class UserEntity with JsonConvert<UserEntity> {
	late UserData data;
}

class UserData with JsonConvert<UserData> {
	late int id;
	late dynamic username;
	late String nickname;
	late String avatar;
	late String phone;
	late dynamic email;
	late dynamic introduction;
	@JSONField(name: "notification_count")
	late int notificationCount;
	late int status;
	@JSONField(name: "created_at")
	late String createdAt;
	@JSONField(name: "updated_at")
	late String updatedAt;
}
