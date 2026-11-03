import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'profile_form.dart';
import 'profile_home_screen.dart';
import 'profile_providers.dart';

class ProfilePanel extends ConsumerStatefulWidget {
  const ProfilePanel({super.key});

  @override
  ConsumerState<ProfilePanel> createState() => _ProfilePanelState();
}

class _ProfilePanelState extends ConsumerState<ProfilePanel> {
  bool _creating = false;
  bool _saving = false;
  String? _error;

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
                      trailing: snapshot.selectedId == profile.id
                          ? const Icon(Icons.check_circle_outline)
                          : null,
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
            ],
          ),
        );
  }
}
