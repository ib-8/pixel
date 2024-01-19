import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseTable {
  static final supabase = Supabase.instance.client;
  static final assets = supabase.from('assets');
  static final events = supabase.from('events');
}
