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
-   **Access Control**: The app is protected by a pass key to prevent unauthorized use.

## How It Works

The application is a Flutter app that communicates with a Firebase Functions backend.

1.  **Authentication**: On first launch, the app prompts the user for a pass key. The app sends this key to a dedicated Firebase Function (`validatePassKey`) for validation.
2.  **API Proxy**: Once validated, the user can interact with the chat. All API calls to the Gemini API are proxied through a Firebase Function (`geminiProxy`). This keeps the Gemini API key secure and private.
3.  **Emotion & Text Analysis**: The first call prompts the model to return two things: the character's current emotion as a single word, and a natural, in-character chat response.
4.  **Emotional Image Generation**: The second call uses the emotion word from the first response to prompt the Gemini API to generate a new image of the character expressing that specific emotion. The new image is then displayed in the UI.

## Technology Stack

-   **Framework**: Flutter
-   **Language**: Dart
-   **AI Model**: Google Gemini API (`gemini-2.5-flash-image-preview`)
-   **Backend**: Firebase Cloud Functions (v2)
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

4.  **Set Environment Variables:**
    -   This project uses Firebase Functions environment variables to store the Gemini API key and the app's pass key.
    -   Set the variables using the following commands. Replace `your_gemini_api_key` with your actual Gemini API key, and choose a secure pass key.
        ```powershell
        # Set your Gemini API Key
        firebase functions:config:set gemini.key="your_gemini_api_key"

        # Set the pass key for the app
        firebase functions:config:set vivechat.pass_key="your_secret_pass_key"
        ```

5.  **Deploy Firebase Cloud Functions:**
    -   Navigate to the functions directory and install dependencies:
        ```bash
        cd functions
        npm install
        ```
    -   Deploy the functions:
        ```bash
        firebase deploy --only functions
        ```

6.  **Get Flutter dependencies:**
    ```bash
    flutter pub get
    ```

7.  **Run the application:**
    ```bash
    flutter run
    ```