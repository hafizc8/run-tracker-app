import 'package:zest_mobile/app/core/models/interface/model_interface.dart';
import 'package:zest_mobile/app/core/models/model/user_mini_model.dart';

// ignore: must_be_immutable
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
        this.isLiked,
        this.isOwner = false,
        this.comments,
        this.likes,
    });

    final String? id;
    final String? title;
    final String? content;
    final String? district;
    final int? likesCount;
    final int? commentsCount;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final UserMiniModel? user;
    final List<Gallery> galleries;
    final List<Comment>? comments;
    bool? isOwner;
    bool? isLiked;
    List<UserMiniModel>? likes;

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
        UserMiniModel? user,
        List<Gallery>? galleries,
        bool? isLiked,
        bool? isOwner,
        List<Comment>? comments,
        List<UserMiniModel>? likes
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
            isLiked: isLiked ?? this.isLiked,
            comments: comments ?? this.comments,
            isOwner: isOwner ?? this.isOwner,
            likes: likes ?? this.likes
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
            user: json["user"] == null ? null : UserMiniModel.fromJson(json["user"]),
            galleries: json["galleries"] == null ? [] : List<Gallery>.from(json["galleries"]!.map((x) => Gallery.fromJson(x))),
            comments: json["comments"] == null ? [] : List<Comment>.from(json["comments"]!.map((x) => Comment.fromJson(x))),
            isLiked: json['is_liked'] == 1,
            isOwner: false,
            likes: json["likes"] == null ? [] : List<UserMiniModel>.from(json["likes"]!.map((x) => UserMiniModel.fromJson(x['user']))),
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
    id, title, content, district, likesCount, commentsCount, createdAt, updatedAt, user, galleries, comments, isLiked, isOwner, likes];
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

class Comment extends Model<Comment> {
    Comment({
        required this.id,
        required this.content,
        required this.createdAt,
        required this.user,
        required this.replies,
    });

    final String? id;
    final String? content;
    final DateTime? createdAt;
    final UserMiniModel? user;
    final List<Reply> replies;

    @override
      Comment copyWith({
        String? id,
        String? content,
        DateTime? createdAt,
        UserMiniModel? user,
        List<Reply>? replies,
    }) {
        return Comment(
            id: id ?? this.id,
            content: content ?? this.content,
            createdAt: createdAt ?? this.createdAt,
            user: user ?? this.user,
            replies: replies ?? this.replies,
        );
    }

    factory Comment.fromJson(Map<String, dynamic> json){ 
        return Comment(
            id: json["id"],
            content: json["content"],
            createdAt: DateTime.tryParse(json["created_at"] ?? ""),
            user: json["user"] == null ? null : UserMiniModel.fromJson(json["user"]),
            replies: json["replies"] == null ? [] : List<Reply>.from(json["replies"]!.map((x) => Reply.fromJson(x))),
        );
    }

    @override
      Map<String, dynamic> toJson() => {
        "id": id,
        "content": content,
        "created_at": createdAt?.toIso8601String(),
        "user": user?.toJson(),
        "replies": replies.map((x) => x.toJson()).toList(),
    };

    @override
    List<Object?> get props => [
    id, content, createdAt, user, replies, ];
}

class Reply extends Model<Reply> {
    Reply({
        required this.id,
        required this.userId,
        required this.postId,
        required this.parentId,
        required this.content,
        required this.createdAt,
        required this.updatedAt,
        required this.deletedAt,
        required this.user,
    });

    final String? id;
    final String? userId;
    final String? postId;
    final String? parentId;
    final String? content;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final dynamic deletedAt;
    final UserMiniModel? user;

    @override
      Reply copyWith({
        String? id,
        String? userId,
        String? postId,
        String? parentId,
        String? content,
        DateTime? createdAt,
        DateTime? updatedAt,
        dynamic deletedAt,
        UserMiniModel? user,
    }) {
        return Reply(
            id: id ?? this.id,
            userId: userId ?? this.userId,
            postId: postId ?? this.postId,
            parentId: parentId ?? this.parentId,
            content: content ?? this.content,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            deletedAt: deletedAt ?? this.deletedAt,
            user: user ?? this.user,
        );
    }

    factory Reply.fromJson(Map<String, dynamic> json){ 
        return Reply(
            id: json["id"],
            userId: json["user_id"],
            postId: json["post_id"],
            parentId: json["parent_id"],
            content: json["content"],
            createdAt: DateTime.tryParse(json["created_at"] ?? ""),
            updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
            deletedAt: json["deleted_at"],
            user: json["user"] == null ? null : UserMiniModel.fromJson(json["user"]),
        );
    }

    @override
      Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "post_id": postId,
        "parent_id": parentId,
        "content": content,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "user": user?.toJson(),
    };

    @override
    List<Object?> get props => [
    id, userId, postId, parentId, content, createdAt, updatedAt, deletedAt, user, ];
}