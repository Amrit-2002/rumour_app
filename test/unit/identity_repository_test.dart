import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rumour/core/services/storage_service.dart';
import 'package:rumour/features/identity/data/datasources/random_user_remote_datasource.dart';
import 'package:rumour/features/identity/data/repositories/identity_repository_impl.dart';

class FakeRandomUserRemoteDataSource implements RandomUserRemoteDataSource {
  int callCount = 0;
  RandomUserDto nextResponse;
  bool shouldThrow;

  FakeRandomUserRemoteDataSource({
    this.nextResponse = const RandomUserDto(
      firstName: 'Brave',
      lastName: 'Badger',
      username: 'bravebadger',
    ),
    this.shouldThrow = false,
  });

  @override
  Future<RandomUserDto> fetchRandomUser() async {
    callCount++;
    if (shouldThrow) {
      throw Exception('Network error');
    }
    return nextResponse;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('IdentityRepositoryImpl Flow Tests', () {
    late StorageService storageService;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      storageService = StorageService(prefs);
    });

    test(
        'Step 3 & 4 & 5: When no local identity exists, calls RandomUser API and persists identity',
        () async {
      final fakeDataSource = FakeRandomUserRemoteDataSource(
        nextResponse: const RandomUserDto(
          firstName: 'gaetan',
          lastName: 'bourgeois',
          username: 'gaetanb',
        ),
      );

      final repository = IdentityRepositoryImpl(
        storageService,
        remoteDataSource: fakeDataSource,
      );

      final identity = await repository.getOrCreateIdentity(
        roomCode: '581290',
        uid: 'user_1',
      );

      expect(fakeDataSource.callCount, equals(1));
      // Formatted into capitalized format
      expect(identity.adjective, equals('Gaetan'));
      expect(identity.animal, equals('Bourgeois'));
      expect(identity.fullName, equals('Gaetan Bourgeois'));
      expect(identity.isRestored, isFalse);

      // Verify persisted locally
      final stored = await repository.getStoredIdentity('581290');
      expect(stored, isNotNull);
      expect(stored!.fullName, equals('Gaetan Bourgeois'));
    });

    test(
        'Step 1 & 2: When local identity exists, reuses it without calling RandomUser API',
        () async {
      final fakeDataSource = FakeRandomUserRemoteDataSource(
        nextResponse: const RandomUserDto(
          firstName: 'First',
          lastName: 'Call',
          username: 'firstcall',
        ),
      );

      final repository = IdentityRepositoryImpl(
        storageService,
        remoteDataSource: fakeDataSource,
      );

      // First call -> calls API
      final firstIdentity = await repository.getOrCreateIdentity(
        roomCode: 'ROOM01',
        uid: 'uid_initial',
      );
      expect(fakeDataSource.callCount, equals(1));
      expect(firstIdentity.fullName, equals('First Call'));

      // Change API response to verify it is NOT called again
      fakeDataSource.nextResponse = const RandomUserDto(
        firstName: 'Second',
        lastName: 'ShouldNotBeCalled',
        username: 'second',
      );

      // Second call for the same room -> reuses local identity without API call
      final secondIdentity = await repository.getOrCreateIdentity(
        roomCode: 'ROOM01',
        uid: 'uid_refreshed',
      );

      expect(fakeDataSource.callCount, equals(1)); // Still 1! No new request
      expect(secondIdentity.fullName, equals('First Call'));
      expect(secondIdentity.isRestored, isTrue);
      expect(secondIdentity.uid, equals('uid_refreshed'));
    });

    test('Throws exception when RandomUser API fails', () async {
      final fakeDataSource = FakeRandomUserRemoteDataSource(shouldThrow: true);

      final repository = IdentityRepositoryImpl(
        storageService,
        remoteDataSource: fakeDataSource,
      );

      expect(
        () => repository.getOrCreateIdentity(
          roomCode: 'FAIL01',
          uid: 'user_fallback',
        ),
        throwsA(isA<Exception>()),
      );
      expect(fakeDataSource.callCount, equals(1));
    });
  });
}

