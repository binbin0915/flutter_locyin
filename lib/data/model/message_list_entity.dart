import 'package:flutter_locyin/generated/json/base/json_convert_content.dart';
import 'package:flutter_locyin/generated/json/base/json_field.dart';

class MessageListEntity with JsonConvert<MessageListEntity> {
	late List<MessageListData> data;
}

class MessageListData with JsonConvert<MessageListData> {
	late MessageListDataStranger stranger;
	late int count;
	late dynamic type;
	late int id;
	late int online;
	late String excerpt;
	String draft = '';
	@JSONField(name: "created_at")
	late String createdAt;
	@JSONField(name: "updated_at")
	late String updatedAt;
}

class MessageListDataStranger with JsonConvert<MessageListDataStranger> {
	late int id;
	late dynamic username;
	late String nickname;
	late String avatar;
	late dynamic email;
	late dynamic introduction;
	@JSONField(name: "notification_count")
	late int notificationCount;
	late int status;
	late int online;
	@JSONField(name: "created_at")
	late String createdAt;
	@JSONField(name: "updated_at")
	late String updatedAt;
}
