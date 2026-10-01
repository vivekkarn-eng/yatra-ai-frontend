import 'package:flutter/material.dart';

class YatraSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final bool showResults;
  final List<Map<String, String>> searchResults;
  final ValueChanged<Map<String, String>> onPlaceTap;

  const YatraSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
    required this.showResults,
    required this.searchResults,
    required this.onPlaceTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 30),
      child: Column(
        children: [
          // =========================================================
          // PREMIUM SEARCH FIELD
          // =========================================================
          Container(
            height: 62,
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBF4),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: const Color(0xFFD8C29D),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF5B402B).withOpacity(0.08),
                  blurRadius: 18,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            child: Row(
              children: [
                const SizedBox(width: 17),

                // Search icon
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1E1C5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.search_rounded,
                    size: 20,
                    color: Color(0xFFA6532A),
                  ),
                ),

                const SizedBox(width: 11),

                // Text field
                Expanded(
                  child: TextField(
                    controller: controller,
                    onChanged: onChanged,
                    textInputAction: TextInputAction.search,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF30251F),
                    ),
                    decoration: const InputDecoration(
                      hintText:
                          'Search places, temples, monuments...',
                      hintStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF9B8D7D),
                      ),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),

                // Clear / microphone
                if (controller.text.isEmpty)
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6ECDB),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.mic_none_rounded,
                      size: 19,
                      color: Color(0xFF806B58),
                    ),
                  )
                else
                  IconButton(
                    onPressed: onClear,
                    icon: const Icon(
                      Icons.close_rounded,
                      size: 20,
                    ),
                    color: const Color(0xFF806B58),
                    tooltip: 'Clear search',
                  ),
              ],
            ),
          ),

          // =========================================================
          // SEARCH RESULTS
          // =========================================================
          if (showResults) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBF4),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: const Color(0xFFD8C29D),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF5B402B).withOpacity(0.08),
                    blurRadius: 18,
                    offset: const Offset(0, 7),
                  ),
                ],
              ),
              child: searchResults.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 30,
                            color: Color(0xFFA6532A),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'No place found',
                            style: TextStyle(
                              fontFamily: 'Cormorant Garamond',
                              fontSize: 19,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF30251F),
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'Try another monument or city.',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF827467),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: searchResults.map((place) {
                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => onPlaceTap(place),
                            borderRadius: BorderRadius.circular(18),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 13,
                                vertical: 11,
                              ),
                              child: Row(
                                children: [
                                  // Place icon
                                  Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF2E3C8),
                                      borderRadius:
                                          BorderRadius.circular(14),
                                    ),
                                    child: const Icon(
                                      Icons.account_balance_rounded,
                                      color: Color(0xFFA6532A),
                                      size: 20,
                                    ),
                                  ),

                                  const SizedBox(width: 11),

                                  // Place information
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          place['name'] ?? '',
                                          maxLines: 1,
                                          overflow:
                                              TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontFamily:
                                                'Cormorant Garamond',
                                            fontSize: 18,
                                            fontWeight:
                                                FontWeight.w800,
                                            color:
                                                Color(0xFF30251F),
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '${place['city'] ?? ''} • '
                                          '${place['location'] ?? ''}',
                                          maxLines: 1,
                                          overflow:
                                              TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color:
                                                Color(0xFF827467),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 14,
                                    color: Color(0xFFA6532A),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
            ),
          ],
        ],
      ),
    );
  }
}