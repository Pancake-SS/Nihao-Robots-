import 'dart:math';

const writingPrompts = <String>[
  'Describe a place where you feel at home.',
  'Tell the story of a meal you still remember.',
  'Write about a friend who made you laugh.',
  'Describe your ideal weekend from morning to night.',
  'What would you show a visitor in your city?',
  'Write a short story about finding a lost object.',
  'Describe a song that changes your mood.',
  'Tell a story about a surprising journey.',
  'What is one small thing you learned this week?',
  'Describe your favourite season and its sounds.',
  'Write a letter to yourself one year from now.',
  'Imagine a conversation with a friendly robot.',
  'Describe a market, shop or café you like.',
  'What would your perfect rainy day look like?',
  'Tell a story that begins with an unexpected phone call.',
  'Describe a person who taught you something useful.',
  'Write about a movie scene you remember clearly.',
  'Imagine a day without your phone.',
  'Describe a festival or family tradition.',
  'Write about a mistake that turned into a good memory.',
  'What would you do if you had a free train ticket?',
  'Describe the view from your window.',
  'Write a short dialogue between two strangers.',
  'Tell a story from the point of view of a pet.',
  'Describe a skill you would like to learn.',
  'What makes a good friend?',
  'Imagine opening a tiny bookshop.',
  'Write about a time you helped someone.',
  'Describe a food you would like to try.',
  'Tell a story about a letter arriving late.',
  'What is your favourite way to spend an evening?',
  'Describe a place you would like to visit in China.',
];

String randomWritingPrompt({String? excluding, Random? random}) {
  final choices = writingPrompts
      .where((prompt) => prompt != excluding)
      .toList();
  return choices[(random ?? Random()).nextInt(choices.length)];
}
