import 'package:flutter_locyin/data/model/dynamic_comment_entity.dart';

dynamicCommentEntityFromJson(DynamicCommentEntity data, Map<String, dynamic> json) {
	if (json['data'] != null) {
		data.data = (json['data'] as List).map((v) => DynamicCommentData().fromJson(v)).toList();
	}
	if (json['links'] != null) {
		data.links = DynamicCommentLinks().fromJson(json['links']);
	}
	if (json['meta'] != null) {
		data.meta = DynamicCommentMeta().fromJson(json['meta']);
	}
	return data;
}

Map<String, dynamic> dynamicCommentEntityToJson(DynamicCommentEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['data'] =  entity.data.map((v) => v.toJson()).toList();
	data['links'] = entity.links.toJson();
	data['meta'] = entity.meta.toJson();
	return data;
}

dynamicCommentDataFromJson(DynamicCommentData data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'] is String
				? int.tryParse(json['id'])
				: json['id'].toInt();
	}
	if (json['replier_id'] != null) {
		data.replierId = json['replier_id'] is String
				? int.tryParse(json['replier_id'])
				: json['replier_id'].toInt();
	}
	if (json['poster_id'] != null) {
		data.posterId = json['poster_id'] is String
				? int.tryParse(json['poster_id'])
				: json['poster_id'].toInt();
	}
	if (json['replier_nickname'] != null) {
		data.replierNickname = json['replier_nickname'].toString();
	}
	if (json['replier_avatar'] != null) {
		data.replierAvatar = json['replier_avatar'].toString();
	}
	if (json['receiver_id'] != null) {
		data.receiverId = json['receiver_id'] is String
				? int.tryParse(json['receiver_id'])
				: json['receiver_id'].toInt();
	}
	if (json['receiver_nickname'] != null) {
		data.receiverNickname = json['receiver_nickname'].toString();
	}
	if (json['thumb_count'] != null) {
		data.thumbCount = json['thumb_count'] is String
				? int.tryParse(json['thumb_count'])
				: json['thumb_count'].toInt();
	}
	if (json['content'] != null) {
		data.content = json['content'].toString();
	}
	if (json['created_at'] != null) {
		data.createdAt = json['created_at'].toString();
	}
	if (json['updated_at'] != null) {
		data.updatedAt = json['updated_at'].toString();
	}
	return data;
}

Map<String, dynamic> dynamicCommentDataToJson(DynamicCommentData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['replier_id'] = entity.replierId;
	data['poster_id'] = entity.posterId;
	data['replier_nickname'] = entity.replierNickname;
	data['replier_avatar'] = entity.replierAvatar;
	data['receiver_id'] = entity.receiverId;
	data['receiver_nickname'] = entity.receiverNickname;
	data['thumb_count'] = entity.thumbCount;
	data['content'] = entity.content;
	data['created_at'] = entity.createdAt;
	data['updated_at'] = entity.updatedAt;
	return data;
}

dynamicCommentLinksFromJson(DynamicCommentLinks data, Map<String, dynamic> json) {
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
		data.next = json['next'];
	}
	return data;
}

Map<String, dynamic> dynamicCommentLinksToJson(DynamicCommentLinks entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['first'] = entity.first;
	data['last'] = entity.last;
	data['prev'] = entity.prev;
	data['next'] = entity.next;
	return data;
}

dynamicCommentMetaFromJson(DynamicCommentMeta data, Map<String, dynamic> json) {
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
		data.links = (json['links'] as List).map((v) => DynamicCommentMetaLinks().fromJson(v)).toList();
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

Map<String, dynamic> dynamicCommentMetaToJson(DynamicCommentMeta entity) {
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

dynamicCommentMetaLinksFromJson(DynamicCommentMetaLinks data, Map<String, dynamic> json) {
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

Map<String, dynamic> dynamicCommentMetaLinksToJson(DynamicCommentMetaLinks entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['url'] = entity.url;
	data['label'] = entity.label;
	data['active'] = entity.active;
	return data;
}