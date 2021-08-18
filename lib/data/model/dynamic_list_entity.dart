import 'package:flutter_locyin/generated/json/base/json_convert_content.dart';
import 'package:flutter_locyin/generated/json/base/json_field.dart';

class DynamicListEntity with JsonConvert<DynamicListEntity> {
	late List<DynamicListData> data;
	late DynamicListLinks links;
	late DynamicListMeta meta;
}

class DynamicListData with JsonConvert<DynamicListData> {
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
	late DynamicListDataUser user;
	late List<DynamicListDataImages> images;
}

class DynamicListDataUser with JsonConvert<DynamicListDataUser> {
	late int id;
	late String username;
	late String nickname;
	late String avatar;
	late String email;
	late String introduction;
	@JSONField(name: "notification_count")
	late int notificationCount;
	@JSONField(name: "created_at")
	late String createdAt;
	@JSONField(name: "updated_at")
	late String updatedAt;
}

class DynamicListDataImages with JsonConvert<DynamicListDataImages> {
	late int id;
	@JSONField(name: "user_id")
	late int userId;
	@JSONField(name: "dynamic_id")
	late int dynamicId;
	late String type;
	late String path;
}

class DynamicListLinks with JsonConvert<DynamicListLinks> {
	late String first;
	late String last;
	late dynamic prev;
	late String next;
}

class DynamicListMeta with JsonConvert<DynamicListMeta> {
	@JSONField(name: "current_page")
	late int currentPage;
	late int from;
	@JSONField(name: "last_page")
	late int lastPage;
	late List<DynamicListMetaLinks> links;
	late String path;
	@JSONField(name: "per_page")
	late String perPage;
	late int to;
	late int total;
}

class DynamicListMetaLinks with JsonConvert<DynamicListMetaLinks> {
	late String url;
	late String label;
	late bool active;
}
