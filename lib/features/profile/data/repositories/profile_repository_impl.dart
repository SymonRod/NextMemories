import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../features/auth/domain/entities/server_config.dart';
import '../../domain/entities/user_info.dart';
import '../../domain/repositories/i_profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';
import '../models/user_info_model.dart';

class ProfileRepositoryImpl implements IProfileRepository {
  final ProfileRemoteDatasource _datasource;
  const ProfileRepositoryImpl(this._datasource);

  factory ProfileRepositoryImpl.fromConfig(ServerConfig config) =>
      ProfileRepositoryImpl(ProfileRemoteDatasource(config));

  @override
  Future<Either<Failure, UserInfo>> getUserInfo() async {
    try {
      final model = await _datasource.getUserInfo();
      return Right(_toEntity(model));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.unknown) {
        return const Left(NetworkFailure('Impossibile raggiungere il server'));
      }
      return Left(NetworkFailure(e.message ?? 'Errore di rete'));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  UserInfo _toEntity(UserInfoModel model) => UserInfo(
        id: model.id,
        displayName: model.displayName,
        email: (model.email?.isEmpty ?? true) ? null : model.email,
        quota: QuotaInfo(
          used: model.quota.used,
          total: model.quota.total,
          relative: model.quota.relative,
          unlimited: model.quota.quota < 0,
        ),
      );
}
