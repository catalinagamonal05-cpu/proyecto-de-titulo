// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_repositorio_remoto.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(loginRepositorioRemoto)
final loginRepositorioRemotoProvider = LoginRepositorioRemotoProvider._();

final class LoginRepositorioRemotoProvider
    extends
        $FunctionalProvider<
          LoginRepositorioRemoto,
          LoginRepositorioRemoto,
          LoginRepositorioRemoto
        >
    with $Provider<LoginRepositorioRemoto> {
  LoginRepositorioRemotoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loginRepositorioRemotoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loginRepositorioRemotoHash();

  @$internal
  @override
  $ProviderElement<LoginRepositorioRemoto> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LoginRepositorioRemoto create(Ref ref) {
    return loginRepositorioRemoto(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LoginRepositorioRemoto value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LoginRepositorioRemoto>(value),
    );
  }
}

String _$loginRepositorioRemotoHash() =>
    r'4ab236dd447f0a94689f57c9f1c3a3fac906c942';
