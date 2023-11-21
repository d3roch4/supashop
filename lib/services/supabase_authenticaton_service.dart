import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supashop/entities/account.dart';
import 'package:supashop/repository/implementations/profile_repository_supabase.dart';
import 'package:supashop/services/authentication_service.dart';

class SupabaseAuthenticationService extends AuthenticationService {
  late SupabaseClient supabase;

  Future initialize() async {
    var resutl = await Supabase.initialize(
      url: 'https://mvtmzrtbynecxiyoztqg.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im12dG16cnRieW5lY3hpeW96dHFnIiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODc1NDMxNjksImV4cCI6MjAwMzExOTE2OX0.tan7UIOoYUxu4YK8R0p37-Ii8rZTX2uIO_nZyTZVVoI',
      authFlowType: AuthFlowType.pkce,
    );
    supabase = resutl.client;
  }

  @override
  Future<String> getAccessToken() {
    // TODO: implement getAccessToken
    throw UnimplementedError();
  }

  @override
  Future<String> getAccessTokenIfValid() {
    // TODO: implement getAccessTokenIfValid
    throw UnimplementedError();
  }

  @override
  Future<Account?> loadUser() async {
    if (supabase.auth.currentUser == null) return null;
    currentAccount =
        await ProfileRepositorySupabase.getMyProfileStatic(supabase);
    return currentAccount;
  }

  @override
  Future<void> logout() async {
    await supabase.auth.signOut();
    currentAccount = null;
  }

  @override
  Future<Account?> signIn(
      {required String email, String? emailRedirectTo}) async {
    var result = Completer<Account>();
    StreamSubscription<AuthState>? _authStateSubscription;

    _authStateSubscription = supabase.auth.onAuthStateChange.listen(
      (data) async {
        var user = await loadUser();
        if (user == null) return;
        result.complete(user);
        _authStateSubscription?.cancel();
      },
      onError: (error, stackTrace) {
        print(error.toString());
        print(stackTrace.toString());
        result.completeError(error);
        _authStateSubscription?.cancel();
      },
      onDone: () {
        _authStateSubscription?.cancel();
      },
    );

    await supabase.auth.signInWithOtp(
      email: email,
      emailRedirectTo: emailRedirectTo,
    );

    return result.future;
  }

  @override
  Future<bool> signUp(Account user, String password) {
    // TODO: implement signUp
    throw UnimplementedError();
  }
}