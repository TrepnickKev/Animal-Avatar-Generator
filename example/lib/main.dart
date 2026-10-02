import 'dart:math';

import 'package:animal_avatar/animal_avatar.dart';
import 'package:flutter/material.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: const PreviewPage(),
    );
  }
}

/// Shows 10 sample avatars from random seeds; the shuffle button rerolls them.
class PreviewPage extends StatefulWidget {
  const PreviewPage({super.key});

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  static const int _count = 10;

  final Random _random = Random();
  late List<String> _seeds = _rollSeeds();
  bool _showBadge = true;

  List<String> _rollSeeds() => [
        for (var i = 0; i < _count; i++)
          'avatar-${_random.nextInt(1 << 32).toRadixString(16)}',
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('animal_avatar — preview'),
        actions: [
          Row(
            children: [
              const Text('Badge'),
              Switch(
                value: _showBadge,
                onChanged: (v) => setState(() => _showBadge = v),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: [
              for (final seed in _seeds)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimalAvatar(seed, size: 140, showBadge: _showBadge),
                    const SizedBox(height: 6),
                    Text(
                      seed,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => setState(() => _seeds = _rollSeeds()),
        icon: const Icon(Icons.casino),
        label: const Text('Shuffle'),
      ),
    );
  }
}
