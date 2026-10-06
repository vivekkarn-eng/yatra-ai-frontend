const express = require("express");
const cors = require("cors");
require("dotenv").config();

const { GoogleGenAI } = require("@google/genai");

const app = express();

const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json({ limit: "20mb" }));

// ============================================================
// GEMINI
// ============================================================

const ai = new GoogleGenAI({
  apiKey: process.env.GEMINI_API_KEY,
});

// ============================================================
// YATRA SUPPORTED PLACES
// ============================================================

const YATRA_PLACES = [
  // ---------------- INDORE ----------------

  {
    name: "Rajwada",
    city: "Indore",
    location: "Madhya Pradesh",
    clues:
      "Historic seven-storey Holkar palace in the old market area of Indore, with a prominent arched entrance and stone/wood architecture.",
  },
  {
    name: "Lal Bagh Palace",
    city: "Indore",
    location: "Madhya Pradesh",
    clues:
      "Grand Holkar palace in Indore with European-inspired architecture, large palace facade and extensive grounds.",
  },
  {
    name: "Krishnapura Chhatris",
    city: "Indore",
    location: "Madhya Pradesh",
    clues:
      "Group of ornate memorial cenotaphs near the Khan River in Indore, with domes, arches and detailed stone decoration.",
  },
  {
    name: "Kanch Mandir",
    city: "Indore",
    location: "Madhya Pradesh",
    clues:
      "Jain temple famous for its interior covered extensively with mirrors and glass decorations.",
  },
  {
    name: "Annapurna Temple",
    city: "Indore",
    location: "Madhya Pradesh",
    clues:
      "Colorful Hindu temple complex in Indore with an ornate entrance and multiple decorative towers.",
  },
  {
    name: "Bada Ganpati",
    city: "Indore",
    location: "Madhya Pradesh",
    clues:
      "Historic Ganesh temple in Indore known for its very large Ganesha idol.",
  },
  {
    name: "Gandhi Hall",
    city: "Indore",
    location: "Madhya Pradesh",
    clues:
      "Historic Indo-European style public building in central Indore with a prominent clock tower and domes.",
  },
  {
    name: "Central Museum",
    city: "Indore",
    location: "Madhya Pradesh",
    clues:
      "Museum building in Indore containing archaeological and historical collections.",
  },
  {
    name: "Ralamandal Wildlife Sanctuary",
    city: "Indore",
    location: "Madhya Pradesh",
    clues:
      "Forest and hill landscape near Indore, associated with wildlife and nature rather than a single monument.",
  },
  {
    name: "Pipliyapala Regional Park",
    city: "Indore",
    location: "Madhya Pradesh",
    clues:
      "Large landscaped recreational park in Indore with gardens, lake and outdoor scenery.",
  },

  // ---------------- JAIPUR ----------------

  {
    name: "Hawa Mahal",
    city: "Jaipur",
    location: "Rajasthan",
    clues:
      "Famous pink sandstone Palace of Winds in Jaipur with a distinctive honeycomb facade and many small windows.",
  },
  {
    name: "Amber Fort",
    city: "Jaipur",
    location: "Rajasthan",
    clues:
      "Large hilltop fort near Jaipur with massive walls, gates, courtyards and Rajput-Mughal architecture.",
  },
  {
    name: "City Palace Jaipur",
    city: "Jaipur",
    location: "Rajasthan",
    clues:
      "Royal palace complex in the center of Jaipur with ornate courtyards, gateways and Rajput architecture.",
  },
  {
    name: "Jantar Mantar Jaipur",
    city: "Jaipur",
    location: "Rajasthan",
    clues:
      "Historic astronomical observatory containing huge geometric stone instruments.",
  },
  {
    name: "Jal Mahal",
    city: "Jaipur",
    location: "Rajasthan",
    clues:
      "Palace appearing to float in Man Sagar Lake, with a symmetrical sandstone facade.",
  },
  {
    name: "Nahargarh Fort",
    city: "Jaipur",
    location: "Rajasthan",
    clues:
      "Hilltop fort overlooking Jaipur, with long defensive walls and pale yellow architecture.",
  },
  {
    name: "Jaigarh Fort",
    city: "Jaipur",
    location: "Rajasthan",
    clues:
      "Large hilltop fort near Amber with massive defensive walls and historic military architecture.",
  },
  {
    name: "Albert Hall Museum",
    city: "Jaipur",
    location: "Rajasthan",
    clues:
      "Grand Indo-Saracenic museum building in Jaipur with domes, arches and ornate facade.",
  },
  {
    name: "Galtaji Temple",
    city: "Jaipur",
    location: "Rajasthan",
    clues:
      "Historic Hindu temple complex in a rocky valley near Jaipur, famous for its temples and sacred water tanks.",
  },
  {
    name: "Birla Mandir Jaipur",
    city: "Jaipur",
    location: "Rajasthan",
    clues:
      "Large white marble Hindu temple in Jaipur with multiple domes and carved marble architecture.",
  },

  // ---------------- MUMBAI ----------------

  {
    name: "Gateway of India",
    city: "Mumbai",
    location: "Maharashtra",
    clues:
      "Iconic monumental arch on Mumbai waterfront overlooking the Arabian Sea. Indo-Saracenic architecture, large central arch and four turrets.",
  },
  {
    name: "Chhatrapati Shivaji Maharaj Terminus",
    city: "Mumbai",
    location: "Maharashtra",
    clues:
      "Grand historic railway terminus in Mumbai with Victorian Gothic architecture, large central dome, towers and ornate facade.",
  },
  {
    name: "Elephanta Caves",
    city: "Mumbai",
    location: "Maharashtra",
    clues:
      "Ancient rock-cut cave temples on Elephanta Island, famous for large stone sculptures including Shiva.",
  },
  {
    name: "Chhatrapati Shivaji Maharaj Vastu Sangrahalaya",
    city: "Mumbai",
    location: "Maharashtra",
    clues:
      "Historic museum in Mumbai with a large Indo-Saracenic building, dome and landscaped grounds.",
  },
  {
    name: "Siddhivinayak Temple",
    city: "Mumbai",
    location: "Maharashtra",
    clues:
      "Famous Hindu Ganesha temple in Mumbai with a distinctive temple facade and golden dome.",
  },
  {
    name: "Haji Ali Dargah",
    city: "Mumbai",
    location: "Maharashtra",
    clues:
      "White Islamic shrine located on a small island/causeway in the Arabian Sea near Mumbai.",
  },
  {
    name: "Kanheri Caves",
    city: "Mumbai",
    location: "Maharashtra",
    clues:
      "Ancient Buddhist rock-cut caves within Sanjay Gandhi National Park, with stone halls and carved structures.",
  },
  {
    name: "Bandra-Worli Sea Link",
    city: "Mumbai",
    location: "Maharashtra",
    clues:
      "Modern cable-stayed bridge across Mumbai's sea, with distinctive tall pylons and suspension cables.",
  },
  {
    name: "Sanjay Gandhi National Park",
    city: "Mumbai",
    location: "Maharashtra",
    clues:
      "Large green national park within Mumbai with forest, hills and natural landscapes.",
  },
  {
    name: "Marine Drive",
    city: "Mumbai",
    location: "Maharashtra",
    clues:
      "Curved Mumbai waterfront promenade along the Arabian Sea, famous for its coastal road and skyline.",
  },

  // ---------------- MYSURU ----------------

  {
    name: "Mysore Palace",
    city: "Mysuru",
    location: "Karnataka",
    clues:
      "Magnificent royal palace in Mysuru with Indo-Saracenic architecture, large central dome and ornate towers.",
  },
  {
    name: "Chamundi Hill",
    city: "Mysuru",
    location: "Karnataka",
    clues:
      "Prominent hill overlooking Mysuru, associated with Chamundeshwari Temple and a large Nandi statue.",
  },
  {
    name: "Chamundeshwari Temple",
    city: "Mysuru",
    location: "Karnataka",
    clues:
      "Major Hindu temple on Chamundi Hill with a tall colorful Dravidian-style gopuram.",
  },
  {
    name: "St. Philomena Cathedral",
    city: "Mysuru",
    location: "Karnataka",
    clues:
      "Large neo-Gothic Catholic cathedral in Mysuru with two very tall pointed towers.",
  },
  {
    name: "Jaganmohan Palace",
    city: "Mysuru",
    location: "Karnataka",
    clues:
      "Historic royal palace in Mysuru with ornate facade and Indo-European architectural features.",
  },
  {
    name: "Karanji Lake",
    city: "Mysuru",
    location: "Karnataka",
    clues:
      "Scenic lake and nature area near Mysuru with water, trees and walking areas.",
  },
  {
    name: "Railway Museum Mysuru",
    city: "Mysuru",
    location: "Karnataka",
    clues:
      "Railway heritage museum displaying historic locomotives, coaches and railway equipment.",
  },
  {
    name: "Devaraja Market",
    city: "Mysuru",
    location: "Karnataka",
    clues:
      "Historic colorful market in Mysuru with shops, flower stalls and traditional market architecture.",
  },
  {
    name: "Lalitha Mahal Palace",
    city: "Mysuru",
    location: "Karnataka",
    clues:
      "Elegant white palace near Mysuru inspired by European architecture, with a prominent central dome.",
  },
  {
    name: "Mysuru Zoo",
    city: "Mysuru",
    location: "Karnataka",
    clues:
      "Large zoological garden in Mysuru with landscaped paths, trees and animal enclosures.",
  },

  // ---------------- BHOPAL ----------------

  {
    name: "Taj-ul-Masajid",
    city: "Bhopal",
    location: "Madhya Pradesh",
    clues:
      "Huge pink mosque in Bhopal with two tall minarets, large domes and a broad courtyard.",
  },
  {
    name: "Upper Lake",
    city: "Bhopal",
    location: "Madhya Pradesh",
    clues:
      "Large lake in Bhopal with broad water views, shoreline and surrounding city landscape.",
  },
  {
    name: "Van Vihar National Park",
    city: "Bhopal",
    location: "Madhya Pradesh",
    clues:
      "Urban national park near Upper Lake in Bhopal with forest and wildlife landscapes.",
  },
  {
    name: "Bharat Bhavan",
    city: "Bhopal",
    location: "Madhya Pradesh",
    clues:
      "Multidisciplinary arts center in Bhopal with distinctive modern architecture and lake views.",
  },
  {
    name: "Tribal Museum Bhopal",
    city: "Bhopal",
    location: "Madhya Pradesh",
    clues:
      "Museum showcasing tribal culture, art, architecture and traditional displays in Bhopal.",
  },
  {
    name: "Gohar Mahal",
    city: "Bhopal",
    location: "Madhya Pradesh",
    clues:
      "Historic palace on the Upper Lake in Bhopal with traditional Mughal and Rajput architectural details.",
  },
  {
    name: "Moti Masjid Bhopal",
    city: "Bhopal",
    location: "Madhya Pradesh",
    clues:
      "Historic mosque in Bhopal with white facade, domes and Islamic architectural elements.",
  },
  {
    name: "Sadar Manzil",
    city: "Bhopal",
    location: "Madhya Pradesh",
    clues:
      "Historic royal building in the old city of Bhopal associated with the Nawabs.",
  },
  {
    name: "Birla Mandir Bhopal",
    city: "Bhopal",
    location: "Madhya Pradesh",
    clues:
      "Hindu temple on a hill in Bhopal with pale sandstone architecture and views of the city.",
  },
  {
    name: "Regional Science Centre Bhopal",
    city: "Bhopal",
    location: "Madhya Pradesh",
    clues:
      "Science museum and educational center in Bhopal with exhibits and modern buildings.",
  },

  // ---------------- OTHER YATRA PLACES ----------------

  {
    name: "Khajuraho Temples",
    city: "Khajuraho",
    location: "Madhya Pradesh",
    clues:
      "Famous group of ancient sandstone Hindu and Jain temples with extremely detailed exterior carvings and tall temple towers.",
  },
  {
    name: "Taj Mahal",
    city: "Agra",
    location: "Uttar Pradesh",
    clues:
      "World-famous white marble mausoleum in Agra with a huge central onion dome, four minarets and a symmetrical garden setting.",
  },
  {
    name: "Red Fort",
    city: "Delhi",
    location: "Delhi",
    clues:
      "Massive red sandstone Mughal fort in Old Delhi with enormous red walls, monumental gates and historic palace structures.",
  },
  {
    name: "Charminar",
    city: "Hyderabad",
    location: "Telangana",
    clues:
      "Iconic Hyderabad monument with four tall minarets, four large arches and a square symmetrical structure.",
  },
  {
    name: "Sanchi Stupa",
    city: "Sanchi",
    location: "Madhya Pradesh",
    clues:
      "Ancient Buddhist hemispherical stone stupa at Sanchi with carved gateways surrounding the monument.",
  },
];

// ============================================================
// HELPERS
// ============================================================

function normalizeText(value) {
  return String(value || "")
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, " ")
    .replace(/\s+/g, " ")
    .trim();
}

function clamp(value, min, max) {
  return Math.min(Math.max(value, min), max);
}

function findYatraPlace(name, city) {
  const normalizedName = normalizeText(name);
  const normalizedCity = normalizeText(city);

  if (!normalizedName) {
    return null;
  }

  // Exact name + city
  let match = YATRA_PLACES.find(
    (place) =>
      normalizeText(place.name) === normalizedName &&
      normalizeText(place.city) === normalizedCity
  );

  if (match) return match;

  // Exact name only
  match = YATRA_PLACES.find(
    (place) =>
      normalizeText(place.name) === normalizedName
  );

  if (match) return match;

  // Name contained in model answer
  match = YATRA_PLACES.find((place) => {
    const candidate = normalizeText(place.name);

    return (
      normalizedName.includes(candidate) ||
      candidate.includes(normalizedName)
    );
  });

  return match || null;
}

function extractJson(text) {
  if (!text) {
    throw new Error("Gemini returned an empty response.");
  }

  let cleaned = text.trim();

  cleaned = cleaned
    .replace(/^```json\s*/i, "")
    .replace(/^```\s*/i, "")
    .replace(/\s*```$/i, "")
    .trim();

  try {
    return JSON.parse(cleaned);
  } catch (_) {
    const start = cleaned.indexOf("{");
    const end = cleaned.lastIndexOf("}");

    if (start !== -1 && end !== -1 && end > start) {
      return JSON.parse(
        cleaned.substring(start, end + 1)
      );
    }

    throw new Error(
      "Could not parse Gemini JSON response."
    );
  }
}

// ============================================================
// HEALTH CHECK
// ============================================================

app.get("/", (req, res) => {
  res.json({
    status: "ok",
    service: "YATRA AI Backend",
    recognitionPlaces: YATRA_PLACES.length,
    endpoints: [
      "POST /recognize-place",
      "POST /generate-story",
    ],
  });
});

// ============================================================
// GENERATE STORY
// ============================================================

app.post("/generate-story", async (req, res) => {
  try {
    const {
      name,
      city,
      state,
      location,
    } = req.body;

    if (!name) {
      return res.status(400).json({
        error: "Place name is required.",
      });
    }

    if (!process.env.GEMINI_API_KEY) {
      return res.status(500).json({
        error: "GEMINI_API_KEY is not configured.",
      });
    }

    const placeCity = city || location || "";
    const placeState = state || "";

    const prompt = `
You are YATRA AI, an expert Indian heritage historian and tourism storyteller.

Create an accurate, engaging and visitor-friendly story for:

Place: ${name}
City: ${placeCity}
State: ${placeState}

Return EXACTLY these six sections:

THE STORY
HISTORY
ARCHITECTURE
WHAT MAKES IT SPECIAL
DID YOU KNOW?
VISITOR CONTEXT

Rules:
- Focus specifically on the requested place.
- Do not invent facts.
- Keep historical details accurate.
- Make the writing engaging but suitable for a tourism application.
- Mention important historical figures or events only when relevant.
- Architecture should describe visible and historically important features.
- DID YOU KNOW? should contain interesting but reliable facts.
- VISITOR CONTEXT should help a tourist understand why the place matters.
- Do not include markdown tables.
`;

    const response =
      await ai.models.generateContent({
        model: "gemini-2.5-flash-lite",
        contents: prompt,
      });

    const text =
      response.text || "";

    if (!text.trim()) {
      throw new Error(
        "Gemini returned an empty story."
      );
    }

    return res.json({
      success: true,
      name,
      city: placeCity,
      state: placeState,
      story: text.trim(),
    });
  } catch (error) {
    console.error(
      "STORY GENERATION ERROR:",
      error
    );

    return res.status(500).json({
      success: false,
      error:
        error?.message ||
        "Failed to generate story.",
    });
  }
});

// ============================================================
// RECOGNIZE PLACE
// ============================================================

app.post("/recognize-place", async (req, res) => {
  try {
    const {
      imageBase64,
      mimeType,
    } = req.body;

    console.log("");
    console.log(
      "========================================"
    );
    console.log(
      "YATRA AI IMAGE RECOGNITION REQUEST"
    );
    console.log(
      "========================================"
    );

    if (!imageBase64) {
      return res.status(400).json({
        success: false,
        error: "imageBase64 is required.",
      });
    }

    if (!process.env.GEMINI_API_KEY) {
      return res.status(500).json({
        success: false,
        error: "GEMINI_API_KEY is not configured.",
      });
    }

    const safeMimeType =
      typeof mimeType === "string" &&
      mimeType.startsWith("image/")
        ? mimeType
        : "image/jpeg";

    console.log(
      "Image MIME type:",
      safeMimeType
    );

    console.log(
      "Image base64 length:",
      imageBase64.length
    );

    const candidateList =
      YATRA_PLACES.map(
        (place, index) =>
          `${index + 1}. ${place.name} — ${place.city}, ${place.location}\n` +
          `Visual clues: ${place.clues}`
      ).join("\n\n");

    // --------------------------------------------------------
    // STRONGER VISUAL RECOGNITION PROMPT
    // --------------------------------------------------------

    const prompt = `
You are the visual recognition engine for YATRA, an Indian heritage tourism application.

Analyze the supplied monument photograph carefully.

Your job is to identify which ONE of the supported YATRA places is shown in the image.

IMPORTANT:
- Actually inspect the IMAGE.
- Do not answer based only on the text list.
- Compare the architecture, silhouette, facade, domes, arches, towers, minarets, color, surroundings and other visible landmarks.
- Prefer the visually strongest match.
- The image may be a tourist photograph taken from an unusual angle.
- Ignore weather, lighting, image quality and minor obstructions.
- Do not confuse a generic temple, palace or monument with another place just because the architectural style is similar.
- If the monument is clearly recognizable as one of the candidates, select that candidate.
- If the image is genuinely unrelated to all candidates, return UNKNOWN.

SUPPORTED YATRA PLACES:

${candidateList}

RETURN ONLY JSON:

{
  "name": "exact supported place name",
  "city": "exact supported city",
  "confidence": 0.0,
  "visual_reason": "short explanation of the visual evidence"
}

For UNKNOWN:

{
  "name": "Unknown place",
  "city": "",
  "confidence": 0.0,
  "visual_reason": "why none of the supported places can be identified"
}

VERY IMPORTANT:
The "name" MUST be copied exactly from the supported list when a match exists.
Do not invent a new monument name.
Do not return a generic category such as "Indian temple".
`;

    // --------------------------------------------------------
    // GEMINI VISION CALL
    // --------------------------------------------------------

    const response =
      await ai.models.generateContent({
        model: "gemini-2.5-flash",

        contents: [
          {
            inlineData: {
              mimeType: safeMimeType,
              data: imageBase64,
            },
          },
          {
            text: prompt,
          },
        ],

        config: {
          responseMimeType:
            "application/json",

          responseSchema: {
            type: "object",

            properties: {
              name: {
                type: "string",
              },

              city: {
                type: "string",
              },

              confidence: {
                type: "number",
              },

              visual_reason: {
                type: "string",
              },
            },

            required: [
              "name",
              "city",
              "confidence",
              "visual_reason",
            ],
          },
        },
      });

    const rawText =
      response.text || "";

    console.log("");
    console.log(
      "RAW GEMINI RECOGNITION:"
    );
    console.log(rawText);

    if (!rawText.trim()) {
      throw new Error(
        "Gemini returned an empty recognition response."
      );
    }

    // --------------------------------------------------------
    // PARSE RESULT
    // --------------------------------------------------------

    let result;

    try {
      result = extractJson(rawText);
    } catch (parseError) {
      console.error(
        "JSON PARSE ERROR:",
        parseError
      );

      return res.status(500).json({
        success: false,
        error:
          "AI returned an invalid recognition result.",
        raw: rawText,
      });
    }

    const detectedName =
      String(result.name || "").trim();

    const detectedCity =
      String(result.city || "").trim();

    const visualReason =
      String(
        result.visual_reason || ""
      ).trim();

    let confidence =
      Number(result.confidence);

    if (!Number.isFinite(confidence)) {
      confidence = 0;
    }

    confidence = clamp(
      confidence,
      0,
      1
    );

    console.log("");
    console.log(
      "GEMINI DETECTED:",
      detectedName
    );

    console.log(
      "GEMINI CITY:",
      detectedCity
    );

    console.log(
      "GEMINI CONFIDENCE:",
      confidence
    );

    console.log(
      "VISUAL REASON:",
      visualReason
    );

    // --------------------------------------------------------
    // MATCH AGAINST YATRA DATABASE
    // --------------------------------------------------------

    const matchedPlace =
      findYatraPlace(
        detectedName,
        detectedCity
      );

    // --------------------------------------------------------
    // UNKNOWN
    // --------------------------------------------------------

    if (!matchedPlace) {
      console.log(
        "RESULT: UNKNOWN PLACE"
      );

      console.log(
        "========================================"
      );

      return res.json({
        success: true,
        name: "Unknown place",
        city: "",
        state: "",
        confidence: 0,
        visualReason:
          visualReason ||
          "The image could not be confidently matched to a supported YATRA place.",
      });
    }

    // --------------------------------------------------------
    // SUCCESS
    // --------------------------------------------------------

    // Make the confidence slightly conservative.
    // We do NOT blindly show 98/99% for every result.
    const finalConfidence =
      clamp(
        confidence,
        0,
        1
      );

    console.log(
      "MATCHED YATRA PLACE:",
      matchedPlace.name
    );

    console.log(
      "MATCHED CITY:",
      matchedPlace.city
    );

    console.log(
      "FINAL CONFIDENCE:",
      finalConfidence
    );

    console.log(
      "========================================"
    );

    return res.json({
      success: true,

      name: matchedPlace.name,

      city: matchedPlace.city,

      state: matchedPlace.location,

      confidence:
        Number(
          finalConfidence.toFixed(2)
        ),

      visualReason:
        visualReason ||
        `Visual features matched ${matchedPlace.name}.`,
    });
  } catch (error) {
    console.error("");
    console.error(
      "========================================"
    );
    console.error(
      "YATRA AI RECOGNITION ERROR"
    );
    console.error(error);
    console.error(
      "========================================"
    );

    return res.status(500).json({
      success: false,
      error:
        error?.message ||
        "Failed to recognize place.",
    });
  }
});

// ============================================================
// START SERVER
// ============================================================

app.listen(PORT, () => {
  console.log("");
  console.log(
    "========================================"
  );
  console.log(
    "YATRA AI BACKEND IS RUNNING"
  );
  console.log(
    "========================================"
  );
  console.log(
    `Port: ${PORT}`
  );
  console.log(
    `Recognition places: ${YATRA_PLACES.length}`
  );
  console.log(
    "Recognition model: gemini-2.5-flash"
  );
  console.log(
    "Story model: gemini-2.5-flash-lite"
  );
  console.log(
    "========================================"
  );
});