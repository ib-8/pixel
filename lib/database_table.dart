import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseTable {
  static final supabase = Supabase.instance.client;
  static final assets = supabase.from('assets');
  static final employees = supabase.from('employees');
  static final events = supabase.from('events');
  static final requesters = supabase.from('requesters');
  static final expenses = supabase.from('expenses');
}
