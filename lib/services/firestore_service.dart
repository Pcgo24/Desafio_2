import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/prontuario.dart';

class FirestoreService {
  CollectionReference<Map<String, dynamic>> get prontuariosCollection =>
      FirebaseFirestore.instance.collection('prontuarios');

  Future<void> adicionarProntuario(Prontuario prontuario) async {
    final data = prontuario.toFirestoreMap();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      data['uid'] = uid;
    }
    await prontuariosCollection.add(data);
  }

  Future<void> atualizarProntuario(Prontuario prontuario) async {
    if (prontuario.id == null) throw ArgumentError('Prontuario sem id');
    await prontuariosCollection
        .doc(prontuario.id)
        .update(prontuario.toFirestoreMap());
  }

  Future<void> deletarProntuario(String id) async {
    await prontuariosCollection.doc(id).delete();
  }

  Stream<List<Prontuario>> getProntuarios() {
    return prontuariosCollection.snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => Prontuario.fromMap(doc.id, doc.data()))
          .toList(),
    );
  }

  Stream<List<Prontuario>> queryByPaciente(String paciente) {
    return prontuariosCollection
        .where('paciente', isGreaterThanOrEqualTo: paciente)
        .where('paciente', isLessThanOrEqualTo: paciente + '\uf8ff')
        .snapshots()
        .map(
          (s) => s.docs.map((d) => Prontuario.fromMap(d.id, d.data())).toList(),
        );
  }

  Stream<List<Prontuario>> queryByDateRange(DateTime from, DateTime to) {
    final fromTs = Timestamp.fromDate(from);
    final toTs = Timestamp.fromDate(to);
    return prontuariosCollection
        .where('data', isGreaterThanOrEqualTo: fromTs)
        .where('data', isLessThanOrEqualTo: toTs)
        .orderBy('data', descending: true)
        .snapshots()
        .map(
          (s) => s.docs.map((d) => Prontuario.fromMap(d.id, d.data())).toList(),
        );
  }

  Future<void> saveNotificationToken(String uid, String token) async {
    final ref = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tokens');
    await ref.doc(token).set({
      'token': token,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
