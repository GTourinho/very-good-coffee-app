import 'package:coffee_app/src/coffee/data/services/image_cache_service.dart';
import 'package:coffee_app/src/coffee/domain/entities/coffee.dart';
import 'package:json_annotation/json_annotation.dart';

part 'coffee_model.g.dart';

/// Data model for coffee.
@JsonSerializable()
class CoffeeModel extends Coffee {
  /// {@macro coffee_model}
  const CoffeeModel({
    required super.id,
    required super.imageUrl,
    super.isFavorite = false,
  });

  /// Creates a [CoffeeModel] from a JSON object.
  factory CoffeeModel.fromJson(Map<String, dynamic> json) =>
      _$CoffeeModelFromJson(json);

  /// Creates a model from an entity.
  factory CoffeeModel.fromEntity(Coffee entity) {
    return CoffeeModel(
      id: entity.id,
      imageUrl: entity.imageUrl,
      isFavorite: entity.isFavorite,
    );
  }

  /// Creates a model from API response.
  factory CoffeeModel.fromApiResponse(Map<String, dynamic> json) {
    final file = json['file'];

    if (file == null) {
      throw Exception(
        'Oops! The coffee image is not available right now. Please try again.',
      );
    }

    final fileUrl = file as String;
    final id = fileUrl.split('/').last.split('.').first;

    return CoffeeModel(
      id: id,
      imageUrl: fileUrl,
    );
  }

  /// Converts to JSON.
  Map<String, dynamic> toJson() => _$CoffeeModelToJson(this);

  /// Gets the display image path.
  Future<String> getDisplayImagePath(
    ImageCacheService imageCacheService,
  ) async {
    final cachedPath = await imageCacheService.getCachedImagePath(imageUrl);
    return cachedPath ?? imageUrl;
  }
}
