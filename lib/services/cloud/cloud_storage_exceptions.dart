class CloudStorageException implements Exception {
  const CloudStorageException();
}

class CouldNotCreateNoteEception extends CloudStorageException {}

class CouldNotGetAllNotesException extends CloudStorageException {}

class CouldNotUpdateNoteException extends CloudStorageException {}

class CouldNotDeleteNoteException extends CloudStorageException {}
