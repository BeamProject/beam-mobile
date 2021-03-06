class LastMeasurementData {
  static const COLUMN_ID = "id";
  static const COLUMN_TIMESTAMP_MS = "timestamp_ms_since_epoch";

  final int millisecondsSinceEpochInUtc;

  LastMeasurementData(this.millisecondsSinceEpochInUtc);

  Map<String, dynamic> toMap() {
    return {
      // We only want to keep one row with the last measurement data
      COLUMN_ID: 0,
      COLUMN_TIMESTAMP_MS: millisecondsSinceEpochInUtc,
    };
  }

  factory LastMeasurementData.fromMap(Map<String, dynamic> map) {
    return LastMeasurementData(map[COLUMN_TIMESTAMP_MS]);
  }
}
