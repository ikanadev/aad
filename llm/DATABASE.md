### Drift Client Guide
#### Database Tables (Drift)
Every syncable table includes these columns alongside business columns:

// In every syncable table definition
```
RealColumn get serverVersion => real()();         // Last known server version for this row
BoolColumn get isDirty => boolean().withDefault(const Constant(false))();  
BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
```
serverVersion starts at 0 for locally-created rows.
Watermark is not in Drift — store in a key-value store (SharedPreferences/secure storage):

```
// Single value, not per-table
int lastSyncedVersion;   // "I've applied everything up to this version"
bool needsBootstrap;     // True on fresh install
```

