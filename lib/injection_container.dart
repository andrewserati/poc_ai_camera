import 'package:get_it/get_it.dart';
import 'package:poc_ai_camera/tensor_flow_service.dart';

GetIt getIt = GetIt.instance;

final class InjectionContainer {
  static void register() {
    getIt.registerLazySingleton<TensorFlowService>(() => TensorFlowService());
  }

  static void unregister() {
    getIt.unregister<TensorFlowService>();
  }
}
