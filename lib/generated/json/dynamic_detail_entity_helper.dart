import 'package:flutter_locyin/data/model/dynamic_detail_entity.dart';

dynamicDetailEntityFromJson(DynamicDetailEntity data, Map<String, dynamic> json) {
	if (json['data'] != null) {
		data.data = DynamicDetailData().fromJson(json['data']);
	}
	return data;
}

Map<String, dynamic> dynamicDetailEntityToJson(DynamicDetailEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['data'] = entity.data.toJson();
	return data;
}

dynamicDetailDataFromJson(DynamicDetailData data, Map<String, dynamic> json) {
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
		data.user = DynamicDetailDataUser().fromJson(json['user']);
	}
	if (json['images'] != null) {
		data.images = (json['images'] as List).map((v) => DynamicDetailDataImages().fromJson(v)).toList();
	}
	return data;
}

Map<String, dynamic> dynamicDetailDataToJson(DynamicDetailData entity) {
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

dynamicDetailDataUserFromJson(DynamicDetailDataUser data, Map<String, dynamic> json) {
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
	if (json['status'] != null) {
		data.status = json['status'] is String
				? int.tryParse(json['status'])
				: json['status'].toInt();
	}
	if (json['created_at'] != null) {
		data.createdAt = json['created_at'].toString();
	}
	if (json['updated_at'] != null) {
		data.updatedAt = json['updated_at'].toString();
	}
	return data;
}

Map<String, dynamic> dynamicDetailDataUserToJson(DynamicDetailDataUser entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['username'] = entity.username;
	data['nickname'] = entity.nickname;
	data['avatar'] = entity.avatar;
	data['email'] = entity.email;
	data['introduction'] = entity.introduction;
	data['notification_count'] = entity.notificationCount;
	data['status'] = entity.status;
	data['created_at'] = entity.createdAt;
	data['updated_at'] = entity.updatedAt;
	return data;
}

dynamicDetailDataImagesFromJson(DynamicDetailDataImages data, Map<String, dynamic> json) {
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

Map<String, dynamic> dynamicDetailDataImagesToJson(DynamicDetailDataImages entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['user_id'] = entity.userId;
	data['dynamic_id'] = entity.dynamicId;
	data['type'] = entity.type;
	data['path'] = entity.path;
	return data;
}