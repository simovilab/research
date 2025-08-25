#!/usr/bin/env bash
# Explicit, readable script to create GitHub issues (no loops/ifs)
# - One parent "workflow" issue per project, using the full project description
# - Sub-issues per project, with titles and bodies from the issues backlog
# - Each sub-issue is linked back to its parent and added as a checklist item
#
# Requirements
# - gh (GitHub CLI) authenticated: gh auth status
# - jq installed
# - You have permission to create issues in simovilab/* repos
#
# Usage
#   bash create_github_issues.sh

set -euo pipefail

ORG="simovilab"
TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

# Helper: create an issue via gh api and capture JSON
create_issue() {
  local repo="$1" title="$2" body_file="$3"
  gh api -X POST "repos/$repo/issues" -f "title=$title" -F "body=@$body_file"
}

# Helper: comment on an issue
comment_issue() {
  local repo="$1" num="$2" text="$3"
  gh api -X POST "repos/$repo/issues/$num/comments" -f "body=$text" >/dev/null
}

# Helper: replace body of an issue
replace_issue_body() {
  local repo="$1" num="$2" body_file="$3"
  gh api -X PATCH "repos/$repo/issues/$num" -F "body=@$body_file" >/dev/null
}

################################################################################
# Project 1 — Databús API
################################################################################

P1_REPO="$ORG/databus"
P1_TITLE="Databús API"
P1_BODY="$TMP_DIR/p1_body.md"
cat >"$P1_BODY" <<'EOF'
### Project 1 — Databús API

#### General Objective

Build a production-grade API to collect public transportation tracking and telemetry data and support operational service management tasks.

#### Specific Objectives

- Update and complete endpoints (read/write, validation, and pagination).
- Update and complete documentation (OpenAPI) with request/response examples.
- Define and implement a CRUD strategy for storage across different database types.
- Implement token-based authentication and role-based access control.
- Manage clients (vehicles, devices, people, agencies, others): registration and lifecycle.
- Manage permissions, security, and performance (basic limits and quotas).
- Create an admin panel prototype.
- Create unit and integration tests.

#### Technologies

Repository: https://github.com/simovilab/databus

- Python
- Django
- Django REST Framework
- PostgreSQL, Redis, Apache Jena Fuseki
- OpenAPI
- Vue (documentation)
EOF

P1_CREATE_JSON=$(create_issue "$P1_REPO" "$P1_TITLE" "$P1_BODY")
P1_NUM=$(echo "$P1_CREATE_JSON" | jq -r '.number')
P1_URL=$(echo "$P1_CREATE_JSON" | jq -r '.html_url')

# Sub-issues for Project 1
# 1. Complete CRUD endpoints with validation and pagination
P1_S1_TITLE="Complete CRUD endpoints with validation and pagination"
P1_S1_BODY="$TMP_DIR/p1_s1.md"
cat >"$P1_S1_BODY" <<'EOF'
**Description**

Implement read/write endpoints with request/response validation and pagination across core resources.

**Acceptance Criteria**

- [ ] All planned endpoints exist with GET/POST/PATCH/DELETE where applicable
- [ ] Input validation with clear error messages and status codes
- [ ] Pagination (limit/offset or cursor) consistently implemented
- [ ] OpenAPI spec updated with examples
EOF
P1_S1_JSON=$(create_issue "$P1_REPO" "$P1_S1_TITLE" "$P1_S1_BODY")
P1_S1_NUM=$(echo "$P1_S1_JSON" | jq -r '.number')
P1_S1_URL=$(echo "$P1_S1_JSON" | jq -r '.html_url')
comment_issue "$P1_REPO" "$P1_S1_NUM" "Tracked in $P1_URL"

# 2. OpenAPI documentation with examples and error codes
P1_S2_TITLE="OpenAPI documentation with examples and error codes"
P1_S2_BODY="$TMP_DIR/p1_s2.md"
cat >"$P1_S2_BODY" <<'EOF'
**Description**

Document all endpoints with request/response samples and error payloads.

**Acceptance Criteria**

- [ ] OpenAPI paths, schemas, and components complete
- [ ] Example requests/responses per operation
- [ ] Standard error schema documented and referenced
- [ ] Rendered docs (Swagger/Redoc) linked in README
EOF
P1_S2_JSON=$(create_issue "$P1_REPO" "$P1_S2_TITLE" "$P1_S2_BODY")
P1_S2_NUM=$(echo "$P1_S2_JSON" | jq -r '.number')
P1_S2_URL=$(echo "$P1_S2_JSON" | jq -r '.html_url')
comment_issue "$P1_REPO" "$P1_S2_NUM" "Tracked in $P1_URL"

# 3. Storage strategy: CRUD to PostgreSQL/Redis/Fuseki
P1_S3_TITLE="Storage strategy: CRUD to PostgreSQL/Redis/Fuseki"
P1_S3_BODY="$TMP_DIR/p1_s3.md"
cat >"$P1_S3_BODY" <<'EOF'
**Description**

Implement storage adapters and patterns for different backends.

**Acceptance Criteria**

- [ ] PostgreSQL models/migrations for operational data
- [ ] Redis integration for caching / high-frequency writes where needed
- [ ] Optional Fuseki integration for semantic views (if applicable)
- [ ] Configuration documented with env vars
EOF
P1_S3_JSON=$(create_issue "$P1_REPO" "$P1_S3_TITLE" "$P1_S3_BODY")
P1_S3_NUM=$(echo "$P1_S3_JSON" | jq -r '.number')
P1_S3_URL=$(echo "$P1_S3_JSON" | jq -r '.html_url')
comment_issue "$P1_REPO" "$P1_S3_NUM" "Tracked in $P1_URL"

# 4. JWT authentication and role-based access control
P1_S4_TITLE="JWT authentication and role-based access control"
P1_S4_BODY="$TMP_DIR/p1_s4.md"
cat >"$P1_S4_BODY" <<'EOF'
**Description**

Secure the API with token auth and roles.

**Acceptance Criteria**

- [ ] JWT issuance and verification flows
- [ ] Roles/permissions mapped to endpoints/actions
- [ ] Token rotation/expiry documented
- [ ] Tests for authz/authn paths
EOF
P1_S4_JSON=$(create_issue "$P1_REPO" "$P1_S4_TITLE" "$P1_S4_BODY")
P1_S4_NUM=$(echo "$P1_S4_JSON" | jq -r '.number')
P1_S4_URL=$(echo "$P1_S4_JSON" | jq -r '.html_url')
comment_issue "$P1_REPO" "$P1_S4_NUM" "Tracked in $P1_URL"

# 5. Client registry and lifecycle management
P1_S5_TITLE="Client registry and lifecycle management"
P1_S5_BODY="$TMP_DIR/p1_s5.md"
cat >"$P1_S5_BODY" <<'EOF'
**Description**

Manage registered clients (vehicles/devices/users/agencies).

**Acceptance Criteria**

- [ ] Models for clients, keys, quotas, status
- [ ] CRUD and lifecycle operations (register/disable/rotate)
- [ ] Metrics of usage per client captured
- [ ] Admin views for management
EOF
P1_S5_JSON=$(create_issue "$P1_REPO" "$P1_S5_TITLE" "$P1_S5_BODY")
P1_S5_NUM=$(echo "$P1_S5_JSON" | jq -r '.number')
P1_S5_URL=$(echo "$P1_S5_JSON" | jq -r '.html_url')
comment_issue "$P1_REPO" "$P1_S5_NUM" "Tracked in $P1_URL"

# 6. Rate limiting and basic quotas
P1_S6_TITLE="Rate limiting and basic quotas"
P1_S6_BODY="$TMP_DIR/p1_s6.md"
cat >"$P1_S6_BODY" <<'EOF'
**Description**

Protect the API with rate limits and quotas per client.

**Acceptance Criteria**

- [ ] Global and per-client rate limits in place
- [ ] Quota counters persisted/reset policy defined
- [ ] 429 responses with headers (remaining/reset)
- [ ] Tests for limits and bursty traffic
EOF
P1_S6_JSON=$(create_issue "$P1_REPO" "$P1_S6_TITLE" "$P1_S6_BODY")
P1_S6_NUM=$(echo "$P1_S6_JSON" | jq -r '.number')
P1_S6_URL=$(echo "$P1_S6_JSON" | jq -r '.html_url')
comment_issue "$P1_REPO" "$P1_S6_NUM" "Tracked in $P1_URL"

# 7. Security and performance hygiene
P1_S7_TITLE="Security and performance hygiene"
P1_S7_BODY="$TMP_DIR/p1_s7.md"
cat >"$P1_S7_BODY" <<'EOF'
**Description**

Apply CORS, ETag/HTTP caching, pagination defaults, and timeouts.

**Acceptance Criteria**

- [ ] CORS config per environment
- [ ] ETag/Last-Modified and cache headers where safe
- [ ] Sensible pagination defaults and max caps
- [ ] Request timeouts and connection pooling
EOF
P1_S7_JSON=$(create_issue "$P1_REPO" "$P1_S7_TITLE" "$P1_S7_BODY")
P1_S7_NUM=$(echo "$P1_S7_JSON" | jq -r '.number')
P1_S7_URL=$(echo "$P1_S7_JSON" | jq -r '.html_url')
comment_issue "$P1_REPO" "$P1_S7_NUM" "Tracked in $P1_URL"

# 8. Admin panel prototype
P1_S8_TITLE="Admin panel prototype"
P1_S8_BODY="$TMP_DIR/p1_s8.md"
cat >"$P1_S8_BODY" <<'EOF'
**Description**

Provide an admin dashboard for basic operations and metrics.

**Acceptance Criteria**

- [ ] Admin views for clients, keys, quotas
- [ ] Lightweight traffic/latency/errors chart(s)
- [ ] Auth-gated access and audit logs
- [ ] Linked from README
EOF
P1_S8_JSON=$(create_issue "$P1_REPO" "$P1_S8_TITLE" "$P1_S8_BODY")
P1_S8_NUM=$(echo "$P1_S8_JSON" | jq -r '.number')
P1_S8_URL=$(echo "$P1_S8_JSON" | jq -r '.html_url')
comment_issue "$P1_REPO" "$P1_S8_NUM" "Tracked in $P1_URL"

# 9. Unit and integration tests
P1_S9_TITLE="Unit and integration tests"
P1_S9_BODY="$TMP_DIR/p1_s9.md"
cat >"$P1_S9_BODY" <<'EOF'
**Description**

Coverage for endpoints, auth, storage, limits.

**Acceptance Criteria**

- [ ] Unit tests for serializers/validators
- [ ] Integration tests hitting a test DB/Redis
- [ ] Contract tests vs OpenAPI examples
- [ ] CI job running tests and linting
EOF
P1_S9_JSON=$(create_issue "$P1_REPO" "$P1_S9_TITLE" "$P1_S9_BODY")
P1_S9_NUM=$(echo "$P1_S9_JSON" | jq -r '.number')
P1_S9_URL=$(echo "$P1_S9_JSON" | jq -r '.html_url')
comment_issue "$P1_REPO" "$P1_S9_NUM" "Tracked in $P1_URL"

# Append sub-issue checklist to parent body and update
P1_PARENT_UPDATE="$TMP_DIR/p1_parent_update.md"
cat >"$P1_PARENT_UPDATE" <<EOF
$(cat "$P1_BODY")

### Sub-issues

- [ ] [$P1_S1_TITLE]($P1_S1_URL)
- [ ] [$P1_S2_TITLE]($P1_S2_URL)
- [ ] [$P1_S3_TITLE]($P1_S3_URL)
- [ ] [$P1_S4_TITLE]($P1_S4_URL)
- [ ] [$P1_S5_TITLE]($P1_S5_URL)
- [ ] [$P1_S6_TITLE]($P1_S6_URL)
- [ ] [$P1_S7_TITLE]($P1_S7_URL)
- [ ] [$P1_S8_TITLE]($P1_S8_URL)
- [ ] [$P1_S9_TITLE]($P1_S9_URL)
EOF
replace_issue_body "$P1_REPO" "$P1_NUM" "$P1_PARENT_UPDATE"

################################################################################
# Project 2 — Django GTFS (Schedule)
################################################################################

P2_REPO="$ORG/django-app-gtfs"
P2_TITLE="Django GTFS (Schedule)"
P2_BODY="$TMP_DIR/p2_body.md"
cat >"$P2_BODY" <<'EOF'
### Project 2 — Django GTFS application (Schedule version)

#### General Objective

Develop a Django application that provides models, validations, and utilities for managing GTFS Schedule data.

#### Specific Objectives

- Update and complete database models based on GTFS v2.0, with referential integrity constraints.
- Create a schema document as a single source of truth, aligned to the official spec and used to generate models and documentation.
- Migrate to composite primary keys (Django 5.2) according to GTFS-defined keys.
- Implement a fixtures creation tool (management commands).
- Create an import utility for GTFS from ZIP (command `import_gtfs`).
- Create an export utility for GTFS to ZIP (command `export_gtfs`).
- Module to build the `stop_times.txt` table with the arrival-time estimator.
- Publish as a Django extension on PyPI (currently a Git submodule), with semantic versioning.
- Create documentation with minimal usage examples.

#### Technologies

Repository: https://github.com/simovilab/django-app-gtfs

- Python
- Django 5.2 (composite primary keys)
- PostgreSQL/PostGIS (spatial support for `shapes.txt` and stops)
- Vue (documentation)
EOF

P2_CREATE_JSON=$(create_issue "$P2_REPO" "$P2_TITLE" "$P2_BODY")
P2_NUM=$(echo "$P2_CREATE_JSON" | jq -r '.number')
P2_URL=$(echo "$P2_CREATE_JSON" | jq -r '.html_url')

# Sub-issues for Project 2
P2_S1_TITLE="Authoritative schema document for GTFS Schedule"
P2_S1_BODY="$TMP_DIR/p2_s1.md"
cat >"$P2_S1_BODY" <<'EOF'
**Description**

Create a schema file aligned with GTFS v2.0 to generate models/docs.

**Acceptance Criteria**

- [ ] Schema includes fields, types, constraints, PKs/FKs
- [ ] Versioned and referenced by codegen/docs
- [ ] Validated against sample GTFS feeds
EOF
P2_S1_JSON=$(create_issue "$P2_REPO" "$P2_S1_TITLE" "$P2_S1_BODY")
P2_S1_NUM=$(echo "$P2_S1_JSON" | jq -r '.number')
P2_S1_URL=$(echo "$P2_S1_JSON" | jq -r '.html_url')
comment_issue "$P2_REPO" "$P2_S1_NUM" "Tracked in $P2_URL"

P2_S2_TITLE="Implement models with referential integrity"
P2_S2_BODY="$TMP_DIR/p2_s2.md"
cat >"$P2_S2_BODY" <<'EOF'
**Description**

Model GTFS entities with constraints in Django.

**Acceptance Criteria**

- [ ] All core tables modeled (agency, routes, trips, stops, stop_times, shapes, calendars, …)
- [ ] FKs/unique constraints per spec
- [ ] Migrations created and applied
EOF
P2_S2_JSON=$(create_issue "$P2_REPO" "$P2_S2_TITLE" "$P2_S2_BODY")
P2_S2_NUM=$(echo "$P2_S2_JSON" | jq -r '.number')
P2_S2_URL=$(echo "$P2_S2_JSON" | jq -r '.html_url')
comment_issue "$P2_REPO" "$P2_S2_NUM" "Tracked in $P2_URL"

P2_S3_TITLE="Migrate to composite primary keys (Django 5.2)"
P2_S3_BODY="$TMP_DIR/p2_s3.md"
cat >"$P2_S3_BODY" <<'EOF'
**Description**

Use composite PKs as defined by GTFS where required.

**Acceptance Criteria**

- [ ] Composite PKs implemented where applicable
- [ ] Admin/query patterns documented
- [ ] Tests cover CRUD and relations
EOF
P2_S3_JSON=$(create_issue "$P2_REPO" "$P2_S3_TITLE" "$P2_S3_BODY")
P2_S3_NUM=$(echo "$P2_S3_JSON" | jq -r '.number')
P2_S3_URL=$(echo "$P2_S3_JSON" | jq -r '.html_url')
comment_issue "$P2_REPO" "$P2_S3_NUM" "Tracked in $P2_URL"

P2_S4_TITLE="Management command: create fixtures"
P2_S4_BODY="$TMP_DIR/p2_s4.md"
cat >"$P2_S4_BODY" <<'EOF'
**Description**

Generate minimal fixtures for testing and docs.

**Acceptance Criteria**

- [ ] Command produces deterministic small datasets
- [ ] Seed option and output path configurable
- [ ] Used by test suite
EOF
P2_S4_JSON=$(create_issue "$P2_REPO" "$P2_S4_TITLE" "$P2_S4_BODY")
P2_S4_NUM=$(echo "$P2_S4_JSON" | jq -r '.number')
P2_S4_URL=$(echo "$P2_S4_JSON" | jq -r '.html_url')
comment_issue "$P2_REPO" "$P2_S4_NUM" "Tracked in $P2_URL"

P2_S5_TITLE="import_gtfs: ZIP → database"
P2_S5_BODY="$TMP_DIR/p2_s5.md"
cat >"$P2_S5_BODY" <<'EOF'
**Description**

Import a GTFS ZIP into DB.

**Acceptance Criteria**

- [ ] Supports required and optional files
- [ ] Validates referential integrity and types
- [ ] Reports errors with line/file context
EOF
P2_S5_JSON=$(create_issue "$P2_REPO" "$P2_S5_TITLE" "$P2_S5_BODY")
P2_S5_NUM=$(echo "$P2_S5_JSON" | jq -r '.number')
P2_S5_URL=$(echo "$P2_S5_JSON" | jq -r '.html_url')
comment_issue "$P2_REPO" "$P2_S5_NUM" "Tracked in $P2_URL"

P2_S6_TITLE="export_gtfs: database → ZIP"
P2_S6_BODY="$TMP_DIR/p2_s6.md"
cat >"$P2_S6_BODY" <<'EOF'
**Description**

Export DB to a valid GTFS ZIP.

**Acceptance Criteria**

- [ ] Includes only valid/linked rows
- [ ] Passes validator checks
- [ ] Metadata (version, timestamp) embedded
EOF
P2_S6_JSON=$(create_issue "$P2_REPO" "$P2_S6_TITLE" "$P2_S6_BODY")
P2_S6_NUM=$(echo "$P2_S6_JSON" | jq -r '.number')
P2_S6_URL=$(echo "$P2_S6_JSON" | jq -r '.html_url')
comment_issue "$P2_REPO" "$P2_S6_NUM" "Tracked in $P2_URL"

P2_S7_TITLE="stop_times builder using ETA estimator"
P2_S7_BODY="$TMP_DIR/p2_s7.md"
cat >"$P2_S7_BODY" <<'EOF'
**Description**

Build stop_times using ETA module hooks.

**Acceptance Criteria**

- [ ] Pluggable interface to ETA module
- [ ] Deterministic output on given seed
- [ ] Tests with synthetic data
EOF
P2_S7_JSON=$(create_issue "$P2_REPO" "$P2_S7_TITLE" "$P2_S7_BODY")
P2_S7_NUM=$(echo "$P2_S7_JSON" | jq -r '.number')
P2_S7_URL=$(echo "$P2_S7_JSON" | jq -r '.html_url')
comment_issue "$P2_REPO" "$P2_S7_NUM" "Tracked in $P2_URL"

P2_S8_TITLE="Publish package to PyPI (semantic versioning)"
P2_S8_BODY="$TMP_DIR/p2_s8.md"
cat >"$P2_S8_BODY" <<'EOF'
**Description**

Package and publish as a Django app.

**Acceptance Criteria**

- [ ] pyproject.toml, classifiers, README
- [ ] Versioning, changelog, release workflow
- [ ] Install/test instructions verified
EOF
P2_S8_JSON=$(create_issue "$P2_REPO" "$P2_S8_TITLE" "$P2_S8_BODY")
P2_S8_NUM=$(echo "$P2_S8_JSON" | jq -r '.number')
P2_S8_URL=$(echo "$P2_S8_JSON" | jq -r '.html_url')
comment_issue "$P2_REPO" "$P2_S8_NUM" "Tracked in $P2_URL"

P2_S9_TITLE="Minimal usage documentation"
P2_S9_BODY="$TMP_DIR/p2_s9.md"
cat >"$P2_S9_BODY" <<'EOF'
**Description**

Provide examples to bootstrap users.

**Acceptance Criteria**

- [ ] README quick start
- [ ] Docs reference models/commands
- [ ] Example datasets linked
EOF
P2_S9_JSON=$(create_issue "$P2_REPO" "$P2_S9_TITLE" "$P2_S9_BODY")
P2_S9_NUM=$(echo "$P2_S9_JSON" | jq -r '.number')
P2_S9_URL=$(echo "$P2_S9_JSON" | jq -r '.html_url')
comment_issue "$P2_REPO" "$P2_S9_NUM" "Tracked in $P2_URL"

P2_PARENT_UPDATE="$TMP_DIR/p2_parent_update.md"
cat >"$P2_PARENT_UPDATE" <<EOF
$(cat "$P2_BODY")

### Sub-issues

- [ ] [$P2_S1_TITLE]($P2_S1_URL)
- [ ] [$P2_S2_TITLE]($P2_S2_URL)
- [ ] [$P2_S3_TITLE]($P2_S3_URL)
- [ ] [$P2_S4_TITLE]($P2_S4_URL)
- [ ] [$P2_S5_TITLE]($P2_S5_URL)
- [ ] [$P2_S6_TITLE]($P2_S6_URL)
- [ ] [$P2_S7_TITLE]($P2_S7_URL)
- [ ] [$P2_S8_TITLE]($P2_S8_URL)
- [ ] [$P2_S9_TITLE]($P2_S9_URL)
EOF
replace_issue_body "$P2_REPO" "$P2_NUM" "$P2_PARENT_UPDATE"

################################################################################
# Project 3 — Django GTFS (Realtime)
################################################################################

P3_REPO="$ORG/django-app-gtfs"
P3_TITLE="Django GTFS (Realtime)"
P3_BODY="$TMP_DIR/p3_body.md"
cat >"$P3_BODY" <<'EOF'
### Project 3 — Django GTFS application (Realtime version)

#### General Objective

Develop a Django application with models and utilities for GTFS Realtime (Protocol Buffers) data management and its integration with Schedule.

#### Specific Objectives

- Update and complete models aligned with the GTFS Realtime specification, with relations to Schedule entities (trips, stops).
- Create a schema document as a single source of truth.
- Define identifiers/keys consistent with Schedule and, when applicable, composite.
- Module to build the `TripUpdates` entity with the arrival-time estimator.
- Implement a fixtures creation tool.
- Serialization/decoding modules (Protocol Buffers) for `VehiclePositions`, `TripUpdates`, and `Alerts`.
- Validation of data feeds (timestamps, identifier consistency) and utilities to convert to JSON.
- Publish as a Django extension on PyPI (currently a Git submodule).
- Create documentation with publish/consume examples.

#### Technologies

Repository: https://github.com/simovilab/django-app-gtfs

- Python
- Django
- Protocol Buffers
- `gtfs-realtime-bindings` (Python)
- Vue (documentation)
EOF

P3_CREATE_JSON=$(create_issue "$P3_REPO" "$P3_TITLE" "$P3_BODY")
P3_NUM=$(echo "$P3_CREATE_JSON" | jq -r '.number')
P3_URL=$(echo "$P3_CREATE_JSON" | jq -r '.html_url')

# Sub-issues for Project 3
P3_S1_TITLE="Schema document for GTFS Realtime"
P3_S1_BODY="$TMP_DIR/p3_s1.md"
cat >"$P3_S1_BODY" <<'EOF'
**Description**

Author a source-of-truth schema aligned to the spec.

**Acceptance Criteria**

- [ ] Entities and relationships to Schedule defined
- [ ] Identifier strategy aligned with Schedule
- [ ] Versioned and referenced by code
EOF
P3_S1_JSON=$(create_issue "$P3_REPO" "$P3_S1_TITLE" "$P3_S1_BODY")
P3_S1_NUM=$(echo "$P3_S1_JSON" | jq -r '.number')
P3_S1_URL=$(echo "$P3_S1_JSON" | jq -r '.html_url')
comment_issue "$P3_REPO" "$P3_S1_NUM" "Tracked in $P3_URL"

P3_S2_TITLE="Implement models aligned to GTFS Realtime"
P3_S2_BODY="$TMP_DIR/p3_s2.md"
cat >"$P3_S2_BODY" <<'EOF'
**Description**

Add Django models for Realtime entities.

**Acceptance Criteria**

- [ ] Entities for TripUpdates, VehiclePositions, Alerts
- [ ] Relations to Schedule entities
- [ ] Constraints and indexes in place
EOF
P3_S2_JSON=$(create_issue "$P3_REPO" "$P3_S2_TITLE" "$P3_S2_BODY")
P3_S2_NUM=$(echo "$P3_S2_JSON" | jq -r '.number')
P3_S2_URL=$(echo "$P3_S2_JSON" | jq -r '.html_url')
comment_issue "$P3_REPO" "$P3_S2_NUM" "Tracked in $P3_URL"

P3_S3_TITLE="Protobuf encode/decode modules"
P3_S3_BODY="$TMP_DIR/p3_s3.md"
cat >"$P3_S3_BODY" <<'EOF'
**Description**

Serialize/deserialize feeds using gtfs-realtime-bindings.

**Acceptance Criteria**

- [ ] Encode TripUpdates/VehiclePositions/Alerts
- [ ] Decode and validate incoming feeds
- [ ] Unit tests with sample binaries
EOF
P3_S3_JSON=$(create_issue "$P3_REPO" "$P3_S3_TITLE" "$P3_S3_BODY")
P3_S3_NUM=$(echo "$P3_S3_JSON" | jq -r '.number')
P3_S3_URL=$(echo "$P3_S3_JSON" | jq -r '.html_url')
comment_issue "$P3_REPO" "$P3_S3_NUM" "Tracked in $P3_URL"

P3_S4_TITLE="Feed validation and JSON conversion"
P3_S4_BODY="$TMP_DIR/p3_s4.md"
cat >"$P3_S4_BODY" <<'EOF'
**Description**

Validate timestamps/IDs and export JSON helpers.

**Acceptance Criteria**

- [ ] Timestamp monotonicity checks
- [ ] Identifier consistency vs Schedule
- [ ] JSON conversion utilities documented
EOF
P3_S4_JSON=$(create_issue "$P3_REPO" "$P3_S4_TITLE" "$P3_S4_BODY")
P3_S4_NUM=$(echo "$P3_S4_JSON" | jq -r '.number')
P3_S4_URL=$(echo "$P3_S4_JSON" | jq -r '.html_url')
comment_issue "$P3_REPO" "$P3_S4_NUM" "Tracked in $P3_URL"

P3_S5_TITLE="TripUpdates builder using ETA estimator"
P3_S5_BODY="$TMP_DIR/p3_s5.md"
cat >"$P3_S5_BODY" <<'EOF'
**Description**

Build TripUpdates with ETA module.

**Acceptance Criteria**

- [ ] Builder function with tests
- [ ] Performance validated under load
- [ ] Deterministic synthetic fixtures
EOF
P3_S5_JSON=$(create_issue "$P3_REPO" "$P3_S5_TITLE" "$P3_S5_BODY")
P3_S5_NUM=$(echo "$P3_S5_JSON" | jq -r '.number')
P3_S5_URL=$(echo "$P3_S5_JSON" | jq -r '.html_url')
comment_issue "$P3_REPO" "$P3_S5_NUM" "Tracked in $P3_URL"

P3_S6_TITLE="Fixtures and sample feeds"
P3_S6_BODY="$TMP_DIR/p3_s6.md"
cat >"$P3_S6_BODY" <<'EOF'
**Description**

Provide reproducible sample data.

**Acceptance Criteria**

- [ ] Small fixtures in repo
- [ ] Scripts to regenerate
- [ ] Used by tests/docs
EOF
P3_S6_JSON=$(create_issue "$P3_REPO" "$P3_S6_TITLE" "$P3_S6_BODY")
P3_S6_NUM=$(echo "$P3_S6_JSON" | jq -r '.number')
P3_S6_URL=$(echo "$P3_S6_JSON" | jq -r '.html_url')
comment_issue "$P3_REPO" "$P3_S6_NUM" "Tracked in $P3_URL"

P3_S7_TITLE="Publish to PyPI"
P3_S7_BODY="$TMP_DIR/p3_s7.md"
cat >"$P3_S7_BODY" <<'EOF'
**Description**

Package and release.

**Acceptance Criteria**

- [ ] Packaging metadata complete
- [ ] Release workflow configured
- [ ] Install/test verified
EOF
P3_S7_JSON=$(create_issue "$P3_REPO" "$P3_S7_TITLE" "$P3_S7_BODY")
P3_S7_NUM=$(echo "$P3_S7_JSON" | jq -r '.number')
P3_S7_URL=$(echo "$P3_S7_JSON" | jq -r '.html_url')
comment_issue "$P3_REPO" "$P3_S7_NUM" "Tracked in $P3_URL"

P3_S8_TITLE="Documentation with publish/consume examples"
P3_S8_BODY="$TMP_DIR/p3_s8.md"
cat >"$P3_S8_BODY" <<'EOF'
**Description**

Show minimal producers/consumers.

**Acceptance Criteria**

- [ ] Producer and consumer snippets
- [ ] Error handling patterns
- [ ] Links to spec and bindings
EOF
P3_S8_JSON=$(create_issue "$P3_REPO" "$P3_S8_TITLE" "$P3_S8_BODY")
P3_S8_NUM=$(echo "$P3_S8_JSON" | jq -r '.number')
P3_S8_URL=$(echo "$P3_S8_JSON" | jq -r '.html_url')
comment_issue "$P3_REPO" "$P3_S8_NUM" "Tracked in $P3_URL"

P3_PARENT_UPDATE="$TMP_DIR/p3_parent_update.md"
cat >"$P3_PARENT_UPDATE" <<EOF
$(cat "$P3_BODY")

### Sub-issues

- [ ] [$P3_S1_TITLE]($P3_S1_URL)
- [ ] [$P3_S2_TITLE]($P3_S2_URL)
- [ ] [$P3_S3_TITLE]($P3_S3_URL)
- [ ] [$P3_S4_TITLE]($P3_S4_URL)
- [ ] [$P3_S5_TITLE]($P3_S5_URL)
- [ ] [$P3_S6_TITLE]($P3_S6_URL)
- [ ] [$P3_S7_TITLE]($P3_S7_URL)
- [ ] [$P3_S8_TITLE]($P3_S8_URL)
EOF
replace_issue_body "$P3_REPO" "$P3_NUM" "$P3_PARENT_UPDATE"

################################################################################
# Project 4 — ETA models from historical data (repo: django-app-gtfs)
################################################################################

P4_REPO="$ORG/django-app-gtfs"
P4_TITLE="ETA models from historical data"
P4_BODY="$TMP_DIR/p4_body.md"
cat >"$P4_BODY" <<'EOF'
### Project 4 — Model builder with historical data

#### General Objective

Build a training and inference module for models that estimate arrival times (ETA) from historical data and telemetry, integrated with the GTFS Schedule and Realtime applications.

#### Specific Objectives

- Design the strategy for collecting and cleaning historical data (sources, schema, and ETL): deduplication, handling time gaps, sampling, and alignment with Schedule entities.
- Implement feature generation (time of day, weekday/holiday, stop sequence, distance to next stop, headway, approximate congestion, optional weather).
- Implement baseline models: historical median and polynomial regression per route–segment–stop, with fallback levels when there is insufficient history.
- Define a temporal training and evaluation protocol (rolling): MAE, RMSE, and MAPE metrics and automatic selection of the best model per segment.
- Design and implement the model registry (versioning): store parameters/coefficients in PostgreSQL and cache in Redis for low latency.
- Develop the inference function `estimate_stop_times()` usable from Schedule and Realtime, supporting batch and online inference.
- Schedule periodic retraining (daily/weekly), historical backfill, and error drift monitoring.
- Integrate with Projects 2 and 3 (coherent keys, input/output contracts) and expose hooks for APIs.
- Create unit/integration tests and a reproducible synthetic validation dataset.

#### Technologies

Repository: https://github.com/simovilab/django-app-gtfs

- Python
- Pandas
- NumPy
- SciPy
- scikit-learn
- PostgreSQL
- Redis
EOF
P4_CREATE_JSON=$(create_issue "$P4_REPO" "$P4_TITLE" "$P4_BODY")
P4_NUM=$(echo "$P4_CREATE_JSON" | jq -r '.number')
P4_URL=$(echo "$P4_CREATE_JSON" | jq -r '.html_url')

# Sub-issues for Project 4
P4_S1_TITLE="Data ingestion and cleaning plan (ETL)"
P4_S1_BODY="$TMP_DIR/p4_s1.md"
cat >"$P4_S1_BODY" <<'EOF'
**Description**

Define sources, schema, deduplication, gap handling, sampling, alignment to Schedule.

**Acceptance Criteria**

- [ ] Written plan and initial pipeline skeleton
- [ ] Unit tests for dedup/gap-filling
- [ ] Reproducible run on sample data
EOF
P4_S1_JSON=$(create_issue "$P4_REPO" "$P4_S1_TITLE" "$P4_S1_BODY")
P4_S1_NUM=$(echo "$P4_S1_JSON" | jq -r '.number')
P4_S1_URL=$(echo "$P4_S1_JSON" | jq -r '.html_url')
comment_issue "$P4_REPO" "$P4_S1_NUM" "Tracked in $P4_URL"

P4_S2_TITLE="Feature engineering module"
P4_S2_BODY="$TMP_DIR/p4_s2.md"
cat >"$P4_S2_BODY" <<'EOF'
**Description**

Implement features (time-of-day, weekday/holiday, sequence, distance to next stop, headway, congestion proxy, weather optional).

**Acceptance Criteria**

- [ ] Feature functions with docstrings
- [ ] Tests on edge cases (first/last stop, missing GPS)
- [ ] Timing benchmarks recorded
EOF
P4_S2_JSON=$(create_issue "$P4_REPO" "$P4_S2_TITLE" "$P4_S2_BODY")
P4_S2_NUM=$(echo "$P4_S2_JSON" | jq -r '.number')
P4_S2_URL=$(echo "$P4_S2_JSON" | jq -r '.html_url')
comment_issue "$P4_REPO" "$P4_S2_NUM" "Tracked in $P4_URL"

P4_S3_TITLE="Baseline models: historical median and polynomial regression"
P4_S3_BODY="$TMP_DIR/p4_s3.md"
cat >"$P4_S3_BODY" <<'EOF'
**Description**

Implement per route-segment-stop baselines with fallbacks.

**Acceptance Criteria**

- [ ] Median baseline with data sufficiency checks
- [ ] Polynomial regression with regularization
- [ ] Fallback hierarchy documented and tested
EOF
P4_S3_JSON=$(create_issue "$P4_REPO" "$P4_S3_TITLE" "$P4_S3_BODY")
P4_S3_NUM=$(echo "$P4_S3_JSON" | jq -r '.number')
P4_S3_URL=$(echo "$P4_S3_JSON" | jq -r '.html_url')
comment_issue "$P4_REPO" "$P4_S3_NUM" "Tracked in $P4_URL"

P4_S4_TITLE="Rolling training and evaluation protocol"
P4_S4_BODY="$TMP_DIR/p4_s4.md"
cat >"$P4_S4_BODY" <<'EOF'
**Description**

Temporal split, MAE/RMSE/MAPE metrics, model selection per segment.

**Acceptance Criteria**

- [ ] Rolling window evaluation implemented
- [ ] Metrics computed and stored
- [ ] Best model per segment selected reproducibly
EOF
P4_S4_JSON=$(create_issue "$P4_REPO" "$P4_S4_TITLE" "$P4_S4_BODY")
P4_S4_NUM=$(echo "$P4_S4_JSON" | jq -r '.number')
P4_S4_URL=$(echo "$P4_S4_JSON" | jq -r '.html_url')
comment_issue "$P4_REPO" "$P4_S4_NUM" "Tracked in $P4_URL"

P4_S5_TITLE="Model registry (PostgreSQL) and Redis cache"
P4_S5_BODY="$TMP_DIR/p4_s5.md"
cat >"$P4_S5_BODY" <<'EOF'
**Description**

Persist parameters/coefficients and enable low-latency retrieval.

**Acceptance Criteria**

- [ ] DB schema and CRUD for model versions
- [ ] Redis cache with TTL/invalidation
- [ ] Migration scripts and docs
EOF
P4_S5_JSON=$(create_issue "$P4_REPO" "$P4_S5_TITLE" "$P4_S5_BODY")
P4_S5_NUM=$(echo "$P4_S5_JSON" | jq -r '.number')
P4_S5_URL=$(echo "$P4_S5_JSON" | jq -r '.html_url')
comment_issue "$P4_REPO" "$P4_S5_NUM" "Tracked in $P4_URL"

P4_S6_TITLE="Inference function estimate_stop_times()"
P4_S6_BODY="$TMP_DIR/p4_s6.md"
cat >"$P4_S6_BODY" <<'EOF'
**Description**

Batch and online inference callable by Schedule/Realtime apps.

**Acceptance Criteria**

- [ ] Deterministic, typed interface with Pydantic
- [ ] Performance meets latency targets
- [ ] Unit/integration tests
EOF
P4_S6_JSON=$(create_issue "$P4_REPO" "$P4_S6_TITLE" "$P4_S6_BODY")
P4_S6_NUM=$(echo "$P4_S6_JSON" | jq -r '.number')
P4_S6_URL=$(echo "$P4_S6_JSON" | jq -r '.html_url')
comment_issue "$P4_REPO" "$P4_S6_NUM" "Tracked in $P4_URL"

P4_S7_TITLE="Scheduled retraining and backfill"
P4_S7_BODY="$TMP_DIR/p4_s7.md"
cat >"$P4_S7_BODY" <<'EOF'
**Description**

Automate daily/weekly retraining and historical backfill.

**Acceptance Criteria**

- [ ] Scheduler jobs (Celery/cron) defined
- [ ] Metrics for drift tracked
- [ ] Runbooks documented
EOF
P4_S7_JSON=$(create_issue "$P4_REPO" "$P4_S7_TITLE" "$P4_S7_BODY")
P4_S7_NUM=$(echo "$P4_S7_JSON" | jq -r '.number')
P4_S7_URL=$(echo "$P4_S7_JSON" | jq -r '.html_url')
comment_issue "$P4_REPO" "$P4_S7_NUM" "Tracked in $P4_URL"

P4_S8_TITLE="Integration with Projects 2 and 3"
P4_S8_BODY="$TMP_DIR/p4_s8.md"
cat >"$P4_S8_BODY" <<'EOF'
**Description**

Coherent keys and I/O contracts; hooks for APIs.

**Acceptance Criteria**

- [ ] Contracts documented
- [ ] End-to-end test with Schedule/Realtime
- [ ] Error handling paths covered
EOF
P4_S8_JSON=$(create_issue "$P4_REPO" "$P4_S8_TITLE" "$P4_S8_BODY")
P4_S8_NUM=$(echo "$P4_S8_JSON" | jq -r '.number')
P4_S8_URL=$(echo "$P4_S8_JSON" | jq -r '.html_url')
comment_issue "$P4_REPO" "$P4_S8_NUM" "Tracked in $P4_URL"

P4_S9_TITLE="Synthetic validation dataset"
P4_S9_BODY="$TMP_DIR/p4_s9.md"
cat >"$P4_S9_BODY" <<'EOF'
**Description**

Provide reproducible synthetic data for tests.

**Acceptance Criteria**

- [ ] Generator script with seed
- [ ] Dataset stored under tests/fixtures
- [ ] Used in CI
EOF
P4_S9_JSON=$(create_issue "$P4_REPO" "$P4_S9_TITLE" "$P4_S9_BODY")
P4_S9_NUM=$(echo "$P4_S9_JSON" | jq -r '.number')
P4_S9_URL=$(echo "$P4_S9_JSON" | jq -r '.html_url')
comment_issue "$P4_REPO" "$P4_S9_NUM" "Tracked in $P4_URL"

P4_S10_TITLE="Metrics report"
P4_S10_BODY="$TMP_DIR/p4_s10.md"
cat >"$P4_S10_BODY" <<'EOF'
**Description**

Summarize performance and trade-offs.

**Acceptance Criteria**

- [ ] Report with MAE/RMSE/MAPE per segment
- [ ] Baselines vs chosen models compared
- [ ] Recommendations for deployment
EOF
P4_S10_JSON=$(create_issue "$P4_REPO" "$P4_S10_TITLE" "$P4_S10_BODY")
P4_S10_NUM=$(echo "$P4_S10_JSON" | jq -r '.number')
P4_S10_URL=$(echo "$P4_S10_JSON" | jq -r '.html_url')
comment_issue "$P4_REPO" "$P4_S10_NUM" "Tracked in $P4_URL"

P4_PARENT_UPDATE="$TMP_DIR/p4_parent_update.md"
cat >"$P4_PARENT_UPDATE" <<EOF
$(cat "$P4_BODY")

### Sub-issues

- [ ] [$P4_S1_TITLE]($P4_S1_URL)
- [ ] [$P4_S2_TITLE]($P4_S2_URL)
- [ ] [$P4_S3_TITLE]($P4_S3_URL)
- [ ] [$P4_S4_TITLE]($P4_S4_URL)
- [ ] [$P4_S5_TITLE]($P4_S5_URL)
- [ ] [$P4_S6_TITLE]($P4_S6_URL)
- [ ] [$P4_S7_TITLE]($P4_S7_URL)
- [ ] [$P4_S8_TITLE]($P4_S8_URL)
- [ ] [$P4_S9_TITLE]($P4_S9_URL)
- [ ] [$P4_S10_TITLE]($P4_S10_URL)
EOF
replace_issue_body "$P4_REPO" "$P4_NUM" "$P4_PARENT_UPDATE"

################################################################################

################################################################################
# Project 11 — Signage editor (CLI and library)
################################################################################

P11_REPO="$ORG/infobus-py"
P11_TITLE="Signage CLI and library"
P11_BODY="$TMP_DIR/p11_body.md"
cat >"$P11_BODY" <<'EOF'
### Project 11 — Signage editor

#### General Objective

Create a CLI tool and Python library for programmatic generation of public transport signage (labels) — stops, vehicles, stations — outputting SVG/PDF/PNG, parameterizable by size, theme, and language, designed for use without a GUI and scalable to a future templating server.

#### Specific Objectives

- Design a template schema (YAML/JSON) to describe signage: dimensions, grids, typefaces, palettes, iconography, and dynamic fields (codes, routes, names, QR).
- Implement a composition engine based on SVG + Jinja2 with conversion to PDF/PNG; support embedded fonts and basic color profiles.
- Expose a CLI with subcommands: `stop`, `vehicle`, `route`, `station`, `custom`, with options: `--format svg|pdf|png`, `--size 1080x1920|mm`, `--dpi`, `--theme`, `--lang`, `--qr-url`.
- Integrate data from Infobús/GTFS when provided: if `--stop-id` or `--route-id` is supplied, populate texts/codes from the API or local files.
- Generate QR and legible codes (high contrast), margins/bleed, and crop marks for printing.
- Validate inputs and template files with Pydantic; friendly error output (Rich).
- Integrate the `signage` subcommand into the existing `infobus` CLI (Click) without breaking compatibility; package with `pyproject.toml` and publish on PyPI.
- Include a minimal set of templates: stop (vertical/horizontal), vehicle (interior/exterior), modular station.
- Golden-image tests for SVG/PNG and CLI tests; automatic lint/format.
- Brief documentation with reproducible examples and local preview; Dockerfile for consistent rendering.

#### Technologies

Repository: https://github.com/simovilab/infobus-py

- Python
- Click (existing CLI)
- Jinja2 (templates)
- CairoSVG (render/convert SVG to/from PNG/PDF)
- Pillow (raster composition and post-processing)
- Pydantic (I/O validation)
- PyYAML / JSON (templates/configuration)
- `segno` or `qrcode` (QR codes)
- Rich (CLI output)
- Inter (primary typeface) + complementary free fonts (e.g., Noto Symbols/Emoji)
EOF

P11_CREATE_JSON=$(create_issue "$P11_REPO" "$P11_TITLE" "$P11_BODY")
P11_NUM=$(echo "$P11_CREATE_JSON" | jq -r '.number')
P11_URL=$(echo "$P11_CREATE_JSON" | jq -r '.html_url')

# Sub-issues for Project 11
P11_S1_TITLE="Template schema (YAML/JSON)"
P11_S1_BODY="$TMP_DIR/p11_s1.md"
cat >"$P11_S1_BODY" <<'EOF'
**Description**

Define template format for dimensions, grid, fonts (Inter), palette, icons, dynamic fields.

**Acceptance Criteria**

- [ ] Pydantic models and JSON Schema exported
- [ ] Examples for stop/vehicle/station
- [ ] Validation errors are human-friendly
EOF
P11_S1_JSON=$(create_issue "$P11_REPO" "$P11_S1_TITLE" "$P11_S1_BODY")
P11_S1_NUM=$(echo "$P11_S1_JSON" | jq -r '.number')
P11_S1_URL=$(echo "$P11_S1_JSON" | jq -r '.html_url')
comment_issue "$P11_REPO" "$P11_S1_NUM" "Tracked in $P11_URL"

P11_S2_TITLE="SVG + Jinja2 composition engine"
P11_S2_BODY="$TMP_DIR/p11_s2.md"
cat >"$P11_S2_BODY" <<'EOF'
**Description**

Render SVG from templates and data; convert to PDF/PNG.

**Acceptance Criteria**

- [ ] Jinja2 environment with autoescape for SVG/XML
- [ ] CairoSVG conversion to PDF/PNG
- [ ] Deterministic outputs with pinned versions
EOF
P11_S2_JSON=$(create_issue "$P11_REPO" "$P11_S2_TITLE" "$P11_S2_BODY")
P11_S2_NUM=$(echo "$P11_S2_JSON" | jq -r '.number')
P11_S2_URL=$(echo "$P11_S2_JSON" | jq -r '.html_url')
comment_issue "$P11_REPO" "$P11_S2_NUM" "Tracked in $P11_URL"

P11_S3_TITLE="CLI subcommands integrated into existing Click CLI (infobus)"
P11_S3_BODY="$TMP_DIR/p11_s3.md"
cat >"$P11_S3_BODY" <<'EOF'
**Description**

Add `signage` group with `stop`, `vehicle`, `route`, `station`, `custom`.

**Acceptance Criteria**

- [ ] Commands and options implemented (`--format`, `--size`, `--dpi`, `--theme`, `--lang`, `--qr-url`)
- [ ] Help text and examples
- [ ] Backward compatibility preserved
EOF
P11_S3_JSON=$(create_issue "$P11_REPO" "$P11_S3_TITLE" "$P11_S3_BODY")
P11_S3_NUM=$(echo "$P11_S3_JSON" | jq -r '.number')
P11_S3_URL=$(echo "$P11_S3_JSON" | jq -r '.html_url')
comment_issue "$P11_REPO" "$P11_S3_NUM" "Tracked in $P11_URL"

P11_S4_TITLE="Infobús/GTFS data integration (optional)"
P11_S4_BODY="$TMP_DIR/p11_s4.md"
cat >"$P11_S4_BODY" <<'EOF'
**Description**

Populate fields from API or local files when IDs provided.

**Acceptance Criteria**

- [ ] `--stop-id` and `--route-id` supported
- [ ] HTTP client with retries/timeouts
- [ ] Local fallback documented
EOF
P11_S4_JSON=$(create_issue "$P11_REPO" "$P11_S4_TITLE" "$P11_S4_BODY")
P11_S4_NUM=$(echo "$P11_S4_JSON" | jq -r '.number')
P11_S4_URL=$(echo "$P11_S4_JSON" | jq -r '.html_url')
comment_issue "$P11_REPO" "$P11_S4_NUM" "Tracked in $P11_URL"

P11_S5_TITLE="QR generation and print features"
P11_S5_BODY="$TMP_DIR/p11_s5.md"
cat >"$P11_S5_BODY" <<'EOF'
**Description**

Generate QR codes and add bleed/crop marks.

**Acceptance Criteria**

- [ ] segno/qrcode integrated for QR
- [ ] High-contrast text and accessibility checks
- [ ] Bleed/crop configurable
EOF
P11_S5_JSON=$(create_issue "$P11_REPO" "$P11_S5_TITLE" "$P11_S5_BODY")
P11_S5_NUM=$(echo "$P11_S5_JSON" | jq -r '.number')
P11_S5_URL=$(echo "$P11_S5_JSON" | jq -r '.html_url')
comment_issue "$P11_REPO" "$P11_S5_NUM" "Tracked in $P11_URL"

P11_S6_TITLE="Validation and rich error output"
P11_S6_BODY="$TMP_DIR/p11_s6.md"
cat >"$P11_S6_BODY" <<'EOF'
**Description**

Validate inputs/templates with Pydantic and show nice errors.

**Acceptance Criteria**

- [ ] Clear, structured errors printed with Rich
- [ ] Non-zero exit codes on failure
- [ ] Tests for invalid inputs
EOF
P11_S6_JSON=$(create_issue "$P11_REPO" "$P11_S6_TITLE" "$P11_S6_BODY")
P11_S6_NUM=$(echo "$P11_S6_JSON" | jq -r '.number')
P11_S6_URL=$(echo "$P11_S6_JSON" | jq -r '.html_url')
comment_issue "$P11_REPO" "$P11_S6_NUM" "Tracked in $P11_URL"

P11_S7_TITLE="Starter templates and themes"
P11_S7_BODY="$TMP_DIR/p11_s7.md"
cat >"$P11_S7_BODY" <<'EOF'
**Description**

Provide base templates for stop/vehicle/station.

**Acceptance Criteria**

- [ ] Vertical/horizontal stop templates
- [ ] Vehicle interior/exterior (A4/A3) templates
- [ ] Station modular template
EOF
P11_S7_JSON=$(create_issue "$P11_REPO" "$P11_S7_TITLE" "$P11_S7_BODY")
P11_S7_NUM=$(echo "$P11_S7_JSON" | jq -r '.number')
P11_S7_URL=$(echo "$P11_S7_JSON" | jq -r '.html_url')
comment_issue "$P11_REPO" "$P11_S7_NUM" "Tracked in $P11_URL"

P11_S8_TITLE="Golden-image tests"
P11_S8_BODY="$TMP_DIR/p11_s8.md"
cat >"$P11_S8_BODY" <<'EOF'
**Description**

Assert rendered SVG/PNG match approved baselines.

**Acceptance Criteria**

- [ ] Baselines in tests/golden
- [ ] Normalized SVG diff and pixel/perceptual diff for PNG
- [ ] Simple command to regenerate baselines
EOF
P11_S8_JSON=$(create_issue "$P11_REPO" "$P11_S8_TITLE" "$P11_S8_BODY")
P11_S8_NUM=$(echo "$P11_S8_JSON" | jq -r '.number')
P11_S8_URL=$(echo "$P11_S8_JSON" | jq -r '.html_url')
comment_issue "$P11_REPO" "$P11_S8_NUM" "Tracked in $P11_URL"

P11_S9_TITLE="Packaging and pre-release to PyPI"
P11_S9_BODY="$TMP_DIR/p11_s9.md"
cat >"$P11_S9_BODY" <<'EOF'
**Description**

Package with pyproject and publish pre-release.

**Acceptance Criteria**

- [ ] Entry points for Click CLI (`infobus signage`)
- [ ] Wheels/sdist built in CI
- [ ] Pre-release published and tagged
EOF
P11_S9_JSON=$(create_issue "$P11_REPO" "$P11_S9_TITLE" "$P11_S9_BODY")
P11_S9_NUM=$(echo "$P11_S9_JSON" | jq -r '.number')
P11_S9_URL=$(echo "$P11_S9_JSON" | jq -r '.html_url')
comment_issue "$P11_REPO" "$P11_S9_NUM" "Tracked in $P11_URL"

P11_S10_TITLE="Docker image for consistent rendering"
P11_S10_BODY="$TMP_DIR/p11_s10.md"
cat >"$P11_S10_BODY" <<'EOF'
**Description**

Provide container to ensure font/render parity.

**Acceptance Criteria**

- [ ] Dockerfile bundling CairoSVG and Inter fonts
- [ ] Example usage in README
- [ ] Determinism notes included
EOF
P11_S10_JSON=$(create_issue "$P11_REPO" "$P11_S10_TITLE" "$P11_S10_BODY")
P11_S10_NUM=$(echo "$P11_S10_JSON" | jq -r '.number')
P11_S10_URL=$(echo "$P11_S10_JSON" | jq -r '.html_url')
comment_issue "$P11_REPO" "$P11_S10_NUM" "Tracked in $P11_URL"

P11_S11_TITLE="Documentation and examples"
P11_S11_BODY="$TMP_DIR/p11_s11.md"
cat >"$P11_S11_BODY" <<'EOF'
**Description**

Minimal docs to get started and preview locally.

**Acceptance Criteria**

- [ ] README quick start and options
- [ ] Example commands and outputs
- [ ] Notes on font licensing (Inter) and usage
EOF
P11_S11_JSON=$(create_issue "$P11_REPO" "$P11_S11_TITLE" "$P11_S11_BODY")
P11_S11_NUM=$(echo "$P11_S11_JSON" | jq -r '.number')
P11_S11_URL=$(echo "$P11_S11_JSON" | jq -r '.html_url')
comment_issue "$P11_REPO" "$P11_S11_NUM" "Tracked in $P11_URL"

P11_PARENT_UPDATE="$TMP_DIR/p11_parent_update.md"
cat >"$P11_PARENT_UPDATE" <<EOF
$(cat "$P11_BODY")

### Sub-issues

- [ ] [$P11_S1_TITLE]($P11_S1_URL)
- [ ] [$P11_S2_TITLE]($P11_S2_URL)
- [ ] [$P11_S3_TITLE]($P11_S3_URL)
- [ ] [$P11_S4_TITLE]($P11_S4_URL)
- [ ] [$P11_S5_TITLE]($P11_S5_URL)
- [ ] [$P11_S6_TITLE]($P11_S6_URL)
- [ ] [$P11_S7_TITLE]($P11_S7_URL)
- [ ] [$P11_S8_TITLE]($P11_S8_URL)
- [ ] [$P11_S9_TITLE]($P11_S9_URL)
- [ ] [$P11_S10_TITLE]($P11_S10_URL)
- [ ] [$P11_S11_TITLE]($P11_S11_URL)
EOF
replace_issue_body "$P11_REPO" "$P11_NUM" "$P11_PARENT_UPDATE"

################################################################################
# Project 5 — Long-term ETA method (doctoral)
################################################################################

P5_REPO="$ORG/databus-py"
P5_TITLE="Long-term ETA method (doctoral)"
P5_BODY="$TMP_DIR/p5_body.md"
cat >"$P5_BODY" <<'EOF'
### Project 5 — Long-term arrival-time prediction method

(Doctoral work)

Scope intentionally minimal in the roadmap; implementation details will be refined in the research plan and evolve independently.
EOF

P5_CREATE_JSON=$(create_issue "$P5_REPO" "$P5_TITLE" "$P5_BODY")
P5_NUM=$(echo "$P5_CREATE_JSON" | jq -r '.number')
P5_URL=$(echo "$P5_CREATE_JSON" | jq -r '.html_url')

# Sub-issues for Project 5
P5_S1_TITLE="Scope and research questions document"
P5_S1_BODY="$TMP_DIR/p5_s1.md"
cat >"$P5_S1_BODY" <<'EOF'
**Description**

Define objectives, hypotheses, and evaluation protocol.

**Acceptance Criteria**

- [ ] Problem statement and goals written
- [ ] Data and methods outline
- [ ] Milestones and risks listed
EOF
P5_S1_JSON=$(create_issue "$P5_REPO" "$P5_S1_TITLE" "$P5_S1_BODY")
P5_S1_URL=$(echo "$P5_S1_JSON" | jq -r '.html_url')
comment_issue "$P5_REPO" "$(echo "$P5_S1_JSON" | jq -r '.number')" "Tracked in $P5_URL"

P5_S2_TITLE="Baseline experiment plan"
P5_S2_BODY="$TMP_DIR/p5_s2.md"
cat >"$P5_S2_BODY" <<'EOF'
**Description**

Design initial baselines and metrics.

**Acceptance Criteria**

- [ ] Candidate models and features listed
- [ ] Train/validation split strategy defined
- [ ] Reproducibility plan (seeds, env) noted
EOF
P5_S2_JSON=$(create_issue "$P5_REPO" "$P5_S2_TITLE" "$P5_S2_BODY")
P5_S2_URL=$(echo "$P5_S2_JSON" | jq -r '.html_url')
comment_issue "$P5_REPO" "$(echo "$P5_S2_JSON" | jq -r '.number')" "Tracked in $P5_URL"

P5_S3_TITLE="Data requirements and ethics checklist"
P5_S3_BODY="$TMP_DIR/p5_s3.md"
cat >"$P5_S3_BODY" <<'EOF'
**Description**

Specify datasets, privacy, and governance.

**Acceptance Criteria**

- [ ] Data sources and licenses documented
- [ ] Privacy/ethics considerations addressed
- [ ] Approval process (if any) captured
EOF
P5_S3_JSON=$(create_issue "$P5_REPO" "$P5_S3_TITLE" "$P5_S3_BODY")
P5_S3_URL=$(echo "$P5_S3_JSON" | jq -r '.html_url')
comment_issue "$P5_REPO" "$(echo "$P5_S3_JSON" | jq -r '.number')" "Tracked in $P5_URL"

P5_PARENT_UPDATE="$TMP_DIR/p5_parent_update.md"
cat >"$P5_PARENT_UPDATE" <<EOF
$(cat "$P5_BODY")

### Sub-issues

- [ ] [$P5_S1_TITLE]($P5_S1_URL)
- [ ] [$P5_S2_TITLE]($P5_S2_URL)
- [ ] [$P5_S3_TITLE]($P5_S3_URL)
EOF
replace_issue_body "$P5_REPO" "$P5_NUM" "$P5_PARENT_UPDATE"

################################################################################
# Project 6 — Bus movement simulator
################################################################################

P6_REPO="$ORG/simbus"
P6_TITLE="Bus movement simulator"
P6_BODY="$TMP_DIR/p6_body.md"
cat >"$P6_BODY" <<'EOF'
### Project 6 — Bus movement simulator

#### General Objective

Create a deterministic and reproducible simulation module of bus movement based on GTFS Schedule, for end-to-end system tests and intermediate stages.

#### Specific Objectives

- Ingest a GTFS bundle and generate parameterizable simulation scenarios (routes, trips, frequencies).
- Simulate vehicle movement in ticks (1–5 s) with speed profiles, dwell times by stop, and controlled stochastic variability (seed).
- Generate and send vehicle positions (and optionally synthetic TripUpdates/Alerts) to the Databús API to validate data pipelines.
- Implement simple perturbations (delays, detours, holding for headway control) for robustness tests.
- Orchestrate the simulation with Celery (periodic tasks and per-scenario queues).
- Provide scenario configuration via YAML/JSON (number of buses, routes to simulate, schedules, jitter, seed).
- Record events and basic metrics (on-time performance, service gaps) for validation.
- Expose management commands: `generate_scenario`, `start_sim`, `stop_sim`, `list_sims`.
- Create unit tests and synthetic fixtures.

#### Technologies

Repository: https://github.com/simovilab/simbus

- Python
- Django
- Celery
- NumPy (speed/noise profiles)
- YAML/JSON for scenario configuration

#### Deliverables

- Docker container for server installation
- Module with scenario components, simulation engine, and connectors to Databús.
- Example scenarios (small/medium) and synthetic data.
- Management commands to run the simulation.
- Extensive documentation.
EOF

P6_CREATE_JSON=$(create_issue "$P6_REPO" "$P6_TITLE" "$P6_BODY")
P6_NUM=$(echo "$P6_CREATE_JSON" | jq -r '.number')
P6_URL=$(echo "$P6_CREATE_JSON" | jq -r '.html_url')

# Sub-issues for Project 6
P6_S1_TITLE="Ingest GTFS and generate scenarios"
P6_S1_BODY="$TMP_DIR/p6_s1.md"
cat >"$P6_S1_BODY" <<'EOF'
**Description**

Build scenario objects from GTFS with parameters.

**Acceptance Criteria**

- [ ] Scenario builder with routes/trips/frequencies
- [ ] Configurable via YAML/JSON
- [ ] Validation and tests
EOF
P6_S1_JSON=$(create_issue "$P6_REPO" "$P6_S1_TITLE" "$P6_S1_BODY")
P6_S1_URL=$(echo "$P6_S1_JSON" | jq -r '.html_url')
comment_issue "$P6_REPO" "$(echo "$P6_S1_JSON" | jq -r '.number')" "Tracked in $P6_URL"

P6_S2_TITLE="Deterministic tick engine"
P6_S2_BODY="$TMP_DIR/p6_s2.md"
cat >"$P6_S2_BODY" <<'EOF'
**Description**

Simulate motion in ticks (1–5s) with seeds.

**Acceptance Criteria**

- [ ] Velocity profiles and dwell times modeled
- [ ] Seeded stochastic variability
- [ ] Performance benchmarked
EOF
P6_S2_JSON=$(create_issue "$P6_REPO" "$P6_S2_TITLE" "$P6_S2_BODY")
P6_S2_URL=$(echo "$P6_S2_JSON" | jq -r '.html_url')
comment_issue "$P6_REPO" "$(echo "$P6_S2_JSON" | jq -r '.number')" "Tracked in $P6_URL"

P6_S3_TITLE="Emit synthetic VehiclePositions/TripUpdates/Alerts to Databús"
P6_S3_BODY="$TMP_DIR/p6_s3.md"
cat >"$P6_S3_BODY" <<'EOF'
**Description**

Validate pipelines by sending synthetic data.

**Acceptance Criteria**

- [ ] HTTP client to Databús with retries/backoff
- [ ] Throttling controls
- [ ] Toggle for Alerts/TripUpdates
EOF
P6_S3_JSON=$(create_issue "$P6_REPO" "$P6_S3_TITLE" "$P6_S3_BODY")
P6_S3_URL=$(echo "$P6_S3_JSON" | jq -r '.html_url')
comment_issue "$P6_REPO" "$(echo "$P6_S3_JSON" | jq -r '.number')" "Tracked in $P6_URL"

P6_S4_TITLE="Perturbations: delays, detours, holding"
P6_S4_BODY="$TMP_DIR/p6_s4.md"
cat >"$P6_S4_BODY" <<'EOF'
**Description**

Add simple robustness scenarios.

**Acceptance Criteria**

- [ ] Configurable perturbations per scenario
- [ ] Effects visible in metrics
- [ ] Tests for each perturbation type
EOF
P6_S4_JSON=$(create_issue "$P6_REPO" "$P6_S4_TITLE" "$P6_S4_BODY")
P6_S4_URL=$(echo "$P6_S4_JSON" | jq -r '.html_url')
comment_issue "$P6_REPO" "$(echo "$P6_S4_JSON" | jq -r '.number')" "Tracked in $P6_URL"

P6_S5_TITLE="Orchestrate with Celery"
P6_S5_BODY="$TMP_DIR/p6_s5.md"
cat >"$P6_S5_BODY" <<'EOF'
**Description**

Periodic tasks and per-scenario queues.

**Acceptance Criteria**

- [ ] Celery beat and workers configured
- [ ] Task monitoring documented
- [ ] Graceful shutdown
EOF
P6_S5_JSON=$(create_issue "$P6_REPO" "$P6_S5_TITLE" "$P6_S5_BODY")
P6_S5_URL=$(echo "$P6_S5_JSON" | jq -r '.html_url')
comment_issue "$P6_REPO" "$(echo "$P6_S5_JSON" | jq -r '.number')" "Tracked in $P6_URL"

P6_S6_TITLE="Scenario configuration format"
P6_S6_BODY="$TMP_DIR/p6_s6.md"
cat >"$P6_S6_BODY" <<'EOF'
**Description**

YAML/JSON schema and examples.

**Acceptance Criteria**

- [ ] Schema validated with Pydantic
- [ ] Example small/medium scenarios included
- [ ] Docs updated
EOF
P6_S6_JSON=$(create_issue "$P6_REPO" "$P6_S6_TITLE" "$P6_S6_BODY")
P6_S6_URL=$(echo "$P6_S6_JSON" | jq -r '.html_url')
comment_issue "$P6_REPO" "$(echo "$P6_S6_JSON" | jq -r '.number')" "Tracked in $P6_URL"

P6_S7_TITLE="Metrics and logging"
P6_S7_BODY="$TMP_DIR/p6_s7.md"
cat >"$P6_S7_BODY" <<'EOF'
**Description**

Record OTP, headway adherence, gaps.

**Acceptance Criteria**

- [ ] Metrics collected and exported
- [ ] Structured logs
- [ ] Dashboard example (optional)
EOF
P6_S7_JSON=$(create_issue "$P6_REPO" "$P6_S7_TITLE" "$P6_S7_BODY")
P6_S7_URL=$(echo "$P6_S7_JSON" | jq -r '.html_url')
comment_issue "$P6_REPO" "$(echo "$P6_S7_JSON" | jq -r '.number')" "Tracked in $P6_URL"

P6_S8_TITLE="Management commands"
P6_S8_BODY="$TMP_DIR/p6_s8.md"
cat >"$P6_S8_BODY" <<'EOF'
**Description**

CLI to manage simulations.

**Acceptance Criteria**

- [ ] generate_scenario/start_sim/stop_sim/list_sims implemented
- [ ] Help text and examples
- [ ] Tested end-to-end
EOF
P6_S8_JSON=$(create_issue "$P6_REPO" "$P6_S8_TITLE" "$P6_S8_BODY")
P6_S8_URL=$(echo "$P6_S8_JSON" | jq -r '.html_url')
comment_issue "$P6_REPO" "$(echo "$P6_S8_JSON" | jq -r '.number')" "Tracked in $P6_URL"

P6_S9_TITLE="Unit tests and synthetic fixtures"
P6_S9_BODY="$TMP_DIR/p6_s9.md"
cat >"$P6_S9_BODY" <<'EOF'
**Description**

Ensure reliability and reproducibility.

**Acceptance Criteria**

- [ ] Fixtures under tests/
- [ ] CI passing
- [ ] Deterministic outputs with seeds
EOF
P6_S9_JSON=$(create_issue "$P6_REPO" "$P6_S9_TITLE" "$P6_S9_BODY")
P6_S9_URL=$(echo "$P6_S9_JSON" | jq -r '.html_url')
comment_issue "$P6_REPO" "$(echo "$P6_S9_JSON" | jq -r '.number')" "Tracked in $P6_URL"

P6_S10_TITLE="Docker container for server install"
P6_S10_BODY="$TMP_DIR/p6_s10.md"
cat >"$P6_S10_BODY" <<'EOF'
**Description**

Provide containerized runtime.

**Acceptance Criteria**

- [ ] Dockerfile with envs and healthcheck
- [ ] Compose example
- [ ] README deployment guide
EOF
P6_S10_JSON=$(create_issue "$P6_REPO" "$P6_S10_TITLE" "$P6_S10_BODY")
P6_S10_URL=$(echo "$P6_S10_JSON" | jq -r '.html_url')
comment_issue "$P6_REPO" "$(echo "$P6_S10_JSON" | jq -r '.number')" "Tracked in $P6_URL"

P6_PARENT_UPDATE="$TMP_DIR/p6_parent_update.md"
cat >"$P6_PARENT_UPDATE" <<EOF
$(cat "$P6_BODY")

### Sub-issues

- [ ] [$P6_S1_TITLE]($P6_S1_URL)
- [ ] [$P6_S2_TITLE]($P6_S2_URL)
- [ ] [$P6_S3_TITLE]($P6_S3_URL)
- [ ] [$P6_S4_TITLE]($P6_S4_URL)
- [ ] [$P6_S5_TITLE]($P6_S5_URL)
- [ ] [$P6_S6_TITLE]($P6_S6_URL)
- [ ] [$P6_S7_TITLE]($P6_S7_URL)
- [ ] [$P6_S8_TITLE]($P6_S8_URL)
- [ ] [$P6_S9_TITLE]($P6_S9_URL)
- [ ] [$P6_S10_TITLE]($P6_S10_URL)
EOF
replace_issue_body "$P6_REPO" "$P6_NUM" "$P6_PARENT_UPDATE"

################################################################################
# Project 7 — Infobús API
################################################################################

P7_REPO="$ORG/infobus"
P7_TITLE="Infobús API"
P7_BODY="$TMP_DIR/p7_body.md"
cat >"$P7_BODY" <<'EOF'
### Project 7 — Infobús API

#### General Objective

Provide a public passenger information API based on GTFS (Schedule/Realtime) and derived metrics, for consumption by websites, mobile apps, screens, and chatbots.

#### Specific Objectives

- Update and complete read endpoints: stops, routes, trips, arrivals/ETAs by stop and by route, service status, alerts, and (if applicable) headways/occupancy.
- Add search/autocomplete for stops and routes, and basic health checks.
- Update and complete documentation (OpenAPI) with request/response examples and error codes.
- Define and implement the storage/reading strategy: PostgreSQL for Schedule, Redis for cache/Realtime, and Fuseki if semantic views are exposed.
- Implement token-based authentication (e.g., JWT) for registered clients and define rate limits for public endpoints.
- Manage clients (sites, apps, screens, chatbots): registration, keys, quotas, and usage metrics.
- Manage permissions, security, and performance: CORS, pagination, ETag/HTTP caching, query limits, and rate limiting.
- Create an admin panel prototype (Django admin/dedicated panel) with basic metrics (traffic, latency, errors).
- Create unit, integration, and contract tests (validation against the OpenAPI schema).

#### Technologies

Repository: https://github.com/simovilab/infobus

- Python
- Django
- Django REST Framework
- PostgreSQL, Redis, Apache Jena Fuseki
- OpenAPI
- Vue (documentation)
EOF

P7_CREATE_JSON=$(create_issue "$P7_REPO" "$P7_TITLE" "$P7_BODY")
P7_NUM=$(echo "$P7_CREATE_JSON" | jq -r '.number')
P7_URL=$(echo "$P7_CREATE_JSON" | jq -r '.html_url')

# Sub-issues for Project 7
P7_S1_TITLE="Read endpoints: stops, routes, trips, arrivals/ETAs, status, alerts"
P7_S1_BODY="$TMP_DIR/p7_s1.md"
cat >"$P7_S1_BODY" <<'EOF'
**Description**

Implement core read endpoints.

**Acceptance Criteria**

- [ ] Endpoints implemented with pagination
- [ ] ETAs integrated with Project 4
- [ ] OpenAPI updated with examples
EOF
P7_S1_JSON=$(create_issue "$P7_REPO" "$P7_S1_TITLE" "$P7_S1_BODY")
P7_S1_URL=$(echo "$P7_S1_JSON" | jq -r '.html_url')
comment_issue "$P7_REPO" "$(echo "$P7_S1_JSON" | jq -r '.number')" "Tracked in $P7_URL"

P7_S2_TITLE="Search/autocomplete and health checks"
P7_S2_BODY="$TMP_DIR/p7_s2.md"
cat >"$P7_S2_BODY" <<'EOF'
**Description**

Add search and basic health endpoints.

**Acceptance Criteria**

- [ ] Search for stops/routes with ranking
- [ ] /health and /ready endpoints
- [ ] Tests for both
EOF
P7_S2_JSON=$(create_issue "$P7_REPO" "$P7_S2_TITLE" "$P7_S2_BODY")
P7_S2_URL=$(echo "$P7_S2_JSON" | jq -r '.html_url')
comment_issue "$P7_REPO" "$(echo "$P7_S2_JSON" | jq -r '.number')" "Tracked in $P7_URL"

P7_S3_TITLE="Storage/reading strategy"
P7_S3_BODY="$TMP_DIR/p7_s3.md"
cat >"$P7_S3_BODY" <<'EOF'
**Description**

PostgreSQL for Schedule, Redis for cache/Realtime, Fuseki optional.

**Acceptance Criteria**

- [ ] Data access layer implemented
- [ ] Cache keys/TTLs documented
- [ ] Optional semantic views integrated
EOF
P7_S3_JSON=$(create_issue "$P7_REPO" "$P7_S3_TITLE" "$P7_S3_BODY")
P7_S3_URL=$(echo "$P7_S3_JSON" | jq -r '.html_url')
comment_issue "$P7_REPO" "$(echo "$P7_S3_JSON" | jq -r '.number')" "Tracked in $P7_URL"

P7_S4_TITLE="Authentication (JWT) and public rate limits"
P7_S4_BODY="$TMP_DIR/p7_s4.md"
cat >"$P7_S4_BODY" <<'EOF'
**Description**

Secure endpoints and protect public APIs.

**Acceptance Criteria**

- [ ] JWT for registered clients
- [ ] Rate limits for public endpoints
- [ ] 401/429 responses with details
EOF
P7_S4_JSON=$(create_issue "$P7_REPO" "$P7_S4_TITLE" "$P7_S4_BODY")
P7_S4_URL=$(echo "$P7_S4_JSON" | jq -r '.html_url')
comment_issue "$P7_REPO" "$(echo "$P7_S4_JSON" | jq -r '.number')" "Tracked in $P7_URL"

P7_S5_TITLE="Client management and usage metrics"
P7_S5_BODY="$TMP_DIR/p7_s5.md"
cat >"$P7_S5_BODY" <<'EOF'
**Description**

Register clients, keys, quotas, usage.

**Acceptance Criteria**

- [ ] Client models and admin views
- [ ] Usage metrics captured
- [ ] Rotation/disable flows
EOF
P7_S5_JSON=$(create_issue "$P7_REPO" "$P7_S5_TITLE" "$P7_S5_BODY")
P7_S5_URL=$(echo "$P7_S5_JSON" | jq -r '.html_url')
comment_issue "$P7_REPO" "$(echo "$P7_S5_JSON" | jq -r '.number')" "Tracked in $P7_URL"

P7_S6_TITLE="Security and performance best practices"
P7_S6_BODY="$TMP_DIR/p7_s6.md"
cat >"$P7_S6_BODY" <<'EOF'
**Description**

CORS, ETag/HTTP caching, query limits, rate limiting.

**Acceptance Criteria**

- [ ] CORS configured per env
- [ ] ETag and cache headers where safe
- [ ] Query and result limits enforced
EOF
P7_S6_JSON=$(create_issue "$P7_REPO" "$P7_S6_TITLE" "$P7_S6_BODY")
P7_S6_URL=$(echo "$P7_S6_JSON" | jq -r '.html_url')
comment_issue "$P7_REPO" "$(echo "$P7_S6_JSON" | jq -r '.number')" "Tracked in $P7_URL"

P7_S7_TITLE="Admin panel prototype"
P7_S7_BODY="$TMP_DIR/p7_s7.md"
cat >"$P7_S7_BODY" <<'EOF'
**Description**

Minimal admin UI with traffic/latency/errors.

**Acceptance Criteria**

- [ ] KPIs charted
- [ ] Filters and basic drill-down
- [ ] Auth-gated access
EOF
P7_S7_JSON=$(create_issue "$P7_REPO" "$P7_S7_TITLE" "$P7_S7_BODY")
P7_S7_URL=$(echo "$P7_S7_JSON" | jq -r '.html_url')
comment_issue "$P7_REPO" "$(echo "$P7_S7_JSON" | jq -r '.number')" "Tracked in $P7_URL"

P7_S8_TITLE="Unit/integration/contract tests"
P7_S8_BODY="$TMP_DIR/p7_s8.md"
cat >"$P7_S8_BODY" <<'EOF'
**Description**

Test endpoints and OpenAPI conformance.

**Acceptance Criteria**

- [ ] Unit tests for serializers/validators
- [ ] Integration with DB/Redis
- [ ] Contract tests vs OpenAPI
EOF
P7_S8_JSON=$(create_issue "$P7_REPO" "$P7_S8_TITLE" "$P7_S8_BODY")
P7_S8_URL=$(echo "$P7_S8_JSON" | jq -r '.html_url')
comment_issue "$P7_REPO" "$(echo "$P7_S8_JSON" | jq -r '.number')" "Tracked in $P7_URL"

P7_PARENT_UPDATE="$TMP_DIR/p7_parent_update.md"
cat >"$P7_PARENT_UPDATE" <<EOF
$(cat "$P7_BODY")

### Sub-issues

- [ ] [$P7_S1_TITLE]($P7_S1_URL)
- [ ] [$P7_S2_TITLE]($P7_S2_URL)
- [ ] [$P7_S3_TITLE]($P7_S3_URL)
- [ ] [$P7_S4_TITLE]($P7_S4_URL)
- [ ] [$P7_S5_TITLE]($P7_S5_URL)
- [ ] [$P7_S6_TITLE]($P7_S6_URL)
- [ ] [$P7_S7_TITLE]($P7_S7_URL)
- [ ] [$P7_S8_TITLE]($P7_S8_URL)
EOF
replace_issue_body "$P7_REPO" "$P7_NUM" "$P7_PARENT_UPDATE"

################################################################################
# Project 8 — Screens server
################################################################################

P8_REPO="$ORG/infobus-screens"
P8_TITLE="Screens server"
P8_BODY="$TMP_DIR/p8_body.md"
cat >"$P8_BODY" <<'EOF'
### Project 8 — Screens server

#### General Objective

Implement the server that consumes data from the Infobús API and manages real-time information sent to information screens installed on buses and at stops.

#### Specific Objectives

- Screen configuration platform: register/deregister devices, grouping (by route, terminal, zone), environment variables, and per-device overrides.
- Persistent connection with screens via WebSockets/SSE with exponential backoff and heartbeats.
- Persistence and reliable delivery strategy: per-device queues, retries, and backoff.
- Presentation templates (layouts) for contexts: on-board (next stop, ETA, connections) and stop (upcoming departures, alerts, occupancy if available).
- Integration with Infobús API: efficient queries, cache usage, and differential updates.
- Content scheduling by time and location (windows, playlists) and handling of emergencies/alerts.
- Security: device authentication (tokens/keys per device), CORS, message signing, and audit logging.
- Observability: delivery/latency metrics, availability per device, logs, and a basic monitoring panel.
- Unit and integration tests (including simulated devices and screens fixtures).

#### Technologies

Repository: https://github.com/simovilab/infobus-screens

- Python
- Django
- Django Channels (WebSockets, SSE)
- Redis (pipeline and cache)
- httpx (HTTP client to Infobús API)
- Vue / TypeScript
- VueUse
- Tailwind
- Vite

#### Deliverables

- Server module with device administration, distribution channels, and templates.
- Admin panel for configuration and monitoring.
- Screen templates (on-board and stop) ready for use and customization.
- Docker container and deployment guide.
EOF

P8_CREATE_JSON=$(create_issue "$P8_REPO" "$P8_TITLE" "$P8_BODY")
P8_NUM=$(echo "$P8_CREATE_JSON" | jq -r '.number')
P8_URL=$(echo "$P8_CREATE_JSON" | jq -r '.html_url')

# Sub-issues for Project 8
P8_S1_TITLE="Device registry and configuration"
P8_S1_BODY="$TMP_DIR/p8_s1.md"
cat >"$P8_S1_BODY" <<'EOF'
**Description**

Register/deregister devices, groups, env vars, per-device overrides.

**Acceptance Criteria**

- [ ] Device/group models and APIs
- [ ] Override resolution order documented
- [ ] Admin views
EOF
P8_S1_JSON=$(create_issue "$P8_REPO" "$P8_S1_TITLE" "$P8_S1_BODY")
P8_S1_URL=$(echo "$P8_S1_JSON" | jq -r '.html_url')
comment_issue "$P8_REPO" "$(echo "$P8_S1_JSON" | jq -r '.number')" "Tracked in $P8_URL"

P8_S2_TITLE="Persistent connections (WebSockets/SSE)"
P8_S2_BODY="$TMP_DIR/p8_s2.md"
cat >"$P8_S2_BODY" <<'EOF'
**Description**

Maintain connections with reconnection and heartbeats.

**Acceptance Criteria**

- [ ] WebSockets/SSE with exponential backoff
- [ ] Heartbeat protocol and timeouts
- [ ] Load/latency measured
EOF
P8_S2_JSON=$(create_issue "$P8_REPO" "$P8_S2_TITLE" "$P8_S2_BODY")
P8_S2_URL=$(echo "$P8_S2_JSON" | jq -r '.html_url')
comment_issue "$P8_REPO" "$(echo "$P8_S2_JSON" | jq -r '.number')" "Tracked in $P8_URL"

P8_S3_TITLE="Reliable delivery: per-device queues and retries"
P8_S3_BODY="$TMP_DIR/p8_s3.md"
cat >"$P8_S3_BODY" <<'EOF'
**Description**

Ensure message persistence and retry strategy.

**Acceptance Criteria**

- [ ] Queue per device with backoff
- [ ] At-least-once semantics
- [ ] Metrics for delivery
EOF
P8_S3_JSON=$(create_issue "$P8_REPO" "$P8_S3_TITLE" "$P8_S3_BODY")
P8_S3_URL=$(echo "$P8_S3_JSON" | jq -r '.html_url')
comment_issue "$P8_REPO" "$(echo "$P8_S3_JSON" | jq -r '.number')" "Tracked in $P8_URL"

P8_S4_TITLE="Layout templates (onboard and stop contexts)"
P8_S4_BODY="$TMP_DIR/p8_s4.md"
cat >"$P8_S4_BODY" <<'EOF'
**Description**

Provide base layouts and templating hooks.

**Acceptance Criteria**

- [ ] Onboard and stop layouts implemented
- [ ] Theming and content regions defined
- [ ] Sample data to preview
EOF
P8_S4_JSON=$(create_issue "$P8_REPO" "$P8_S4_TITLE" "$P8_S4_BODY")
P8_S4_URL=$(echo "$P8_S4_JSON" | jq -r '.html_url')
comment_issue "$P8_REPO" "$(echo "$P8_S4_JSON" | jq -r '.number')" "Tracked in $P8_URL"

P8_S5_TITLE="Infobús API integration"
P8_S5_BODY="$TMP_DIR/p8_s5.md"
cat >"$P8_S5_BODY" <<'EOF'
**Description**

Efficient queries, caching, delta updates.

**Acceptance Criteria**

- [ ] Client with pooling/retries
- [ ] Cache strategy documented
- [ ] Delta update mechanism
EOF
P8_S5_JSON=$(create_issue "$P8_REPO" "$P8_S5_TITLE" "$P8_S5_BODY")
P8_S5_URL=$(echo "$P8_S5_JSON" | jq -r '.html_url')
comment_issue "$P8_REPO" "$(echo "$P8_S5_JSON" | jq -r '.number')" "Tracked in $P8_URL"

P8_S6_TITLE="Scheduling and emergency modes"
P8_S6_BODY="$TMP_DIR/p8_s6.md"
cat >"$P8_S6_BODY" <<'EOF'
**Description**

Time/geo-based content windows and alerts.

**Acceptance Criteria**

- [ ] Schedule config and engine
- [ ] Emergency override flow
- [ ] Tests
EOF
P8_S6_JSON=$(create_issue "$P8_REPO" "$P8_S6_TITLE" "$P8_S6_BODY")
P8_S6_URL=$(echo "$P8_S6_JSON" | jq -r '.html_url')
comment_issue "$P8_REPO" "$(echo "$P8_S6_JSON" | jq -r '.number')" "Tracked in $P8_URL"

P8_S7_TITLE="Security (device tokens, CORS, signing, audit)"
P8_S7_BODY="$TMP_DIR/p8_s7.md"
cat >"$P8_S7_BODY" <<'EOF'
**Description**

Secure comms and record actions.

**Acceptance Criteria**

- [ ] Per-device tokens/keys
- [ ] Message signing/verification (if used)
- [ ] Audit logs
EOF
P8_S7_JSON=$(create_issue "$P8_REPO" "$P8_S7_TITLE" "$P8_S7_BODY")
P8_S7_URL=$(echo "$P8_S7_JSON" | jq -r '.html_url')
comment_issue "$P8_REPO" "$(echo "$P8_S7_JSON" | jq -r '.number')" "Tracked in $P8_URL"

P8_S8_TITLE="Observability"
P8_S8_BODY="$TMP_DIR/p8_s8.md"
cat >"$P8_S8_BODY" <<'EOF'
**Description**

Metrics, availability per device, logs, basic dashboard.

**Acceptance Criteria**

- [ ] Prometheus metrics exposed
- [ ] Logs structured with correlation IDs
- [ ] Dashboard JSON in repo
EOF
P8_S8_JSON=$(create_issue "$P8_REPO" "$P8_S8_TITLE" "$P8_S8_BODY")
P8_S8_URL=$(echo "$P8_S8_JSON" | jq -r '.html_url')
comment_issue "$P8_REPO" "$(echo "$P8_S8_JSON" | jq -r '.number')" "Tracked in $P8_URL"

P8_S9_TITLE="Tests with simulated devices"
P8_S9_BODY="$TMP_DIR/p8_s9.md"
cat >"$P8_S9_BODY" <<'EOF'
**Description**

Fixtures and integration tests.

**Acceptance Criteria**

- [ ] Simulated device fixtures
- [ ] Integration tests with reconnects
- [ ] CI passing
EOF
P8_S9_JSON=$(create_issue "$P8_REPO" "$P8_S9_TITLE" "$P8_S9_BODY")
P8_S9_URL=$(echo "$P8_S9_JSON" | jq -r '.html_url')
comment_issue "$P8_REPO" "$(echo "$P8_S9_JSON" | jq -r '.number')" "Tracked in $P8_URL"

P8_S10_TITLE="Docker image and deploy guide"
P8_S10_BODY="$TMP_DIR/p8_s10.md"
cat >"$P8_S10_BODY" <<'EOF'
**Description**

Container and deployment notes.

**Acceptance Criteria**

- [ ] Dockerfile and compose example
- [ ] Env/config documented
- [ ] Healthchecks
EOF
P8_S10_JSON=$(create_issue "$P8_REPO" "$P8_S10_TITLE" "$P8_S10_BODY")
P8_S10_URL=$(echo "$P8_S10_JSON" | jq -r '.html_url')
comment_issue "$P8_REPO" "$(echo "$P8_S10_JSON" | jq -r '.number')" "Tracked in $P8_URL"

P8_PARENT_UPDATE="$TMP_DIR/p8_parent_update.md"
cat >"$P8_PARENT_UPDATE" <<EOF
$(cat "$P8_BODY")

### Sub-issues

- [ ] [$P8_S1_TITLE]($P8_S1_URL)
- [ ] [$P8_S2_TITLE]($P8_S2_URL)
- [ ] [$P8_S3_TITLE]($P8_S3_URL)
- [ ] [$P8_S4_TITLE]($P8_S4_URL)
- [ ] [$P8_S5_TITLE]($P8_S5_URL)
- [ ] [$P8_S6_TITLE]($P8_S6_URL)
- [ ] [$P8_S7_TITLE]($P8_S7_URL)
- [ ] [$P8_S8_TITLE]($P8_S8_URL)
- [ ] [$P8_S9_TITLE]($P8_S9_URL)
- [ ] [$P8_S10_TITLE]($P8_S10_URL)
EOF
replace_issue_body "$P8_REPO" "$P8_NUM" "$P8_PARENT_UPDATE"

################################################################################
# Project 9 — Public transportation data panel
################################################################################

P9_REPO="$ORG/infobus-data"
P9_TITLE="Public transport data panel"
P9_BODY="$TMP_DIR/p9_body.md"
cat >"$P9_BODY" <<'EOF'
### Project 9 — Public transport data panel

#### General Objective

Develop a monitoring and basic analytics panel (real time and near real time) for public transport based on GTFS Schedule, GTFS Realtime, and indicators derived from Databús/Infobús.

#### Specific Objectives

- Define and operationalize key performance indicators (KPIs): on-time performance, headway adherence, average delay by route, feed freshness, API latency, service gaps, and occupancy (if available).
- Implement data adapters: queries to Infobús API, reading GTFS Schedule (PostgreSQL), and aggregations for KPIs.
- Expose KPIs as Prometheus metrics (Python exporter).
- Enable building queries with PromQL.
- Build Grafana dashboards: network overview, by route, by stop, and API/feed health.
- Configure alerts (Alertmanager): feed freshness, API 5xx/latency errors, drop in reporting vehicles.
- Document KPI definitions, assumptions, and limitations.

#### Technologies

- Python
- FastAPI or simple Prometheus exporter
- Prometheus
- Prometheus Alertmanager
- Grafana
- PostgreSQL (Schedule)
- Redis (optional cache)

#### Deliverables

- Prometheus exporter with operational KPIs.
- Grafana dashboards (JSON) for network, routes, stops, and system health.
- Alert rules (Alertmanager) and initial threshold guides.
- Brief document with KPI definitions and deployment procedure.
EOF

P9_CREATE_JSON=$(create_issue "$P9_REPO" "$P9_TITLE" "$P9_BODY")
P9_NUM=$(echo "$P9_CREATE_JSON" | jq -r '.number')
P9_URL=$(echo "$P9_CREATE_JSON" | jq -r '.html_url')

# Sub-issues for Project 9
P9_S1_TITLE="KPI dictionary and definitions"
P9_S1_BODY="$TMP_DIR/p9_s1.md"
cat >"$P9_S1_BODY" <<'EOF'
**Description**

Define KPIs (OTP, headway adherence, avg delay, feed freshness, API latency, gaps, occupancy if available).

**Acceptance Criteria**

- [ ] Written dictionary with formulas and assumptions
- [ ] Edge cases noted
- [ ] Linked in README
EOF
P9_S1_JSON=$(create_issue "$P9_REPO" "$P9_S1_TITLE" "$P9_S1_BODY")
P9_S1_URL=$(echo "$P9_S1_JSON" | jq -r '.html_url')
comment_issue "$P9_REPO" "$(echo "$P9_S1_JSON" | jq -r '.number')" "Tracked in $P9_URL"

P9_S2_TITLE="Data adapters"
P9_S2_BODY="$TMP_DIR/p9_s2.md"
cat >"$P9_S2_BODY" <<'EOF'
**Description**

Query Infobús API, read Schedule (PostgreSQL), aggregate KPIs.

**Acceptance Criteria**

- [ ] Adapters implemented with tests
- [ ] Caching strategy (optional) documented
- [ ] Error handling for partial data
EOF
P9_S2_JSON=$(create_issue "$P9_REPO" "$P9_S2_TITLE" "$P9_S2_BODY")
P9_S2_URL=$(echo "$P9_S2_JSON" | jq -r '.html_url')
comment_issue "$P9_REPO" "$(echo "$P9_S2_JSON" | jq -r '.number')" "Tracked in $P9_URL"

P9_S3_TITLE="Prometheus exporter service"
P9_S3_BODY="$TMP_DIR/p9_s3.md"
cat >"$P9_S3_BODY" <<'EOF'
**Description**

Expose KPIs as Prometheus metrics.

**Acceptance Criteria**

- [ ] Metrics endpoints implemented
- [ ] Naming/labels consistent
- [ ] Load-tested minimally
EOF
P9_S3_JSON=$(create_issue "$P9_REPO" "$P9_S3_TITLE" "$P9_S3_BODY")
P9_S3_URL=$(echo "$P9_S3_JSON" | jq -r '.html_url')
comment_issue "$P9_REPO" "$(echo "$P9_S3_JSON" | jq -r '.number')" "Tracked in $P9_URL"

P9_S4_TITLE="PromQL examples"
P9_S4_BODY="$TMP_DIR/p9_s4.md"
cat >"$P9_S4_BODY" <<'EOF'
**Description**

Provide query snippets.

**Acceptance Criteria**

- [ ] Query examples for each KPI
- [ ] Saved as docs/snippets
EOF
P9_S4_JSON=$(create_issue "$P9_REPO" "$P9_S4_TITLE" "$P9_S4_BODY")
P9_S4_URL=$(echo "$P9_S4_JSON" | jq -r '.html_url')
comment_issue "$P9_REPO" "$(echo "$P9_S4_JSON" | jq -r '.number')" "Tracked in $P9_URL"

P9_S5_TITLE="Grafana dashboards"
P9_S5_BODY="$TMP_DIR/p9_s5.md"
cat >"$P9_S5_BODY" <<'EOF'
**Description**

Dashboards for network, route, stop, and API/feed health.

**Acceptance Criteria**

- [ ] JSON dashboards in repo
- [ ] Variables and drill-downs
- [ ] Screenshots in README
EOF
P9_S5_JSON=$(create_issue "$P9_REPO" "$P9_S5_TITLE" "$P9_S5_BODY")
P9_S5_URL=$(echo "$P9_S5_JSON" | jq -r '.html_url')
comment_issue "$P9_REPO" "$(echo "$P9_S5_JSON" | jq -r '.number')" "Tracked in $P9_URL"

P9_S6_TITLE="Alertmanager rules"
P9_S6_BODY="$TMP_DIR/p9_s6.md"
cat >"$P9_S6_BODY" <<'EOF'
**Description**

Alerts for feed freshness, 5xx/latency, drop in reporting vehicles.

**Acceptance Criteria**

- [ ] Alert rules YAML in repo
- [ ] Thresholds documented
- [ ] Test playbook for alerts
EOF
P9_S6_JSON=$(create_issue "$P9_REPO" "$P9_S6_TITLE" "$P9_S6_BODY")
P9_S6_URL=$(echo "$P9_S6_JSON" | jq -r '.html_url')
comment_issue "$P9_REPO" "$(echo "$P9_S6_JSON" | jq -r '.number')" "Tracked in $P9_URL"

P9_S7_TITLE="Deployment and docs"
P9_S7_BODY="$TMP_DIR/p9_s7.md"
cat >"$P9_S7_BODY" <<'EOF'
**Description**

Document deployment steps.

**Acceptance Criteria**

- [ ] README with exporter setup
- [ ] Prometheus scrape jobs documented
- [ ] Grafana/Alertmanager config steps included
EOF
P9_S7_JSON=$(create_issue "$P9_REPO" "$P9_S7_TITLE" "$P9_S7_BODY")
P9_S7_URL=$(echo "$P9_S7_JSON" | jq -r '.html_url')
comment_issue "$P9_REPO" "$(echo "$P9_S7_JSON" | jq -r '.number')" "Tracked in $P9_URL"

P9_PARENT_UPDATE="$TMP_DIR/p9_parent_update.md"
cat >"$P9_PARENT_UPDATE" <<EOF
$(cat "$P9_BODY")

### Sub-issues

- [ ] [$P9_S1_TITLE]($P9_S1_URL)
- [ ] [$P9_S2_TITLE]($P9_S2_URL)
- [ ] [$P9_S3_TITLE]($P9_S3_URL)
- [ ] [$P9_S4_TITLE]($P9_S4_URL)
- [ ] [$P9_S5_TITLE]($P9_S5_URL)
- [ ] [$P9_S6_TITLE]($P9_S6_URL)
- [ ] [$P9_S7_TITLE]($P9_S7_URL)
EOF
replace_issue_body "$P9_REPO" "$P9_NUM" "$P9_PARENT_UPDATE"

################################################################################
# Project 10 — Infobús MCP (server and client)
################################################################################

P10_REPO="$ORG/infobus-mcp"
P10_TITLE="Infobús MCP (server and client)"
P10_BODY="$TMP_DIR/p10_body.md"
cat >"$P10_BODY" <<'EOF'
### Project 10 — Infobús MCP server and client

#### General Objective

Develop an MCP (Model Context Protocol) server and client that exposes Infobús capabilities as tools and resources discoverable by assistants/LLMs, enabling natural-language queries and assisted flows.

#### Specific Objectives

- Implement an MCP server in Python that integrates the Infobús API as tools/resources/prompts.
- Define input/output contracts with validation (Pydantic) and traceability (structured logging).
- Implement MCP transport (JSON-RPC over WebSocket/stdio) and basic authorization.
- Design security controls: token limits, per-client quotas, tool filtering, and rate limiting.
- Build a minimal client (Nuxt/Vue).
- Create example playbooks (sequences) for common tasks.
- Unit/integration tests: simulate tool calls, validate schemas, and test latency.

#### Technologies

Repository: https://github.com/simovilab/infobus-mcp

- Python (server)
- MCP SDK (Python) / MCP specification
- WebSocket / stdio (transport)
- Pydantic (I/O validation)
- httpx (HTTP client to Infobús API)
- Nuxt / Vue (client)

#### Deliverables

- MCP server with documented tools/resources/prompts.
- Minimal client (Nuxt/Vue) with chat and tool invocation.
- Context documents and example playbooks.
- Test suite and local/deployment guide.
EOF

P10_CREATE_JSON=$(create_issue "$P10_REPO" "$P10_TITLE" "$P10_BODY")
P10_NUM=$(echo "$P10_CREATE_JSON" | jq -r '.number')
P10_URL=$(echo "$P10_CREATE_JSON" | jq -r '.html_url')

# Sub-issues for Project 10
P10_S1_TITLE="MCP server: tools/resources/prompts"
P10_S1_BODY="$TMP_DIR/p10_s1.md"
cat >"$P10_S1_BODY" <<'EOF'
**Description**

Implement server exposing Infobús capabilities.

**Acceptance Criteria**

- [ ] Tools: get_eta, get_stop, search_stops, get_route, service_status, get_alerts
- [ ] Resources: GTFS refs, OpenAPI, examples
- [ ] Prompts: guided templates for FAQs
EOF
P10_S1_JSON=$(create_issue "$P10_REPO" "$P10_S1_TITLE" "$P10_S1_BODY")
P10_S1_URL=$(echo "$P10_S1_JSON" | jq -r '.html_url')
comment_issue "$P10_REPO" "$(echo "$P10_S1_JSON" | jq -r '.number')" "Tracked in $P10_URL"

P10_S2_TITLE="I/O contracts and validation (Pydantic)"
P10_S2_BODY="$TMP_DIR/p10_s2.md"
cat >"$P10_S2_BODY" <<'EOF'
**Description**

Define typed inputs/outputs and logging.

**Acceptance Criteria**

- [ ] Pydantic models with enums/ranges
- [ ] Structured logging with correlation IDs
- [ ] Error surfaces consistent
EOF
P10_S2_JSON=$(create_issue "$P10_REPO" "$P10_S2_TITLE" "$P10_S2_BODY")
P10_S2_URL=$(echo "$P10_S2_JSON" | jq -r '.html_url')
comment_issue "$P10_REPO" "$(echo "$P10_S2_JSON" | jq -r '.number')" "Tracked in $P10_URL"

P10_S3_TITLE="Transport and authorization"
P10_S3_BODY="$TMP_DIR/p10_s3.md"
cat >"$P10_S3_BODY" <<'EOF'
**Description**

JSON-RPC over WebSocket/stdio and basic auth controls.

**Acceptance Criteria**

- [ ] WebSocket/stdio transports implemented
- [ ] Allowed-origins list and client tokens (if used)
- [ ] Timeouts and rate limits
EOF
P10_S3_JSON=$(create_issue "$P10_REPO" "$P10_S3_TITLE" "$P10_S3_BODY")
P10_S3_URL=$(echo "$P10_S3_JSON" | jq -r '.html_url')
comment_issue "$P10_REPO" "$(echo "$P10_S3_JSON" | jq -r '.number')" "Tracked in $P10_URL"

P10_S4_TITLE="Security limits and filters"
P10_S4_BODY="$TMP_DIR/p10_s4.md"
cat >"$P10_S4_BODY" <<'EOF'
**Description**

Token limits, per-client quotas, tool filtering.

**Acceptance Criteria**

- [ ] Configurable quotas and limits
- [ ] Tool allow/deny lists
- [ ] Tests for abuse scenarios
EOF
P10_S4_JSON=$(create_issue "$P10_REPO" "$P10_S4_TITLE" "$P10_S4_BODY")
P10_S4_URL=$(echo "$P10_S4_JSON" | jq -r '.html_url')
comment_issue "$P10_REPO" "$(echo "$P10_S4_JSON" | jq -r '.number')" "Tracked in $P10_URL"

P10_S5_TITLE="Minimal Nuxt/Vue client"
P10_S5_BODY="$TMP_DIR/p10_s5.md"
cat >"$P10_S5_BODY" <<'EOF'
**Description**

Chat UI with tool invocation.

**Acceptance Criteria**

- [ ] Chat with streaming and tool selection
- [ ] Disambiguation flows
- [ ] Shareable conversation links
EOF
P10_S5_JSON=$(create_issue "$P10_REPO" "$P10_S5_TITLE" "$P10_S5_BODY")
P10_S5_URL=$(echo "$P10_S5_JSON" | jq -r '.html_url')
comment_issue "$P10_REPO" "$(echo "$P10_S5_JSON" | jq -r '.number')" "Tracked in $P10_URL"

P10_S6_TITLE="Playbooks (assisted sequences)"
P10_S6_BODY="$TMP_DIR/p10_s6.md"
cat >"$P10_S6_BODY" <<'EOF'
**Description**

Example flows for common tasks.

**Acceptance Criteria**

- [ ] Plan simple trip, check delays, quick panel for stop/route
- [ ] Docs and sample JSON
EOF
P10_S6_JSON=$(create_issue "$P10_REPO" "$P10_S6_TITLE" "$P10_S6_BODY")
P10_S6_URL=$(echo "$P10_S6_JSON" | jq -r '.html_url')
comment_issue "$P10_REPO" "$(echo "$P10_S6_JSON" | jq -r '.number')" "Tracked in $P10_URL"

P10_S7_TITLE="Tests (unit/integration/latency)"
P10_S7_BODY="$TMP_DIR/p10_s7.md"
cat >"$P10_S7_BODY" <<'EOF'
**Description**

Validate tools, schemas, and performance.

**Acceptance Criteria**

- [ ] Unit tests for each tool
- [ ] Integration against Infobús API sandbox
- [ ] Latency thresholds checked
EOF
P10_S7_JSON=$(create_issue "$P10_REPO" "$P10_S7_TITLE" "$P10_S7_BODY")
P10_S7_URL=$(echo "$P10_S7_JSON" | jq -r '.html_url')
comment_issue "$P10_REPO" "$(echo "$P10_S7_JSON" | jq -r '.number')" "Tracked in $P10_URL"

P10_PARENT_UPDATE="$TMP_DIR/p10_parent_update.md"
cat >"$P10_PARENT_UPDATE" <<EOF
$(cat "$P10_BODY")

### Sub-issues

- [ ] [$P10_S1_TITLE]($P10_S1_URL)
- [ ] [$P10_S2_TITLE]($P10_S2_URL)
- [ ] [$P10_S3_TITLE]($P10_S3_URL)
- [ ] [$P10_S4_TITLE]($P10_S4_URL)
- [ ] [$P10_S5_TITLE]($P10_S5_URL)
- [ ] [$P10_S6_TITLE]($P10_S6_URL)
- [ ] [$P10_S7_TITLE]($P10_S7_URL)
EOF
replace_issue_body "$P10_REPO" "$P10_NUM" "$P10_PARENT_UPDATE"

echo "Created issues for Projects 1–11."
