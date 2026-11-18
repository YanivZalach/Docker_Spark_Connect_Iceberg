#!/bin/bash
set -euo pipefail

SCHEMATOOL="/opt/hive/bin/schematool -dbType postgres"

# Fresh database (no VERSION table yet): create the schema. Existing database: upgrade it
# to this metastore's version, which is a no-op when it is already current. The upgrade
# path covers databases created by older versions of this stack with the 2.3.0 schema.
if $SCHEMATOOL -info >/dev/null 2>&1; then
  $SCHEMATOOL -upgradeSchema
else
  $SCHEMATOOL -initSchema
fi

exec /opt/hive/bin/hive --skiphadoopversion --skiphbasecp --service metastore
