// @dart=2.9
import 'dart:typed_data';

class WorkloadHandwrittenSignature {
  WorkloadHandwrittenSignature({
    this.fullName,
    this.position,
    this.note,
    this.signatureImageBytes,
    this.signedAt,
  });

  final String fullName;
  final String position;
  final String note;
  final Uint8List signatureImageBytes;
  final DateTime signedAt;
}

