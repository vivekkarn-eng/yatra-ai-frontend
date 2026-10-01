class YatraJourney {
  static final Set<String> _discovered = <String>{};
  static final List<String> _history = <String>[];

  /// Number of different places discovered.
  static int get uniqueDiscoveries => _discovered.length;

  /// Total number of successful discoveries.
  static int get discoveryCount => _history.length;

  /// Most recent discoveries first.
  static List<String> get history => List.unmodifiable(_history);

  /// Record a successful AI recognition.
  static void recordDiscovery(String name) {
    if (name.isEmpty || name == 'Unknown place') {
      return;
    }

    _discovered.add(name);
    _history.insert(0, name);
  }
}