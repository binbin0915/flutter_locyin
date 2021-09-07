import 'package:flutter_locyin/data/model/chat_message_entity.dart';

chatMessageEntityFromJson(ChatMessageEntity data, Map<String, dynamic> json) {
	if (json['data'] != null) {
		data.data = (json['data'] as List).map((v) => ChatMessageData().fromJson(v)).toList();
	}
	if (json['links'] != null) {
		data.links = ChatMessageLinks().fromJson(json['links']);
	}
	if (json['meta'] != null) {
		data.meta = ChatMessageMeta().fromJson(json['meta']);
	}
	return data;
}

Map<String, dynamic> chatMessageEntityToJson(ChatMessageEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['data'] =  entity.data.map((v) => v.toJson()).toList();
	data['links'] = entity.links.toJson();
	data['meta'] = entity.meta.toJson();
	return data;
}

chatMessageDataFromJson(ChatMessageData data, Map<String, dynamic> json) {
	if (json['from_id'] != null) {
		data.fromId = json['from_id'] is String
				? int.tryParse(json['from_id'])
				: json['from_id'].toInt();
	}
	if (json['to_id'] != null) {
		data.toId = json['to_id'] is String
				? int.tryParse(json['to_id'])
				: json['to_id'].toInt();
	}
	if (json['content'] != null) {
		data.content = json['content'].toString();
	}
	if (json['push'] != null) {
		data.push = json['push'] is String
				? int.tryParse(json['push'])
				: json['push'].toInt();
	}
	if (json['read'] != null) {
		data.read = json['read'] is String
				? int.tryParse(json['read'])
				: json['read'].toInt();
	}
	if (json['status'] != null) {
		data.status = json['status'] is String
				? int.tryParse(json['status'])
				: json['status'].toInt();
	}
	if (json['type'] != null) {
		data.type = json['type'].toString();
	}
	if (json['uuid'] != null) {
		data.uuid = json['uuid'].toString();
	}
	if (json['thumbnail'] != null) {
		data.thumbnail = json['thumbnail'].toString();
	}
	if (json['length'] != null) {
		data.length = json['length'] is String
				? double.tryParse(json['length'])
				: json['length'].toDouble();
	}
	if (json['progress'] != null) {
		data.progress = json['progress'] is String
				? double.tryParse(json['progress'])
				: json['progress'].toDouble();
	}
	if (json['created_at'] != null) {
		data.createdAt = json['created_at'].toString();
	}
	if (json['updated_at'] != null) {
		data.updatedAt = json['updated_at'].toString();
	}
	return data;
}

Map<String, dynamic> chatMessageDataToJson(ChatMessageData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['from_id'] = entity.fromId;
	data['to_id'] = entity.toId;
	data['content'] = entity.content;
	data['push'] = entity.push;
	data['read'] = entity.read;
	data['status'] = entity.status;
	data['type'] = entity.type;
	data['uuid'] = entity.uuid;
	data['thumbnail'] = entity.thumbnail;
	data['length'] = entity.length;
	data['progress'] = entity.progress;
	data['created_at'] = entity.createdAt;
	data['updated_at'] = entity.updatedAt;
	return data;
}

chatMessageLinksFromJson(ChatMessageLinks data, Map<String, dynamic> json) {
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

Map<String, dynamic> chatMessageLinksToJson(ChatMessageLinks entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['first'] = entity.first;
	data['last'] = entity.last;
	data['prev'] = entity.prev;
	data['next'] = entity.next;
	return data;
}

chatMessageMetaFromJson(ChatMessageMeta data, Map<String, dynamic> json) {
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
		data.links = (json['links'] as List).map((v) => ChatMessageMetaLinks().fromJson(v)).toList();
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

Map<String, dynamic> chatMessageMetaToJson(ChatMessageMeta entity) {
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

chatMessageMetaLinksFromJson(ChatMessageMetaLinks data, Map<String, dynamic> json) {
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

Map<String, dynamic> chatMessageMetaLinksToJson(ChatMessageMetaLinks entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['url'] = entity.url;
	data['label'] = entity.label;
	data['active'] = entity.active;
	return data;
}