import 'dart:io';
import 'package:excel/excel.dart';
import 'package:file_saver/file_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<List<Map<String, dynamic>>> fetchAllRequests() async {
  final client = Supabase.instance.client;
  final res = await client
      .from('scaffold_requests')
      .select()
      .order('created_at', ascending: false);

  return List<Map<String, dynamic>>.from(res);
}

Future<void> exportRequestsToExcel() async {
  final rows = await fetchAllRequests();
  final excel = Excel.createExcel();
  final sheet = excel['Requests'];

  sheet.appendRow([
    'ID',
    'Subcontractor',
    'Location',
    'Type',
    'Height',
    'Weight Capacity',
    'Date Required',
    'Removal Date',
    'Status',
  ]);

  for (final r in rows) {
    sheet.appendRow([
      r['id'],
      r['subcontractor_name'],
      r['location'],
      r['scaffold_type'],
      r['height'],
      r['weight_capacity'],
      r['date_required'],
      r['removal_date'],
      r['status'],
    ]);
  }

  final bytes = excel.encode()!;
  final dir = await getApplicationDocumentsDirectory();
  final filePath = '${dir.path}/scaffold_requests.xlsx';
  final file = File(filePath);
  await file.writeAsBytes(bytes, flush: true);

  await FileSaver.instance.saveFile(
    name: 'scaffold_requests',
    bytes: bytes,
    ext: 'xlsx',
    mimeType: MimeType.microsoftExcel,
  );
}
