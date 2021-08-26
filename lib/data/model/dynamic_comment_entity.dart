import 'package:flutter_locyin/generated/json/base/json_convert_content.dart';
import 'package:flutter_locyin/generated/json/base/json_field.dart';

class DynamicCommentEntity with JsonConvert<DynamicCommentEntity> {
	late List<DynamicCommentData> data;
	late DynamicCommentLinks links;
	late DynamicCommentMeta meta;
}

class DynamicCommentData with JsonConvert<DynamicCommentData> {
	late int id;
	@JSONField(name: "replier_id")
	late int replierId;
	@JSONField(name: "poster_id")
	late int posterId;
	@JSONField(name: "replier_nickname")
	late String replierNickname;
	@JSONField(name: "replier_avatar")
	late String replierAvatar;
	@JSONField(name: "receiver_id")
	late int receiverId;
	@JSONField(name: "receiver_nickname")
	late String receiverNickname;
	@JSONField(name: "thumb_count")
	late int thumbCount;
	late String content;
	@JSONField(name: "created_at")
	late String createdAt;
	@JSONField(name: "updated_at")
	late String updatedAt;
}

class DynamicCommentLinks with JsonConvert<DynamicCommentLinks> {
	late String first;
	late String last;
	late dynamic prev;
	late dynamic next;
}

class DynamicCommentMeta with JsonConvert<DynamicCommentMeta> {
	@JSONField(name: "current_page")
	late int currentPage;
	late int from;
	@JSONField(name: "last_page")
	late int lastPage;
	late List<DynamicCommentMetaLinks> links;
	late String path;
	@JSONField(name: "per_page")
	late String perPage;
	late int to;
	late int total;
}

class DynamicCommentMetaLinks with JsonConvert<DynamicCommentMetaLinks> {
	late String url;
	late String label;
	late bool active;
}
