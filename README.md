# Vivechat: The Living Character Chat

**[➡️ Live Web App ⬅️](https://yuji-hamada.github.io/vivechat/)**

<!-- This is a Flutter application that brings a static image to life. -->
Vivechat is a Flutter application that brings a static image to life using the power of the Google Gemini API. Select an image of any character, and have a dynamic, context-aware conversation. The character's image changes in real-time to reflect its emotional state based on your chat, creating a truly interactive experience.

## Features

-   **Dynamic Character Creation**: Start a conversation with any character by simply selecting an image from your device.
-   **AI-Powered Conversation**: Engage in natural, context-aware conversations. The AI remembers the recent chat history to provide relevant and engaging responses.
-   **Real-Time Emotion Generation**: The app analyzes the conversation to determine the character's emotion (e.g., Happy, Sad, Angry) in real-time.
-   **On-the-Fly Image Synthesis**: Based on the detected emotion, the app generates a new image of the character expressing that feeling, updating its avatar on the fly.
-   **Emotion Caching**: To improve performance and reduce API costs, generated emotional images are cached. If an emotion reoccurs, the cached image is displayed instantly.
-   **Emotion Gallery**: View all the emotional variations of your character that have been generated during your conversation in a tiled gallery.
-   **Persistent Chat History**: Your conversation and generated images are saved locally, so you can pick up where you left off.

## How It Works

When a user sends a message, the app initiates a two-phase process:

1.  **Emotion & Text Analysis**: The conversation history and the base character image are sent to the Gemini API. The model is prompted to return two things: the character's current emotion as a single word, and a natural, in-character chat response.
2.  **Emotional Image Generation**: The app immediately uses the emotion word from the first response to make a second API call. This call prompts the Gemini API to generate a new image of the character expressing that specific emotion. The new image is then displayed in the UI.

## Technology Stack

-   **Framework**: Flutter
-   **Language**: Dart
-   **AI Model**: Google Gemini API (`gemini-2.5-flash-image-preview`)

## Setup and Installation

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/your-username/vivechat.git
    cd vivechat
    ```

2.  **Get Flutter dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Add your API Key:**
    -   Create a new file named `lib/secrets.dart`.
    -   Add the following code to the file:
        ```dart
        // lib/secrets.dart
        const String geminiApiKey = 'YOUR_GEMINI_API_KEY';
        ```
    -   Paste your actual Gemini API key in place of `YOUR_GEMINI_API_KEY`.
    -   **Note**: The `secrets.dart` file is included in `.gitignore` to keep your key private.

4.  **Enable the API in Google Cloud:**
    -   Go to your Google Cloud Console.
    -   Ensure you have the **Generative Language API** enabled for your project.

5.  **Run the application:**
    ```bash
    flutter run
    ```