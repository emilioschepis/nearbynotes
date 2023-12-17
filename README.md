# NearbyNotes

Explore the map around you and find notes left by other users. Mark an important moment or your favorite place with your own note.

This project was made for Supabase's [LWX Hackathon](https://supabase.com/blog/supabase-hackathon-lwx). 
It is made using SwiftUI and uses the new [supabase-swift](https://github.com/supabase-community/supabase-swift) package to connect to the remote project.

## Public TestFlight link

The app is currently being reviewed by Apple. Check back soon for a public TestFlight link!

## Demo video

https://github.com/emilioschepis/nearbynotes/assets/16031715/64451a27-18f7-445c-b818-e57fd86f71b5

## Features

- Authentication: sign in with your Apple account to create new notes and like other people's.
- Database: store all the notes in the PostgreSQL database.
  - PostGIS + rpc: used to query all notes within a certain distance from the user ([source](https://github.com/emilioschepis/nearbynotes/blob/main/supabase/migrations/20231210115703_create_find_notes_nearby_function.sql)).
