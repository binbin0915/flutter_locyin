import 'package:flutter_locyin/generated/json/base/json_convert_content.dart';
import 'package:flutter_locyin/generated/json/base/json_field.dart';

class ChatMessageEntity with JsonConvert<ChatMessageEntity> {
	late List<ChatMessageData> data;
	late ChatMessageLinks links;
	late ChatMessageMeta meta;
}

class ChatMessageData with JsonConvert<ChatMessageData> {
	@JSONField(name: "from_id")
	late int fromId;
	@JSONField(name: "to_id")
	late int toId;
	late String content;
	late int push;
	late int read;
	late int status;
	late String type;
	late String uuid;
	String? thumbnail;
	double? length;
	double progress = 1.0;
	@JSONField(name: "created_at")
	late String createdAt;
	@JSONField(name: "updated_at")
	late String updatedAt;
}

class ChatMessageLinks with JsonConvert<ChatMessageLinks> {
	late String first;
	late String last;
	late dynamic prev;
	late dynamic next;
}

class ChatMessageMeta with JsonConvert<ChatMessageMeta> {
	@JSONField(name: "current_page")
	late int currentPage;
	late int from;
	@JSONField(name: "last_page")
	late int lastPage;
	late List<ChatMessageMetaLinks> links;
	late String path;
	@JSONField(name: "per_page")
	late String perPage;
	late int to;
	late int total;
}

class ChatMessageMetaLinks with JsonConvert<ChatMessageMetaLinks> {
	late String url;
	late String label;
	late bool active;
}
