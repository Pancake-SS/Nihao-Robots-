import 'package:flutter/material.dart';

import '../../shared/app_brand.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../shared/cozy_ui.dart';
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
    final story =
        _step < 5 &&
        MediaQuery.sizeOf(context).width >= 550 &&
        MediaQuery.textScalerOf(context).scale(16) <= 24;
    return PopScope(
      canPop: !_saving,
      child: Scaffold(
        appBar: AppBar(title: const AppScreenTitle('First steps')),
        body: WarmPageBackground(
          child: SingleChildScrollView(
            controller: _scroll,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      spacing: 12,
                      runSpacing: 4,
                      children: [
                        Text(
                          'Step ${_step + 1} of ${foundationPages.length}',
                          key: const Key('foundation-position'),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.4,
                            color: AppColors.mutedInk,
                          ),
                        ),
                        Text(
                          '${_step + 1} / ${foundationPages.length}',
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                    const SizedBox(height: 9),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: LinearProgressIndicator(
                        value: (_step + 1) / foundationPages.length,
                        semanticsLabel: 'Introduction position',
                      ),
                    ),
                    const SizedBox(height: 19),
                    if (story)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(27),
                        child: SizedBox(
                          height: 335,
                          child: Stack(
                            children: [
                              const Positioned.fill(child: NightStudyScene()),
                              Positioned.fill(
                                child: Container(
                                  color: const Color(0x33101F3B),
                                ),
                              ),
                              Positioned(
                                top: 21,
                                left: 20,
                                right: 20,
                                child: Row(
                                  children: [
                                    const Text(
                                      'NI HAO ROBOTS',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 1.5,
                                        fontSize: 10,
                                        color: AppColors.yellow,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      'SCENE ${_step + 1} OF 5',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 68,
                                left: 22,
                                right: 22,
                                child: Column(
                                  children: [
                                    Text(
                                      page.title,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 26,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    const SizedBox(height: 14),
                                    Container(
                                      constraints: const BoxConstraints(
                                        maxWidth: 660,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 19,
                                        vertical: 17,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xDE182845),
                                        border: Border.all(
                                          color: const Color(0xFF7F7AA8),
                                        ),
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      child: Text(
                                        page.body,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          height: 1.45,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Positioned(
                                bottom: 5,
                                left: 10,
                                child: RobotArt(
                                  artwork: RobotArtwork.orbOnNavy,
                                  size: 100,
                                ),
                              ),
                              const Positioned(
                                bottom: 20,
                                right: 22,
                                child: Text(
                                  'CLICK NEXT TO CONTINUE  ›',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white70,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: AppColors.paper,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: AppColors.border),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x120F2943),
                              blurRadius: 20,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    page.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineLarge,
                                  ),
                                ),
                                const RobotArt(
                                  artwork: RobotArtwork.tallOnPaper,
                                  size: 95,
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Text(page.body),
                            if (page.hanzi != null) ...[
                              const SizedBox(height: 19),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(22),
                                decoration: BoxDecoration(
                                  color: AppColors.cream,
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      page.hanzi!,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 39,
                                        height: 1.4,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    if (page.pinyin != null &&
                                        (widget.profile.showPinyin ||
                                            page.teachesPinyin))
                                      Text(
                                        page.pinyin!,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall,
                                      ),
                                    if (page.translation != null)
                                      Text(
                                        page.translation!,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: AppColors.mutedInk,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ] else if (page.pinyin != null &&
                                (widget.profile.showPinyin ||
                                    page.teachesPinyin)) ...[
                              const SizedBox(height: 18),
                              Center(
                                child: Text(
                                  page.pinyin!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall,
                                ),
                              ),
                            ],
                            if (_step >= 5) ...[
                              const SizedBox(height: 12),
                              const Text(
                                'Audio is not available in this introduction.',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.mutedInk,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    if (_error != null) ...[
                      const SizedBox(height: 14),
                      Semantics(
                        liveRegion: true,
                        child: Text(
                          _error!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 18),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      alignment: WrapAlignment.end,
                      children: [
                        TextButton(
                          onPressed: _saving
                              ? null
                              : () => _save(_step, leave: true),
                          child: const Text('Save and leave'),
                        ),
                        if (_step > 0)
                          OutlinedButton.icon(
                            onPressed: _saving ? null : () => _save(_step - 1),
                            icon: const Icon(Icons.arrow_back_rounded),
                            label: const Text('Back'),
                          ),
                        FilledButton.icon(
                          onPressed: _saving
                              ? null
                              : () => _save(
                                  last ? _step : _step + 1,
                                  leave: last,
                                  complete: last,
                                ),
                          icon: Icon(
                            last
                                ? Icons.check_rounded
                                : Icons.arrow_forward_rounded,
                          ),
                          label: Text(
                            _saving
                                ? 'Saving…'
                                : last
                                ? 'Finish introduction'
                                : 'Next',
                          ),
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
    );
  }
}
