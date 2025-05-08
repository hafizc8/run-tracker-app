import 'package:zest_mobile/app/core/models/interface/model_interface.dart';

class PostModel extends Model<PostModel> {
    PostModel({
        required this.id,
        required this.title,
        required this.content,
        required this.district,
        required this.likesCount,
        required this.commentsCount,
        required this.createdAt,
        required this.updatedAt,
        required this.user,
        required this.galleries,
    });

    final String? id;
    final String? title;
    final String? content;
    final String? district;
    final int? likesCount;
    final int? commentsCount;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final User? user;
    final List<Gallery> galleries;

    @override
  PostModel copyWith({
        String? id,
        String? title,
        String? content,
        String? district,
        int? likesCount,
        int? commentsCount,
        DateTime? createdAt,
        DateTime? updatedAt,
        User? user,
        List<Gallery>? galleries,
    }) {
        return PostModel(
            id: id ?? this.id,
            title: title ?? this.title,
            content: content ?? this.content,
            district: district ?? this.district,
            likesCount: likesCount ?? this.likesCount,
            commentsCount: commentsCount ?? this.commentsCount,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            user: user ?? this.user,
            galleries: galleries ?? this.galleries,
        );
    }

    factory PostModel.fromJson(Map<String, dynamic> json){ 
        return PostModel(
            id: json["id"],
            title: json["title"],
            content: json["content"],
            district: json["district"],
            likesCount: json["likes_count"],
            commentsCount: json["comments_count"],
            createdAt: DateTime.tryParse(json["created_at"] ?? ""),
            updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
            user: json["user"] == null ? null : User.fromJson(json["user"]),
            galleries: json["galleries"] == null ? [] : List<Gallery>.from(json["galleries"]!.map((x) => Gallery.fromJson(x))),
        );
    }

    @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "content": content,
        "district": district,
        "likes_count": likesCount,
        "comments_count": commentsCount,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "user": user?.toJson(),
        "galleries": galleries.map((x) => x.toJson()).toList(),
    };

    @override
    List<Object?> get props => [
    id, title, content, district, likesCount, commentsCount, createdAt, updatedAt, user, galleries, ];
}

class Gallery extends Model<Gallery> {
    Gallery({
        required this.id,
        required this.type,
        required this.path,
        required this.url,
    });

    final String? id;
    final int? type;
    final String? path;
    final String? url;

    @override
  Gallery copyWith({
        String? id,
        int? type,
        String? path,
        String? url,
    }) {
        return Gallery(
            id: id ?? this.id,
            type: type ?? this.type,
            path: path ?? this.path,
            url: url ?? this.url,
        );
    }

    factory Gallery.fromJson(Map<String, dynamic> json){ 
        return Gallery(
            id: json["id"],
            type: json["type"],
            path: json["path"],
            url: json["url"],
        );
    }

    @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "path": path,
        "url": url,
    };

    @override
    List<Object?> get props => [
    id, type, path, url, ];
}

class User extends Model<User> {
    User({
        required this.id,
        required this.name,
        required this.imagePath,
        required this.imageUrl,
    });

    final String? id;
    final String? name;
    final String? imagePath;
    final String? imageUrl;

    @override
  User copyWith({
        String? id,
        String? name,
        String? imagePath,
        String? imageUrl,
    }) {
        return User(
            id: id ?? this.id,
            name: name ?? this.name,
            imagePath: imagePath ?? this.imagePath,
            imageUrl: imageUrl ?? this.imageUrl,
        );
    }

    factory User.fromJson(Map<String, dynamic> json){ 
        return User(
            id: json["id"],
            name: json["name"],
            imagePath: json["image_path"],
            imageUrl: json["image_url"],
        );
    }

    @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image_path": imagePath,
        "image_url": imageUrl,
    };

    @override
    List<Object?> get props => [
    id, name, imagePath, imageUrl, ];
}

class Pagination extends Model<Pagination> {
    Pagination({
        required this.total,
        required this.offset,
        required this.current,
        required this.last,
        required this.next,
        required this.prev,
    });

    final int? total;
    final int? offset;
    final int? current;
    final int? last;
    final String? next;
    final String? prev;

    @override
  Pagination copyWith({
        int? total,
        int? offset,
        int? current,
        int? last,
        String? next,
        String? prev,
    }) {
        return Pagination(
            total: total ?? this.total,
            offset: offset ?? this.offset,
            current: current ?? this.current,
            last: last ?? this.last,
            next: next ?? this.next,
            prev: prev ?? this.prev,
        );
    }

    factory Pagination.fromJson(Map<String, dynamic> json){ 
        return Pagination(
            total: json["total"],
            offset: json["offset"],
            current: json["current"],
            last: json["last"],
            next: json["next"],
            prev: json["prev"],
        );
    }

    @override
  Map<String, dynamic> toJson() => {
        "total": total,
        "offset": offset,
        "current": current,
        "last": last,
        "next": next,
        "prev": prev,
    };

    @override
    List<Object?> get props => [
    total, offset, current, last, next, prev, ];
}
