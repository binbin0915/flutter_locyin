import 'package:flutter_locyin/generated/json/base/json_convert_content.dart';
import 'package:flutter_locyin/generated/json/base/json_field.dart';

class MessageListEntity with JsonConvert<MessageListEntity> {
	late List<MessageListData> data;
}

class MessageListData with JsonConvert<MessageListData> {
	late MessageListDataStranger stranger;
	late int count;
	late String type;
	late String excerpt;
	@JSONField(name: "created_at")
	late String createdAt;
	@JSONField(name: "updated_at")
	late String updatedAt;
}

class MessageListDataStranger with JsonConvert<MessageListDataStranger> {
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
