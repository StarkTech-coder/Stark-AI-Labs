import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// --- GLOBAL STATE MANAGEMENT (REACTIVE MEMORY) ---
// This provider holds the job description text across the entire application [cite: 2026-01-31]
final jobTextProvider = StateProvider<String>((ref) => "");

void main() {
  runApp(
    // ProviderScope is required to initialize Riverpod and wrap the entire widget tree [cite: 2026-01-31]
    const ProviderScope(child: ArkIQ()),
  );
}

class ArkIQ extends StatelessWidget {
  const ArkIQ({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ArcIQ: Riverpod Edition',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
      ),
      home: const Intelegent(),
    );
  }
}

/// [Intelegent] - Input Module
/// Inherits from ConsumerWidget to interact with Riverpod providers [cite: 2026-01-31]
class Intelegent extends ConsumerWidget {
  const Intelegent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Controller to manage and capture user input from the TextField [cite: 2026-01-31]
    final TextEditingController jobController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("ARCIQ // COMMAND CENTER"),
        backgroundColor: const Color(0xFF1B5E20),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "INJECT JOB DESCRIPTION INTO SYSTEM",
              style: TextStyle(
                color: Color(0xFF00E676),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: jobController,
              maxLines: 5,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF121212),
                hintText: "Paste job details here...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD50000),
                padding: const EdgeInsets.symmetric(vertical: 20),
              ),
              onPressed: () {
                // UPDATE STATE: Writing input text to the global provider [cite: 2026-01-31]
                ref.read(jobTextProvider.notifier).state = jobController.text;

                // NAVIGATION: Pushing the result page onto the stack [cite: 2026-01-31]
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AnalysisResultPage(),
                  ),
                );
              },
              child: const Text("TRIGGER STRATEGIC ANALYSIS"),
            ),
          ],
        ),
      ),
    );
  }
}

/// [AnalysisResultPage] - Display Module
/// Observes changes in jobTextProvider to render analyzed data [cite: 2026-01-31]
class AnalysisResultPage extends ConsumerWidget {
  const AnalysisResultPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // READING STATE: ref.watch ensures the UI rebuilds if the data changes [cite: 2026-01-31]
    final currentJobText = ref.watch(jobTextProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("ANALYSIS REPORT"),
        backgroundColor: const Color(0xFF01579B),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.psychology_outlined,
              color: Color(0xFF00B0FF),
              size: 100,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white10),
              ),
              child: Text(
                currentJobText.isEmpty ? "NO DATA FOUND" : currentJobText,
                style: const TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
