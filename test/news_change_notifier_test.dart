import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing/article.dart';
import 'package:flutter_testing/news_change_notifier.dart';
import 'package:flutter_testing/news_service.dart';
import 'package:mocktail/mocktail.dart';

//* use group test for a collection of tests.
//* arrange: use when(() => ...);
//* act: call a f(x);
//* assert: use expect(value1, value2);

class MockNewsService extends Mock implements NewsService {}

void main() {
  late NewsChangeNotifier sysUnderTest;
  late MockNewsService mockNewsService;

  setUp(() {
    mockNewsService = MockNewsService();
    sysUnderTest = NewsChangeNotifier(mockNewsService);
  });

  final List<Article> articles = [
    Article(title: 'Title1', content: 'Content1'),
    Article(title: 'Title2', content: 'Content2'),
    Article(title: 'Title3', content: 'Content3'),
  ];

  void arrangeNewsService() {
    when(() => mockNewsService.getArticles()).thenAnswer((_) async => articles);
  }

  test('assert initial values are correct', () {
    expect(sysUnderTest.articles, []);
    expect(sysUnderTest.isLoading, false);
  });

  group('articles call', () {
    test('get articles with the news service', () async {
      // arrange
      arrangeNewsService();
      //act
      await sysUnderTest.getArticles();
      //assert
      verify(() => mockNewsService.getArticles()).called(1);
    });

    test('''
        indicates loading of data,
        sets articles to the ones from the service,
        inicates that the data is not being loaded anymore
    ''', () async {
      //arrange
      arrangeNewsService();

      //act
      final future = sysUnderTest.getArticles();

      //assert
      expect(sysUnderTest.isLoading, true);

      await future;

      //assert
      expect(sysUnderTest.articles, articles);

      //assert
      expect(sysUnderTest.isLoading, false);
    });
  });
}
