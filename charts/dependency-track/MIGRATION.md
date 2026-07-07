# Migration

This document covers the usage of the migration feature and necessary steps across various versions.

## General approach

The migration is an atomic step that should be planned within a maintenance window. But it can be tested without impacting a productive environment before.

Since the migration cannot be done in-place, you need at least a separate PostgreSQL database instance.

To prevent data loss, make sure that the active OWASP Dependency Track instance is not public accessible and cannot be modified during the migration process by disabling *ingresses* or the *apiServer* workload.

### Steps

1. Setup a new PostgreSQL database instance
2. Database connection secrets should exists for both (old and new) instances
3. Create a file `migration-values.yaml` with the following content:
```yaml
migration:
  enabled: true
  sourceDatabase:
     jdbcUrl: # Required: Configure the source database URL
     existingSecret: # Required: Configure the source database credentials
  targetDatabase:
    jdbcUrl: # Required: Configure the target database URL
    existingSecret: # Required: Configure the target database credentials
  image: # Optionally adjust the migrator image here
 
apiServer:
  replicaCount: 0  # Recommended

httpRoute:
  enabled: false  # Optional

ingress:
  enabled: false  # Optional
```
4. Run the migration using this values file `-f migration-values.yaml`
5. Upgrade to newer Chart versions using this new database instance (the release name can be re-used)
6. Remove old database instance if the migration has been accepted

