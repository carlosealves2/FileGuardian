import 'package:get_it/get_it.dart';

import 'package:guardian_ui/core/grpc/grpc_channel.dart';
import 'package:guardian_ui/features/dashboard/data/datasources/upload_remote_datasource.dart';
import 'package:guardian_ui/features/dashboard/data/repositories/upload_repository_impl.dart';
import 'package:guardian_ui/features/dashboard/domain/repositories/upload_repository.dart';
import 'package:guardian_ui/features/dashboard/domain/usecases/cancel_process.dart';
import 'package:guardian_ui/features/dashboard/domain/usecases/list_processes.dart';
import 'package:guardian_ui/features/dashboard/domain/usecases/pause_process.dart';
import 'package:guardian_ui/features/dashboard/domain/usecases/resume_process.dart';
import 'package:guardian_ui/features/dashboard/domain/usecases/upload_file.dart';
import 'package:guardian_ui/features/dashboard/domain/usecases/upload_folder.dart';
import 'package:guardian_ui/features/dashboard/presentation/bloc/process_list_bloc.dart';
import 'package:guardian_ui/features/dashboard/presentation/bloc/process_list_event.dart';
import 'package:guardian_ui/features/dashboard/presentation/bloc/upload_bloc.dart';
import 'package:guardian_ui/features/process_detail/data/datasources/process_detail_remote_datasource.dart';
import 'package:guardian_ui/features/process_detail/data/repositories/process_detail_repository_impl.dart';
import 'package:guardian_ui/features/process_detail/domain/repositories/process_detail_repository.dart';
import 'package:guardian_ui/features/process_detail/domain/usecases/get_process_detail.dart';
import 'package:guardian_ui/features/process_detail/presentation/bloc/process_detail_bloc.dart';
import 'package:guardian_ui/features/settings/data/datasources/config_remote_datasource.dart';
import 'package:guardian_ui/features/settings/data/repositories/config_repository_impl.dart';
import 'package:guardian_ui/features/settings/domain/repositories/config_repository.dart';
import 'package:guardian_ui/features/settings/domain/usecases/get_config.dart';
import 'package:guardian_ui/features/settings/domain/usecases/list_providers.dart';
import 'package:guardian_ui/features/settings/domain/usecases/update_provider_config.dart';
import 'package:guardian_ui/features/settings/presentation/bloc/settings_bloc.dart';

final getIt = GetIt.instance;

void configureDependencies() {
  // ── Core ──────────────────────────────────────────────
  getIt.registerLazySingleton<GrpcChannel>(() => GrpcChannel());

  // ── Settings ──────────────────────────────────────────
  getIt.registerLazySingleton<ConfigRemoteDataSource>(
    () => ConfigRemoteDataSource(
      client: getIt<GrpcChannel>().configServiceClient,
    ),
  );

  getIt.registerLazySingleton<ConfigRepository>(
    () => ConfigRepositoryImpl(remoteDataSource: getIt<ConfigRemoteDataSource>()),
  );

  getIt.registerLazySingleton(() => GetConfig(repository: getIt<ConfigRepository>()));
  getIt.registerLazySingleton(() => ListProviders(repository: getIt<ConfigRepository>()));
  getIt.registerLazySingleton(
    () => UpdateProviderConfig(repository: getIt<ConfigRepository>()),
  );

  getIt.registerFactory(
    () => SettingsBloc(
      getConfig: getIt<GetConfig>(),
      listProviders: getIt<ListProviders>(),
      updateProviderConfig: getIt<UpdateProviderConfig>(),
    ),
  );

  // ── Dashboard ─────────────────────────────────────────
  getIt.registerLazySingleton<UploadRemoteDataSource>(
    () => UploadRemoteDataSource(
      client: getIt<GrpcChannel>().uploadServiceClient,
    ),
  );

  getIt.registerLazySingleton<UploadRepository>(
    () => UploadRepositoryImpl(remoteDataSource: getIt<UploadRemoteDataSource>()),
  );

  getIt.registerLazySingleton(() => ListProcesses(repository: getIt<UploadRepository>()));
  getIt.registerLazySingleton(() => UploadFile(repository: getIt<UploadRepository>()));
  getIt.registerLazySingleton(() => UploadFolder(repository: getIt<UploadRepository>()));
  getIt.registerLazySingleton(() => PauseProcess(repository: getIt<UploadRepository>()));
  getIt.registerLazySingleton(() => ResumeProcess(repository: getIt<UploadRepository>()));
  getIt.registerLazySingleton(() => CancelProcess(repository: getIt<UploadRepository>()));

  getIt.registerLazySingleton(
    () => ProcessListBloc(
      listProcesses: getIt<ListProcesses>(),
    ),
  );

  getIt.registerLazySingleton(() {
    final uploadBloc = UploadBloc(
      uploadFile: getIt<UploadFile>(),
      uploadFolder: getIt<UploadFolder>(),
      pauseProcess: getIt<PauseProcess>(),
      resumeProcess: getIt<ResumeProcess>(),
      cancelProcess: getIt<CancelProcess>(),
    );

    uploadBloc.onProcessChanged = () {
      getIt<ProcessListBloc>().add(const ProcessListRefreshRequested());
    };

    return uploadBloc;
  });

  // ── Process Detail ────────────────────────────────────
  getIt.registerLazySingleton<ProcessDetailRemoteDataSource>(
    () => ProcessDetailRemoteDataSource(
      client: getIt<GrpcChannel>().uploadServiceClient,
    ),
  );

  getIt.registerLazySingleton<ProcessDetailRepository>(
    () => ProcessDetailRepositoryImpl(
      remoteDataSource: getIt<ProcessDetailRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton(
    () => GetProcessDetail(repository: getIt<ProcessDetailRepository>()),
  );

  getIt.registerFactoryParam<ProcessDetailBloc, String, void>(
    (processId, _) => ProcessDetailBloc(
      processId: processId,
      getProcessDetail: getIt<GetProcessDetail>(),
      pauseProcess: getIt<PauseProcess>(),
      resumeProcess: getIt<ResumeProcess>(),
      cancelProcess: getIt<CancelProcess>(),
      uploadBloc: getIt<UploadBloc>(),
    ),
  );
}
