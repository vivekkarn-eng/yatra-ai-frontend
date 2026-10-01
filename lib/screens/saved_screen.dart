import 'package:flutter/material.dart';
import '../data/place_data.dart';
import 'place_story_screen.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});
  @override State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  @override
  Widget build(BuildContext context) {
    final places = YatraPlaces.all.where((p) => YatraSaved.isSaved(p['name']!)).toList();
    return Scaffold(
      backgroundColor: const Color(0xFFF3E8D2),
      appBar: AppBar(backgroundColor: const Color(0xFFF3E8D2), foregroundColor: const Color(0xFF30251F), elevation: 0, title: const Text('Saved Places', style: TextStyle(fontFamily: 'Georgia', fontWeight: FontWeight.w800))),
      body: places.isEmpty
          ? Center(child: Padding(padding: const EdgeInsets.all(30), child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(width: 74, height: 74, decoration: const BoxDecoration(color: Color(0xFFF2E3C8), shape: BoxShape.circle), child: const Icon(Icons.bookmark_border_rounded, size: 38, color: Color(0xFFA6532A))),
              const SizedBox(height: 16), const Text('No saved places yet', style: TextStyle(fontFamily: 'Georgia', fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF30251F))),
              const SizedBox(height: 7), const Text('Save a heritage place from its story page and it will appear here.', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF75685D))),
            ])))
          : ListView.separated(
              padding: const EdgeInsets.all(14), itemCount: places.length, separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) { final p = places[i]; return ListTile(
                tileColor: const Color(0xFFFFF9EF), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                leading: ClipRRect(borderRadius: BorderRadius.circular(12), child: (p['image'] ?? '').isEmpty ? Container(width: 58, height: 58, color: const Color(0xFFE5D5B8), child: const Icon(Icons.account_balance, color: Color(0xFFA6532A))) : Image.asset(p['image']!, width: 58, height: 58, fit: BoxFit.cover)),
                title: Text(p['name']!, style: const TextStyle(fontFamily: 'Georgia', fontWeight: FontWeight.w800)),
                subtitle: Text('${p['city']} • ${p['location']}'),
                trailing: IconButton(icon: const Icon(Icons.bookmark_rounded, color: Color(0xFFA6532A)), onPressed: () { setState(() => YatraSaved.toggle(p['name']!)); }),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PlaceStoryScreen(place: p))),
              ); },
            ),
    );
  }
}
