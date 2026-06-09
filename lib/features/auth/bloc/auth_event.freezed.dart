// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AuthEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String email) emailChanged,
    required TResult Function(String password) passwordChanged,
    required TResult Function(String confirmPassword) confirmPasswordChanged,
    required TResult Function() passwordVisibilityToggled,
    required TResult Function() confirmPasswordVisibilityToggled,
    required TResult Function() loginSubmitted,
    required TResult Function() registerSubmitted,
    required TResult Function() googleSignInRequested,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String email)? emailChanged,
    TResult? Function(String password)? passwordChanged,
    TResult? Function(String confirmPassword)? confirmPasswordChanged,
    TResult? Function()? passwordVisibilityToggled,
    TResult? Function()? confirmPasswordVisibilityToggled,
    TResult? Function()? loginSubmitted,
    TResult? Function()? registerSubmitted,
    TResult? Function()? googleSignInRequested,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email)? emailChanged,
    TResult Function(String password)? passwordChanged,
    TResult Function(String confirmPassword)? confirmPasswordChanged,
    TResult Function()? passwordVisibilityToggled,
    TResult Function()? confirmPasswordVisibilityToggled,
    TResult Function()? loginSubmitted,
    TResult Function()? registerSubmitted,
    TResult Function()? googleSignInRequested,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthEmailChanged value) emailChanged,
    required TResult Function(AuthPasswordChanged value) passwordChanged,
    required TResult Function(AuthConfirmPasswordChanged value)
        confirmPasswordChanged,
    required TResult Function(AuthPasswordVisibilityToggled value)
        passwordVisibilityToggled,
    required TResult Function(AuthConfirmPasswordVisibilityToggled value)
        confirmPasswordVisibilityToggled,
    required TResult Function(AuthLoginSubmitted value) loginSubmitted,
    required TResult Function(AuthRegisterSubmitted value) registerSubmitted,
    required TResult Function(AuthGoogleSignInRequested value)
        googleSignInRequested,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthEmailChanged value)? emailChanged,
    TResult? Function(AuthPasswordChanged value)? passwordChanged,
    TResult? Function(AuthConfirmPasswordChanged value)? confirmPasswordChanged,
    TResult? Function(AuthPasswordVisibilityToggled value)?
        passwordVisibilityToggled,
    TResult? Function(AuthConfirmPasswordVisibilityToggled value)?
        confirmPasswordVisibilityToggled,
    TResult? Function(AuthLoginSubmitted value)? loginSubmitted,
    TResult? Function(AuthRegisterSubmitted value)? registerSubmitted,
    TResult? Function(AuthGoogleSignInRequested value)? googleSignInRequested,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthEmailChanged value)? emailChanged,
    TResult Function(AuthPasswordChanged value)? passwordChanged,
    TResult Function(AuthConfirmPasswordChanged value)? confirmPasswordChanged,
    TResult Function(AuthPasswordVisibilityToggled value)?
        passwordVisibilityToggled,
    TResult Function(AuthConfirmPasswordVisibilityToggled value)?
        confirmPasswordVisibilityToggled,
    TResult Function(AuthLoginSubmitted value)? loginSubmitted,
    TResult Function(AuthRegisterSubmitted value)? registerSubmitted,
    TResult Function(AuthGoogleSignInRequested value)? googleSignInRequested,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthEventCopyWith<$Res> {
  factory $AuthEventCopyWith(AuthEvent value, $Res Function(AuthEvent) then) =
      _$AuthEventCopyWithImpl<$Res, AuthEvent>;
}

/// @nodoc
class _$AuthEventCopyWithImpl<$Res, $Val extends AuthEvent>
    implements $AuthEventCopyWith<$Res> {
  _$AuthEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$AuthEmailChangedImplCopyWith<$Res> {
  factory _$$AuthEmailChangedImplCopyWith(_$AuthEmailChangedImpl value,
          $Res Function(_$AuthEmailChangedImpl) then) =
      __$$AuthEmailChangedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String email});
}

/// @nodoc
class __$$AuthEmailChangedImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$AuthEmailChangedImpl>
    implements _$$AuthEmailChangedImplCopyWith<$Res> {
  __$$AuthEmailChangedImplCopyWithImpl(_$AuthEmailChangedImpl _value,
      $Res Function(_$AuthEmailChangedImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
  }) {
    return _then(_$AuthEmailChangedImpl(
      null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AuthEmailChangedImpl implements AuthEmailChanged {
  const _$AuthEmailChangedImpl(this.email);

  @override
  final String email;

  @override
  String toString() {
    return 'AuthEvent.emailChanged(email: $email)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthEmailChangedImpl &&
            (identical(other.email, email) || other.email == email));
  }

  @override
  int get hashCode => Object.hash(runtimeType, email);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthEmailChangedImplCopyWith<_$AuthEmailChangedImpl> get copyWith =>
      __$$AuthEmailChangedImplCopyWithImpl<_$AuthEmailChangedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String email) emailChanged,
    required TResult Function(String password) passwordChanged,
    required TResult Function(String confirmPassword) confirmPasswordChanged,
    required TResult Function() passwordVisibilityToggled,
    required TResult Function() confirmPasswordVisibilityToggled,
    required TResult Function() loginSubmitted,
    required TResult Function() registerSubmitted,
    required TResult Function() googleSignInRequested,
  }) {
    return emailChanged(email);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String email)? emailChanged,
    TResult? Function(String password)? passwordChanged,
    TResult? Function(String confirmPassword)? confirmPasswordChanged,
    TResult? Function()? passwordVisibilityToggled,
    TResult? Function()? confirmPasswordVisibilityToggled,
    TResult? Function()? loginSubmitted,
    TResult? Function()? registerSubmitted,
    TResult? Function()? googleSignInRequested,
  }) {
    return emailChanged?.call(email);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email)? emailChanged,
    TResult Function(String password)? passwordChanged,
    TResult Function(String confirmPassword)? confirmPasswordChanged,
    TResult Function()? passwordVisibilityToggled,
    TResult Function()? confirmPasswordVisibilityToggled,
    TResult Function()? loginSubmitted,
    TResult Function()? registerSubmitted,
    TResult Function()? googleSignInRequested,
    required TResult orElse(),
  }) {
    if (emailChanged != null) {
      return emailChanged(email);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthEmailChanged value) emailChanged,
    required TResult Function(AuthPasswordChanged value) passwordChanged,
    required TResult Function(AuthConfirmPasswordChanged value)
        confirmPasswordChanged,
    required TResult Function(AuthPasswordVisibilityToggled value)
        passwordVisibilityToggled,
    required TResult Function(AuthConfirmPasswordVisibilityToggled value)
        confirmPasswordVisibilityToggled,
    required TResult Function(AuthLoginSubmitted value) loginSubmitted,
    required TResult Function(AuthRegisterSubmitted value) registerSubmitted,
    required TResult Function(AuthGoogleSignInRequested value)
        googleSignInRequested,
  }) {
    return emailChanged(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthEmailChanged value)? emailChanged,
    TResult? Function(AuthPasswordChanged value)? passwordChanged,
    TResult? Function(AuthConfirmPasswordChanged value)? confirmPasswordChanged,
    TResult? Function(AuthPasswordVisibilityToggled value)?
        passwordVisibilityToggled,
    TResult? Function(AuthConfirmPasswordVisibilityToggled value)?
        confirmPasswordVisibilityToggled,
    TResult? Function(AuthLoginSubmitted value)? loginSubmitted,
    TResult? Function(AuthRegisterSubmitted value)? registerSubmitted,
    TResult? Function(AuthGoogleSignInRequested value)? googleSignInRequested,
  }) {
    return emailChanged?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthEmailChanged value)? emailChanged,
    TResult Function(AuthPasswordChanged value)? passwordChanged,
    TResult Function(AuthConfirmPasswordChanged value)? confirmPasswordChanged,
    TResult Function(AuthPasswordVisibilityToggled value)?
        passwordVisibilityToggled,
    TResult Function(AuthConfirmPasswordVisibilityToggled value)?
        confirmPasswordVisibilityToggled,
    TResult Function(AuthLoginSubmitted value)? loginSubmitted,
    TResult Function(AuthRegisterSubmitted value)? registerSubmitted,
    TResult Function(AuthGoogleSignInRequested value)? googleSignInRequested,
    required TResult orElse(),
  }) {
    if (emailChanged != null) {
      return emailChanged(this);
    }
    return orElse();
  }
}

abstract class AuthEmailChanged implements AuthEvent {
  const factory AuthEmailChanged(final String email) = _$AuthEmailChangedImpl;

  String get email;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthEmailChangedImplCopyWith<_$AuthEmailChangedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthPasswordChangedImplCopyWith<$Res> {
  factory _$$AuthPasswordChangedImplCopyWith(_$AuthPasswordChangedImpl value,
          $Res Function(_$AuthPasswordChangedImpl) then) =
      __$$AuthPasswordChangedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String password});
}

/// @nodoc
class __$$AuthPasswordChangedImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$AuthPasswordChangedImpl>
    implements _$$AuthPasswordChangedImplCopyWith<$Res> {
  __$$AuthPasswordChangedImplCopyWithImpl(_$AuthPasswordChangedImpl _value,
      $Res Function(_$AuthPasswordChangedImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? password = null,
  }) {
    return _then(_$AuthPasswordChangedImpl(
      null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AuthPasswordChangedImpl implements AuthPasswordChanged {
  const _$AuthPasswordChangedImpl(this.password);

  @override
  final String password;

  @override
  String toString() {
    return 'AuthEvent.passwordChanged(password: $password)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthPasswordChangedImpl &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @override
  int get hashCode => Object.hash(runtimeType, password);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthPasswordChangedImplCopyWith<_$AuthPasswordChangedImpl> get copyWith =>
      __$$AuthPasswordChangedImplCopyWithImpl<_$AuthPasswordChangedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String email) emailChanged,
    required TResult Function(String password) passwordChanged,
    required TResult Function(String confirmPassword) confirmPasswordChanged,
    required TResult Function() passwordVisibilityToggled,
    required TResult Function() confirmPasswordVisibilityToggled,
    required TResult Function() loginSubmitted,
    required TResult Function() registerSubmitted,
    required TResult Function() googleSignInRequested,
  }) {
    return passwordChanged(password);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String email)? emailChanged,
    TResult? Function(String password)? passwordChanged,
    TResult? Function(String confirmPassword)? confirmPasswordChanged,
    TResult? Function()? passwordVisibilityToggled,
    TResult? Function()? confirmPasswordVisibilityToggled,
    TResult? Function()? loginSubmitted,
    TResult? Function()? registerSubmitted,
    TResult? Function()? googleSignInRequested,
  }) {
    return passwordChanged?.call(password);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email)? emailChanged,
    TResult Function(String password)? passwordChanged,
    TResult Function(String confirmPassword)? confirmPasswordChanged,
    TResult Function()? passwordVisibilityToggled,
    TResult Function()? confirmPasswordVisibilityToggled,
    TResult Function()? loginSubmitted,
    TResult Function()? registerSubmitted,
    TResult Function()? googleSignInRequested,
    required TResult orElse(),
  }) {
    if (passwordChanged != null) {
      return passwordChanged(password);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthEmailChanged value) emailChanged,
    required TResult Function(AuthPasswordChanged value) passwordChanged,
    required TResult Function(AuthConfirmPasswordChanged value)
        confirmPasswordChanged,
    required TResult Function(AuthPasswordVisibilityToggled value)
        passwordVisibilityToggled,
    required TResult Function(AuthConfirmPasswordVisibilityToggled value)
        confirmPasswordVisibilityToggled,
    required TResult Function(AuthLoginSubmitted value) loginSubmitted,
    required TResult Function(AuthRegisterSubmitted value) registerSubmitted,
    required TResult Function(AuthGoogleSignInRequested value)
        googleSignInRequested,
  }) {
    return passwordChanged(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthEmailChanged value)? emailChanged,
    TResult? Function(AuthPasswordChanged value)? passwordChanged,
    TResult? Function(AuthConfirmPasswordChanged value)? confirmPasswordChanged,
    TResult? Function(AuthPasswordVisibilityToggled value)?
        passwordVisibilityToggled,
    TResult? Function(AuthConfirmPasswordVisibilityToggled value)?
        confirmPasswordVisibilityToggled,
    TResult? Function(AuthLoginSubmitted value)? loginSubmitted,
    TResult? Function(AuthRegisterSubmitted value)? registerSubmitted,
    TResult? Function(AuthGoogleSignInRequested value)? googleSignInRequested,
  }) {
    return passwordChanged?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthEmailChanged value)? emailChanged,
    TResult Function(AuthPasswordChanged value)? passwordChanged,
    TResult Function(AuthConfirmPasswordChanged value)? confirmPasswordChanged,
    TResult Function(AuthPasswordVisibilityToggled value)?
        passwordVisibilityToggled,
    TResult Function(AuthConfirmPasswordVisibilityToggled value)?
        confirmPasswordVisibilityToggled,
    TResult Function(AuthLoginSubmitted value)? loginSubmitted,
    TResult Function(AuthRegisterSubmitted value)? registerSubmitted,
    TResult Function(AuthGoogleSignInRequested value)? googleSignInRequested,
    required TResult orElse(),
  }) {
    if (passwordChanged != null) {
      return passwordChanged(this);
    }
    return orElse();
  }
}

abstract class AuthPasswordChanged implements AuthEvent {
  const factory AuthPasswordChanged(final String password) =
      _$AuthPasswordChangedImpl;

  String get password;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthPasswordChangedImplCopyWith<_$AuthPasswordChangedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthConfirmPasswordChangedImplCopyWith<$Res> {
  factory _$$AuthConfirmPasswordChangedImplCopyWith(
          _$AuthConfirmPasswordChangedImpl value,
          $Res Function(_$AuthConfirmPasswordChangedImpl) then) =
      __$$AuthConfirmPasswordChangedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String confirmPassword});
}

/// @nodoc
class __$$AuthConfirmPasswordChangedImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$AuthConfirmPasswordChangedImpl>
    implements _$$AuthConfirmPasswordChangedImplCopyWith<$Res> {
  __$$AuthConfirmPasswordChangedImplCopyWithImpl(
      _$AuthConfirmPasswordChangedImpl _value,
      $Res Function(_$AuthConfirmPasswordChangedImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? confirmPassword = null,
  }) {
    return _then(_$AuthConfirmPasswordChangedImpl(
      null == confirmPassword
          ? _value.confirmPassword
          : confirmPassword // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AuthConfirmPasswordChangedImpl implements AuthConfirmPasswordChanged {
  const _$AuthConfirmPasswordChangedImpl(this.confirmPassword);

  @override
  final String confirmPassword;

  @override
  String toString() {
    return 'AuthEvent.confirmPasswordChanged(confirmPassword: $confirmPassword)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthConfirmPasswordChangedImpl &&
            (identical(other.confirmPassword, confirmPassword) ||
                other.confirmPassword == confirmPassword));
  }

  @override
  int get hashCode => Object.hash(runtimeType, confirmPassword);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthConfirmPasswordChangedImplCopyWith<_$AuthConfirmPasswordChangedImpl>
      get copyWith => __$$AuthConfirmPasswordChangedImplCopyWithImpl<
          _$AuthConfirmPasswordChangedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String email) emailChanged,
    required TResult Function(String password) passwordChanged,
    required TResult Function(String confirmPassword) confirmPasswordChanged,
    required TResult Function() passwordVisibilityToggled,
    required TResult Function() confirmPasswordVisibilityToggled,
    required TResult Function() loginSubmitted,
    required TResult Function() registerSubmitted,
    required TResult Function() googleSignInRequested,
  }) {
    return confirmPasswordChanged(confirmPassword);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String email)? emailChanged,
    TResult? Function(String password)? passwordChanged,
    TResult? Function(String confirmPassword)? confirmPasswordChanged,
    TResult? Function()? passwordVisibilityToggled,
    TResult? Function()? confirmPasswordVisibilityToggled,
    TResult? Function()? loginSubmitted,
    TResult? Function()? registerSubmitted,
    TResult? Function()? googleSignInRequested,
  }) {
    return confirmPasswordChanged?.call(confirmPassword);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email)? emailChanged,
    TResult Function(String password)? passwordChanged,
    TResult Function(String confirmPassword)? confirmPasswordChanged,
    TResult Function()? passwordVisibilityToggled,
    TResult Function()? confirmPasswordVisibilityToggled,
    TResult Function()? loginSubmitted,
    TResult Function()? registerSubmitted,
    TResult Function()? googleSignInRequested,
    required TResult orElse(),
  }) {
    if (confirmPasswordChanged != null) {
      return confirmPasswordChanged(confirmPassword);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthEmailChanged value) emailChanged,
    required TResult Function(AuthPasswordChanged value) passwordChanged,
    required TResult Function(AuthConfirmPasswordChanged value)
        confirmPasswordChanged,
    required TResult Function(AuthPasswordVisibilityToggled value)
        passwordVisibilityToggled,
    required TResult Function(AuthConfirmPasswordVisibilityToggled value)
        confirmPasswordVisibilityToggled,
    required TResult Function(AuthLoginSubmitted value) loginSubmitted,
    required TResult Function(AuthRegisterSubmitted value) registerSubmitted,
    required TResult Function(AuthGoogleSignInRequested value)
        googleSignInRequested,
  }) {
    return confirmPasswordChanged(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthEmailChanged value)? emailChanged,
    TResult? Function(AuthPasswordChanged value)? passwordChanged,
    TResult? Function(AuthConfirmPasswordChanged value)? confirmPasswordChanged,
    TResult? Function(AuthPasswordVisibilityToggled value)?
        passwordVisibilityToggled,
    TResult? Function(AuthConfirmPasswordVisibilityToggled value)?
        confirmPasswordVisibilityToggled,
    TResult? Function(AuthLoginSubmitted value)? loginSubmitted,
    TResult? Function(AuthRegisterSubmitted value)? registerSubmitted,
    TResult? Function(AuthGoogleSignInRequested value)? googleSignInRequested,
  }) {
    return confirmPasswordChanged?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthEmailChanged value)? emailChanged,
    TResult Function(AuthPasswordChanged value)? passwordChanged,
    TResult Function(AuthConfirmPasswordChanged value)? confirmPasswordChanged,
    TResult Function(AuthPasswordVisibilityToggled value)?
        passwordVisibilityToggled,
    TResult Function(AuthConfirmPasswordVisibilityToggled value)?
        confirmPasswordVisibilityToggled,
    TResult Function(AuthLoginSubmitted value)? loginSubmitted,
    TResult Function(AuthRegisterSubmitted value)? registerSubmitted,
    TResult Function(AuthGoogleSignInRequested value)? googleSignInRequested,
    required TResult orElse(),
  }) {
    if (confirmPasswordChanged != null) {
      return confirmPasswordChanged(this);
    }
    return orElse();
  }
}

abstract class AuthConfirmPasswordChanged implements AuthEvent {
  const factory AuthConfirmPasswordChanged(final String confirmPassword) =
      _$AuthConfirmPasswordChangedImpl;

  String get confirmPassword;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthConfirmPasswordChangedImplCopyWith<_$AuthConfirmPasswordChangedImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthPasswordVisibilityToggledImplCopyWith<$Res> {
  factory _$$AuthPasswordVisibilityToggledImplCopyWith(
          _$AuthPasswordVisibilityToggledImpl value,
          $Res Function(_$AuthPasswordVisibilityToggledImpl) then) =
      __$$AuthPasswordVisibilityToggledImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AuthPasswordVisibilityToggledImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$AuthPasswordVisibilityToggledImpl>
    implements _$$AuthPasswordVisibilityToggledImplCopyWith<$Res> {
  __$$AuthPasswordVisibilityToggledImplCopyWithImpl(
      _$AuthPasswordVisibilityToggledImpl _value,
      $Res Function(_$AuthPasswordVisibilityToggledImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AuthPasswordVisibilityToggledImpl
    implements AuthPasswordVisibilityToggled {
  const _$AuthPasswordVisibilityToggledImpl();

  @override
  String toString() {
    return 'AuthEvent.passwordVisibilityToggled()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthPasswordVisibilityToggledImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String email) emailChanged,
    required TResult Function(String password) passwordChanged,
    required TResult Function(String confirmPassword) confirmPasswordChanged,
    required TResult Function() passwordVisibilityToggled,
    required TResult Function() confirmPasswordVisibilityToggled,
    required TResult Function() loginSubmitted,
    required TResult Function() registerSubmitted,
    required TResult Function() googleSignInRequested,
  }) {
    return passwordVisibilityToggled();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String email)? emailChanged,
    TResult? Function(String password)? passwordChanged,
    TResult? Function(String confirmPassword)? confirmPasswordChanged,
    TResult? Function()? passwordVisibilityToggled,
    TResult? Function()? confirmPasswordVisibilityToggled,
    TResult? Function()? loginSubmitted,
    TResult? Function()? registerSubmitted,
    TResult? Function()? googleSignInRequested,
  }) {
    return passwordVisibilityToggled?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email)? emailChanged,
    TResult Function(String password)? passwordChanged,
    TResult Function(String confirmPassword)? confirmPasswordChanged,
    TResult Function()? passwordVisibilityToggled,
    TResult Function()? confirmPasswordVisibilityToggled,
    TResult Function()? loginSubmitted,
    TResult Function()? registerSubmitted,
    TResult Function()? googleSignInRequested,
    required TResult orElse(),
  }) {
    if (passwordVisibilityToggled != null) {
      return passwordVisibilityToggled();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthEmailChanged value) emailChanged,
    required TResult Function(AuthPasswordChanged value) passwordChanged,
    required TResult Function(AuthConfirmPasswordChanged value)
        confirmPasswordChanged,
    required TResult Function(AuthPasswordVisibilityToggled value)
        passwordVisibilityToggled,
    required TResult Function(AuthConfirmPasswordVisibilityToggled value)
        confirmPasswordVisibilityToggled,
    required TResult Function(AuthLoginSubmitted value) loginSubmitted,
    required TResult Function(AuthRegisterSubmitted value) registerSubmitted,
    required TResult Function(AuthGoogleSignInRequested value)
        googleSignInRequested,
  }) {
    return passwordVisibilityToggled(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthEmailChanged value)? emailChanged,
    TResult? Function(AuthPasswordChanged value)? passwordChanged,
    TResult? Function(AuthConfirmPasswordChanged value)? confirmPasswordChanged,
    TResult? Function(AuthPasswordVisibilityToggled value)?
        passwordVisibilityToggled,
    TResult? Function(AuthConfirmPasswordVisibilityToggled value)?
        confirmPasswordVisibilityToggled,
    TResult? Function(AuthLoginSubmitted value)? loginSubmitted,
    TResult? Function(AuthRegisterSubmitted value)? registerSubmitted,
    TResult? Function(AuthGoogleSignInRequested value)? googleSignInRequested,
  }) {
    return passwordVisibilityToggled?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthEmailChanged value)? emailChanged,
    TResult Function(AuthPasswordChanged value)? passwordChanged,
    TResult Function(AuthConfirmPasswordChanged value)? confirmPasswordChanged,
    TResult Function(AuthPasswordVisibilityToggled value)?
        passwordVisibilityToggled,
    TResult Function(AuthConfirmPasswordVisibilityToggled value)?
        confirmPasswordVisibilityToggled,
    TResult Function(AuthLoginSubmitted value)? loginSubmitted,
    TResult Function(AuthRegisterSubmitted value)? registerSubmitted,
    TResult Function(AuthGoogleSignInRequested value)? googleSignInRequested,
    required TResult orElse(),
  }) {
    if (passwordVisibilityToggled != null) {
      return passwordVisibilityToggled(this);
    }
    return orElse();
  }
}

abstract class AuthPasswordVisibilityToggled implements AuthEvent {
  const factory AuthPasswordVisibilityToggled() =
      _$AuthPasswordVisibilityToggledImpl;
}

/// @nodoc
abstract class _$$AuthConfirmPasswordVisibilityToggledImplCopyWith<$Res> {
  factory _$$AuthConfirmPasswordVisibilityToggledImplCopyWith(
          _$AuthConfirmPasswordVisibilityToggledImpl value,
          $Res Function(_$AuthConfirmPasswordVisibilityToggledImpl) then) =
      __$$AuthConfirmPasswordVisibilityToggledImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AuthConfirmPasswordVisibilityToggledImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res,
        _$AuthConfirmPasswordVisibilityToggledImpl>
    implements _$$AuthConfirmPasswordVisibilityToggledImplCopyWith<$Res> {
  __$$AuthConfirmPasswordVisibilityToggledImplCopyWithImpl(
      _$AuthConfirmPasswordVisibilityToggledImpl _value,
      $Res Function(_$AuthConfirmPasswordVisibilityToggledImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AuthConfirmPasswordVisibilityToggledImpl
    implements AuthConfirmPasswordVisibilityToggled {
  const _$AuthConfirmPasswordVisibilityToggledImpl();

  @override
  String toString() {
    return 'AuthEvent.confirmPasswordVisibilityToggled()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthConfirmPasswordVisibilityToggledImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String email) emailChanged,
    required TResult Function(String password) passwordChanged,
    required TResult Function(String confirmPassword) confirmPasswordChanged,
    required TResult Function() passwordVisibilityToggled,
    required TResult Function() confirmPasswordVisibilityToggled,
    required TResult Function() loginSubmitted,
    required TResult Function() registerSubmitted,
    required TResult Function() googleSignInRequested,
  }) {
    return confirmPasswordVisibilityToggled();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String email)? emailChanged,
    TResult? Function(String password)? passwordChanged,
    TResult? Function(String confirmPassword)? confirmPasswordChanged,
    TResult? Function()? passwordVisibilityToggled,
    TResult? Function()? confirmPasswordVisibilityToggled,
    TResult? Function()? loginSubmitted,
    TResult? Function()? registerSubmitted,
    TResult? Function()? googleSignInRequested,
  }) {
    return confirmPasswordVisibilityToggled?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email)? emailChanged,
    TResult Function(String password)? passwordChanged,
    TResult Function(String confirmPassword)? confirmPasswordChanged,
    TResult Function()? passwordVisibilityToggled,
    TResult Function()? confirmPasswordVisibilityToggled,
    TResult Function()? loginSubmitted,
    TResult Function()? registerSubmitted,
    TResult Function()? googleSignInRequested,
    required TResult orElse(),
  }) {
    if (confirmPasswordVisibilityToggled != null) {
      return confirmPasswordVisibilityToggled();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthEmailChanged value) emailChanged,
    required TResult Function(AuthPasswordChanged value) passwordChanged,
    required TResult Function(AuthConfirmPasswordChanged value)
        confirmPasswordChanged,
    required TResult Function(AuthPasswordVisibilityToggled value)
        passwordVisibilityToggled,
    required TResult Function(AuthConfirmPasswordVisibilityToggled value)
        confirmPasswordVisibilityToggled,
    required TResult Function(AuthLoginSubmitted value) loginSubmitted,
    required TResult Function(AuthRegisterSubmitted value) registerSubmitted,
    required TResult Function(AuthGoogleSignInRequested value)
        googleSignInRequested,
  }) {
    return confirmPasswordVisibilityToggled(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthEmailChanged value)? emailChanged,
    TResult? Function(AuthPasswordChanged value)? passwordChanged,
    TResult? Function(AuthConfirmPasswordChanged value)? confirmPasswordChanged,
    TResult? Function(AuthPasswordVisibilityToggled value)?
        passwordVisibilityToggled,
    TResult? Function(AuthConfirmPasswordVisibilityToggled value)?
        confirmPasswordVisibilityToggled,
    TResult? Function(AuthLoginSubmitted value)? loginSubmitted,
    TResult? Function(AuthRegisterSubmitted value)? registerSubmitted,
    TResult? Function(AuthGoogleSignInRequested value)? googleSignInRequested,
  }) {
    return confirmPasswordVisibilityToggled?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthEmailChanged value)? emailChanged,
    TResult Function(AuthPasswordChanged value)? passwordChanged,
    TResult Function(AuthConfirmPasswordChanged value)? confirmPasswordChanged,
    TResult Function(AuthPasswordVisibilityToggled value)?
        passwordVisibilityToggled,
    TResult Function(AuthConfirmPasswordVisibilityToggled value)?
        confirmPasswordVisibilityToggled,
    TResult Function(AuthLoginSubmitted value)? loginSubmitted,
    TResult Function(AuthRegisterSubmitted value)? registerSubmitted,
    TResult Function(AuthGoogleSignInRequested value)? googleSignInRequested,
    required TResult orElse(),
  }) {
    if (confirmPasswordVisibilityToggled != null) {
      return confirmPasswordVisibilityToggled(this);
    }
    return orElse();
  }
}

abstract class AuthConfirmPasswordVisibilityToggled implements AuthEvent {
  const factory AuthConfirmPasswordVisibilityToggled() =
      _$AuthConfirmPasswordVisibilityToggledImpl;
}

/// @nodoc
abstract class _$$AuthLoginSubmittedImplCopyWith<$Res> {
  factory _$$AuthLoginSubmittedImplCopyWith(_$AuthLoginSubmittedImpl value,
          $Res Function(_$AuthLoginSubmittedImpl) then) =
      __$$AuthLoginSubmittedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AuthLoginSubmittedImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$AuthLoginSubmittedImpl>
    implements _$$AuthLoginSubmittedImplCopyWith<$Res> {
  __$$AuthLoginSubmittedImplCopyWithImpl(_$AuthLoginSubmittedImpl _value,
      $Res Function(_$AuthLoginSubmittedImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AuthLoginSubmittedImpl implements AuthLoginSubmitted {
  const _$AuthLoginSubmittedImpl();

  @override
  String toString() {
    return 'AuthEvent.loginSubmitted()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$AuthLoginSubmittedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String email) emailChanged,
    required TResult Function(String password) passwordChanged,
    required TResult Function(String confirmPassword) confirmPasswordChanged,
    required TResult Function() passwordVisibilityToggled,
    required TResult Function() confirmPasswordVisibilityToggled,
    required TResult Function() loginSubmitted,
    required TResult Function() registerSubmitted,
    required TResult Function() googleSignInRequested,
  }) {
    return loginSubmitted();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String email)? emailChanged,
    TResult? Function(String password)? passwordChanged,
    TResult? Function(String confirmPassword)? confirmPasswordChanged,
    TResult? Function()? passwordVisibilityToggled,
    TResult? Function()? confirmPasswordVisibilityToggled,
    TResult? Function()? loginSubmitted,
    TResult? Function()? registerSubmitted,
    TResult? Function()? googleSignInRequested,
  }) {
    return loginSubmitted?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email)? emailChanged,
    TResult Function(String password)? passwordChanged,
    TResult Function(String confirmPassword)? confirmPasswordChanged,
    TResult Function()? passwordVisibilityToggled,
    TResult Function()? confirmPasswordVisibilityToggled,
    TResult Function()? loginSubmitted,
    TResult Function()? registerSubmitted,
    TResult Function()? googleSignInRequested,
    required TResult orElse(),
  }) {
    if (loginSubmitted != null) {
      return loginSubmitted();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthEmailChanged value) emailChanged,
    required TResult Function(AuthPasswordChanged value) passwordChanged,
    required TResult Function(AuthConfirmPasswordChanged value)
        confirmPasswordChanged,
    required TResult Function(AuthPasswordVisibilityToggled value)
        passwordVisibilityToggled,
    required TResult Function(AuthConfirmPasswordVisibilityToggled value)
        confirmPasswordVisibilityToggled,
    required TResult Function(AuthLoginSubmitted value) loginSubmitted,
    required TResult Function(AuthRegisterSubmitted value) registerSubmitted,
    required TResult Function(AuthGoogleSignInRequested value)
        googleSignInRequested,
  }) {
    return loginSubmitted(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthEmailChanged value)? emailChanged,
    TResult? Function(AuthPasswordChanged value)? passwordChanged,
    TResult? Function(AuthConfirmPasswordChanged value)? confirmPasswordChanged,
    TResult? Function(AuthPasswordVisibilityToggled value)?
        passwordVisibilityToggled,
    TResult? Function(AuthConfirmPasswordVisibilityToggled value)?
        confirmPasswordVisibilityToggled,
    TResult? Function(AuthLoginSubmitted value)? loginSubmitted,
    TResult? Function(AuthRegisterSubmitted value)? registerSubmitted,
    TResult? Function(AuthGoogleSignInRequested value)? googleSignInRequested,
  }) {
    return loginSubmitted?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthEmailChanged value)? emailChanged,
    TResult Function(AuthPasswordChanged value)? passwordChanged,
    TResult Function(AuthConfirmPasswordChanged value)? confirmPasswordChanged,
    TResult Function(AuthPasswordVisibilityToggled value)?
        passwordVisibilityToggled,
    TResult Function(AuthConfirmPasswordVisibilityToggled value)?
        confirmPasswordVisibilityToggled,
    TResult Function(AuthLoginSubmitted value)? loginSubmitted,
    TResult Function(AuthRegisterSubmitted value)? registerSubmitted,
    TResult Function(AuthGoogleSignInRequested value)? googleSignInRequested,
    required TResult orElse(),
  }) {
    if (loginSubmitted != null) {
      return loginSubmitted(this);
    }
    return orElse();
  }
}

abstract class AuthLoginSubmitted implements AuthEvent {
  const factory AuthLoginSubmitted() = _$AuthLoginSubmittedImpl;
}

/// @nodoc
abstract class _$$AuthRegisterSubmittedImplCopyWith<$Res> {
  factory _$$AuthRegisterSubmittedImplCopyWith(
          _$AuthRegisterSubmittedImpl value,
          $Res Function(_$AuthRegisterSubmittedImpl) then) =
      __$$AuthRegisterSubmittedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AuthRegisterSubmittedImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$AuthRegisterSubmittedImpl>
    implements _$$AuthRegisterSubmittedImplCopyWith<$Res> {
  __$$AuthRegisterSubmittedImplCopyWithImpl(_$AuthRegisterSubmittedImpl _value,
      $Res Function(_$AuthRegisterSubmittedImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AuthRegisterSubmittedImpl implements AuthRegisterSubmitted {
  const _$AuthRegisterSubmittedImpl();

  @override
  String toString() {
    return 'AuthEvent.registerSubmitted()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthRegisterSubmittedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String email) emailChanged,
    required TResult Function(String password) passwordChanged,
    required TResult Function(String confirmPassword) confirmPasswordChanged,
    required TResult Function() passwordVisibilityToggled,
    required TResult Function() confirmPasswordVisibilityToggled,
    required TResult Function() loginSubmitted,
    required TResult Function() registerSubmitted,
    required TResult Function() googleSignInRequested,
  }) {
    return registerSubmitted();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String email)? emailChanged,
    TResult? Function(String password)? passwordChanged,
    TResult? Function(String confirmPassword)? confirmPasswordChanged,
    TResult? Function()? passwordVisibilityToggled,
    TResult? Function()? confirmPasswordVisibilityToggled,
    TResult? Function()? loginSubmitted,
    TResult? Function()? registerSubmitted,
    TResult? Function()? googleSignInRequested,
  }) {
    return registerSubmitted?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email)? emailChanged,
    TResult Function(String password)? passwordChanged,
    TResult Function(String confirmPassword)? confirmPasswordChanged,
    TResult Function()? passwordVisibilityToggled,
    TResult Function()? confirmPasswordVisibilityToggled,
    TResult Function()? loginSubmitted,
    TResult Function()? registerSubmitted,
    TResult Function()? googleSignInRequested,
    required TResult orElse(),
  }) {
    if (registerSubmitted != null) {
      return registerSubmitted();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthEmailChanged value) emailChanged,
    required TResult Function(AuthPasswordChanged value) passwordChanged,
    required TResult Function(AuthConfirmPasswordChanged value)
        confirmPasswordChanged,
    required TResult Function(AuthPasswordVisibilityToggled value)
        passwordVisibilityToggled,
    required TResult Function(AuthConfirmPasswordVisibilityToggled value)
        confirmPasswordVisibilityToggled,
    required TResult Function(AuthLoginSubmitted value) loginSubmitted,
    required TResult Function(AuthRegisterSubmitted value) registerSubmitted,
    required TResult Function(AuthGoogleSignInRequested value)
        googleSignInRequested,
  }) {
    return registerSubmitted(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthEmailChanged value)? emailChanged,
    TResult? Function(AuthPasswordChanged value)? passwordChanged,
    TResult? Function(AuthConfirmPasswordChanged value)? confirmPasswordChanged,
    TResult? Function(AuthPasswordVisibilityToggled value)?
        passwordVisibilityToggled,
    TResult? Function(AuthConfirmPasswordVisibilityToggled value)?
        confirmPasswordVisibilityToggled,
    TResult? Function(AuthLoginSubmitted value)? loginSubmitted,
    TResult? Function(AuthRegisterSubmitted value)? registerSubmitted,
    TResult? Function(AuthGoogleSignInRequested value)? googleSignInRequested,
  }) {
    return registerSubmitted?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthEmailChanged value)? emailChanged,
    TResult Function(AuthPasswordChanged value)? passwordChanged,
    TResult Function(AuthConfirmPasswordChanged value)? confirmPasswordChanged,
    TResult Function(AuthPasswordVisibilityToggled value)?
        passwordVisibilityToggled,
    TResult Function(AuthConfirmPasswordVisibilityToggled value)?
        confirmPasswordVisibilityToggled,
    TResult Function(AuthLoginSubmitted value)? loginSubmitted,
    TResult Function(AuthRegisterSubmitted value)? registerSubmitted,
    TResult Function(AuthGoogleSignInRequested value)? googleSignInRequested,
    required TResult orElse(),
  }) {
    if (registerSubmitted != null) {
      return registerSubmitted(this);
    }
    return orElse();
  }
}

abstract class AuthRegisterSubmitted implements AuthEvent {
  const factory AuthRegisterSubmitted() = _$AuthRegisterSubmittedImpl;
}

/// @nodoc
abstract class _$$AuthGoogleSignInRequestedImplCopyWith<$Res> {
  factory _$$AuthGoogleSignInRequestedImplCopyWith(
          _$AuthGoogleSignInRequestedImpl value,
          $Res Function(_$AuthGoogleSignInRequestedImpl) then) =
      __$$AuthGoogleSignInRequestedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AuthGoogleSignInRequestedImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$AuthGoogleSignInRequestedImpl>
    implements _$$AuthGoogleSignInRequestedImplCopyWith<$Res> {
  __$$AuthGoogleSignInRequestedImplCopyWithImpl(
      _$AuthGoogleSignInRequestedImpl _value,
      $Res Function(_$AuthGoogleSignInRequestedImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AuthGoogleSignInRequestedImpl implements AuthGoogleSignInRequested {
  const _$AuthGoogleSignInRequestedImpl();

  @override
  String toString() {
    return 'AuthEvent.googleSignInRequested()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthGoogleSignInRequestedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String email) emailChanged,
    required TResult Function(String password) passwordChanged,
    required TResult Function(String confirmPassword) confirmPasswordChanged,
    required TResult Function() passwordVisibilityToggled,
    required TResult Function() confirmPasswordVisibilityToggled,
    required TResult Function() loginSubmitted,
    required TResult Function() registerSubmitted,
    required TResult Function() googleSignInRequested,
  }) {
    return googleSignInRequested();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String email)? emailChanged,
    TResult? Function(String password)? passwordChanged,
    TResult? Function(String confirmPassword)? confirmPasswordChanged,
    TResult? Function()? passwordVisibilityToggled,
    TResult? Function()? confirmPasswordVisibilityToggled,
    TResult? Function()? loginSubmitted,
    TResult? Function()? registerSubmitted,
    TResult? Function()? googleSignInRequested,
  }) {
    return googleSignInRequested?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email)? emailChanged,
    TResult Function(String password)? passwordChanged,
    TResult Function(String confirmPassword)? confirmPasswordChanged,
    TResult Function()? passwordVisibilityToggled,
    TResult Function()? confirmPasswordVisibilityToggled,
    TResult Function()? loginSubmitted,
    TResult Function()? registerSubmitted,
    TResult Function()? googleSignInRequested,
    required TResult orElse(),
  }) {
    if (googleSignInRequested != null) {
      return googleSignInRequested();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthEmailChanged value) emailChanged,
    required TResult Function(AuthPasswordChanged value) passwordChanged,
    required TResult Function(AuthConfirmPasswordChanged value)
        confirmPasswordChanged,
    required TResult Function(AuthPasswordVisibilityToggled value)
        passwordVisibilityToggled,
    required TResult Function(AuthConfirmPasswordVisibilityToggled value)
        confirmPasswordVisibilityToggled,
    required TResult Function(AuthLoginSubmitted value) loginSubmitted,
    required TResult Function(AuthRegisterSubmitted value) registerSubmitted,
    required TResult Function(AuthGoogleSignInRequested value)
        googleSignInRequested,
  }) {
    return googleSignInRequested(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthEmailChanged value)? emailChanged,
    TResult? Function(AuthPasswordChanged value)? passwordChanged,
    TResult? Function(AuthConfirmPasswordChanged value)? confirmPasswordChanged,
    TResult? Function(AuthPasswordVisibilityToggled value)?
        passwordVisibilityToggled,
    TResult? Function(AuthConfirmPasswordVisibilityToggled value)?
        confirmPasswordVisibilityToggled,
    TResult? Function(AuthLoginSubmitted value)? loginSubmitted,
    TResult? Function(AuthRegisterSubmitted value)? registerSubmitted,
    TResult? Function(AuthGoogleSignInRequested value)? googleSignInRequested,
  }) {
    return googleSignInRequested?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthEmailChanged value)? emailChanged,
    TResult Function(AuthPasswordChanged value)? passwordChanged,
    TResult Function(AuthConfirmPasswordChanged value)? confirmPasswordChanged,
    TResult Function(AuthPasswordVisibilityToggled value)?
        passwordVisibilityToggled,
    TResult Function(AuthConfirmPasswordVisibilityToggled value)?
        confirmPasswordVisibilityToggled,
    TResult Function(AuthLoginSubmitted value)? loginSubmitted,
    TResult Function(AuthRegisterSubmitted value)? registerSubmitted,
    TResult Function(AuthGoogleSignInRequested value)? googleSignInRequested,
    required TResult orElse(),
  }) {
    if (googleSignInRequested != null) {
      return googleSignInRequested(this);
    }
    return orElse();
  }
}

abstract class AuthGoogleSignInRequested implements AuthEvent {
  const factory AuthGoogleSignInRequested() = _$AuthGoogleSignInRequestedImpl;
}
