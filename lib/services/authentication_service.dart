import '../entities/account.dart';

abstract class AuthenticationService {
  Account? currentAccount;

  Future<Account?> loadUser();

  Future<Account?> signIn({required String email, String? emailRedirectTo});

  Future<bool> signUp(Account user, String password);

  Future<void> logout();

  Future<String> getAccessTokenIfValid();

  Future<String> getAccessToken();
}