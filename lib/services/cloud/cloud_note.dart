import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/foundation.dart';
import 'package:my_notes/services/cloud/cloud_storage_constants.dart';

@immutable
class CloudNote {
  final String docId;
  final String ownerUserId;
  final String title;
  final String body;
  final DateTime createdAt;
  final DateTime editedAt;

  const CloudNote(
      {required this.docId,
      required this.ownerUserId,
      required this.title,
      required this.body,
      required this.createdAt,
      required this.editedAt, });

  CloudNote.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot, )
      : docId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        title = snapshot.data()[titleFieldName] as String,
        body = snapshot.data()[bodyFieldName] as String,
        createdAt = (snapshot.data()[createdAtFieldName] as Timestamp).toDate(),
        editedAt = (snapshot.data()[editedAtFieldName] as Timestamp).toDate();
}
