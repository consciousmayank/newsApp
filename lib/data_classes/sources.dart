// To parse this JSON data, do
//
//     final sources = sourcesFromMap(jsonString);

import 'dart:convert';

class Sources {
  Sources({
    this.status,
    this.sources,
  });

  Sources.empty()
      : this(
          status: '',
          sources: [],
        );

  factory Sources.fromJson(String str) => Sources.fromMap(json.decode(str));

  factory Sources.fromMap(Map<String, dynamic> json) => Sources(
        status: json["status"],
        sources: json["sources"] != null
            ? List<Source>.from(json["sources"].map((x) => Source.fromMap(x)))
            : [],
      );

  final List<Source>? sources;
  final String? status;

  Sources copyWith({
    String? status,
    List<Source>? sources,
  }) =>
      Sources(
        status: status ?? this.status,
        sources: sources ?? this.sources,
      );

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
        "status": status,
        "sources": sources != null
            ? List<dynamic>.from(sources!.map((x) => x.toMap()))
            : [],
      };
}

class Source {
  Source({
    this.id,
    this.name,
    this.description,
    this.url,
    this.category,
    this.language,
    this.country,
    this.isSaved = false,
  });

  Source.empty()
      : this(
          id: '',
          name: null,
          description: '',
          url: '',
          category: '',
          language: '',
          country: '',
          isSaved: false,
        );

  factory Source.fromJson(String str) => Source.fromMap(json.decode(str));

  factory Source.fromMap(Map<String, dynamic> json) => Source(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        url: json["url"],
        category: json["category"],
        language: json["language"],
        country: json["country"],
      );

  factory Source.fromMapDB(Map<String, dynamic> json) => Source(
        id: json["sourceId"],
        name: json["name"],
        description: json["description"],
        url: json["url"],
        category: json["category"],
        language: json["language"],
        country: json["country"],
      );

  final String? category;
  final String? country;
  final String? description;
  final String? id;
  final bool isSaved;
  final String? language;
  final String? name;
  final String? url;

  Source copyWith({
    String? id,
    String? name,
    String? description,
    String? url,
    String? category,
    String? language,
    String? country,
    bool? isSaved,
  }) =>
      Source(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        url: url ?? this.url,
        category: category ?? this.category,
        language: language ?? this.language,
        country: country ?? this.country,
        isSaved: isSaved ?? this.isSaved,
      );

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "description": description,
        "url": url,
        "category": category,
        "language": language,
        "country": country,
      };

  Map<String, Object?> toMapDb() => {
        "sourceId": id ?? '',
        "name": name ?? '',
        "description": description ?? '',
        "url": url ?? '',
        "category": category ?? '',
        "language": language ?? '',
        "country": country ?? '',
      };
}
