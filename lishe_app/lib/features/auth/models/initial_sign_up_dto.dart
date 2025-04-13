import 'package:freezed_annotation/freezed_annotation.dart';

part 'initial_sign_up_dto.freezed.dart';
part 'initial_sign_up_dto.g.dart';

@freezed
class InitialSignUpDTO with _$InitialSignUpDTO {
  const factory InitialSignUpDTO({
    required String username,
    required String token,
  }) = _InitialSignUpDTO;

  factory InitialSignUpDTO.fromJson(Map<String, dynamic> json) =>
      _$InitialSignUpDTOFromJson(json);
}
