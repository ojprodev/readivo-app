import 'package:isar/isar.dart';

part 'review.g.dart';

@collection
@Name('reviews')
class Review{
  Id id = Isar.autoIncrement;
  late int? rating;
  late String? review;
  late DateTime? updatedAt;
  late DateTime createdAt;
}