import 'package:equatable/equatable.dart';

/// {@template coffee}
/// A coffee image entity representing a coffee picture.
/// {@endtemplate}
class Coffee extends Equatable {
  /// {@macro coffee}
  const Coffee({
    required this.id,
    required this.imageUrl,
    this.isFavorite = false,
  });

  /// The unique identifier for this coffee image.
  final String id;

  /// The URL of the coffee image.
  final String imageUrl;

  /// Whether this coffee image is marked as favorite.
  final bool isFavorite;

  /// Creates a copy of this [Coffee] with updated values.
  Coffee copyWith({
    String? id,
    String? imageUrl,
    bool? isFavorite,
  }) {
    return Coffee(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [id, imageUrl, isFavorite];
}
