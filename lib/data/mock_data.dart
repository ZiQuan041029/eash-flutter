/// Greeting pills on the landing screen (from design).
const List<Map<String, String>> kLandingGreetings = <Map<String, String>>[
  <String, String>{'label': 'HELLO', 'bg': 'lime'},
  <String, String>{'label': 'नमस्ते', 'bg': 'blue'},
  <String, String>{'label': 'வணக்கம்', 'bg': 'yellow'},
];

class InterestTag {
  const InterestTag({required this.id, required this.emoji, required this.label});

  final String id;
  final String emoji;
  final String label;
}

class InterestCategory {
  const InterestCategory({required this.title, required this.tags});

  final String title;
  final List<InterestTag> tags;
}

/// Mock catalog for Step 1 — interests (from PDF).
const List<InterestCategory> kInterestCategories = <InterestCategory>[
  InterestCategory(
    title: 'Sports & Wellness',
    tags: <InterestTag>[
      InterestTag(id: 'cycling', emoji: '🚴', label: 'Cycling'),
      InterestTag(id: 'pickle', emoji: '🏓', label: 'Pickle & Paddle'),
      InterestTag(id: 'gym', emoji: '🏋️', label: 'Gym & Fitness'),
      InterestTag(id: 'football', emoji: '⚽', label: 'Football'),
    ],
  ),
  InterestCategory(
    title: 'Food & Drink',
    tags: <InterestTag>[
      InterestTag(id: 'coffee', emoji: '☕', label: 'Coffee & Tea'),
      InterestTag(id: 'street', emoji: '🍢', label: 'Street Food'),
      InterestTag(id: 'fast', emoji: '🍔', label: 'Fast Food'),
      InterestTag(id: 'vegan', emoji: '🥗', label: 'Vegan Eats'),
      InterestTag(id: 'halal', emoji: '🍖', label: 'Halal Food'),
      InterestTag(id: 'grocery', emoji: '🥬', label: 'Grocery'),
    ],
  ),
  InterestCategory(
    title: 'Vibe & Lifestyle',
    tags: <InterestTag>[
      InterestTag(id: 'music', emoji: '🎵', label: 'Music'),
      InterestTag(id: 'games', emoji: '🎮', label: 'Video Games'),
      InterestTag(id: 'travel', emoji: '✈️', label: 'Traveling'),
      InterestTag(id: 'fashion', emoji: '👠', label: 'Fashion'),
      InterestTag(id: 'culture', emoji: '🗿', label: 'Culture'),
    ],
  ),
];

const String kMockEmail = 'student@university.edu';
const String kTagline = 'Connect, explore, and thrive with your digital community.';
const String kAssistantName = 'KAI';

/// Placeholder copy for visa steps.
const String kVisaInstruction =
    'Ensure all details, including your full name, institution, and expiry date, are clearly legible in the preview above.';

const String kCameraRationale =
    'To complete your profile and verify your identity, we need access to your camera to take a quick selfie.';

const String kAlignVisaHint = 'Align your student visa within the frame';
