=====================================
MINIMUM REQUIREMENTS:
1) Contains at least three models with corresponding tables, including a join table
2) Accesses a SQLite3 database using ActiveRecord
3) Has a CLI that allows users to interact with your database as defined by your user stories (CRUD)
4) Uses good OO design patterns. You should have separate models for your runner and CLI interface
=====================================
IDEA: Max & Adam's Karaoke CLI App

1) User Stories
    -CREATE: Users, User Collection, User Playlists 
    -READ: Songs (Search for song lyrics), User Collection (All songs you choose to save), User playlists (Groups of songs based on your mood / the situation)
    -UPDATE (WRITE): Update collection / playlists, User information
    -DESTROY: Update collection / playlists

2) MVP: 
    - Greet user
        - Register
        - Login
        - Exit
    - Access Is Granted (Assuming Success)
    - Home Menu
        - Find A Song
            - Ask for artist & song
            - Back
                - Display the result
                    - Choose correct result
                        - See Lyrics
                            - Back
                        - Add to Collection
                        - Go To Main Menu (Back)
                    - Search Again
        - Look At Your Songs / See Your Collection
            - List The Collection As Selectable Items
                - See Lyrics
                    - Back
                - Remove From Collection
            - Back
        - Exit


3) ERD: https://lyricsovh.docs.apiary.io/#reference/0/lyrics-of-a-song/search?console=1

4) Relevant information to APIs we might use: No auth required - however query process is pretty clunky. Will be unable to show multiple results & will need artist AND song title to return a result. 

URL: https://lyricsovh.docs.apiary.io/#reference/0/lyrics-of-a-song/search?console=1
=====================================