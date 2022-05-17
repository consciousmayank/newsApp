import 'package:news_app_mayank/data_classes/new_articles.dart';
import 'package:news_app_mayank/data_classes/sources.dart' as complete_source;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const String savedNewsArticleTable = 'saved_news_article_table';
const String savedSourcesTable = 'saved_sources_table';

class DatabaseService {
  static DatabaseService? _instance;

  static Database? _db;

  static Future<DatabaseService> getInstance() async {
    _instance ??= DatabaseService();
    _db = await openDatabase(
      join(await getDatabasesPath(), 'news_database.db'),
      onCreate: (db, version) async {
        // Run the CREATE TABLE statement on the database.
        await db.execute(
          'CREATE TABLE $savedNewsArticleTable(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL , source TEXT, author TEXT, title TEXT, description TEXT, url TEXT, urlToImage TEXT, publishedAt TEXT, content TEXT, isBookmarked INTEGER)',
        );
        await db.execute(
          'CREATE TABLE $savedSourcesTable(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL , sourceId TEXT, name TEXT, description TEXT, url TEXT, category TEXT, language TEXT, country TEXT)',
        );
      },
      version: 1,
    );
    return Future.value(_instance);
  }

  Future<int?> insertArticle(Article singleArticle) async {
    return await _db?.insert(
      savedNewsArticleTable,
      singleArticle.toMapDb(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int?> insertSource(complete_source.Source singleSource) async {
    return await _db?.insert(
      savedSourcesTable,
      singleSource.toMapDb(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Article>> getSavedArticles() async {
    // Query the table for all The Articles.
    final List<Map<String, dynamic>>? maps =
        await _db?.query(savedNewsArticleTable);

    // Convert the List<Map<String, dynamic> into a List<Article>.
    return maps != null
        ? List.generate(maps.length, (i) {
            return Article.fromMapDb(maps[i]).copyWith(
              isBookmarked: true,
            );
          })
        : [];
  }

  Future<List<complete_source.Source>> getSavedSources() async {
    // Query the table for all The Articles.
    final List<Map<String, dynamic>>? maps =
        await _db?.query(savedSourcesTable);

    // Convert the List<Map<String, dynamic> into a List<Article>.
    return maps != null
        ? List.generate(maps.length, (i) {
            return complete_source.Source.fromMapDB(maps[i]).copyWith(
              isSaved: true,
            );
          })
        : [];
  }

  Future<int?> deleteSavedArticle({
    required String title,
  }) async {
    return await _db?.delete(
      savedNewsArticleTable,
      // Use a `where` clause to delete a specific dog.
      where: 'title = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [title],
    );
  }

  Future<int?> deleteSavedSources({
    required String name,
  }) async {
    return await _db?.delete(
      savedSourcesTable,
      // Use a `where` clause to delete a specific dog.
      where: 'name = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [name],
    );
  }
}
