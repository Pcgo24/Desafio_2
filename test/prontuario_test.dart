import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;
import 'package:flutter_test/flutter_test.dart';
import 'package:projetodswm4/models/prontuario.dart';

void main() {
  group('Prontuario.fromMap', () {
    test('parses Firestore Timestamp', () {
      final timestamp = Timestamp.fromDate(DateTime.utc(2023, 1, 2, 3, 4, 5));
      final map = {
        'paciente': 'Alice',
        'descricao': 'Consulta',
        'data': timestamp,
      };

      final p = Prontuario.fromMap('id1', map);

      expect(p.id, 'id1');
      expect(p.paciente, 'Alice');
      expect(p.descricao, 'Consulta');
      expect(p.data, timestamp.toDate());
    });

    test('parses ISO8601 string', () {
      final iso = '2024-05-06T07:08:09.000Z';
      final map = {'paciente': 'Bob', 'descricao': 'Retorno', 'data': iso};

      final p = Prontuario.fromMap('id2', map);

      expect(p.id, 'id2');
      expect(p.paciente, 'Bob');
      expect(p.descricao, 'Retorno');
      expect(p.data.toUtc().toIso8601String(), iso);
    });

    test('parses int milliseconds since epoch', () {
      final ms = DateTime(2022, 12, 31, 23, 59, 59).millisecondsSinceEpoch;
      final map = {'paciente': 'Carol', 'descricao': 'Emergência', 'data': ms};

      final p = Prontuario.fromMap('id3', map);

      expect(p.id, 'id3');
      expect(p.paciente, 'Carol');
      expect(p.descricao, 'Emergência');
      expect(p.data.millisecondsSinceEpoch, ms);
    });
  });
}
