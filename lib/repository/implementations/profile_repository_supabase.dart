import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supashop/entities/account.dart';
import 'package:supashop/repository/profile_repository.dart';

class ProfileRepositorySupabase extends ProfileRepository {
  final supabase = Supabase.instance.client;

  static Future<Account> getMyProfileStatic(SupabaseClient supabase) {
    var user = supabase.auth.currentUser!;
    return supabase
        .from('profiles')
        .select()
        .eq('id', user.id)
        .single()
        .then((value) => Account.fromJson(value)
          ..email = user.email
          ..isAdmin = user.appMetadata['admin'] == true);
  }

  @override
  Future<void> save(Account account) async {
    await supabase.from('profiles').update({
      'full_name': account.name,
      'document_number': account.documentNumber,
    }).eq('id', account.id);
  }

  @override
  Future<Account> getMyProfile() {
    return getMyProfileStatic(supabase);
  }
}