import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_selector/file_selector.dart';

import 'dart:convert';
import 'dart:typed_data';

import '../../data/database_provider.dart';
import '../../shared/context_tour.dart';

import 'profile_form.dart';
import 'profile_home_screen.dart';
import 'profile_providers.dart';
import 'profile_archive.dart';

class ProfilePanel extends ConsumerStatefulWidget {
  const ProfilePanel({super.key});

  @override
  ConsumerState<ProfilePanel> createState() => _ProfilePanelState();
}

class _ProfilePanelState extends ConsumerState<ProfilePanel> {
  final _exportTarget = GlobalKey();
  final _importTarget = GlobalKey();
  bool _creating = false;
  bool _saving = false;
  String? _error;
  static const _saveType = XTypeGroup(
    label: 'Ni Hao Robot saves',
    extensions: ['json'],
    mimeTypes: ['application/json'],
    uniformTypeIdentifiers: ['public.json'],
  );

  Future<void> _export(int id, String name) async {
    if (_saving) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final source = await ref
          .read(profileArchiveRepositoryProvider)
          .exportProfile(id);
      final filename =
          'nihao_${name.replaceAll(RegExp(r'[^A-Za-z0-9_-]'), '_')}.json';
      final location = await getSaveLocation(
        suggestedName: filename,
        acceptedTypeGroups: [_saveType],
      );
      if (location != null) {
        await XFile.fromData(
          Uint8List.fromList(utf8.encode(source)),
          mimeType: 'application/json',
          name: filename,
        ).saveTo(location.path);
        if (mounted)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Account save exported.')),
          );
      }
    } catch (_) {
      if (mounted)
        setState(() => _error = 'Could not export this account. Try again.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _import() async {
    if (_saving) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final picked = await openFile(acceptedTypeGroups: [_saveType]);
      if (picked == null) return;
      final bytes = await picked.readAsBytes();
      if (bytes.length > 50 * 1024 * 1024)
        throw const FormatException('The save is too large.');
      final source = utf8.decode(bytes);
      await ref.read(profileArchiveReadyProvider.future);
      final id = await ref
          .read(profileArchiveRepositoryProvider)
          .importProfile(source);
      await ref.read(profileRepositoryProvider).select(id);
      ref.invalidate(profilesProvider);
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account imported as a new profile.')),
        );
    } on FormatException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } catch (_) {
      if (mounted)
        setState(
          () => _error =
              'Could not import this account. The current profiles were kept.',
        );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _save(
    Future<void> Function() action, {
    bool creating = false,
  }) async {
    if (_saving) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await action();
      if (mounted && creating) setState(() => _creating = false);
    } catch (_) {
      if (mounted) {
        setState(
          () => _error = 'Could not save your profile choice. Your entries are still here. Please try again.',
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ref
        .watch(profilesProvider)
        .when(
          loading: () => const Padding(
            padding: EdgeInsets.all(24),
            child: Center(
              child: CircularProgressIndicator(
                semanticsLabel: 'Loading local profiles',
              ),
            ),
          ),
          error: (_, _) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Could not open your local profiles. Your saved data has not been reset.',
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () {
                  ref.invalidate(appDatabaseProvider);
                  ref.invalidate(profileRepositoryProvider);
                  ref.invalidate(profilesProvider);
                },
                child: const Text('Try again'),
              ),
            ],
          ),
          data: (snapshot) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_error != null) ...[
                Semantics(
                  liveRegion: true,
                  child: Text(
                    _error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              if (_creating || snapshot.profiles.isEmpty)
                ProfileForm(
                  isSaving: _saving,
                  onCancel: snapshot.profiles.isEmpty
                      ? null
                      : () => setState(() {
                          _creating = false;
                          _error = null;
                        }),
                  onSubmit: (draft) => _save(
                    () => ref.read(profilesProvider.notifier).create(draft),
                    creating: true,
                  ),
                )
              else ...[
                Text(
                  'Choose your profile',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                const Text('Each profile keeps its own learning settings.'),
                const SizedBox(height: 16),
                for (final profile in snapshot.profiles)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      key: ValueKey('profile-${profile.id}'),
                      selected: snapshot.selectedId == profile.id,
                      selectedTileColor: Theme.of(context)
                          .scaffoldBackgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      title: Text(profile.name),
                      subtitle: Text(
                        'Profile ${profile.id} · ${profile.level.label}\n${profile.dailyMinutes} min a day · ${profile.goal.label}',
                      ),
                      isThreeLine: true,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          KeyedSubtree(
                            key: profile.id == snapshot.profiles.first.id
                                ? _exportTarget
                                : null,
                            child: IconButton(
                              key: ValueKey('export-profile-${profile.id}'),
                              tooltip: 'Export account save',
                              onPressed: _saving
                                  ? null
                                  : () => _export(profile.id, profile.name),
                              icon: const Icon(Icons.download_outlined),
                            ),
                          ),
                          if (snapshot.selectedId == profile.id)
                            const Icon(Icons.check_circle_outline),
                        ],
                      ),
                      enabled: !_saving,
                      onTap: () => _save(
                        () => ref
                            .read(profilesProvider.notifier)
                            .select(profile.id),
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: _saving || snapshot.selected == null
                      ? null
                      : () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => ProfileHomeScreen(
                                profile: snapshot.selected!,
                              ),
                            ),
                          );
                        },
                  child: Text(_saving ? 'Saving choice…' : 'Continue'),
                ),
                TextButton(
                  onPressed: _saving
                      ? null
                      : () => setState(() {
                          _creating = true;
                          _error = null;
                        }),
                  child: const Text('Create another profile'),
                ),
              ],
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () => showContextTour(context, [
                    if (snapshot.profiles.isNotEmpty && !_creating)
                      TourStop(
                        _exportTarget,
                        'Export an account',
                        'Save this profile, its progress, custom words and writing to a JSON file.',
                      ),
                    TourStop(
                      _importTarget,
                      'Import an account',
                      'Choose a Ni Hao Robot save file. It becomes a new profile and leaves existing profiles intact.',
                    ),
                  ]),
                  icon: const Icon(Icons.help_outline),
                  label: const Text('Account tutorial'),
                ),
              ),
              KeyedSubtree(
                key: _importTarget,
                child: OutlinedButton.icon(
                  key: const ValueKey('import-profile'),
                  onPressed: _saving ? null : _import,
                  icon: const Icon(Icons.upload_file_outlined),
                  label: const Text('Import account save'),
                ),
              ),
            ],
          ),
        );
  }
}
