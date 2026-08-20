import 'package:flutter_firebase_blog_app/data/model/post.dart';

/// Portfolio-only content used when Firestore is empty or unavailable.
///
/// Keeping preview data in its own module makes the fallback explicit and
/// prevents it from leaking into the live Firestore repository path.
final List<Post> portfolioSamplePosts = [
  Post(
    id: 'sample-1',
    writer: 'oosuhada',
    title: 'Designing a calmer Flutter feed',
    content:
        'A practical pass on spacing, hierarchy, and state so a learning project reads like a small product instead of a CRUD demo.\n\nThe biggest change was not adding more UI. It was deciding what should lead: a clear journal identity, one useful action, and recent writing with enough visual weight to invite a tap.\n\nI also moved portfolio fallback content into its own sample module. The live Firestore path stays real, while an empty project still has something intentional to show.',
    createdAt: DateTime(2026, 8, 20, 18, 20),
    imgUrl: '',
    category: 'Flutter UI',
  ),
  Post(
    id: 'sample-2',
    writer: 'oosuhada',
    title: 'Firestore streams without an empty first impression',
    content:
        'How the journal keeps its live Firebase stream intact while presenting intentional preview content when credentials or documents are unavailable.\n\nThe feed still subscribes to the posts collection and switches to live mode as soon as documents arrive. Preview mode is only a presentation fallback, not a replacement repository.\n\nThat separation makes the project easier to review in a portfolio and safer to reconnect to a real Firebase project later.',
    createdAt: DateTime(2026, 8, 19, 21, 10),
    imgUrl: '',
    category: 'Firebase',
  ),
  Post(
    id: 'sample-3',
    writer: 'oosuhada',
    title: 'A writing flow that survives the keyboard',
    content:
        'Notes on making image selection, draft preview, validation, and publishing feel coherent on a small Android screen.\n\nThe editor is one scrollable surface, so the keyboard never has to fight a fixed column for space. Cover selection gets a visible preview instead of a tiny upload square.\n\nIn portfolio preview mode the interaction stays local. In live mode the same screen continues through Firebase Storage and Firestore.',
    createdAt: DateTime(2026, 8, 18, 15, 40),
    imgUrl: '',
    category: 'Build Notes',
  ),
];

bool isPortfolioSamplePost(Post post) => post.id.startsWith('sample-');
