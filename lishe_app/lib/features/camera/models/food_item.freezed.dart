// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'food_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FoodItem _$FoodItemFromJson(Map<String, dynamic> json) {
  return _FoodItem.fromJson(json);
}

/// @nodoc
mixin _$FoodItem {
  @JsonKey(name: 'food_id')
  String get foodId => throw _privateConstructorUsedError;
  @JsonKey(name: 'food_name')
  String get foodName => throw _privateConstructorUsedError;
  @JsonKey(name: 'brand_name')
  String get brandName => throw _privateConstructorUsedError;
  @JsonKey(name: 'food_type')
  String get foodType => throw _privateConstructorUsedError;
  @JsonKey(name: 'food_url')
  String get foodUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'calories')
  double get calories => throw _privateConstructorUsedError;
  @JsonKey(name: 'protein')
  double get protein => throw _privateConstructorUsedError;
  @JsonKey(name: 'fat')
  double get fat => throw _privateConstructorUsedError;
  @JsonKey(name: 'carbohydrate')
  double get carbs => throw _privateConstructorUsedError;
  @JsonKey(name: 'fiber')
  double get fiber => throw _privateConstructorUsedError;
  @JsonKey(name: 'sugar')
  double get sugar => throw _privateConstructorUsedError;
  @JsonKey(name: 'sodium')
  double get sodium => throw _privateConstructorUsedError;
  @JsonKey(name: 'potassium')
  double get potassium => throw _privateConstructorUsedError;
  @JsonKey(name: 'cholesterol')
  double get cholesterol => throw _privateConstructorUsedError;
  @JsonKey(name: 'saturated_fat')
  double get saturatedFat => throw _privateConstructorUsedError;
  @JsonKey(name: 'unsaturated_fat')
  double get unsaturatedFat => throw _privateConstructorUsedError;
  @JsonKey(name: 'trans_fat')
  double get transFat => throw _privateConstructorUsedError;
  @JsonKey(name: 'vitamin_a')
  double get vitaminA => throw _privateConstructorUsedError;
  @JsonKey(name: 'vitamin_c')
  double get vitaminC => throw _privateConstructorUsedError;
  @JsonKey(name: 'calcium')
  double get calcium => throw _privateConstructorUsedError;
  @JsonKey(name: 'iron')
  double get iron => throw _privateConstructorUsedError;
  @JsonKey(name: 'serving_size')
  double get servingSize => throw _privateConstructorUsedError;
  @JsonKey(name: 'serving_unit')
  String get servingUnit => throw _privateConstructorUsedError;

  /// Serializes this FoodItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FoodItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FoodItemCopyWith<FoodItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FoodItemCopyWith<$Res> {
  factory $FoodItemCopyWith(FoodItem value, $Res Function(FoodItem) then) =
      _$FoodItemCopyWithImpl<$Res, FoodItem>;
  @useResult
  $Res call(
      {@JsonKey(name: 'food_id') String foodId,
      @JsonKey(name: 'food_name') String foodName,
      @JsonKey(name: 'brand_name') String brandName,
      @JsonKey(name: 'food_type') String foodType,
      @JsonKey(name: 'food_url') String foodUrl,
      @JsonKey(name: 'calories') double calories,
      @JsonKey(name: 'protein') double protein,
      @JsonKey(name: 'fat') double fat,
      @JsonKey(name: 'carbohydrate') double carbs,
      @JsonKey(name: 'fiber') double fiber,
      @JsonKey(name: 'sugar') double sugar,
      @JsonKey(name: 'sodium') double sodium,
      @JsonKey(name: 'potassium') double potassium,
      @JsonKey(name: 'cholesterol') double cholesterol,
      @JsonKey(name: 'saturated_fat') double saturatedFat,
      @JsonKey(name: 'unsaturated_fat') double unsaturatedFat,
      @JsonKey(name: 'trans_fat') double transFat,
      @JsonKey(name: 'vitamin_a') double vitaminA,
      @JsonKey(name: 'vitamin_c') double vitaminC,
      @JsonKey(name: 'calcium') double calcium,
      @JsonKey(name: 'iron') double iron,
      @JsonKey(name: 'serving_size') double servingSize,
      @JsonKey(name: 'serving_unit') String servingUnit});
}

/// @nodoc
class _$FoodItemCopyWithImpl<$Res, $Val extends FoodItem>
    implements $FoodItemCopyWith<$Res> {
  _$FoodItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FoodItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? foodId = null,
    Object? foodName = null,
    Object? brandName = null,
    Object? foodType = null,
    Object? foodUrl = null,
    Object? calories = null,
    Object? protein = null,
    Object? fat = null,
    Object? carbs = null,
    Object? fiber = null,
    Object? sugar = null,
    Object? sodium = null,
    Object? potassium = null,
    Object? cholesterol = null,
    Object? saturatedFat = null,
    Object? unsaturatedFat = null,
    Object? transFat = null,
    Object? vitaminA = null,
    Object? vitaminC = null,
    Object? calcium = null,
    Object? iron = null,
    Object? servingSize = null,
    Object? servingUnit = null,
  }) {
    return _then(_value.copyWith(
      foodId: null == foodId
          ? _value.foodId
          : foodId // ignore: cast_nullable_to_non_nullable
              as String,
      foodName: null == foodName
          ? _value.foodName
          : foodName // ignore: cast_nullable_to_non_nullable
              as String,
      brandName: null == brandName
          ? _value.brandName
          : brandName // ignore: cast_nullable_to_non_nullable
              as String,
      foodType: null == foodType
          ? _value.foodType
          : foodType // ignore: cast_nullable_to_non_nullable
              as String,
      foodUrl: null == foodUrl
          ? _value.foodUrl
          : foodUrl // ignore: cast_nullable_to_non_nullable
              as String,
      calories: null == calories
          ? _value.calories
          : calories // ignore: cast_nullable_to_non_nullable
              as double,
      protein: null == protein
          ? _value.protein
          : protein // ignore: cast_nullable_to_non_nullable
              as double,
      fat: null == fat
          ? _value.fat
          : fat // ignore: cast_nullable_to_non_nullable
              as double,
      carbs: null == carbs
          ? _value.carbs
          : carbs // ignore: cast_nullable_to_non_nullable
              as double,
      fiber: null == fiber
          ? _value.fiber
          : fiber // ignore: cast_nullable_to_non_nullable
              as double,
      sugar: null == sugar
          ? _value.sugar
          : sugar // ignore: cast_nullable_to_non_nullable
              as double,
      sodium: null == sodium
          ? _value.sodium
          : sodium // ignore: cast_nullable_to_non_nullable
              as double,
      potassium: null == potassium
          ? _value.potassium
          : potassium // ignore: cast_nullable_to_non_nullable
              as double,
      cholesterol: null == cholesterol
          ? _value.cholesterol
          : cholesterol // ignore: cast_nullable_to_non_nullable
              as double,
      saturatedFat: null == saturatedFat
          ? _value.saturatedFat
          : saturatedFat // ignore: cast_nullable_to_non_nullable
              as double,
      unsaturatedFat: null == unsaturatedFat
          ? _value.unsaturatedFat
          : unsaturatedFat // ignore: cast_nullable_to_non_nullable
              as double,
      transFat: null == transFat
          ? _value.transFat
          : transFat // ignore: cast_nullable_to_non_nullable
              as double,
      vitaminA: null == vitaminA
          ? _value.vitaminA
          : vitaminA // ignore: cast_nullable_to_non_nullable
              as double,
      vitaminC: null == vitaminC
          ? _value.vitaminC
          : vitaminC // ignore: cast_nullable_to_non_nullable
              as double,
      calcium: null == calcium
          ? _value.calcium
          : calcium // ignore: cast_nullable_to_non_nullable
              as double,
      iron: null == iron
          ? _value.iron
          : iron // ignore: cast_nullable_to_non_nullable
              as double,
      servingSize: null == servingSize
          ? _value.servingSize
          : servingSize // ignore: cast_nullable_to_non_nullable
              as double,
      servingUnit: null == servingUnit
          ? _value.servingUnit
          : servingUnit // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FoodItemImplCopyWith<$Res>
    implements $FoodItemCopyWith<$Res> {
  factory _$$FoodItemImplCopyWith(
          _$FoodItemImpl value, $Res Function(_$FoodItemImpl) then) =
      __$$FoodItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'food_id') String foodId,
      @JsonKey(name: 'food_name') String foodName,
      @JsonKey(name: 'brand_name') String brandName,
      @JsonKey(name: 'food_type') String foodType,
      @JsonKey(name: 'food_url') String foodUrl,
      @JsonKey(name: 'calories') double calories,
      @JsonKey(name: 'protein') double protein,
      @JsonKey(name: 'fat') double fat,
      @JsonKey(name: 'carbohydrate') double carbs,
      @JsonKey(name: 'fiber') double fiber,
      @JsonKey(name: 'sugar') double sugar,
      @JsonKey(name: 'sodium') double sodium,
      @JsonKey(name: 'potassium') double potassium,
      @JsonKey(name: 'cholesterol') double cholesterol,
      @JsonKey(name: 'saturated_fat') double saturatedFat,
      @JsonKey(name: 'unsaturated_fat') double unsaturatedFat,
      @JsonKey(name: 'trans_fat') double transFat,
      @JsonKey(name: 'vitamin_a') double vitaminA,
      @JsonKey(name: 'vitamin_c') double vitaminC,
      @JsonKey(name: 'calcium') double calcium,
      @JsonKey(name: 'iron') double iron,
      @JsonKey(name: 'serving_size') double servingSize,
      @JsonKey(name: 'serving_unit') String servingUnit});
}

/// @nodoc
class __$$FoodItemImplCopyWithImpl<$Res>
    extends _$FoodItemCopyWithImpl<$Res, _$FoodItemImpl>
    implements _$$FoodItemImplCopyWith<$Res> {
  __$$FoodItemImplCopyWithImpl(
      _$FoodItemImpl _value, $Res Function(_$FoodItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of FoodItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? foodId = null,
    Object? foodName = null,
    Object? brandName = null,
    Object? foodType = null,
    Object? foodUrl = null,
    Object? calories = null,
    Object? protein = null,
    Object? fat = null,
    Object? carbs = null,
    Object? fiber = null,
    Object? sugar = null,
    Object? sodium = null,
    Object? potassium = null,
    Object? cholesterol = null,
    Object? saturatedFat = null,
    Object? unsaturatedFat = null,
    Object? transFat = null,
    Object? vitaminA = null,
    Object? vitaminC = null,
    Object? calcium = null,
    Object? iron = null,
    Object? servingSize = null,
    Object? servingUnit = null,
  }) {
    return _then(_$FoodItemImpl(
      foodId: null == foodId
          ? _value.foodId
          : foodId // ignore: cast_nullable_to_non_nullable
              as String,
      foodName: null == foodName
          ? _value.foodName
          : foodName // ignore: cast_nullable_to_non_nullable
              as String,
      brandName: null == brandName
          ? _value.brandName
          : brandName // ignore: cast_nullable_to_non_nullable
              as String,
      foodType: null == foodType
          ? _value.foodType
          : foodType // ignore: cast_nullable_to_non_nullable
              as String,
      foodUrl: null == foodUrl
          ? _value.foodUrl
          : foodUrl // ignore: cast_nullable_to_non_nullable
              as String,
      calories: null == calories
          ? _value.calories
          : calories // ignore: cast_nullable_to_non_nullable
              as double,
      protein: null == protein
          ? _value.protein
          : protein // ignore: cast_nullable_to_non_nullable
              as double,
      fat: null == fat
          ? _value.fat
          : fat // ignore: cast_nullable_to_non_nullable
              as double,
      carbs: null == carbs
          ? _value.carbs
          : carbs // ignore: cast_nullable_to_non_nullable
              as double,
      fiber: null == fiber
          ? _value.fiber
          : fiber // ignore: cast_nullable_to_non_nullable
              as double,
      sugar: null == sugar
          ? _value.sugar
          : sugar // ignore: cast_nullable_to_non_nullable
              as double,
      sodium: null == sodium
          ? _value.sodium
          : sodium // ignore: cast_nullable_to_non_nullable
              as double,
      potassium: null == potassium
          ? _value.potassium
          : potassium // ignore: cast_nullable_to_non_nullable
              as double,
      cholesterol: null == cholesterol
          ? _value.cholesterol
          : cholesterol // ignore: cast_nullable_to_non_nullable
              as double,
      saturatedFat: null == saturatedFat
          ? _value.saturatedFat
          : saturatedFat // ignore: cast_nullable_to_non_nullable
              as double,
      unsaturatedFat: null == unsaturatedFat
          ? _value.unsaturatedFat
          : unsaturatedFat // ignore: cast_nullable_to_non_nullable
              as double,
      transFat: null == transFat
          ? _value.transFat
          : transFat // ignore: cast_nullable_to_non_nullable
              as double,
      vitaminA: null == vitaminA
          ? _value.vitaminA
          : vitaminA // ignore: cast_nullable_to_non_nullable
              as double,
      vitaminC: null == vitaminC
          ? _value.vitaminC
          : vitaminC // ignore: cast_nullable_to_non_nullable
              as double,
      calcium: null == calcium
          ? _value.calcium
          : calcium // ignore: cast_nullable_to_non_nullable
              as double,
      iron: null == iron
          ? _value.iron
          : iron // ignore: cast_nullable_to_non_nullable
              as double,
      servingSize: null == servingSize
          ? _value.servingSize
          : servingSize // ignore: cast_nullable_to_non_nullable
              as double,
      servingUnit: null == servingUnit
          ? _value.servingUnit
          : servingUnit // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FoodItemImpl extends _FoodItem {
  const _$FoodItemImpl(
      {@JsonKey(name: 'food_id') required this.foodId,
      @JsonKey(name: 'food_name') required this.foodName,
      @JsonKey(name: 'brand_name') required this.brandName,
      @JsonKey(name: 'food_type') required this.foodType,
      @JsonKey(name: 'food_url') required this.foodUrl,
      @JsonKey(name: 'calories') required this.calories,
      @JsonKey(name: 'protein') required this.protein,
      @JsonKey(name: 'fat') required this.fat,
      @JsonKey(name: 'carbohydrate') required this.carbs,
      @JsonKey(name: 'fiber') required this.fiber,
      @JsonKey(name: 'sugar') required this.sugar,
      @JsonKey(name: 'sodium') required this.sodium,
      @JsonKey(name: 'potassium') required this.potassium,
      @JsonKey(name: 'cholesterol') required this.cholesterol,
      @JsonKey(name: 'saturated_fat') required this.saturatedFat,
      @JsonKey(name: 'unsaturated_fat') required this.unsaturatedFat,
      @JsonKey(name: 'trans_fat') required this.transFat,
      @JsonKey(name: 'vitamin_a') required this.vitaminA,
      @JsonKey(name: 'vitamin_c') required this.vitaminC,
      @JsonKey(name: 'calcium') required this.calcium,
      @JsonKey(name: 'iron') required this.iron,
      @JsonKey(name: 'serving_size') required this.servingSize,
      @JsonKey(name: 'serving_unit') required this.servingUnit})
      : super._();

  factory _$FoodItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$FoodItemImplFromJson(json);

  @override
  @JsonKey(name: 'food_id')
  final String foodId;
  @override
  @JsonKey(name: 'food_name')
  final String foodName;
  @override
  @JsonKey(name: 'brand_name')
  final String brandName;
  @override
  @JsonKey(name: 'food_type')
  final String foodType;
  @override
  @JsonKey(name: 'food_url')
  final String foodUrl;
  @override
  @JsonKey(name: 'calories')
  final double calories;
  @override
  @JsonKey(name: 'protein')
  final double protein;
  @override
  @JsonKey(name: 'fat')
  final double fat;
  @override
  @JsonKey(name: 'carbohydrate')
  final double carbs;
  @override
  @JsonKey(name: 'fiber')
  final double fiber;
  @override
  @JsonKey(name: 'sugar')
  final double sugar;
  @override
  @JsonKey(name: 'sodium')
  final double sodium;
  @override
  @JsonKey(name: 'potassium')
  final double potassium;
  @override
  @JsonKey(name: 'cholesterol')
  final double cholesterol;
  @override
  @JsonKey(name: 'saturated_fat')
  final double saturatedFat;
  @override
  @JsonKey(name: 'unsaturated_fat')
  final double unsaturatedFat;
  @override
  @JsonKey(name: 'trans_fat')
  final double transFat;
  @override
  @JsonKey(name: 'vitamin_a')
  final double vitaminA;
  @override
  @JsonKey(name: 'vitamin_c')
  final double vitaminC;
  @override
  @JsonKey(name: 'calcium')
  final double calcium;
  @override
  @JsonKey(name: 'iron')
  final double iron;
  @override
  @JsonKey(name: 'serving_size')
  final double servingSize;
  @override
  @JsonKey(name: 'serving_unit')
  final String servingUnit;

  @override
  String toString() {
    return 'FoodItem(foodId: $foodId, foodName: $foodName, brandName: $brandName, foodType: $foodType, foodUrl: $foodUrl, calories: $calories, protein: $protein, fat: $fat, carbs: $carbs, fiber: $fiber, sugar: $sugar, sodium: $sodium, potassium: $potassium, cholesterol: $cholesterol, saturatedFat: $saturatedFat, unsaturatedFat: $unsaturatedFat, transFat: $transFat, vitaminA: $vitaminA, vitaminC: $vitaminC, calcium: $calcium, iron: $iron, servingSize: $servingSize, servingUnit: $servingUnit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FoodItemImpl &&
            (identical(other.foodId, foodId) || other.foodId == foodId) &&
            (identical(other.foodName, foodName) ||
                other.foodName == foodName) &&
            (identical(other.brandName, brandName) ||
                other.brandName == brandName) &&
            (identical(other.foodType, foodType) ||
                other.foodType == foodType) &&
            (identical(other.foodUrl, foodUrl) || other.foodUrl == foodUrl) &&
            (identical(other.calories, calories) ||
                other.calories == calories) &&
            (identical(other.protein, protein) || other.protein == protein) &&
            (identical(other.fat, fat) || other.fat == fat) &&
            (identical(other.carbs, carbs) || other.carbs == carbs) &&
            (identical(other.fiber, fiber) || other.fiber == fiber) &&
            (identical(other.sugar, sugar) || other.sugar == sugar) &&
            (identical(other.sodium, sodium) || other.sodium == sodium) &&
            (identical(other.potassium, potassium) ||
                other.potassium == potassium) &&
            (identical(other.cholesterol, cholesterol) ||
                other.cholesterol == cholesterol) &&
            (identical(other.saturatedFat, saturatedFat) ||
                other.saturatedFat == saturatedFat) &&
            (identical(other.unsaturatedFat, unsaturatedFat) ||
                other.unsaturatedFat == unsaturatedFat) &&
            (identical(other.transFat, transFat) ||
                other.transFat == transFat) &&
            (identical(other.vitaminA, vitaminA) ||
                other.vitaminA == vitaminA) &&
            (identical(other.vitaminC, vitaminC) ||
                other.vitaminC == vitaminC) &&
            (identical(other.calcium, calcium) || other.calcium == calcium) &&
            (identical(other.iron, iron) || other.iron == iron) &&
            (identical(other.servingSize, servingSize) ||
                other.servingSize == servingSize) &&
            (identical(other.servingUnit, servingUnit) ||
                other.servingUnit == servingUnit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        foodId,
        foodName,
        brandName,
        foodType,
        foodUrl,
        calories,
        protein,
        fat,
        carbs,
        fiber,
        sugar,
        sodium,
        potassium,
        cholesterol,
        saturatedFat,
        unsaturatedFat,
        transFat,
        vitaminA,
        vitaminC,
        calcium,
        iron,
        servingSize,
        servingUnit
      ]);

  /// Create a copy of FoodItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FoodItemImplCopyWith<_$FoodItemImpl> get copyWith =>
      __$$FoodItemImplCopyWithImpl<_$FoodItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FoodItemImplToJson(
      this,
    );
  }
}

abstract class _FoodItem extends FoodItem {
  const factory _FoodItem(
      {@JsonKey(name: 'food_id') required final String foodId,
      @JsonKey(name: 'food_name') required final String foodName,
      @JsonKey(name: 'brand_name') required final String brandName,
      @JsonKey(name: 'food_type') required final String foodType,
      @JsonKey(name: 'food_url') required final String foodUrl,
      @JsonKey(name: 'calories') required final double calories,
      @JsonKey(name: 'protein') required final double protein,
      @JsonKey(name: 'fat') required final double fat,
      @JsonKey(name: 'carbohydrate') required final double carbs,
      @JsonKey(name: 'fiber') required final double fiber,
      @JsonKey(name: 'sugar') required final double sugar,
      @JsonKey(name: 'sodium') required final double sodium,
      @JsonKey(name: 'potassium') required final double potassium,
      @JsonKey(name: 'cholesterol') required final double cholesterol,
      @JsonKey(name: 'saturated_fat') required final double saturatedFat,
      @JsonKey(name: 'unsaturated_fat') required final double unsaturatedFat,
      @JsonKey(name: 'trans_fat') required final double transFat,
      @JsonKey(name: 'vitamin_a') required final double vitaminA,
      @JsonKey(name: 'vitamin_c') required final double vitaminC,
      @JsonKey(name: 'calcium') required final double calcium,
      @JsonKey(name: 'iron') required final double iron,
      @JsonKey(name: 'serving_size') required final double servingSize,
      @JsonKey(name: 'serving_unit')
      required final String servingUnit}) = _$FoodItemImpl;
  const _FoodItem._() : super._();

  factory _FoodItem.fromJson(Map<String, dynamic> json) =
      _$FoodItemImpl.fromJson;

  @override
  @JsonKey(name: 'food_id')
  String get foodId;
  @override
  @JsonKey(name: 'food_name')
  String get foodName;
  @override
  @JsonKey(name: 'brand_name')
  String get brandName;
  @override
  @JsonKey(name: 'food_type')
  String get foodType;
  @override
  @JsonKey(name: 'food_url')
  String get foodUrl;
  @override
  @JsonKey(name: 'calories')
  double get calories;
  @override
  @JsonKey(name: 'protein')
  double get protein;
  @override
  @JsonKey(name: 'fat')
  double get fat;
  @override
  @JsonKey(name: 'carbohydrate')
  double get carbs;
  @override
  @JsonKey(name: 'fiber')
  double get fiber;
  @override
  @JsonKey(name: 'sugar')
  double get sugar;
  @override
  @JsonKey(name: 'sodium')
  double get sodium;
  @override
  @JsonKey(name: 'potassium')
  double get potassium;
  @override
  @JsonKey(name: 'cholesterol')
  double get cholesterol;
  @override
  @JsonKey(name: 'saturated_fat')
  double get saturatedFat;
  @override
  @JsonKey(name: 'unsaturated_fat')
  double get unsaturatedFat;
  @override
  @JsonKey(name: 'trans_fat')
  double get transFat;
  @override
  @JsonKey(name: 'vitamin_a')
  double get vitaminA;
  @override
  @JsonKey(name: 'vitamin_c')
  double get vitaminC;
  @override
  @JsonKey(name: 'calcium')
  double get calcium;
  @override
  @JsonKey(name: 'iron')
  double get iron;
  @override
  @JsonKey(name: 'serving_size')
  double get servingSize;
  @override
  @JsonKey(name: 'serving_unit')
  String get servingUnit;

  /// Create a copy of FoodItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FoodItemImplCopyWith<_$FoodItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
