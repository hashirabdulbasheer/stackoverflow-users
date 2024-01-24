import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stackoverflow_users/features/users/domain/repositories/bookmarks_repository.dart';

import '../../../../utils/test_utils.dart';

void main() {
  test('Fetching users should return an empty list if there are no bookmarks',
      () async {
    SOFBookmarksRepository repository = TestUtils.makeBookmarksRepository();

    Either result = await repository.fetchBookmarks();

    expect(result.isLeft, false);
    expect(result.isRight, true);
    expect(result.right, []);
  });

  test('Saving a bookmark should return the saved bookmark', () async {
    SOFBookmarksRepository repository = TestUtils.makeBookmarksRepository();

    Either result = await repository.saveBookmark(TestUtils.user);
    expect(result.isLeft, false);
    expect(result.isRight, true);
    expect(result.right, true);

    Either result2 = await repository.fetchBookmarks();

    expect(result2.isLeft, false);
    expect(result2.isRight, true);
    expect(result2.right, [TestUtils.user]);
  });

  test('Deleting a bookmark should remove the bookmark', () async {
    SOFBookmarksRepository repository = TestUtils.makeBookmarksRepository();

    Either result = await repository.saveBookmark(TestUtils.user);
    expect(result.isLeft, false);
    expect(result.isRight, true);
    expect(result.right, true);

    Either result2 = await repository.fetchBookmarks();

    expect(result2.isLeft, false);
    expect(result2.isRight, true);
    expect(result2.right, [TestUtils.user]);

    Either result3 = await repository.deleteBookmark(TestUtils.user);
    expect(result3.isLeft, false);
    expect(result3.isRight, true);
    expect(result3.right, true);

    Either result4 = await repository.fetchBookmarks();

    expect(result4.isLeft, false);
    expect(result4.isRight, true);
    expect(result4.right, []);
  });
}
