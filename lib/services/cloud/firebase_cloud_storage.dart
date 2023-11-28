import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_notes/services/cloud/cloud_note.dart';
import 'package:my_notes/services/cloud/cloud_storage_constants.dart';
import 'package:my_notes/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection('notes');

  void createNewNote({required String ownerUserId}) async {
    await notes.add(<String, dynamic>{
      ownerUserIdFieldName: ownerUserId,
      titleFieldName: '',
      bodyFieldName: '',
    });
  }

  Future<Iterable<CloudNote>> getNotes({ownerUserId}) async {
    try {
      return await notes
          .where(
            ownerUserIdFieldName,
            isEqualTo: ownerUserId,
          )
          .get()
          .then((value) => value.docs.map((doc) {
                return CloudNote(
                  docId: doc.id,
                  ownerUserId: doc.data()[ownerUserIdFieldName] as String,
                  title: doc.data()[titleFieldName] as String,
                  body: doc.data()[bodyFieldName] as String,
                );
              }));
    } catch (e) {
      throw CouldNotGetAllNotesException();
    }
  }

  Future<void> updateNote({
    required String docId,
    required String title,
    required String body,
  }) async {
    try {
      await notes
          .doc(docId)
          .update({titleFieldName: title, bodyFieldName: body});
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  Future<void> deleteNotes({required String docId}) async {
    try {
      await notes.doc(docId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }

  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) =>
      notes.snapshots().map((event) => event.docs
          .map((doc) => CloudNote.fromSnapshot(doc))
          .where((note) => note.ownerUserId == ownerUserId));

  FirebaseCloudStorage._sharedInstances();
  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstances();

  factory FirebaseCloudStorage() => _shared;
}
