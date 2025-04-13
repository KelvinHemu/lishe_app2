// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'initial_sign_up_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

InitialSignUpDTO _$InitialSignUpDTOFromJson(Map<String, dynamic> json) {
  return _InitialSignUpDTO.fromJson(json);
}

/// @nodoc
mixin _$InitialSignUpDTO {
  String get username => throw _privateConstructorUsedError;
  String get token => throw _privateConstructorUsedError;

  /// Serializes this InitialSignUpDTO to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InitialSignUpDTO
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InitialSignUpDTOCopyWith<InitialSignUpDTO> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InitialSignUpDTOCopyWith<$Res> {
  factory $InitialSignUpDTOCopyWith(
          InitialSignUpDTO value, $Res Function(InitialSignUpDTO) then) =
      _$InitialSignUpDTOCopyWithImpl<$Res, InitialSignUpDTO>;
  @useResult
  $Res call({String username, String token});
}

/// @nodoc
class _$InitialSignUpDTOCopyWithImpl<$Res, $Val extends InitialSignUpDTO>
    implements $InitialSignUpDTOCopyWith<$Res> {
  _$InitialSignUpDTOCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InitialSignUpDTO
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? username = null,
    Object? token = null,
  }) {
    return _then(_value.copyWith(
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InitialSignUpDTOImplCopyWith<$Res>
    implements $InitialSignUpDTOCopyWith<$Res> {
  factory _$$InitialSignUpDTOImplCopyWith(_$InitialSignUpDTOImpl value,
          $Res Function(_$InitialSignUpDTOImpl) then) =
      __$$InitialSignUpDTOImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String username, String token});
}

/// @nodoc
class __$$InitialSignUpDTOImplCopyWithImpl<$Res>
    extends _$InitialSignUpDTOCopyWithImpl<$Res, _$InitialSignUpDTOImpl>
    implements _$$InitialSignUpDTOImplCopyWith<$Res> {
  __$$InitialSignUpDTOImplCopyWithImpl(_$InitialSignUpDTOImpl _value,
      $Res Function(_$InitialSignUpDTOImpl) _then)
      : super(_value, _then);

  /// Create a copy of InitialSignUpDTO
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? username = null,
    Object? token = null,
  }) {
    return _then(_$InitialSignUpDTOImpl(
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InitialSignUpDTOImpl implements _InitialSignUpDTO {
  const _$InitialSignUpDTOImpl({required this.username, required this.token});

  factory _$InitialSignUpDTOImpl.fromJson(Map<String, dynamic> json) =>
      _$$InitialSignUpDTOImplFromJson(json);

  @override
  final String username;
  @override
  final String token;

  @override
  String toString() {
    return 'InitialSignUpDTO(username: $username, token: $token)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InitialSignUpDTOImpl &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.token, token) || other.token == token));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, username, token);

  /// Create a copy of InitialSignUpDTO
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InitialSignUpDTOImplCopyWith<_$InitialSignUpDTOImpl> get copyWith =>
      __$$InitialSignUpDTOImplCopyWithImpl<_$InitialSignUpDTOImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InitialSignUpDTOImplToJson(
      this,
    );
  }
}

abstract class _InitialSignUpDTO implements InitialSignUpDTO {
  const factory _InitialSignUpDTO(
      {required final String username,
      required final String token}) = _$InitialSignUpDTOImpl;

  factory _InitialSignUpDTO.fromJson(Map<String, dynamic> json) =
      _$InitialSignUpDTOImpl.fromJson;

  @override
  String get username;
  @override
  String get token;

  /// Create a copy of InitialSignUpDTO
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InitialSignUpDTOImplCopyWith<_$InitialSignUpDTOImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
