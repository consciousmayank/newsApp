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

## SOURCES BOTTOMSHEET
    This screen is used to choose a single or group of sources whose news articles user wants to load and read. User has an option to choose from list of sources present online or from the list of sources saved by him in the database.

## Running the App

Use the following command to run the app in:-

flutter run --dart-define BASE_URL=https://newsapi.org/v2 --dart-define SHOW_LOGS=true --dart-define API_KEY=<API_KEY_FROM_newsapi.org>

