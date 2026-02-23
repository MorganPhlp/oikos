import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationsDatasource {
  final SupabaseClient supabase;

  NotificationsDatasource(this.supabase);

  Stream<List<Map<String, dynamic>>> getNotificationsForUser(String userId) {
    return supabase
        .from('notifications')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at', ascending: false);
  }

  Future<void> markAsRead(String notificationId) async {
    await supabase
        .from('notifications')
        .update({'is_read': true})
        .eq('id', notificationId);
  }
}
