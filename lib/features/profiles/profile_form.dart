import 'package:flutter/material.dart';

import 'profile.dart';

class ProfileForm extends StatefulWidget {
  const ProfileForm({
    required this.onSubmit,
    required this.isSaving,
    this.onCancel,
    super.key,
  });

  final ValueChanged<ProfileDraft> onSubmit;
  final bool isSaving;
  final VoidCallback? onCancel;

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  LearnerLevel _level = LearnerLevel.beginner;
  LearningGoal _goal = LearningGoal.everyday;
  int _minutes = 5;
  bool _pinyin = true;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _submit() {
    if (widget.isSaving || !_formKey.currentState!.validate()) return;
    widget.onSubmit(
      ProfileDraft(
        name: _name.text,
        level: _level,
        goal: _goal,
        dailyMinutes: _minutes,
        showPinyin: _pinyin,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Create local profile',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text('Saved on this device. No email or password needed.'),
          const SizedBox(height: 20),
          TextFormField(
            key: const Key('profile-name'),
            controller: _name,
            enabled: !widget.isSaving,
            decoration: const InputDecoration(
              labelText: 'Profile name',
              border: OutlineInputBorder(),
            ),
            validator: validateProfileName,
            textInputAction: TextInputAction.next,
            maxLength: 40,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<LearnerLevel>(
            initialValue: _level,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Your level',
              border: OutlineInputBorder(),
            ),
            items: [
              for (final level in LearnerLevel.values)
                DropdownMenuItem(value: level, child: Text(level.label)),
            ],
            onChanged: widget.isSaving
                ? null
                : (value) => setState(() => _level = value!),
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<LearningGoal>(
            initialValue: _goal,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Learning goal',
              border: OutlineInputBorder(),
            ),
            items: [
              for (final goal in LearningGoal.values)
                DropdownMenuItem(value: goal, child: Text(goal.label)),
            ],
            onChanged: widget.isSaving
                ? null
                : (value) => setState(() => _goal = value!),
          ),
          const SizedBox(height: 20),
          Text(
            'A manageable daily goal',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final minutes in dailyMinuteOptions)
                ChoiceChip(
                  label: Text('$minutes min'),
                  selected: _minutes == minutes,
                  onSelected: widget.isSaving
                      ? null
                      : (_) => setState(() => _minutes = minutes),
                ),
            ],
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Show Pinyin'),
            subtitle: const Text(
              'Tone-marked reading support alongside Chinese.',
            ),
            value: _pinyin,
            onChanged: widget.isSaving
                ? null
                : (value) => setState(() => _pinyin = value),
          ),
          const Text('Simplified Chinese · English guidance'),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: widget.isSaving ? null : _submit,
            child: Text(widget.isSaving ? 'Saving profile…' : 'Create profile'),
          ),
          if (widget.onCancel != null)
            TextButton(
              onPressed: widget.isSaving ? null : widget.onCancel,
              child: const Text('Back to profiles'),
            ),
        ],
      ),
    );
  }
}
