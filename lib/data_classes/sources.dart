// To parse this JSON data, do
//
//     final sources = sourcesFromMap(jsonString);

import 'dart:convert';

class Sources {
  Sources({
    this.status,
    this.sources,
  });

  final String? status;
  final List<Source>? sources;

  Sources copyWith({
    String? status,
    List<Source>? sources,
  }) =>
      Sources(
        status: status ?? this.status,
        sources: sources ?? this.sources,
      );

  factory Sources.fromJson(String str) => Sources.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Sources.fromMap(Map<String, dynamic> json) => Sources(
        status: json["status"],
        sources: json["sources"] != null
            ? List<Source>.from(json["sources"].map((x) => Source.fromMap(x)))
            : [],
      );

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
  });

  final String? id;
  final String? name;
  final String? description;
  final String? url;
  final String? category;
  final String? language;
  final String? country;

  Source copyWith({
    String? id,
    String? name,
    String? description,
    String? url,
    String? category,
    String? language,
    String? country,
  }) =>
      Source(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        url: url ?? this.url,
        category: category ?? this.category,
        language: language ?? this.language,
        country: country ?? this.country,
      );

  factory Source.fromJson(String str) => Source.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Source.fromMap(Map<String, dynamic> json) => Source(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        url: json["url"],
        category: json["category"],
        language: json["language"],
        country: json["country"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "description": description,
        "url": url,
        "category": category,
        "language": language,
        "country": country,
      };
}
