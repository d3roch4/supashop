import 'package:supashop/entities/account.dart';

abstract class ProfileRepository {
  Future<void> save(Account account);

  Future<Account> getMyProfile();
}