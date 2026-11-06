import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:rumour/core/errors/exceptions.dart';
import 'package:rumour/features/identity/data/datasources/random_user_remote_datasource.dart';

void main() {
  group('RandomUserRemoteDataSource', () {
    test('fetchRandomUser() returns RandomUserDto when response is 200',
        () async {
      final mockJson = jsonEncode({
        'results': [
          {
            'name': {
              'title': 'Mr',
              'first': 'Arthur',
              'last': 'Dent',
            },
            'login': {
              'username': 'galaxytraveler',
            },
          }
        ],
      });

      final mockClient = MockClient((request) async {
        expect(request.url.toString(), equals('https://randomuser.me/api/'));
        return http.Response(mockJson, 200, headers: {
          'content-type': 'application/json',
        });
      });

      final dataSource = RandomUserRemoteDataSourceImpl(client: mockClient);
      final result = await dataSource.fetchRandomUser();

      expect(result.firstName, equals('Arthur'));
      expect(result.lastName, equals('Dent'));
      expect(result.username, equals('galaxytraveler'));
      expect(result.title, equals('Mr'));
    });

    test('fetchRandomUser() throws ServerException when response status is not 200',
        () async {
      final mockClient = MockClient((request) async {
        return http.Response('Internal Server Error', 500);
      });

      final dataSource = RandomUserRemoteDataSourceImpl(client: mockClient);

      expect(
        () => dataSource.fetchRandomUser(),
        throwsA(isA<ServerException>()),
      );
    });

    test('fetchRandomUser() throws ServerException on empty results array',
        () async {
      final mockJson = jsonEncode({'results': []});
      final mockClient = MockClient((request) async {
        return http.Response(mockJson, 200);
      });

      final dataSource = RandomUserRemoteDataSourceImpl(client: mockClient);

      expect(
        () => dataSource.fetchRandomUser(),
        throwsA(isA<ServerException>()),
      );
    });
  });
}

