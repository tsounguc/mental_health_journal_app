import 'package:equatable/equatable.dart';
import 'package:mental_health_journal_app/core/enums/update_user_action.dart';
import 'package:mental_health_journal_app/core/use_case.dart';
import 'package:mental_health_journal_app/core/utils/typedefs.dart';
import 'package:mental_health_journal_app/features/auth/domain/repositories/auth_repository.dart';

class UpdateUser implements UseCaseWithParams<void, UpdateUserParams> {
  const UpdateUser(this._repository);

  final AuthRepository _repository;

  @override
  ResultVoid call(UpdateUserParams params) => _repository.updateUser(
        action: params.action,
        userData: params.userData,
      );
}

class UpdateUserParams extends Equatable {
  const UpdateUserParams({
    required this.action,
    required this.userData,
  });

  const UpdateUserParams.empty()
      : this(
          action: UpdateUserAction.name,
          userData: '_empty.name',
        );

  final UpdateUserAction action;
  final String userData;

  @override
  List<Object?> get props => [action, userData];
}
