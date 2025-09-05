const {onRequest} = require("firebase-functions/v2/https");
const {log} = require("firebase-functions/logger");
const {defineString} = require('firebase-functions/params');
const fetch = require("node-fetch");

const VIVECHAT_PASS_KEY = defineString('VIVECHAT_PASS_KEY');
const GEMINI_KEY = defineString('GEMINI_KEY');

exports.validatePassKey = onRequest(async (request, response) => {
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

  try {
    const { pass_key } = request.body;
    const vivechatPassKey = VIVECHAT_PASS_KEY.value();

    log(`Received pass_key: "${pass_key}"`);
    log(`Expected pass_key: "${vivechatPassKey}"`);

    if (pass_key === vivechatPassKey) {
      response.status(200).send({ "status": "ok" });
    } else {
      response.status(401).send("Unauthorized");
    }
  } catch (error) {
    log("Error in validatePassKey:", error);
    response.status(500).send("Internal Server Error");
  }
});

exports.geminiProxy = onRequest(async (request, response) => {
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

  try {
    const apiKey = GEMINI_KEY.value();

    if (!apiKey) {
      log("Gemini API key not set in environment variables.");
      response.status(500).send("API key not configured.");
      return;
    }

    const googleApiUrl =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-image-preview:generateContent?key=" +
      apiKey;

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
      log("Google API Error:", data);
      response.status(googleApiResponse.status).json(data);
      return;
    }

    response.status(200).json(data);
  } catch (error) {
    log("Error calling Google API:", error);
    response.status(500).send("Error forwarding request to Google API.");
  }
});