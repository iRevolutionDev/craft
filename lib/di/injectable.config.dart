// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:craft/app/bloc/authentication_bloc/authentication_bloc.dart'
    as _i303;
import 'package:craft/app/bloc/chat_bloc/chat_bloc.dart' as _i118;
import 'package:craft/app/bloc/connection_bloc/connection_bloc.dart' as _i993;
import 'package:craft/app/bloc/group_bloc/group_bloc.dart' as _i526;
import 'package:craft/app/repository/authentication_repository/repo/authentication_repo.dart'
    as _i652;
import 'package:craft/app/repository/chat_repository/repo/chat_repo.dart'
    as _i1035;
import 'package:craft/app/repository/connection_repository/repo/connection_repo.dart'
    as _i258;
import 'package:craft/app/repository/groups_repository/repo/groups_repo.dart'
    as _i110;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i652.AuthenticationRepo>(() => _i652.AuthenticationRepo());
    gh.factory<_i1035.ChatRepo>(() => _i1035.ChatRepo());
    gh.factory<_i258.ConnectionRepository>(() => _i258.ConnectionRepository());
    gh.factory<_i110.GroupsRepo>(() => _i110.GroupsRepo());
    gh.factory<_i993.ConnectionBloc>(
        () => _i993.ConnectionBloc(gh<_i258.ConnectionRepository>()));
    gh.factory<_i118.ChatBloc>(
        () => _i118.ChatBloc(chatRepository: gh<_i1035.ChatRepo>()));
    gh.factory<_i303.AuthenticationBloc>(
        () => _i303.AuthenticationBloc(gh<_i652.AuthenticationRepo>()));
    gh.factory<_i526.GroupBloc>(() => _i526.GroupBloc(gh<_i110.GroupsRepo>()));
    return this;
  }
}
