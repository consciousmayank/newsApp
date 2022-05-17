import 'dart:convert';

class NewsArticles {
  NewsArticles({
    this.status,
    this.totalResults,
    this.articles,
  });

  final String? status;
  final int? totalResults;
  final List<Article>? articles;

  NewsArticles copyWith({
    String? status,
    int? totalResults,
    List<Article>? articles,
  }) =>
      NewsArticles(
        status: status ?? this.status,
        totalResults: totalResults ?? this.totalResults,
        articles: articles ?? this.articles,
      );

  factory NewsArticles.fromJson(String str) =>
      NewsArticles.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory NewsArticles.fromMap(Map<String, dynamic> json) => NewsArticles(
        status: json["status"],
        totalResults: json["totalResults"],
        articles:
            List<Article>.from(json["articles"].map((x) => Article.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "totalResults": totalResults,
        "articles": articles != null
            ? List<dynamic>.from(articles!.map((x) => x.toMap()))
            : [],
      };

  NewsArticles.empty()
      : this(
          status: null,
          totalResults: 0,
          articles: [],
        );
}

class Article {
  Article({
    this.source,
    this.author,
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
    this.isBookmarked = false,
  });

  Article.empty()
      : this(
          source: null,
          author: null,
          title: null,
          description: null,
          url: null,
          urlToImage: null,
          publishedAt: null,
          content: null,
          isBookmarked: false,
        );

  final Source? source;
  final String? author;
  final String? title;
  final String? description;
  final String? url;
  final String? urlToImage;
  final DateTime? publishedAt;
  final String? content;
  final bool isBookmarked;

  Article copyWith({
    Source? source,
    String? author,
    String? title,
    String? description,
    String? url,
    String? urlToImage,
    DateTime? publishedAt,
    String? content,
    bool? isBookmarked,
  }) =>
      Article(
        source: source ?? this.source,
        author: author ?? this.author,
        title: title ?? this.title,
        description: description ?? this.description,
        url: url ?? this.url,
        urlToImage: urlToImage ?? this.urlToImage,
        publishedAt: publishedAt ?? this.publishedAt,
        content: content ?? this.content,
        isBookmarked: isBookmarked ?? this.isBookmarked,
      );

  factory Article.fromJson(String str) => Article.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Article.fromMap(Map<String, dynamic> json) => Article(
        source: Source.fromMap(json["source"]),
        author: json["author"],
        title: json["title"],
        description: json["description"],
        url: json["url"],
        urlToImage: json["urlToImage"],
        publishedAt: DateTime.parse(json["publishedAt"]),
        content: json["content"],
      );

  factory Article.fromMapDb(Map<String, dynamic> json) => Article(
        source: Source(id: json["source"], name: 'From Db'),
        author: json["author"],
        title: json["title"],
        description: json["description"],
        url: json["url"],
        urlToImage: json["urlToImage"],
        publishedAt: DateTime.parse(json["publishedAt"]),
        content: json["content"],
      );

  Map<String, dynamic> toMap() => {
        "source": source != null ? source!.toMap() : [],
        "author": author,
        "title": title,
        "description": description,
        "url": url,
        "urlToImage": urlToImage,
        "publishedAt": publishedAt,
        "content": content,
      };

  Map<String, dynamic> toMapDb() => {
        "source": source != null ? source!.id : '',
        "author": author ?? '',
        "title": title ?? '',
        "description": description ?? '',
        "url": url ?? '',
        "urlToImage": urlToImage ?? '',
        "publishedAt": publishedAt?.toIso8601String() ?? '',
        "content": content ?? '',
      };
}

class Source {
  Source({
    this.id,
    this.name,
    this.isSaved = false,
  });

  final String? id;
  final String? name;
  final bool isSaved;

  Source copyWith({
    String? id,
    String? name,
    bool? isSaved,
  }) =>
      Source(
        id: id ?? this.id,
        name: name ?? this.name,
        isSaved: isSaved ?? this.isSaved,
      );

  factory Source.fromJson(String str) => Source.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Source.fromMap(Map<String, dynamic> json) => Source(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
      };
}
