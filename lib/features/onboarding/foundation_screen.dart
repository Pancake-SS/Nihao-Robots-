import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../shared/robot_art.dart';
import '../profiles/profile.dart';
import 'foundation_content.dart';
import 'foundation_repository.dart';

class FoundationScreen extends ConsumerStatefulWidget {
  const FoundationScreen({
    required this.profile,
    required this.initial,
    this.replay = false,
    super.key,
  });
  final LearnerProfile profile;
  final FoundationState initial;
  final bool replay;

  @override
  ConsumerState<FoundationScreen> createState() => _FoundationScreenState();
}

class _FoundationScreenState extends ConsumerState<FoundationScreen> {
  late int _step = widget.replay ? 0 : widget.initial.step;
  bool _saving = false;
  String? _error;
  final _scroll = ScrollController();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _save(
    int step, {
    bool leave = false,
    bool complete = false,
  }) async {
    if (_saving) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref
          .read(foundationRepositoryProvider)
          .save(widget.profile.id, step, complete: complete);
      if (!mounted) return;
      ref.invalidate(foundationStateProvider(widget.profile.id));
      setState(() {
        _step = step;
        _saving = false;
      });
      if (leave) {
        Navigator.of(context).pop();
      } else if (_scroll.hasClients) {
        _scroll.jumpTo(0);
      }
    } catch (_) {
      if (mounted)
        setState(() {
          _saving = false;
          _error =
              'Could not save your place. Stay on this page and try again.';
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final page = foundationPages[_step];
    final last = _step == foundationPages.length - 1;
    return PopScope(
      canPop: !_saving,
      child: Scaffold(
        appBar: AppBar(title: const Text('First steps')),
        body: SingleChildScrollView(
          controller: _scroll,
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Material(
                color: AppColors.paper,
                borderRadius: BorderRadius.circular(24),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Step ${_step + 1} of ${foundationPages.length}',
                        key: const Key('foundation-position'),
                      ),
                      const SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: (_step + 1) / foundationPages.length,
                        semanticsLabel: 'Introduction position',
                      ),
                      const SizedBox(height: 24),
                      Text(
                        page.title,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 16),
                      Text(page.body),
                      if (_step == 0)
                        const Center(
                          child: RobotArt(
                            artwork: RobotArtwork.orbOnPaper,
                            size: 160,
                          ),
                        ),
                      if (page.hanzi != null) ...[
                        const SizedBox(height: 24),
                        Text(
                          page.hanzi!,
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                      ],
                      if (page.pinyin != null &&
                          (widget.profile.showPinyin ||
                              page.teachesPinyin)) ...[
                        const SizedBox(height: 12),
                        Text(
                          page.pinyin!,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ],
                      if (page.translation != null) ...[
                        const SizedBox(height: 12),
                        Text(page.translation!),
                      ],
                      if (_step >= 5) ...[
                        const SizedBox(height: 24),
                        const Text(
                          'Audio is not available in this introduction.',
                        ),
                      ],
                      if (_error != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Semantics(
                            liveRegion: true,
                            child: Text(_error!),
                          ),
                        ),
                      const SizedBox(height: 28),
                      const Text(
                        'Select Next to continue. Your place is saved as you go.',
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          if (_step > 0)
                            OutlinedButton(
                              onPressed: _saving
                                  ? null
                                  : () => _save(_step - 1),
                              child: const Text('Back'),
                            ),
                          FilledButton(
                            onPressed: _saving
                                ? null
                                : () => _save(
                                    last ? _step : _step + 1,
                                    leave: last,
                                    complete: last,
                                  ),
                            child: Text(
                              _saving
                                  ? 'Saving…'
                                  : last
                                  ? 'Finish introduction'
                                  : 'Next',
                            ),
                          ),
                          TextButton(
                            onPressed: _saving
                                ? null
                                : () => _save(_step, leave: true),
                            child: const Text('Save and leave'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
