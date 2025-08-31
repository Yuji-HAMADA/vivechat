# Vivechat: The Living Character Chat

**[➡️ Live Web App ⬅️](https://yuji-hamada.github.io/vivechat/)**

Vivechat is a Flutter application that brings a static image to life using the power of the Google Gemini API. Select an image of any character, and have a dynamic, context-aware conversation. The character's image changes in real-time to reflect its emotional state based on your chat, creating a truly interactive experience.

## Features

-   **Dynamic Character Creation**: Start a conversation with any character by simply selecting an image from your device.
-   **AI-Powered Conversation**: Engage in natural, context-aware conversations. The AI remembers the recent chat history to provide relevant and engaging responses.
-   **Real-Time Emotion Generation**: The app analyzes the conversation to determine the character's emotion (e.g., Happy, Sad, Angry) in real-time.
-   **On-the-Fly Image Synthesis**: Based on the detected emotion, the app generates a new image of the character expressing that feeling, updating its avatar on the fly.
-   **Emotion Caching**: To improve performance and reduce API costs, generated emotional images are cached. If an emotion reoccurs, the cached image is displayed instantly.
-   **Emotion Gallery**: View all the emotional variations of your character that have been generated during your conversation in a tiled gallery.
-   **Download Images**: Download your favorite emotional images from the gallery to your device.
-   **Persistent Chat History**: Your conversation and generated images are saved locally, so you can pick up where you left off.

## How It Works

When a user sends a message, the app sends the conversation history and the base character image to a Firebase Cloud Function, which acts as a proxy to the Gemini API. This approach helps to keep the API key secure. The cloud function then makes two calls to the Gemini API:

1.  **Emotion & Text Analysis**: The first call prompts the model to return two things: the character's current emotion as a single word, and a natural, in-character chat response.
2.  **Emotional Image Generation**: The second call uses the emotion word from the first response to prompt the Gemini API to generate a new image of the character expressing that specific emotion. The new image is then displayed in the UI.

## Technology Stack

-   **Framework**: Flutter
-   **Language**: Dart
-   **AI Model**: Google Gemini API (`gemini-2.5-flash-image-preview`)
-   **Backend**: Firebase Cloud Functions
-   **Hosting**: Firebase Hosting

## Setup and Installation

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/your-username/vivechat.git
    cd vivechat
    ```

2.  **Set up Firebase:**
    -   Create a new Firebase project in the [Firebase Console](https://console.firebase.google.com/).
    -   Add a new web app to your Firebase project.
    -   Copy the Firebase configuration object and paste it into `web/index.html`.
    -   Enable the **Generative Language API** in the Google Cloud Console for your Firebase project.

3.  **Set up Firebase CLI:**
    -   Install the Firebase CLI.
    -   Log in to Firebase using `firebase login`.
    -   Configure your project with `firebase use --add` and select your Firebase project.

4.  **Get Flutter dependencies:**
    ```bash
    flutter pub get
    ```

5.  **Add your API Key:**
    -   Create a new file named `lib/secrets.dart`.
    -   Add the following code to the file:
        ```dart
        // lib/secrets.dart
        const String geminiApiKey = 'YOUR_GEMINI_API_KEY';
        ```
    -   Paste your actual Gemini API key in place of `YOUR_GEMINI_API_KEY`.
    -   **Note**: The `secrets.dart` file is included in `.gitignore` to keep your key private.

6.  **Deploy Firebase Cloud Functions:**
    ```bash
    cd functions
    npm install
    firebase deploy --only functions
    ```

7.  **Run the application:**
    ```bash
    flutter run
    ```
