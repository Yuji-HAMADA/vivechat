const functions = require("firebase-functions");
const fetch = require("node-fetch");
require("dotenv").config();

exports.geminiProxy = functions.https.onRequest(async (request, response) => {
  // Set CORS headers for preflight requests
  response.set("Access-Control-Allow-Origin", "*");
  response.set("Access-Control-Allow-Methods", "POST");
  response.set("Access-Control-Allow-Headers", "Content-Type");
  response.set("Access-Control-Max-Age", "3600");

  if (request.method === "OPTIONS") {
    response.status(204).send("");
    return;
  }

  if (request.method !== "POST") {
    response.status(405).send("Method Not Allowed");
    return;
  }

  const apiKey = process.env.GEMINI_KEY;

  if (!apiKey) {
    functions.logger.error("Gemini API key not set in environment variables.");
    response.status(500).send("API key not configured.");
    return;
  }

  const googleApiUrl =
    "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-image-preview:generateContent?key=" +
    apiKey;

  try {
    const googleApiResponse = await fetch(googleApiUrl, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "User-Agent": "ViveChatFirebaseProxy/1.0",
      },
      body: JSON.stringify(request.body),
    });

    const data = await googleApiResponse.json();

    if (!googleApiResponse.ok) {
      functions.logger.error("Google API Error:", data);
      response.status(googleApiResponse.status).json(data);
      return;
    }

    response.status(200).json(data);
  } catch (error) {
    functions.logger.error("Error calling Google API:", error);
    response.status(500).send("Error forwarding request to Google API.");
  }
});