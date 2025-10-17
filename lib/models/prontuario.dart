import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;

class Prontuario {
  final String? id;
  final String paciente;
  final String descricao;
  final DateTime data;

  const Prontuario({
    this.id,
    required this.paciente,
    required this.descricao,
    required this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'paciente': paciente,
      'descricao': descricao,
      'data': data.toIso8601String(),
    };
  }

  Map<String, dynamic> toFirestoreMap() {
    return {
      'paciente': paciente,
      'descricao': descricao,
      'data': Timestamp.fromDate(data),
    };
  }

  factory Prontuario.fromMap(String id, Map<String, dynamic> map) {
    final raw = map['data'];
    DateTime parsed;
    if (raw is Timestamp) {
      parsed = raw.toDate();
    } else if (raw is String) {
      parsed = DateTime.parse(raw);
    } else if (raw is int) {
      parsed = DateTime.fromMillisecondsSinceEpoch(raw);
    } else {
      throw ArgumentError('Unsupported data field type: ${raw.runtimeType}');
    }

    return Prontuario(
      id: id,
      paciente: map['paciente'] as String,
      descricao: map['descricao'] as String,
      data: parsed,
    );
  }

  String toJson() => json.encode(toMap());

  factory Prontuario.fromJson(String id, String source) {
    final map = json.decode(source) as Map<String, dynamic>;
    return Prontuario.fromMap(id, map);
  }

  Prontuario copyWith({
    String? id,
    String? paciente,
    String? descricao,
    DateTime? data,
  }) {
    return Prontuario(
      id: id ?? this.id,
      paciente: paciente ?? this.paciente,
      descricao: descricao ?? this.descricao,
      data: data ?? this.data,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Prontuario &&
        other.id == id &&
        other.paciente == paciente &&
        other.descricao == descricao &&
        other.data == data;
  }

  @override
  int get hashCode => Object.hash(id, paciente, descricao, data);
}
