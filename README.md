# gemini-music-journal-ios

An iOS app where users can find and create reviews for music, see their review history on a map, and get AI-generated song recommendations. 

## Features
* **Find Music:** Pick from trending music, search for specific songs, or browse by your favorite genre using the iTunes API.
* **Write Reviews:** Give a song a rating out of 5 and leave an optional comment. 
* **Map View:** The app saves your current location when you submit a review so you can see exactly where you were on a map.
* **AI Recommendations:** Get new song recommendations based on your previous reviews using the Gemini AI model.
* **Persistent Data:** All profile and review data is permanently stored on your device using SwiftData.

## Technologies Used
* SwiftUI
* MVVM Architecture
* SwiftData
* MapKit
* Gemini API & iTunes Search API

## Setup
To run this app locally, you need to provide your own Google AI Studios API key:
1. Create a `Secrets.plist` file in the main project folder.
2. Add a `String` row with the key `GEMINI_API_KEY` and paste your API key as the value.
*(Note: This file is ignored by Git so your key stays safe).*
