# News App

A flutter application which uses NewsApi to show News snippets. This application has 3 main screens.
## TOP HEADLINES
    This screen loads data from https://newsapi.org/v2/top-headlines and shows news to the user. The query parameters used are.

    1. pageSize.
    2. page. 
    (These help in pagination of the list)
    3. category
    4. sources
    5. country
    6. q

## ALL NEWS
    This screen loads data from https://newsapi.org/v2/everything and shows news to the user. The query parameters used are.

    1. pageSize.
    2. page. 
    (These help in pagination of the list)
    3. sortBy
    4. sources
    5. country
    6. searchIn
    7. q 

User can click an icon in individual list that can help him to bookmark and save the news article in the sqflite database.

## MY FEED
    This screen loads the bookmarked news articles. 


## OTHER FEATURES
1. User can search in 'Top Headlines' and 'All News' screen. 
2. User can also apply filters like, 'Sources', 'Sort By', 'Search in', etc as per which page he in.
3. User can save whole news articles. And visit them in My Feed.
4. User can save sources and load news articles from one or more of the same saved sources in filters.
5. Api key is not being stored in the project. Its being prived at run time using 'dart-define' arguments.
6. User can select dark/light theme, from top right of screen.
7. User can select the theme color among 3 colors.
8. If internet connection is lost, then user will be presented another screen, showing the message. Once internet is turned on,
    the project is resumed. As of now the project restarts from start. 
9. On clicking a news article, the link is open in in-app web browser, which works only in android and ios devices as of now.
10. Stacked architechture has been used for statemanagement, dependency injection, dialog services, navigation, routing.     

## SOURCES BOTTOMSHEET
    This screen is used to choose a single or group of sources whose news articles user wants to load and read. User has an option to choose from list of sources present online or from the list of sources saved by him in the database.

## Running the App

Use the following command to run the app in:-

flutter run --dart-define BASE_URL=https://newsapi.org/v2 --dart-define SHOW_LOGS=true --dart-define API_KEY=<API_KEY_FROM_newsapi.org>

