import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/place_data.dart';
import 'place_story_screen.dart';

class _PlaceInfo {
  final String overview;
  final String bestTime;
  final String attracts;
  final String transport;
  final String duration;

  const _PlaceInfo({
    required this.overview,
    required this.bestTime,
    required this.attracts,
    required this.transport,
    required this.duration,
  });
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapLibreMapController? _mapController;

  static const LatLng _fallbackLocation = LatLng(
    22.7196,
    75.8577,
  );

  LatLng _currentLocation = _fallbackLocation;

  bool _locationLoading = true;
  bool _locationReady = false;
  String? _locationError;

  String? _selectedPlace;
  String? _selectedCity;

  static const String _mapStyle =
      'https://tiles.openfreemap.org/styles/liberty';

  // ============================================================
  // YATRA HERITAGE LOCATIONS
  // ============================================================

  static const Map<String, LatLng> _heritageLocations = {
    // -------------------------
    // INDORE
    // -------------------------

    'Rajwada': LatLng(22.7179, 75.8549),
    'Lal Bagh Palace': LatLng(22.7020, 75.8467),
    'Krishnapura Chhatris': LatLng(22.7168, 75.8524),
    'Kanch Mandir': LatLng(22.7137, 75.8540),
    'Annapurna Temple': LatLng(22.6752, 75.8368),
    'Bada Ganpati': LatLng(22.7185, 75.8475),
    'Gandhi Hall': LatLng(22.7197, 75.8577),
    'Central Museum': LatLng(22.7157, 75.8792),
    'Ralamandal Wildlife Sanctuary': LatLng(22.6505, 75.9137),
    'Pipliyapala Regional Park': LatLng(22.6745, 75.8640),

    // -------------------------
    // JAIPUR
    // -------------------------

    'Hawa Mahal': LatLng(26.9239, 75.8269),
    'Amber Fort': LatLng(26.9855, 75.8500),
    'City Palace Jaipur': LatLng(26.9258, 75.8237),
    'Jantar Mantar Jaipur': LatLng(26.9247, 75.8246),
    'Jal Mahal': LatLng(26.9539, 75.8468),
    'Nahargarh Fort': LatLng(26.9402, 75.8170),
    'Jaigarh Fort': LatLng(26.9855, 75.8417),
    'Albert Hall Museum': LatLng(26.9116, 75.8190),
    'Galtaji Temple': LatLng(26.9174, 75.8574),
    'Birla Mandir Jaipur': LatLng(26.8925, 75.8157),

    // -------------------------
    // MUMBAI
    // -------------------------

    'Gateway of India': LatLng(18.9220, 72.8347),
    'Chhatrapati Shivaji Maharaj Terminus':
        LatLng(18.9402, 72.8356),
    'Elephanta Caves': LatLng(18.9668, 72.9315),
    'Chhatrapati Shivaji Maharaj Vastu Sangrahalaya':
        LatLng(18.9269, 72.8315),
    'Siddhivinayak Temple': LatLng(19.0169, 72.8306),
    'Haji Ali Dargah': LatLng(18.9827, 72.8089),
    'Kanheri Caves': LatLng(19.2041, 72.8982),
    'Bandra-Worli Sea Link': LatLng(19.0368, 72.8168),
    'Sanjay Gandhi National Park': LatLng(19.2147, 72.9106),
    'Marine Drive': LatLng(18.9431, 72.8238),

    // -------------------------
    // MYSURU
    // -------------------------

    'Mysore Palace': LatLng(12.3052, 76.6552),
    'Chamundi Hill': LatLng(12.2750, 76.6700),
    'Chamundeshwari Temple': LatLng(12.2750, 76.6700),
    'St. Philomena Cathedral': LatLng(12.3230, 76.6550),
    'Jaganmohan Palace': LatLng(12.3034, 76.6505),
    'Karanji Lake': LatLng(12.2950, 76.6640),
    'Railway Museum Mysuru': LatLng(12.3192, 76.6388),
    'Devaraja Market': LatLng(12.3111, 76.6520),
    'Lalitha Mahal Palace': LatLng(12.2711, 76.6990),
    'Mysuru Zoo': LatLng(12.3020, 76.6650),

    // -------------------------
    // BHOPAL
    // -------------------------

    'Taj-ul-Masajid': LatLng(23.2599, 77.3447),
    'Upper Lake': LatLng(23.2389, 77.3350),
    'Van Vihar National Park': LatLng(23.2245, 77.3480),
    'Bharat Bhavan': LatLng(23.2385, 77.3340),
    'Tribal Museum Bhopal': LatLng(23.2155, 77.4300),
    'Gohar Mahal': LatLng(23.2595, 77.3440),
    'Moti Masjid Bhopal': LatLng(23.2590, 77.3378),
    'Sadar Manzil': LatLng(23.2590, 77.3395),
    'Birla Mandir Bhopal': LatLng(23.2150, 77.4360),
    'Regional Science Centre Bhopal': LatLng(23.2115, 77.4235),

    // -------------------------
    // OTHER HERITAGE PLACES
    // -------------------------

    'Khajuraho Temples': LatLng(24.8318, 79.9199),
    'Taj Mahal': LatLng(27.1751, 78.0421),
    'Red Fort': LatLng(28.6562, 77.2410),
    'Charminar': LatLng(17.3616, 78.4747),
    'Sanchi Stupa': LatLng(23.4793, 77.7397),
  };

  // ============================================================
  // QUICK TRAVEL INFO
  // ============================================================

  static const Map<String, _PlaceInfo> _placeInfo = {
    'Rajwada': const _PlaceInfo(
      overview: 'Historic Holkar-era palace at the heart of old Indore.',
      bestTime: 'October–March',
      attracts: 'Historic architecture, Holkar heritage and evening atmosphere.',
      transport: 'Auto-rickshaw • City bus • Cab • Indore Junction nearby',
      duration: '45–90 min',
    ),
    'Lal Bagh Palace': const _PlaceInfo(
      overview: 'Grand Holkar palace known for European-influenced interiors and gardens.',
      bestTime: 'October–March',
      attracts: 'Palace architecture, royal interiors and gardens.',
      transport: 'Auto-rickshaw • City bus • Cab',
      duration: '1–2 hrs',
    ),
    'Krishnapura Chhatris': const _PlaceInfo(
      overview: 'Ornate memorial cenotaphs of the Holkar rulers beside the Khan River.',
      bestTime: 'October–March',
      attracts: 'Intricate stonework, night lighting and Holkar history.',
      transport: 'Auto-rickshaw • City bus • Cab',
      duration: '30–60 min',
    ),
    'Kanch Mandir': const _PlaceInfo(
      overview: 'Jain temple famous for its striking interior covered with glass and mirrors.',
      bestTime: 'October–March',
      attracts: 'Glass artwork, Jain architecture and detailed interiors.',
      transport: 'Auto-rickshaw • City bus • Cab',
      duration: '30–60 min',
    ),
    'Annapurna Temple': const _PlaceInfo(
      overview: 'A prominent temple complex known for its colourful architecture and devotional atmosphere.',
      bestTime: 'October–March',
      attracts: 'Temple architecture, sculptures and religious significance.',
      transport: 'Auto-rickshaw • City bus • Cab',
      duration: '30–60 min',
    ),
    'Bada Ganpati': const _PlaceInfo(
      overview: 'Historic Indore temple renowned for its very large Ganesha idol.',
      bestTime: 'October–March',
      attracts: 'Large idol, devotional experience and local heritage.',
      transport: 'Auto-rickshaw • City bus • Cab',
      duration: '20–45 min',
    ),
    'Gandhi Hall': const _PlaceInfo(
      overview: 'Iconic Indore landmark built in an Indo-Gothic style and used for public events.',
      bestTime: 'October–March',
      attracts: 'Architecture, clock tower and central-city setting.',
      transport: 'Auto-rickshaw • City bus • Cab',
      duration: '30–60 min',
    ),
    'Central Museum': const _PlaceInfo(
      overview: 'Indore museum with archaeological, historical and artistic collections.',
      bestTime: 'October–March',
      attracts: 'Sculptures, coins, artefacts and regional history.',
      transport: 'Auto-rickshaw • City bus • Cab',
      duration: '1–2 hrs',
    ),
    'Ralamandal Wildlife Sanctuary': const _PlaceInfo(
      overview: 'Historic hill landscape and nature area on the outskirts of Indore.',
      bestTime: 'October–February',
      attracts: 'Nature, viewpoints, wildlife and outdoor experience.',
      transport: 'Cab • Auto-rickshaw • Local road transport',
      duration: '2–3 hrs',
    ),
    'Pipliyapala Regional Park': const _PlaceInfo(
      overview: 'Large urban park around a lake with landscaped recreation areas.',
      bestTime: 'October–February',
      attracts: 'Lake views, gardens, boating and relaxed evenings.',
      transport: 'Auto-rickshaw • City bus • Cab',
      duration: '1–2 hrs',
    ),
    'Hawa Mahal': const _PlaceInfo(
      overview: 'Famous Jaipur palace facade built with hundreds of small windows.',
      bestTime: 'October–March',
      attracts: 'Iconic facade, photography and Rajput-era architecture.',
      transport: 'Auto-rickshaw • City bus • Cab • Jaipur Metro nearby',
      duration: '45–90 min',
    ),
    'Amber Fort': const _PlaceInfo(
      overview: 'Hilltop fort-palace complex showcasing Rajput and Mughal architectural influences.',
      bestTime: 'October–March',
      attracts: 'Fort architecture, courtyards, views and royal history.',
      transport: 'Auto-rickshaw • Bus • Cab',
      duration: '2–3 hrs',
    ),
    'City Palace Jaipur': const _PlaceInfo(
      overview: 'Royal complex in Jaipur\'s historic walled city with museums and courtyards.',
      bestTime: 'October–March',
      attracts: 'Royal collections, courtyards and palace architecture.',
      transport: 'Auto-rickshaw • City bus • Cab',
      duration: '2–3 hrs',
    ),
    'Jantar Mantar Jaipur': const _PlaceInfo(
      overview: 'Historic astronomical observatory containing monumental precision instruments.',
      bestTime: 'October–March',
      attracts: 'Astronomical instruments, science and architecture.',
      transport: 'Auto-rickshaw • City bus • Cab • Jaipur Metro nearby',
      duration: '1–1.5 hrs',
    ),
    'Jal Mahal': const _PlaceInfo(
      overview: 'Palace set in the middle of Man Sagar Lake and viewed from the lakeside.',
      bestTime: 'October–March',
      attracts: 'Lake setting, palace silhouette and photography.',
      transport: 'Auto-rickshaw • Bus • Cab',
      duration: '30–60 min',
    ),
    'Nahargarh Fort': const _PlaceInfo(
      overview: 'Hilltop fort overlooking Jaipur and the surrounding Aravalli landscape.',
      bestTime: 'October–March',
      attracts: 'City views, fort walls and sunset scenery.',
      transport: 'Cab • Auto-rickshaw • Local bus',
      duration: '1.5–2.5 hrs',
    ),
    'Jaigarh Fort': const _PlaceInfo(
      overview: 'Hill fort known for its massive defensive walls and historic cannon.',
      bestTime: 'October–March',
      attracts: 'Fortification, views and military heritage.',
      transport: 'Cab • Auto-rickshaw • Bus',
      duration: '1.5–2.5 hrs',
    ),
    'Albert Hall Museum': const _PlaceInfo(
      overview: 'Historic museum building housing art and artefacts from Rajasthan and beyond.',
      bestTime: 'October–March',
      attracts: 'Architecture, galleries and museum collections.',
      transport: 'Auto-rickshaw • City bus • Cab',
      duration: '1.5–2 hrs',
    ),
    'Galtaji Temple': const _PlaceInfo(
      overview: 'Temple complex set among the hills and natural water tanks near Jaipur.',
      bestTime: 'October–March',
      attracts: 'Temple architecture, hill setting and sacred water tanks.',
      transport: 'Auto-rickshaw • Cab • Local bus',
      duration: '1–2 hrs',
    ),
    'Birla Mandir Jaipur': const _PlaceInfo(
      overview: 'Modern white-marble Hindu temple set against the Moti Dungari hill.',
      bestTime: 'October–March',
      attracts: 'Marble architecture, peaceful setting and evening illumination.',
      transport: 'Auto-rickshaw • City bus • Cab',
      duration: '45–75 min',
    ),
    'Gateway of India': const _PlaceInfo(
      overview: 'Monumental waterfront arch overlooking Mumbai Harbour.',
      bestTime: 'November–February',
      attracts: 'Harbour views, colonial architecture and nearby waterfront attractions.',
      transport: 'Local train • Bus • Taxi • Ferry nearby',
      duration: '45–90 min',
    ),
    'Chhatrapati Shivaji Maharaj Terminus': const _PlaceInfo(
      overview: 'Historic railway terminus blending Victorian Gothic and Indian architectural elements.',
      bestTime: 'November–February',
      attracts: 'Grand architecture, heritage details and active railway setting.',
      transport: 'Local train • Metro • Bus • Taxi',
      duration: '30–60 min',
    ),
    'Elephanta Caves': const _PlaceInfo(
      overview: 'Rock-cut cave complex on Elephanta Island featuring historic sculptures.',
      bestTime: 'November–February',
      attracts: 'Cave temples, sculptures and ferry journey.',
      transport: 'Ferry from Gateway of India • Taxi/auto to Gateway',
      duration: '3–5 hrs',
    ),
    'Chhatrapati Shivaji Maharaj Vastu Sangrahalaya': const _PlaceInfo(
      overview: 'Major Mumbai museum with collections of art, archaeology and history.',
      bestTime: 'November–February',
      attracts: 'Indian art, sculptures, artefacts and architecture.',
      transport: 'Bus • Taxi • Auto-rickshaw • Local train nearby',
      duration: '1.5–3 hrs',
    ),
    'Siddhivinayak Temple': const _PlaceInfo(
      overview: 'Famous Mumbai temple dedicated to Lord Ganesha.',
      bestTime: 'October–February',
      attracts: 'Devotional atmosphere, temple architecture and cultural importance.',
      transport: 'Local train • Bus • Taxi • Auto-rickshaw',
      duration: '30–90 min',
    ),
    'Haji Ali Dargah': const _PlaceInfo(
      overview: 'Historic mosque and dargah located on an islet reached by a causeway.',
      bestTime: 'November–February',
      attracts: 'Sea setting, architecture and spiritual heritage.',
      transport: 'Bus • Taxi • Auto-rickshaw • Local train nearby',
      duration: '1–2 hrs',
    ),
    'Kanheri Caves': const _PlaceInfo(
      overview: 'Ancient Buddhist rock-cut caves within Sanjay Gandhi National Park.',
      bestTime: 'November–February',
      attracts: 'Rock-cut architecture, inscriptions and forest setting.',
      transport: 'Local train to Borivali • Bus • Taxi/auto',
      duration: '2–4 hrs',
    ),
    'Bandra-Worli Sea Link': const _PlaceInfo(
      overview: 'Major cable-stayed bridge connecting Mumbai\'s western suburbs.',
      bestTime: 'November–February',
      attracts: 'Engineering landmark, skyline views and photography.',
      transport: 'Bus • Taxi • Auto-rickshaw',
      duration: '20–45 min',
    ),
    'Sanjay Gandhi National Park': const _PlaceInfo(
      overview: 'Large protected green area within Mumbai with trails and historic sites.',
      bestTime: 'November–February',
      attracts: 'Nature, trails, wildlife and Kanheri Caves access.',
      transport: 'Local train to Borivali • Bus • Taxi/auto',
      duration: '2–4 hrs',
    ),
    'Marine Drive': const _PlaceInfo(
      overview: 'Iconic Mumbai seafront promenade along Back Bay.',
      bestTime: 'November–February',
      attracts: 'Sea views, sunset, skyline and evening atmosphere.',
      transport: 'Local train • Bus • Taxi • Auto-rickshaw',
      duration: '1–2 hrs',
    ),
    'Mysore Palace': const _PlaceInfo(
      overview: 'Opulent former royal residence and one of Mysuru\'s best-known landmarks.',
      bestTime: 'October–February',
      attracts: 'Royal interiors, architecture and evening illumination.',
      transport: 'City bus • Auto-rickshaw • Cab • Mysuru station nearby',
      duration: '1.5–3 hrs',
    ),
    'Chamundi Hill': const _PlaceInfo(
      overview: 'Hill overlooking Mysuru and home to the Chamundeshwari temple.',
      bestTime: 'October–February',
      attracts: 'Panoramic city views, temple and hill drive.',
      transport: 'City bus • Cab • Auto-rickshaw',
      duration: '1.5–3 hrs',
    ),
    'Chamundeshwari Temple': const _PlaceInfo(
      overview: 'Historic hilltop temple dedicated to Goddess Chamundeshwari.',
      bestTime: 'October–February',
      attracts: 'Temple architecture, religious heritage and city views.',
      transport: 'City bus • Cab • Auto-rickshaw',
      duration: '1–2 hrs',
    ),
    'St. Philomena Cathedral': const _PlaceInfo(
      overview: 'Large Neo-Gothic cathedral and prominent Mysuru landmark.',
      bestTime: 'October–February',
      attracts: 'Twin towers, Gothic architecture and stained-glass details.',
      transport: 'City bus • Auto-rickshaw • Cab',
      duration: '45–90 min',
    ),
    'Jaganmohan Palace': const _PlaceInfo(
      overview: 'Historic palace housing an important collection of Indian art.',
      bestTime: 'October–February',
      attracts: 'Art collections, palace architecture and cultural history.',
      transport: 'City bus • Auto-rickshaw • Cab',
      duration: '1–2 hrs',
    ),
    'Karanji Lake': const _PlaceInfo(
      overview: 'Scenic urban lake at the foot of Chamundi Hill.',
      bestTime: 'October–February',
      attracts: 'Birdlife, walking areas, lake views and nature.',
      transport: 'City bus • Auto-rickshaw • Cab',
      duration: '1–2 hrs',
    ),
    'Railway Museum Mysuru': const _PlaceInfo(
      overview: 'Museum preserving historic railway locomotives, coaches and artefacts.',
      bestTime: 'October–February',
      attracts: 'Railway heritage, vintage coaches and family-friendly exhibits.',
      transport: 'City bus • Auto-rickshaw • Cab',
      duration: '1–2 hrs',
    ),
    'Devaraja Market': const _PlaceInfo(
      overview: 'Historic market known for flowers, spices, produce and local shopping.',
      bestTime: 'October–February',
      attracts: 'Local culture, colourful stalls and photography.',
      transport: 'City bus • Auto-rickshaw • Cab',
      duration: '45–90 min',
    ),
    'Lalitha Mahal Palace': const _PlaceInfo(
      overview: 'Elegant former royal palace set on a hill outside central Mysuru.',
      bestTime: 'October–February',
      attracts: 'Palace architecture, landscaped setting and royal ambience.',
      transport: 'Cab • Auto-rickshaw',
      duration: '1–2 hrs',
    ),
    'Mysuru Zoo': const _PlaceInfo(
      overview: 'Historic zoological garden with a wide range of animal species.',
      bestTime: 'October–February',
      attracts: 'Wildlife, landscaped grounds and family activities.',
      transport: 'City bus • Auto-rickshaw • Cab',
      duration: '2–4 hrs',
    ),
    'Taj-ul-Masajid': const _PlaceInfo(
      overview: 'One of India\'s largest mosques and a major architectural landmark of Bhopal.',
      bestTime: 'October–February',
      attracts: 'Grand mosque architecture and historical significance.',
      transport: 'City bus • Auto-rickshaw • Cab • Bhopal station nearby',
      duration: '45–90 min',
    ),
    'Upper Lake': const _PlaceInfo(
      overview: 'Large historic lake and major recreational landmark of Bhopal.',
      bestTime: 'October–February',
      attracts: 'Lake views, boating, sunsets and waterfront atmosphere.',
      transport: 'City bus • Auto-rickshaw • Cab',
      duration: '1–2 hrs',
    ),
    'Van Vihar National Park': const _PlaceInfo(
      overview: 'Urban national park beside Upper Lake with naturalistic animal enclosures.',
      bestTime: 'October–February',
      attracts: 'Wildlife, cycling, greenery and lake views.',
      transport: 'City bus • Auto-rickshaw • Cab',
      duration: '2–3 hrs',
    ),
    'Bharat Bhavan': const _PlaceInfo(
      overview: 'Multidisciplinary arts centre overlooking Upper Lake.',
      bestTime: 'October–February',
      attracts: 'Indian art, theatre, literature and architecture.',
      transport: 'City bus • Auto-rickshaw • Cab',
      duration: '1–2 hrs',
    ),
    'Tribal Museum Bhopal': const _PlaceInfo(
      overview: 'Museum presenting the cultures, art and traditions of Madhya Pradesh\'s tribal communities.',
      bestTime: 'October–February',
      attracts: 'Immersive displays, crafts and cultural interpretation.',
      transport: 'City bus • Auto-rickshaw • Cab',
      duration: '1.5–3 hrs',
    ),
    'Gohar Mahal': const _PlaceInfo(
      overview: 'Historic palace associated with Bhopal\'s early royal history.',
      bestTime: 'October–February',
      attracts: 'Palace architecture, heritage setting and cultural events.',
      transport: 'Auto-rickshaw • City bus • Cab',
      duration: '45–90 min',
    ),
    'Moti Masjid Bhopal': const _PlaceInfo(
      overview: 'Historic mosque built in the old city of Bhopal.',
      bestTime: 'October–February',
      attracts: 'Islamic architecture and old-city heritage.',
      transport: 'Auto-rickshaw • City bus • Cab',
      duration: '30–60 min',
    ),
    'Sadar Manzil': const _PlaceInfo(
      overview: 'Historic royal audience hall and part of Bhopal\'s old palace precinct.',
      bestTime: 'October–February',
      attracts: 'Royal heritage, architecture and old-city atmosphere.',
      transport: 'Auto-rickshaw • City bus • Cab',
      duration: '30–60 min',
    ),
    'Birla Mandir Bhopal': const _PlaceInfo(
      overview: 'Hilltop temple complex overlooking Bhopal and its lakes.',
      bestTime: 'October–February',
      attracts: 'Temple architecture, views and peaceful setting.',
      transport: 'City bus • Auto-rickshaw • Cab',
      duration: '45–90 min',
    ),
    'Regional Science Centre Bhopal': const _PlaceInfo(
      overview: 'Science museum and interactive centre focused on hands-on learning.',
      bestTime: 'October–February',
      attracts: 'Interactive exhibits, science demonstrations and family activities.',
      transport: 'City bus • Auto-rickshaw • Cab',
      duration: '1.5–3 hrs',
    ),
    'Khajuraho Temples': const _PlaceInfo(
      overview: 'Famous temple group known for detailed medieval sandstone sculpture and architecture.',
      bestTime: 'October–March',
      attracts: 'Sculpture, temple architecture and UNESCO heritage.',
      transport: 'Auto-rickshaw • Taxi • Local bus',
      duration: '3–5 hrs',
    ),
    'Taj Mahal': const _PlaceInfo(
      overview: 'Mughal-era marble mausoleum on the Yamuna River and a globally recognised heritage site.',
      bestTime: 'October–March',
      attracts: 'Architecture, gardens, marble inlay and riverfront setting.',
      transport: 'Agra Metro • Auto-rickshaw • Taxi • Bus',
      duration: '2–4 hrs',
    ),
    'Red Fort': const _PlaceInfo(
      overview: 'Historic Mughal fort complex in the heart of Old Delhi.',
      bestTime: 'October–March',
      attracts: 'Fort architecture, museums and Mughal history.',
      transport: 'Delhi Metro • Bus • Taxi • Auto-rickshaw',
      duration: '2–3 hrs',
    ),
    'Charminar': const _PlaceInfo(
      overview: 'Iconic four-minaret monument in Hyderabad\'s historic old city.',
      bestTime: 'October–February',
      attracts: 'Architecture, bazaars, food culture and old-city atmosphere.',
      transport: 'Metro • Bus • Taxi • Auto-rickshaw',
      duration: '1–2 hrs',
    ),
    'Sanchi Stupa': const _PlaceInfo(
      overview: 'Ancient Buddhist monument complex with stupas, gateways and monasteries.',
      bestTime: 'October–March',
      attracts: 'Buddhist heritage, carved gateways and archaeological landscape.',
      transport: 'Train to Sanchi • Bus • Taxi/auto',
      duration: '2–3 hrs',
    ),
  };

  // ============================================================
  // PLACE → CITY
  // ============================================================

  static const Map<String, String> _placeCities = {
    // Indore
    'Rajwada': 'Indore',
    'Lal Bagh Palace': 'Indore',
    'Krishnapura Chhatris': 'Indore',
    'Kanch Mandir': 'Indore',
    'Annapurna Temple': 'Indore',
    'Bada Ganpati': 'Indore',
    'Gandhi Hall': 'Indore',
    'Central Museum': 'Indore',
    'Ralamandal Wildlife Sanctuary': 'Indore',
    'Pipliyapala Regional Park': 'Indore',

    // Jaipur
    'Hawa Mahal': 'Jaipur',
    'Amber Fort': 'Jaipur',
    'City Palace Jaipur': 'Jaipur',
    'Jantar Mantar Jaipur': 'Jaipur',
    'Jal Mahal': 'Jaipur',
    'Nahargarh Fort': 'Jaipur',
    'Jaigarh Fort': 'Jaipur',
    'Albert Hall Museum': 'Jaipur',
    'Galtaji Temple': 'Jaipur',
    'Birla Mandir Jaipur': 'Jaipur',

    // Mumbai
    'Gateway of India': 'Mumbai',
    'Chhatrapati Shivaji Maharaj Terminus': 'Mumbai',
    'Elephanta Caves': 'Mumbai',
    'Chhatrapati Shivaji Maharaj Vastu Sangrahalaya':
        'Mumbai',
    'Siddhivinayak Temple': 'Mumbai',
    'Haji Ali Dargah': 'Mumbai',
    'Kanheri Caves': 'Mumbai',
    'Bandra-Worli Sea Link': 'Mumbai',
    'Sanjay Gandhi National Park': 'Mumbai',
    'Marine Drive': 'Mumbai',

    // Mysuru
    'Mysore Palace': 'Mysuru',
    'Chamundi Hill': 'Mysuru',
    'Chamundeshwari Temple': 'Mysuru',
    'St. Philomena Cathedral': 'Mysuru',
    'Jaganmohan Palace': 'Mysuru',
    'Karanji Lake': 'Mysuru',
    'Railway Museum Mysuru': 'Mysuru',
    'Devaraja Market': 'Mysuru',
    'Lalitha Mahal Palace': 'Mysuru',
    'Mysuru Zoo': 'Mysuru',

    // Bhopal
    'Taj-ul-Masajid': 'Bhopal',
    'Upper Lake': 'Bhopal',
    'Van Vihar National Park': 'Bhopal',
    'Bharat Bhavan': 'Bhopal',
    'Tribal Museum Bhopal': 'Bhopal',
    'Gohar Mahal': 'Bhopal',
    'Moti Masjid Bhopal': 'Bhopal',
    'Sadar Manzil': 'Bhopal',
    'Birla Mandir Bhopal': 'Bhopal',
    'Regional Science Centre Bhopal': 'Bhopal',

    // Other
    'Khajuraho Temples': 'Khajuraho',
    'Taj Mahal': 'Agra',
    'Red Fort': 'Delhi',
    'Charminar': 'Hyderabad',
    'Sanchi Stupa': 'Sanchi',
  };

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  // ============================================================
  // LOCATION
  // ============================================================

  Future<void> _getUserLocation() async {
    if (!mounted) return;

    setState(() {
      _locationLoading = true;
      _locationError = null;
    });

    try {
      final bool serviceEnabled =
          await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        if (!mounted) return;

        setState(() {
          _locationLoading = false;
          _locationError =
              'Location service is disabled.';
        });

        return;
      }

      LocationPermission permission =
          await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission =
            await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        if (!mounted) return;

        setState(() {
          _locationLoading = false;
          _locationError =
              'Location permission was denied.';
        });

        return;
      }

      if (permission ==
          LocationPermission.deniedForever) {
        if (!mounted) return;

        setState(() {
          _locationLoading = false;
          _locationError =
              'Location permission is permanently denied.';
        });

        return;
      }

      final Position position =
          await Geolocator.getCurrentPosition(
        locationSettings:
            const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final LatLng newLocation = LatLng(
        position.latitude,
        position.longitude,
      );

      if (!mounted) return;

      setState(() {
        _currentLocation = newLocation;
        _locationLoading = false;
        _locationReady = true;
      });

      await _updateMapLibreLocation(
        position,
        newLocation,
      );

      await _moveToUserLocation();
    } catch (e) {
      debugPrint(
        'YATRA location error: $e',
      );

      if (!mounted) return;

      setState(() {
        _locationLoading = false;
        _locationError =
            'Could not get your current location.';
      });
    }
  }

  Future<void> _updateMapLibreLocation(
    Position position,
    LatLng location,
  ) async {
    final controller = _mapController;

    if (controller == null) {
      return;
    }

    try {
      await controller.updateManualLocation(
        ManualLocationUpdate(
          target: location,
          horizontalAccuracy:
              position.accuracy,
          altitude: position.altitude,
          speed: position.speed,
          bearing: position.heading,
          timestamp: DateTime.now(),
        ),
      );
    } catch (e) {
      debugPrint(
        'MapLibre location update error: $e',
      );
    }
  }

  Future<void> _moveToUserLocation() async {
    final controller = _mapController;

    if (controller == null) {
      return;
    }

    try {
      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _currentLocation,
            zoom: 15.5,
          ),
        ),
        duration:
            const Duration(milliseconds: 900),
      );
    } catch (e) {
      debugPrint(
        'Camera movement error: $e',
      );
    }
  }

  // ============================================================
  // MAP
  // ============================================================

  void _onMapCreated(
    MapLibreMapController controller,
  ) {
    _mapController = controller;

    if (_locationReady) {
      controller.updateManualLocation(
        ManualLocationUpdate(
          target: _currentLocation,
          timestamp: DateTime.now(),
        ),
      );

      _moveToUserLocation();
    }
  }

  Future<void> _onStyleLoaded() async {
    await _addHeritageMarkers();
  }

  // ============================================================
  // HERITAGE MARKERS
  // ============================================================

  Future<void> _addHeritageMarkers() async {
    final controller = _mapController;

    if (controller == null) {
      return;
    }

    try {
      for (final entry
          in _heritageLocations.entries) {
        await controller.addCircle(
          CircleOptions(
            geometry: entry.value,
            circleRadius: 8.0,
            circleColor: '#A6532A',
            circleOpacity: 1.0,
            circleStrokeColor: '#FFFFFF',
            circleStrokeWidth: 3.0,
          ),
        );
      }

      controller.onCircleTapped.add(
        _onHeritageMarkerTapped,
      );

      debugPrint(
        'YATRA: ${_heritageLocations.length} heritage markers added.',
      );
    } catch (e) {
      debugPrint(
        'YATRA marker error: $e',
      );
    }
  }

  void _onHeritageMarkerTapped(
    Circle circle,
  ) {
    final geometry =
        circle.options.geometry;

    if (geometry == null) {
      return;
    }

    String? matchedPlace;

    for (final entry
        in _heritageLocations.entries) {
      final LatLng location = entry.value;

      final double latDifference =
          (location.latitude -
                  geometry.latitude)
              .abs();

      final double lngDifference =
          (location.longitude -
                  geometry.longitude)
              .abs();

      if (latDifference < 0.00001 &&
          lngDifference < 0.00001) {
        matchedPlace = entry.key;
        break;
      }
    }

    if (matchedPlace == null) {
      return;
    }

    final String city =
        _placeCities[matchedPlace] ?? '';

    if (!mounted) return;

    setState(() {
      _selectedPlace = matchedPlace;
      _selectedCity = city;
    });
  }

  void _closePlaceCard() {
    setState(() {
      _selectedPlace = null;
      _selectedCity = null;
    });
  }

  Future<void> _openFoodSearch(
    String place,
    String city,
    String category,
  ) async {
    final query = Uri.encodeComponent(
      '$category near $place, $city, India',
    );

    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$query',
    );

    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  }

  Future<void> _openTransportSearch(
    String place,
    String city,
    String category,
  ) async {
    final query = Uri.encodeComponent(
      '$category near $place, $city, India',
    );

    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$query',
    );

    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  }

  void _showTransportOptions() {
    final place = _selectedPlace;
    final city = _selectedCity;

    if (place == null || city == null) {
      return;
    }

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            decoration: const BoxDecoration(
              color: Color(0xFFFFFBF4),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(28),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7E8C9),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.directions_transit_rounded,
                        color: Color(0xFFA6532A),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'EXPLORE TRANSPORT',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.2,
                              color: Color(0xFFA6532A),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Around $place',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF4B3024),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Find nearby public transport and travel points on Google Maps.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 16),
                _transportOptionTile(
                  icon: Icons.directions_bus_rounded,
                  title: 'Bus Stops',
                  subtitle: 'Find nearby bus stops and routes',
                  onTap: () => _openTransportSearch(place, city, 'bus stops'),
                ),
                const SizedBox(height: 10),
                _transportOptionTile(
                  icon: Icons.train_rounded,
                  title: 'Metro Stations',
                  subtitle: 'Find nearby metro stations',
                  onTap: () => _openTransportSearch(place, city, 'metro stations'),
                ),
                const SizedBox(height: 10),
                _transportOptionTile(
                  icon: Icons.train_rounded,
                  title: 'Railway Stations',
                  subtitle: 'Find nearby railway stations',
                  onTap: () => _openTransportSearch(place, city, 'railway stations'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _transportOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.pop(context);
          onTap();
        },
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black12),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFF7E8C9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFFA6532A),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF4B3024),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 15,
                color: Color(0xFFA6532A),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFoodOptions() {
    final place = _selectedPlace;
    final city = _selectedCity;

    if (place == null || city == null) {
      return;
    }

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            decoration: const BoxDecoration(
              color: Color(0xFFFFFBF4),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(28),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7E8C9),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.restaurant_rounded,
                        color: Color(0xFFA6532A),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'EXPLORE FOOD',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.2,
                              color: Color(0xFFA6532A),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Around $place',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF4B3024),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Find restaurants and cafés near this heritage place.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 16),
                _foodOptionTile(
                  icon: Icons.restaurant_rounded,
                  title: 'Restaurants',
                  subtitle: 'Nearby restaurants and dining spots',
                  onTap: () => _openFoodSearch(place, city, 'restaurants'),
                ),
                const SizedBox(height: 10),
                _foodOptionTile(
                  icon: Icons.local_cafe_rounded,
                  title: 'Cafés',
                  subtitle: 'Coffee, snacks and casual places',
                  onTap: () => _openFoodSearch(place, city, 'cafes'),
                ),
                const SizedBox(height: 10),
                _foodOptionTile(
                  icon: Icons.ramen_dining_rounded,
                  title: 'Local Food',
                  subtitle: 'Explore local food around the place',
                  onTap: () => _openFoodSearch(place, city, 'local food'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _foodOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.pop(context);
          onTap();
        },
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black12),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFF7E8C9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFFA6532A),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF4B3024),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.open_in_new_rounded,
                size: 19,
                color: Color(0xFFA6532A),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _goToPlace(
    String name,
  ) async {
    final controller = _mapController;

    if (controller == null) {
      return;
    }

    final LatLng? location =
        _heritageLocations[name];

    if (location == null) {
      return;
    }

    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: location,
          zoom: 15.5,
        ),
      ),
      duration:
          const Duration(milliseconds: 900),
    );
  }

  // ============================================================
  // ZOOM
  // ============================================================

  Future<void> _zoomIn() async {
    final controller = _mapController;

    if (controller == null) {
      return;
    }

    try {
      await controller.animateCamera(
        CameraUpdate.zoomIn(),
      );
    } catch (e) {
      debugPrint(
        'Zoom in error: $e',
      );
    }
  }

  Future<void> _zoomOut() async {
    final controller = _mapController;

    if (controller == null) {
      return;
    }

    try {
      await controller.animateCamera(
        CameraUpdate.zoomOut(),
      );
    } catch (e) {
      debugPrint(
        'Zoom out error: $e',
      );
    }
  }

  Future<void> _retryLocation() async {
    await _getUserLocation();
  }

  // ============================================================
  // UI
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ====================================================
          // MAP
          // ====================================================

          MapLibreMap(
            styleString: _mapStyle,

            initialCameraPosition:
                const CameraPosition(
              target: _fallbackLocation,
              zoom: 12.5,
            ),

            myLocationEnabled: true,

            locationSource:
                ManualLocationSource(),

            myLocationTrackingMode:
                MyLocationTrackingMode.none,

            myLocationRenderMode:
                MyLocationRenderMode.normal,

            compassEnabled: true,

            rotateGesturesEnabled: true,
            scrollGesturesEnabled: true,
            tiltGesturesEnabled: true,
            zoomGesturesEnabled: true,

            onMapCreated:
                _onMapCreated,

            onStyleLoadedCallback:
                _onStyleLoaded,

            onUserLocationUpdated:
                (userLocation) {
              final LatLng? position =
                  userLocation.position;

              if (position == null) {
                return;
              }

              if (!mounted) return;

              setState(() {
                _currentLocation = position;
                _locationReady = true;
              });
            },
          ),

          // ====================================================
          // YATRA HEADER
          // ====================================================

          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.fromLTRB(
                16,
                14,
                16,
                0,
              ),
              child: Align(
                alignment:
                    Alignment.topCenter,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 13,
                  ),
                  decoration:
                      BoxDecoration(
                    color: Colors.white
                        .withValues(
                      alpha: 0.94,
                    ),
                    borderRadius:
                        BorderRadius.circular(
                      18,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 14,
                        offset:
                            Offset(0, 4),
                        color:
                            Colors.black26,
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize:
                        MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.map_rounded,
                        color:
                            Color(0xFFA6532A),
                        size: 25,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'YATRA MAP',
                        style:
                            TextStyle(
                          fontSize: 20,
                          fontWeight:
                              FontWeight.w800,
                          letterSpacing:
                              1.0,
                          color:
                              Color(0xFF4B3024),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ====================================================
          // LOCATION LOADING
          // ====================================================

          if (_locationLoading)
            Positioned(
              top: 90,
              left: 16,
              child: _statusCard(
                icon:
                    Icons.location_searching,
                text:
                    'Finding your location...',
              ),
            ),

          // ====================================================
          // LOCATION ERROR
          // ====================================================

          if (!_locationLoading &&
              _locationError != null)
            Positioned(
              top: 90,
              left: 16,
              right: 16,
              child: GestureDetector(
                onTap:
                    _retryLocation,
                child: Container(
                  padding:
                      const EdgeInsets
                          .symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration:
                      BoxDecoration(
                    color: Colors.white
                        .withValues(
                      alpha: 0.96,
                    ),
                    borderRadius:
                        BorderRadius.circular(
                      15,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 12,
                        color:
                            Colors.black26,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_off,
                        color:
                            Color(0xFFA6532A),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          _locationError!,
                          style:
                              const TextStyle(
                            fontWeight:
                                FontWeight.w600,
                            color:
                                Color(0xFF4B3024),
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.refresh,
                        color:
                            Color(0xFFA6532A),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // ====================================================
          // SELECTED PLACE CARD
          // ====================================================

          if (_selectedPlace != null)
            Positioned(
              left: 16,
              right: 16,
              bottom: 20,
              child: _buildPlaceInfoCard(),
            ),

          // ====================================================
          // ZOOM BUTTONS
          // ====================================================

          Positioned(
            right: 16,
            bottom: 145,
            child: Container(
              decoration:
                  BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(
                  16,
                ),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 12,
                    color:
                        Colors.black26,
                  ),
                ],
              ),
              child: Column(
                children: [
                  _mapButton(
                    icon: Icons.add,
                    onPressed:
                        _zoomIn,
                  ),

                  Container(
                    height: 1,
                    width: 42,
                    color:
                        Colors.black12,
                  ),

                  _mapButton(
                    icon: Icons.remove,
                    onPressed:
                        _zoomOut,
                  ),
                ],
              ),
            ),
          ),

          // ====================================================
          // CURRENT LOCATION BUTTON
          // ====================================================

          Positioned(
            right: 16,
            bottom: 78,
            child: FloatingActionButton(
              heroTag:
                  'yatra_location_button',
              mini: true,
              backgroundColor:
                  Colors.white,
              foregroundColor:
                  const Color(
                0xFFA6532A,
              ),
              elevation: 5,
              onPressed:
                  _moveToUserLocation,
              child: const Icon(
                Icons.my_location,
              ),
            ),
          ),

          // ====================================================
          // COORDINATES
          // ====================================================

          Positioned(
            left: 16,
            bottom: 22,
            child: Container(
              padding:
                  const EdgeInsets
                      .symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration:
                  BoxDecoration(
                color: Colors.white
                    .withValues(
                  alpha: 0.92,
                ),
                borderRadius:
                    BorderRadius.circular(
                  12,
                ),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 8,
                    color:
                        Colors.black26,
                  ),
                ],
              ),
              child: Text(
                '${_currentLocation.latitude.toStringAsFixed(5)}, '
                '${_currentLocation.longitude.toStringAsFixed(5)}',
                style:
                    const TextStyle(
                  fontSize: 12,
                  fontWeight:
                      FontWeight.w600,
                  color:
                      Color(0xFF4B3024),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildPlaceInfoCard() {
    final name = _selectedPlace;
    if (name == null) return const SizedBox.shrink();

    final city = _selectedCity ?? '';
    final info = _placeInfo[name];

    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 390,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: const [
            BoxShadow(
              blurRadius: 20,
              offset: Offset(0, 6),
              color: Colors.black26,
            ),
          ],
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFA6532A),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.account_balance,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF4B3024),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          city,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Center on map',
                    onPressed: () => _goToPlace(name),
                    icon: const Icon(
                      Icons.near_me_rounded,
                      color: Color(0xFFA6532A),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Close',
                    onPressed: _closePlaceCard,
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (info != null) ...[
                Text(
                  info.overview,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.45,
                    color: Color(0xFF4B3024),
                  ),
                ),
                const SizedBox(height: 14),
                _infoRow(
                  Icons.schedule_rounded,
                  'Best time to visit',
                  info.bestTime,
                ),
                _infoRow(
                  Icons.favorite_rounded,
                  'What attracts visitors',
                  info.attracts,
                ),
                _infoRow(
                  Icons.directions_transit_rounded,
                  'Nearby transport',
                  info.transport,
                ),
                _infoRow(
                  Icons.timer_outlined,
                  'Suggested duration',
                  info.duration,
                ),
              ] else
                const Text(
                  'Quick travel information will be added for this place.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),

              const SizedBox(height: 6),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _showTransportOptions,
                  icon: const Icon(
                    Icons.directions_transit_rounded,
                    size: 18,
                  ),
                  label: const Text('EXPLORE TRANSPORT NEARBY'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFA6532A),
                    side: const BorderSide(
                      color: Color(0xFFA6532A),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 13,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _showFoodOptions,
                  icon: const Icon(
                    Icons.restaurant_rounded,
                    size: 18,
                  ),
                  label: const Text('EXPLORE FOOD NEARBY'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFA6532A),
                    side: const BorderSide(
                      color: Color(0xFFA6532A),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 13,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    final place = _buildPlaceForStory(
                      name,
                      city,
                    );

                    if (place == null) {
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PlaceStoryScreen(
                          place: place,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.auto_stories_rounded,
                    size: 18,
                  ),
                  label: const Text('READ STORY'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA6532A),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      vertical: 13,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, String>? _buildPlaceForStory(
    String name,
    String city,
  ) {
    for (final place in YatraPlaces.all) {
      if (place['name'] == name) {
        return place;
      }
    }

    return {
      'name': name,
      'city': city,
      'location': '',
      'image': '',
    };
  }

  Widget _infoRow(
    IconData icon,
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: const Color(0xFFF7E8C9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 18,
              color: const Color(0xFFA6532A),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF4B3024),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.35,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STATUS CARD
  // ============================================================

  Widget _statusCard({
    required IconData icon,
    required String text,
  }) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 11,
      ),
      decoration:
          BoxDecoration(
        color: Colors.white
            .withValues(
          alpha: 0.95,
        ),
        borderRadius:
            BorderRadius.circular(
          15,
        ),
        boxShadow: const [
          BoxShadow(
            blurRadius: 12,
            color: Colors.black26,
          ),
        ],
      ),
      child: Row(
        mainAxisSize:
            MainAxisSize.min,
        children: [
          Icon(
            icon,
            color:
                const Color(
              0xFFA6532A,
            ),
            size: 20,
          ),
          const SizedBox(
            width: 9,
          ),
          Text(
            text,
            style:
                const TextStyle(
              fontWeight:
                  FontWeight.w600,
              color:
                  Color(0xFF4B3024),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MAP BUTTON
  // ============================================================

  Widget _mapButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 44,
      height: 44,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color:
              const Color(
            0xFFA6532A,
          ),
        ),
      ),
    );
  }
}