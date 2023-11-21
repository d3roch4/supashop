import 'package:supashop/entities/account.dart';
import 'package:supashop/services/authentication_service.dart';

class MockAccountService extends AuthenticationService {
  bool fistLoad = false;

  @override
  Future<Account?> loadUser() async {
    return null;
  }

  @override
  Future<void> logout() async {
    currentAccount = null;
  }

  @override
  Future<Account?> signIn(
      {required String email, String? emailRedirectTo}) async {
    var user = Account(
      name: 'Fulano de tal',
      // username: 'username',
      email: 'email@email.com',
      documentNumber: '123.456.789-00',
      image:
          'https://img.freepik.com/fotos-gratis/foto-isolada-de-linda-mulher-de-sucesso-com-cabelos-cacheados-levanta-os-punhos-cerrados-comemora-o-triunfo-ficando-muito-satisfeita-e-feliz-fecha-os-olhos-de-prazer-veste-camiseta-branca-sim-consegui_273609-27735.jpg',
    );
    currentAccount = user;
    return currentAccount;
  }

  @override
  Future<bool> signUp(Account user, String password) async {
    return true;
  }

  @override
  Future<void> save(Account account) async {
    currentAccount = account;
  }

  @override
  Future<String> getAccessToken() async {
    return 'access-token';
  }

  @override
  Future<String> getAccessTokenIfValid() async {
    return 'access-token';
  }
}