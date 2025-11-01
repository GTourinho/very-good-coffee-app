/// A repository for managing coffee data and business logic.
library;

export 'src/data/datasources/coffee_local_datasource.dart';
export 'src/data/datasources/coffee_local_datasource_impl.dart';
export 'src/data/datasources/coffee_remote_datasource.dart';
export 'src/data/datasources/coffee_remote_datasource_impl.dart';
export 'src/data/models/coffee_model.dart';
export 'src/data/repositories/coffee_repository_impl.dart';
export 'src/data/services/http_client.dart';
export 'src/data/services/image_cache_service.dart';
export 'src/data/services/image_cache_service_impl.dart';
export 'src/data/services/image_processor.dart';
export 'src/data/services/image_processor_impl.dart';
export 'src/domain/entities/coffee.dart';
export 'src/domain/repositories/coffee_repository.dart';
export 'src/domain/usecases/get_favorite_coffees.dart';
export 'src/domain/usecases/get_random_coffee.dart';
export 'src/domain/usecases/toggle_favorite_coffee.dart';
