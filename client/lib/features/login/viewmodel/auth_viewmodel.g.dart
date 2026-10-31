// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AuthViewmodel)
final authViewmodelProvider = AuthViewmodelProvider._();

final class AuthViewmodelProvider
    extends $NotifierProvider<AuthViewmodel, AsyncValue<ModeloUsuario>?> {
  AuthViewmodelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authViewmodelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authViewmodelHash();

  @$internal
  @override
  AuthViewmodel create() => AuthViewmodel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<ModeloUsuario>? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<ModeloUsuario>?>(value),
    );
  }
}

String _$authViewmodelHash() => r'5aa7c3203e51e674504a5c7b6b2fa216b3ae31d5';

abstract class _$AuthViewmodel extends $Notifier<AsyncValue<ModeloUsuario>?> {
  AsyncValue<ModeloUsuario>? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<ModeloUsuario>?, AsyncValue<ModeloUsuario>?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<ModeloUsuario>?,
                AsyncValue<ModeloUsuario>?
              >,
              AsyncValue<ModeloUsuario>?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
