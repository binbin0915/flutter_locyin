import 'package:flutter_locyin/data/model/dynamic_list_entity.dart';

dynamicListEntityFromJson(DynamicListEntity data, Map<String, dynamic> json) {
	if (json['data'] != null) {
		data.data = (json['data'] as List).map((v) => DynamicListData().fromJson(v)).toList();
	}
	if (json['links'] != null) {
		data.links = DynamicListLinks().fromJson(json['links']);
	}
	if (json['meta'] != null) {
		data.meta = DynamicListMeta().fromJson(json['meta']);
	}
	return data;
}

Map<String, dynamic> dynamicListEntityToJson(DynamicListEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['data'] =  entity.data.map((v) => v.toJson()).toList();
	data['links'] = entity.links.toJson();
	data['meta'] = entity.meta.toJson();
	return data;
}

dynamicListDataFromJson(DynamicListData data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'] is String
				? int.tryParse(json['id'])
				: json['id'].toInt();
	}
	if (json['user_id'] != null) {
		data.userId = json['user_id'] is String
				? int.tryParse(json['user_id'])
				: json['user_id'].toInt();
	}
	if (json['thumb_count'] != null) {
		data.thumbCount = json['thumb_count'] is String
				? int.tryParse(json['thumb_count'])
				: json['thumb_count'].toInt();
	}
	if (json['thumbed'] != null) {
		data.thumbed = json['thumbed'] is String
				? int.tryParse(json['thumbed'])
				: json['thumbed'].toInt();
	}
	if (json['collected'] != null) {
		data.collected = json['collected'] is String
				? int.tryParse(json['collected'])
				: json['collected'].toInt();
	}
	if (json['collect_count'] != null) {
		data.collectCount = json['collect_count'] is String
				? int.tryParse(json['collect_count'])
				: json['collect_count'].toInt();
	}
	if (json['comment_count'] != null) {
		data.commentCount = json['comment_count'] is String
				? int.tryParse(json['comment_count'])
				: json['comment_count'].toInt();
	}
	if (json['created_at'] != null) {
		data.createdAt = json['created_at'].toString();
	}
	if (json['updated_at'] != null) {
		data.updatedAt = json['updated_at'].toString();
	}
	if (json['content'] != null) {
		data.content = json['content'].toString();
	}
	if (json['location'] != null) {
		data.location = json['location'].toString();
	}
	if (json['user'] != null) {
		data.user = DynamicListDataUser().fromJson(json['user']);
	}
	if (json['images'] != null) {
		data.images = (json['images'] as List).map((v) => DynamicListDataImages().fromJson(v)).toList();
	}
	return data;
}

Map<String, dynamic> dynamicListDataToJson(DynamicListData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['user_id'] = entity.userId;
	data['thumb_count'] = entity.thumbCount;
	data['thumbed'] = entity.thumbed;
	data['collected'] = entity.collected;
	data['collect_count'] = entity.collectCount;
	data['comment_count'] = entity.commentCount;
	data['created_at'] = entity.createdAt;
	data['updated_at'] = entity.updatedAt;
	data['content'] = entity.content;
	data['location'] = entity.location;
	data['user'] = entity.user.toJson();
	data['images'] =  entity.images.map((v) => v.toJson()).toList();
	return data;
}

dynamicListDataUserFromJson(DynamicListDataUser data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'] is String
				? int.tryParse(json['id'])
				: json['id'].toInt();
	}
	if (json['username'] != null) {
		data.username = json['username'].toString();
	}
	if (json['nickname'] != null) {
		data.nickname = json['nickname'].toString();
	}
	if (json['avatar'] != null) {
		data.avatar = json['avatar'].toString();
	}
	if (json['email'] != null) {
		data.email = json['email'].toString();
	}
	if (json['introduction'] != null) {
		data.introduction = json['introduction'].toString();
	}
	if (json['notification_count'] != null) {
		data.notificationCount = json['notification_count'] is String
				? int.tryParse(json['notification_count'])
				: json['notification_count'].toInt();
	}
	if (json['created_at'] != null) {
		data.createdAt = json['created_at'].toString();
	}
	if (json['updated_at'] != null) {
		data.updatedAt = json['updated_at'].toString();
	}
	return data;
}

Map<String, dynamic> dynamicListDataUserToJson(DynamicListDataUser entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['username'] = entity.username;
	data['nickname'] = entity.nickname;
	data['avatar'] = entity.avatar;
	data['email'] = entity.email;
	data['introduction'] = entity.introduction;
	data['notification_count'] = entity.notificationCount;
	data['created_at'] = entity.createdAt;
	data['updated_at'] = entity.updatedAt;
	return data;
}

dynamicListDataImagesFromJson(DynamicListDataImages data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'] is String
				? int.tryParse(json['id'])
				: json['id'].toInt();
	}
	if (json['user_id'] != null) {
		data.userId = json['user_id'] is String
				? int.tryParse(json['user_id'])
				: json['user_id'].toInt();
	}
	if (json['dynamic_id'] != null) {
		data.dynamicId = json['dynamic_id'] is String
				? int.tryParse(json['dynamic_id'])
				: json['dynamic_id'].toInt();
	}
	if (json['type'] != null) {
		data.type = json['type'].toString();
	}
	if (json['path'] != null) {
		data.path = json['path'].toString();
	}
	return data;
}

Map<String, dynamic> dynamicListDataImagesToJson(DynamicListDataImages entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['user_id'] = entity.userId;
	data['dynamic_id'] = entity.dynamicId;
	data['type'] = entity.type;
	data['path'] = entity.path;
	return data;
}

dynamicListLinksFromJson(DynamicListLinks data, Map<String, dynamic> json) {
	if (json['first'] != null) {
		data.first = json['first'].toString();
	}
	if (json['last'] != null) {
		data.last = json['last'].toString();
	}
	if (json['prev'] != null) {
		data.prev = json['prev'];
	}
	if (json['next'] != null) {
		data.next = json['next'].toString();
	}
	return data;
}

Map<String, dynamic> dynamicListLinksToJson(DynamicListLinks entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['first'] = entity.first;
	data['last'] = entity.last;
	data['prev'] = entity.prev;
	data['next'] = entity.next;
	return data;
}

dynamicListMetaFromJson(DynamicListMeta data, Map<String, dynamic> json) {
	if (json['current_page'] != null) {
		data.currentPage = json['current_page'] is String
				? int.tryParse(json['current_page'])
				: json['current_page'].toInt();
	}
	if (json['from'] != null) {
		data.from = json['from'] is String
				? int.tryParse(json['from'])
				: json['from'].toInt();
	}
	if (json['last_page'] != null) {
		data.lastPage = json['last_page'] is String
				? int.tryParse(json['last_page'])
				: json['last_page'].toInt();
	}
	if (json['links'] != null) {
		data.links = (json['links'] as List).map((v) => DynamicListMetaLinks().fromJson(v)).toList();
	}
	if (json['path'] != null) {
		data.path = json['path'].toString();
	}
	if (json['per_page'] != null) {
		data.perPage = json['per_page'].toString();
	}
	if (json['to'] != null) {
		data.to = json['to'] is String
				? int.tryParse(json['to'])
				: json['to'].toInt();
	}
	if (json['total'] != null) {
		data.total = json['total'] is String
				? int.tryParse(json['total'])
				: json['total'].toInt();
	}
	return data;
}

Map<String, dynamic> dynamicListMetaToJson(DynamicListMeta entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['current_page'] = entity.currentPage;
	data['from'] = entity.from;
	data['last_page'] = entity.lastPage;
	data['links'] =  entity.links.map((v) => v.toJson()).toList();
	data['path'] = entity.path;
	data['per_page'] = entity.perPage;
	data['to'] = entity.to;
	data['total'] = entity.total;
	return data;
}

dynamicListMetaLinksFromJson(DynamicListMetaLinks data, Map<String, dynamic> json) {
	if (json['url'] != null) {
		data.url = json['url'].toString();
	}
	if (json['label'] != null) {
		data.label = json['label'].toString();
	}
	if (json['active'] != null) {
		data.active = json['active'];
	}
	return data;
}

Map<String, dynamic> dynamicListMetaLinksToJson(DynamicListMetaLinks entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['url'] = entity.url;
	data['label'] = entity.label;
	data['active'] = entity.active;
	return data;
}