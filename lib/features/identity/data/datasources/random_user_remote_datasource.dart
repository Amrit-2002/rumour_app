import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/errors/exceptions.dart';

class RandomUserDto {
  final String firstName;
  final String lastName;
  final String username;
  final String? title;

  const RandomUserDto({
    required this.firstName,
    required this.lastName,
    required this.username,
    this.title,
  });

  factory RandomUserDto.fromJson(Map<String, dynamic> json) {
    final name = json['name'] as Map<String, dynamic>? ?? {};
    final login = json['login'] as Map<String, dynamic>? ?? {};

    return RandomUserDto(
      firstName: (name['first'] as String?)?.trim() ?? '',
      lastName: (name['last'] as String?)?.trim() ?? '',
      username: (login['username'] as String?)?.trim() ?? '',
      title: (name['title'] as String?)?.trim(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': {
        'first': firstName,
        'last': lastName,
        if (title != null) 'title': title,
      },
      'login': {
        'username': username,
      },
    };
  }
}

abstract class RandomUserRemoteDataSource {
  factory RandomUserRemoteDataSource({http.Client? client}) =
      RandomUserRemoteDataSourceImpl;

  /// Fetches a random user from https://randomuser.me/api/
  Future<RandomUserDto> fetchRandomUser();
}

class RandomUserRemoteDataSourceImpl implements RandomUserRemoteDataSource {
  final http.Client _client;

  RandomUserRemoteDataSourceImpl({http.Client? client})
      : _client = client ?? http.Client();

  static const String endpoint = 'https://randomuser.me/api/';

  @override
  Future<RandomUserDto> fetchRandomUser() async {
    try {
      final response = await _client.get(
        Uri.parse(endpoint),
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded =
            jsonDecode(response.body) as Map<String, dynamic>;
        final List<dynamic>? results = decoded['results'] as List<dynamic>?;
        if (results != null && results.isNotEmpty) {
          final firstItem = results.first as Map<String, dynamic>;
          return RandomUserDto.fromJson(firstItem);
        }
        throw const ServerException(
          'RandomUser API returned empty results list.',
        );
      } else {
        throw ServerException(
          'RandomUser API request failed with status: ${response.statusCode}',
        );
      }
    } on AppException {
      rethrow;
    } catch (e) {
      throw NetworkException(
        'Failed to connect to RandomUser API: $e',
      );
    }
  }
}

