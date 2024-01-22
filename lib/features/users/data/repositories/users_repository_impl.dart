import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:either_dart/either.dart';
import 'package:stackoverflow_users/core/entities/exceptions.dart';

import '../../../../core/entities/sof_response.dart';
import '../../../../core/models/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/users_repository.dart';
import '../datasources/users_network_datasource.dart';

///
///  User repository implementation
///
class SOFUsersRepositoryImpl extends SOFUsersRepository {
  final SOFUsersNetworkDataSource networkDataSource;

  SOFUsersRepositoryImpl({required this.networkDataSource});

  @override
  Future<Either<Failure, List<SOFUser>>> fetchUsers({required int page}) async {
    try {
      SOFResponse response = await networkDataSource.fetchUsers(page: page);
      if (response.isSuccessful && response.body?.isNotEmpty == true) {
        // parse response to domain model
        return Right(_mapUsersResponse(response.body ?? ""));
      }
    } on ServerException catch (error) {
      return Left(getFailure(error));
    } catch (_) {}
    return Left(getDefaultFailure());
  }

  /// Mappers

  List<SOFUser> _mapUsersResponse(String response) {
    var usersList = jsonDecode(response)['items'] as List;
    if (usersList.isNotEmpty) {
      return usersList
          .map((e) => SOFUser(
              id: e["user_id"],
              name: e["display_name"],
              avatar: Uri.parse(e["profile_image"]),
              location: e["location"] ?? "error.location_unavailable".tr(),
              reputation: e["reputation"],
              age: e["age"]))
          .toList();
    }
    return [];
  }
}
