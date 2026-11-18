enum ResourceType { read, watch, listen, music, everyday }

enum ResourceLevel { beginner, intermediate, advanced }

class LearningResource {
  const LearningResource({
    required this.id,
    required this.title,
    required this.description,
    required this.url,
    required this.type,
    required this.levels,
    required this.access,
  });

  final String id, title, description, url, access;
  final ResourceType type;
  final List<ResourceLevel> levels;

  bool matches({String search = '', ResourceType? type, ResourceLevel? level}) {
    final query = search.trim().toLowerCase();
    return (type == null || this.type == type) &&
        (level == null || levels.contains(level)) &&
        (query.isEmpty ||
            '$title $description ${this.type.name}'.toLowerCase().contains(
              query,
            ));
  }
}

/// Links only. Third-party text, audio and video are opened at their source.
const learningResources = <LearningResource>[
  LearningResource(
    id: 'mandarin_bean',
    title: 'Mandarin Bean',
    description: 'Graded stories with audio, Pinyin and translations.',
    url: 'https://mandarinbean.com/all-lessons/',
    type: ResourceType.read,
    levels: ResourceLevel.values,
    access: 'Free reading lessons',
  ),
  LearningResource(
    id: 'hsk_reading',
    title: 'HSK Reading',
    description: 'Short passages with translations and questions.',
    url: 'https://hskreading.com/',
    type: ResourceType.read,
    levels: ResourceLevel.values,
    access: 'Free, no account',
  ),
  LearningResource(
    id: 'lets_read',
    title: "Let's Read",
    description: 'Illustrated children’s books in Chinese and other languages.',
    url: 'https://www.letsreadasia.org/',
    type: ResourceType.read,
    levels: [ResourceLevel.beginner, ResourceLevel.intermediate],
    access: 'Free books',
  ),
  LearningResource(
    id: 'chinese_reading_practice',
    title: 'Chinese Reading Practice',
    description: 'Stories and essays with language notes, from easy to hard.',
    url: 'https://chinesereadingpractice.com/',
    type: ResourceType.read,
    levels: ResourceLevel.values,
    access: 'Free articles',
  ),
  LearningResource(
    id: 'mandarin_click',
    title: 'Mandarin Click',
    description: 'Slow Chinese stories and visual listening practice.',
    url: 'https://www.youtube.com/@MandarinClick',
    type: ResourceType.watch,
    levels: [ResourceLevel.beginner, ResourceLevel.intermediate],
    access: 'Free channel videos',
  ),
  LearningResource(
    id: 'comprehensible_chinese',
    title: 'Comprehensible Chinese',
    description: 'Mandarin explained through gestures, objects and context.',
    url: 'https://www.youtube.com/@ComprehensibleChinese',
    type: ResourceType.watch,
    levels: [ResourceLevel.beginner, ResourceLevel.intermediate],
    access: 'Free channel videos',
  ),
  LearningResource(
    id: 'little_fox',
    title: 'Little Fox Chinese',
    description: 'Animated stories and songs for early listening.',
    url: 'https://chinese.littlefox.com/en',
    type: ResourceType.watch,
    levels: [ResourceLevel.beginner],
    access: 'Free stories and songs',
  ),
  LearningResource(
    id: 'peppa_chinese',
    title: 'Peppa Pig Chinese',
    description: 'Short, repeated everyday conversations in cartoons.',
    url: 'https://www.youtube.com/@PeppaPigChineseOfficial',
    type: ResourceType.watch,
    levels: [ResourceLevel.beginner],
    access: 'Free channel videos',
  ),
  LearningResource(
    id: 'xiaogua',
    title: 'Xiaogua Chinese',
    description: 'Browse comprehensible videos by level and topic.',
    url: 'https://www.xiaoguachinese.com/video-library',
    type: ResourceType.watch,
    levels: ResourceLevel.values,
    access: 'Free-access filter available',
  ),
  LearningResource(
    id: 'mandarin_corner',
    title: 'Mandarin Corner',
    description: 'Longer interviews and natural conversations.',
    url: 'https://www.youtube.com/@MandarinCorner2',
    type: ResourceType.watch,
    levels: [ResourceLevel.intermediate, ResourceLevel.advanced],
    access: 'Free channel videos',
  ),
  LearningResource(
    id: 'easy_mandarin',
    title: 'Easy Mandarin',
    description: 'Street interviews with Chinese and English subtitles.',
    url: 'https://www.youtube.com/@EasyMandarin',
    type: ResourceType.watch,
    levels: [ResourceLevel.intermediate, ResourceLevel.advanced],
    access: 'Free channel videos',
  ),
  LearningResource(
    id: 'luo_xiaohei',
    title: 'Luo Xiaohei',
    description: 'A fantasy animation channel for story-based listening.',
    url: 'https://www.youtube.com/@luoxiaohei',
    type: ResourceType.watch,
    levels: [ResourceLevel.intermediate, ResourceLevel.advanced],
    access: 'Free channel videos',
  ),
  LearningResource(
    id: 'made_by_bilibili',
    title: 'Made By Bilibili',
    description: 'Donghua trailers, clips and available episodes.',
    url: 'https://www.youtube.com/@MadeByBilibili',
    type: ResourceType.watch,
    levels: [ResourceLevel.intermediate, ResourceLevel.advanced],
    access: 'Free channel videos; full series vary',
  ),
  LearningResource(
    id: 'cctv_documentary',
    title: 'CCTV Documentary',
    description: 'Documentaries on Chinese culture, history and nature.',
    url: 'https://www.youtube.com/@CCTVDocumentary',
    type: ResourceType.watch,
    levels: [ResourceLevel.advanced],
    access: 'Free channel videos',
  ),
  LearningResource(
    id: 'maomi',
    title: 'MaoMi Chinese',
    description: 'Learner podcast with a filter for free episodes.',
    url: 'https://maomichinese.com/podcast/',
    type: ResourceType.listen,
    levels: [ResourceLevel.intermediate],
    access: 'Free episodes available',
  ),
  LearningResource(
    id: 'slow_chinese',
    title: 'Slow Chinese',
    description: 'Slower stories and cultural listening.',
    url: 'https://podcasts.apple.com/us/podcast/%E6%85%A2%E9%80%9F%E4%B8%AD%E6%96%87-slow-chinese/id1482243873',
    type: ResourceType.listen,
    levels: [ResourceLevel.beginner, ResourceLevel.intermediate],
    access: 'Free podcast episodes',
  ),
  LearningResource(
    id: 'streetvoice',
    title: 'StreetVoice',
    description: 'Discover independent Chinese-language music.',
    url: 'https://streetvoice.com/',
    type: ResourceType.music,
    levels: [ResourceLevel.intermediate, ResourceLevel.advanced],
    access: 'Free listening on site',
  ),
  LearningResource(
    id: 'sony_mandopop',
    title: 'Sony Music Taiwan',
    description: 'Browse Mandopop artists and releases.',
    url: 'https://www.sonymusic.com.tw/mandopop/',
    type: ResourceType.music,
    levels: [ResourceLevel.intermediate, ResourceLevel.advanced],
    access: 'Free artist discovery; playback varies',
  ),
  LearningResource(
    id: 'zhihu',
    title: 'Zhihu',
    description: 'Questions, answers and discussions by native speakers.',
    url: 'https://www.zhihu.com/',
    type: ResourceType.everyday,
    levels: [ResourceLevel.advanced],
    access: 'Free browsing; sign-in may be needed',
  ),
];
