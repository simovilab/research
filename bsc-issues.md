# Proyectos Eléctricos 2025 II — Issue backlog (copy/paste into GitHub)

Notes

- Language: English (titles concise, descriptions minimal).
- Each issue stands alone. Use “Depends on” to indicate soft ordering.
- Replace placeholders as needed; keep scope small per issue.

---

# Project 1 — Databús API

Repository: https://github.com/simovilab/django-app-gtfs

## Complete CRUD endpoints with validation and pagination

**Description**

Implement read/write endpoints with request/response validation and pagination across core resources.

**Acceptance Criteria**

- [ ] All planned endpoints exist with GET/POST/PATCH/DELETE where applicable
- [ ] Input validation with clear error messages and status codes
- [ ] Pagination (limit/offset or cursor) consistently implemented
- [ ] OpenAPI spec updated with examples

## OpenAPI documentation with examples and error codes

**Description**

Document all endpoints with request/response samples and error payloads.

**Acceptance Criteria**

- [ ] OpenAPI paths, schemas, and components complete
- [ ] Example requests/responses per operation
- [ ] Standard error schema documented and referenced
- [ ] Rendered docs (Swagger/Redoc) linked in README

## Storage strategy: CRUD to PostgreSQL/Redis/Fuseki

**Description**

Implement storage adapters and patterns for different backends.

**Acceptance Criteria**

- [ ] PostgreSQL models/migrations for operational data
- [ ] Redis integration for caching / high-frequency writes where needed
- [ ] Optional Fuseki integration for semantic views (if applicable)
- [ ] Configuration documented with env vars

## JWT authentication and role-based access control

**Description**

Secure the API with token auth and roles.

**Acceptance Criteria**

- [ ] JWT issuance and verification flows
- [ ] Roles/permissions mapped to endpoints/actions
- [ ] Token rotation/expiry documented
- [ ] Tests for authz/authn paths

## Client registry and lifecycle management

**Description**

Manage registered clients (vehicles/devices/users/agencies).

**Acceptance Criteria**

- [ ] Models for clients, keys, quotas, status
- [ ] CRUD and lifecycle operations (register/disable/rotate)
- [ ] Metrics of usage per client captured
- [ ] Admin views for management

## Rate limiting and basic quotas

**Description**

Protect the API with rate limits and quotas per client.

**Acceptance Criteria**

- [ ] Global and per-client rate limits in place
- [ ] Quota counters persisted/reset policy defined
- [ ] 429 responses with headers (remaining/reset)
- [ ] Tests for limits and bursty traffic

## Security and performance hygiene

**Description**

Apply CORS, ETag/HTTP caching, pagination defaults, and timeouts.

**Acceptance Criteria**

- [ ] CORS config per environment
- [ ] ETag/Last-Modified and cache headers where safe
- [ ] Sensible pagination defaults and max caps
- [ ] Request timeouts and connection pooling

## Admin panel prototype

**Description**

Provide an admin dashboard for basic operations and metrics.

**Acceptance Criteria**

- [ ] Admin views for clients, keys, quotas
- [ ] Lightweight traffic/latency/errors chart(s)
- [ ] Auth-gated access and audit logs
- [ ] Linked from README

## Unit and integration tests

**Description**

Coverage for endpoints, auth, storage, limits.

**Acceptance Criteria**

- [ ] Unit tests for serializers/validators
- [ ] Integration tests hitting a test DB/Redis
- [ ] Contract tests vs OpenAPI examples
- [ ] CI job running tests and linting

---

## Project 2 — Django GTFS (Schedule)

Repository: https://github.com/simovilab/django-app-gtfs

## Authoritative schema document for GTFS Schedule

**Description**

Create a schema file aligned with GTFS v2.0 to generate models/docs.

**Acceptance Criteria**

- [ ] Schema includes fields, types, constraints, PKs/FKs
- [ ] Versioned and referenced by codegen/docs
- [ ] Validated against sample GTFS feeds

## Implement models with referential integrity

**Description**

Model GTFS entities with constraints in Django.

**Acceptance Criteria**

- [ ] All core tables modeled (agency, routes, trips, stops, stop_times, shapes, calendars, …)
- [ ] FKs/unique constraints per spec
- [ ] Migrations created and applied

## Migrate to composite primary keys (Django 5.2)

**Description**

Use composite PKs as defined by GTFS where required.

**Acceptance Criteria**

- [ ] Composite PKs implemented where applicable
- [ ] Admin/query patterns documented
- [ ] Tests cover CRUD and relations

## Management command: create fixtures

**Description**

Generate minimal fixtures for testing and docs.

**Acceptance Criteria**

- [ ] Command produces deterministic small datasets
- [ ] Seed option and output path configurable
- [ ] Used by test suite

## import_gtfs: ZIP → database

**Description**

Import a GTFS ZIP into DB.

**Acceptance Criteria**

- [ ] Supports required and optional files
- [ ] Validates referential integrity and types
- [ ] Reports errors with line/file context

## export_gtfs: database → ZIP

**Description**

Export DB to a valid GTFS ZIP.

**Acceptance Criteria**

- [ ] Includes only valid/linked rows
- [ ] Passes validator checks
- [ ] Metadata (version, timestamp) embedded

## stop_times builder using ETA estimator

**Description**

Build stop_times using ETA module hooks.

**Acceptance Criteria**

- [ ] Pluggable interface to ETA module
- [ ] Deterministic output on given seed
- [ ] Tests with synthetic data

## Publish package to PyPI (semantic versioning)

**Description**

Package and publish as a Django app.

**Acceptance Criteria**

- [ ] pyproject.toml, classifiers, README
- [ ] Versioning, changelog, release workflow
- [ ] Install/test instructions verified

## Minimal usage documentation

**Description**

Provide examples to bootstrap users.

**Acceptance Criteria**

- [ ] README quick start
- [ ] Docs reference models/commands
- [ ] Example datasets linked

---

## Project 3 — Django GTFS (Realtime)

Repository: https://github.com/simovilab/django-app-gtfs

## Schema document for GTFS Realtime

**Description**

Author a source-of-truth schema aligned to the spec.

**Acceptance Criteria**

- [ ] Entities and relationships to Schedule defined
- [ ] Identifier strategy aligned with Schedule
- [ ] Versioned and referenced by code

## Implement models aligned to GTFS Realtime

**Description**

Add Django models for Realtime entities.

**Acceptance Criteria**

- [ ] Entities for TripUpdates, VehiclePositions, Alerts
- [ ] Relations to Schedule entities
- [ ] Constraints and indexes in place

## Protobuf encode/decode modules

**Description**

Serialize/deserialize feeds using gtfs-realtime-bindings.

**Acceptance Criteria**

- [ ] Encode TripUpdates/VehiclePositions/Alerts
- [ ] Decode and validate incoming feeds
- [ ] Unit tests with sample binaries

## Feed validation and JSON conversion

**Description**

Validate timestamps/IDs and export JSON helpers.

**Acceptance Criteria**

- [ ] Timestamp monotonicity checks
- [ ] Identifier consistency vs Schedule
- [ ] JSON conversion utilities documented

## TripUpdates builder using ETA estimator

**Description**

Build TripUpdates with ETA module.

**Acceptance Criteria**

- [ ] Builder function with tests
- [ ] Performance validated under load
- [ ] Deterministic synthetic fixtures

## Fixtures and sample feeds

**Description**

Provide reproducible sample data.

**Acceptance Criteria**

- [ ] Small fixtures in repo
- [ ] Scripts to regenerate
- [ ] Used by tests/docs

## Publish to PyPI

**Description**

Package and release.

**Acceptance Criteria**

- [ ] Packaging metadata complete
- [ ] Release workflow configured
- [ ] Install/test verified

## Documentation with publish/consume examples

**Description**

Show minimal producers/consumers.

**Acceptance Criteria**

- [ ] Producer and consumer snippets
- [ ] Error handling patterns
- [ ] Links to spec and bindings

---

## Project 4 — ETA models from historical data

Repository: https://github.com/simovilab/django-app-gtfs

## Data ingestion and cleaning plan (ETL)

**Description**

Define sources, schema, deduplication, gap handling, sampling, alignment to Schedule.

**Acceptance Criteria**

- [ ] Written plan and initial pipeline skeleton
- [ ] Unit tests for dedup/gap-filling
- [ ] Reproducible run on sample data

## Feature engineering module

**Description**

Implement features (time-of-day, weekday/holiday, sequence, distance to next stop, headway, congestion proxy, weather optional).

**Acceptance Criteria**

- [ ] Feature functions with docstrings
- [ ] Tests on edge cases (first/last stop, missing GPS)
- [ ] Timing benchmarks recorded

## Baseline models: historical median and polynomial regression

**Description**

Implement per route-segment-stop baselines with fallbacks.

**Acceptance Criteria**

- [ ] Median baseline with data sufficiency checks
- [ ] Polynomial regression with regularization
- [ ] Fallback hierarchy documented and tested

## Rolling training and evaluation protocol

**Description**

Temporal split, MAE/RMSE/MAPE metrics, model selection per segment.

**Acceptance Criteria**

- [ ] Rolling window evaluation implemented
- [ ] Metrics computed and stored
- [ ] Best model per segment selected reproducibly

## Model registry (PostgreSQL) and Redis cache

**Description**

Persist parameters/coefficients and enable low-latency retrieval.

**Acceptance Criteria**

- [ ] DB schema and CRUD for model versions
- [ ] Redis cache with TTL/invalidation
- [ ] Migration scripts and docs

## Inference function estimate_stop_times()

**Description**

Batch and online inference callable by Schedule/Realtime apps.

**Acceptance Criteria**

- [ ] Deterministic, typed interface with Pydantic
- [ ] Performance meets latency targets
- [ ] Unit/integration tests

## Scheduled retraining and backfill

**Description**

Automate daily/weekly retraining and historical backfill.

**Acceptance Criteria**

- [ ] Scheduler jobs (Celery/cron) defined
- [ ] Metrics for drift tracked
- [ ] Runbooks documented

## Integration with Projects 2 and 3

**Description**

Coherent keys and I/O contracts; hooks for APIs.

**Acceptance Criteria**

- [ ] Contracts documented
- [ ] End-to-end test with Schedule/Realtime
- [ ] Error handling paths covered

## Synthetic validation dataset

**Description**

Provide reproducible synthetic data for tests.

**Acceptance Criteria**

- [ ] Generator script with seed
- [ ] Dataset stored under tests/fixtures
- [ ] Used in CI

## Metrics report

**Description**

Summarize performance and trade-offs.

**Acceptance Criteria**

- [ ] Report with MAE/RMSE/MAPE per segment
- [ ] Baselines vs chosen models compared
- [ ] Recommendations for deployment

---

## Project 5 — Long-term ETA method (doctoral)

Repository: https://github.com/simovilab/databus-py

## Scope and research questions document

**Description**

Define objectives, hypotheses, and evaluation protocol.

**Acceptance Criteria**

- [ ] Problem statement and goals written
- [ ] Data and methods outline
- [ ] Milestones and risks listed

## Baseline experiment plan

**Description**

Design initial baselines and metrics.

**Acceptance Criteria**

- [ ] Candidate models and features listed
- [ ] Train/validation split strategy defined
- [ ] Reproducibility plan (seeds, env) noted

## Data requirements and ethics checklist

**Description**

Specify datasets, privacy, and governance.

**Acceptance Criteria**

- [ ] Data sources and licenses documented
- [ ] Privacy/ethics considerations addressed
- [ ] Approval process (if any) captured

---

## Project 6 — Bus movement simulator

Repository: https://github.com/simovilab/simbus

## Ingest GTFS and generate scenarios

**Description**

Build scenario objects from GTFS with parameters.

**Acceptance Criteria**

- [ ] Scenario builder with routes/trips/frequencies
- [ ] Configurable via YAML/JSON
- [ ] Validation and tests

## Deterministic tick engine

**Description**

Simulate motion in ticks (1–5s) with seeds.

**Acceptance Criteria**

- [ ] Velocity profiles and dwell times modeled
- [ ] Seeded stochastic variability
- [ ] Performance benchmarked

## Emit synthetic VehiclePositions/TripUpdates/Alerts to Databús

**Description**

Validate pipelines by sending synthetic data.

**Acceptance Criteria**

- [ ] HTTP client to Databús with retries/backoff
- [ ] Throttling controls
- [ ] Toggle for Alerts/TripUpdates

## Perturbations: delays, detours, holding

**Description**

Add simple robustness scenarios.

**Acceptance Criteria**

- [ ] Configurable perturbations per scenario
- [ ] Effects visible in metrics
- [ ] Tests for each perturbation type

## Orchestrate with Celery

**Description**

Periodic tasks and per-scenario queues.

**Acceptance Criteria**

- [ ] Celery beat and workers configured
- [ ] Task monitoring documented
- [ ] Graceful shutdown

## Scenario configuration format

**Description**

YAML/JSON schema and examples.

**Acceptance Criteria**

- [ ] Schema validated with Pydantic
- [ ] Example small/medium scenarios included
- [ ] Docs updated

## Metrics and logging

**Description**

Record OTP, headway adherence, gaps.

**Acceptance Criteria**

- [ ] Metrics collected and exported
- [ ] Structured logs
- [ ] Dashboard example (optional)

## Management commands

**Description**

CLI to manage simulations.

**Acceptance Criteria**

- [ ] generate_scenario/start_sim/stop_sim/list_sims implemented
- [ ] Help text and examples
- [ ] Tested end-to-end

## Unit tests and synthetic fixtures

**Description**

Ensure reliability and reproducibility.

**Acceptance Criteria**

- [ ] Fixtures under tests/
- [ ] CI passing
- [ ] Deterministic outputs with seeds

## Docker container for server install

**Description**

Provide containerized runtime.

**Acceptance Criteria**

- [ ] Dockerfile with envs and healthcheck
- [ ] Compose example
- [ ] README deployment guide

---

## Project 7 — Infobús API

Repository: https://github.com/simovilab/infobus

## Read endpoints: stops, routes, trips, arrivals/ETAs, status, alerts

**Description**

Implement core read endpoints.

**Acceptance Criteria**

- [ ] Endpoints implemented with pagination
- [ ] ETAs integrated with Project 4
- [ ] OpenAPI updated with examples

## Search/autocomplete and health checks

**Description**

Add search and basic health endpoints.

**Acceptance Criteria**

- [ ] Search for stops/routes with ranking
- [ ] /health and /ready endpoints
- [ ] Tests for both

## Storage/reading strategy

**Description**

PostgreSQL for Schedule, Redis for cache/Realtime, Fuseki optional.

**Acceptance Criteria**

- [ ] Data access layer implemented
- [ ] Cache keys/TTLs documented
- [ ] Optional semantic views integrated

## Authentication (JWT) and public rate limits

**Description**

Secure endpoints and protect public APIs.

**Acceptance Criteria**

- [ ] JWT for registered clients
- [ ] Rate limits for public endpoints
- [ ] 401/429 responses with details

## Client management and usage metrics

**Description**

Register clients, keys, quotas, usage.

**Acceptance Criteria**

- [ ] Client models and admin views
- [ ] Usage metrics captured
- [ ] Rotation/disable flows

## Security and performance best practices

**Description**

CORS, ETag/HTTP caching, query limits, rate limiting.

**Acceptance Criteria**

- [ ] CORS configured per env
- [ ] ETag and cache headers where safe
- [ ] Query and result limits enforced

## Admin panel prototype

**Description**

Minimal admin UI with traffic/latency/errors.

**Acceptance Criteria**

- [ ] KPIs charted
- [ ] Filters and basic drill-down
- [ ] Auth-gated access

## Unit/integration/contract tests

**Description**

Test endpoints and OpenAPI conformance.

**Acceptance Criteria**

- [ ] Unit tests for serializers/validators
- [ ] Integration with DB/Redis
- [ ] Contract tests vs OpenAPI

---

## Project 8 — Screens server

Repository: https://github.com/simovilab/infobus-screens

## Device registry and configuration

**Description**

Register/deregister devices, groups, env vars, per-device overrides.

**Acceptance Criteria**

- [ ] Device/group models and APIs
- [ ] Override resolution order documented
- [ ] Admin views

## Persistent connections (WebSockets/SSE)

**Description**

Maintain connections with reconnection and heartbeats.

**Acceptance Criteria**

- [ ] WebSockets/SSE with exponential backoff
- [ ] Heartbeat protocol and timeouts
- [ ] Load/latency measured

## Reliable delivery: per-device queues and retries

**Description**

Ensure message persistence and retry strategy.

**Acceptance Criteria**

- [ ] Queue per device with backoff
- [ ] At-least-once semantics
- [ ] Metrics for delivery

## Layout templates (onboard and stop contexts)

**Description**

Provide base layouts and templating hooks.

**Acceptance Criteria**

- [ ] Onboard and stop layouts implemented
- [ ] Theming and content regions defined
- [ ] Sample data to preview

## Infobús API integration

**Description**

Efficient queries, caching, delta updates.

**Acceptance Criteria**

- [ ] Client with pooling/retries
- [ ] Cache strategy documented
- [ ] Delta update mechanism

## Scheduling and emergency modes

**Description**

Time/geo-based content windows and alerts.

**Acceptance Criteria**

- [ ] Schedule config and engine
- [ ] Emergency override flow
- [ ] Tests

## Security (device tokens, CORS, signing, audit)

**Description**

Secure comms and record actions.

**Acceptance Criteria**

- [ ] Per-device tokens/keys
- [ ] Message signing/verification (if used)
- [ ] Audit logs

## Observability

**Description**

Metrics, availability per device, logs, basic dashboard.

**Acceptance Criteria**

- [ ] Prometheus metrics exposed
- [ ] Logs structured with correlation IDs
- [ ] Dashboard JSON in repo

## Tests with simulated devices

**Description**

Fixtures and integration tests.

**Acceptance Criteria**

- [ ] Simulated device fixtures
- [ ] Integration tests with reconnects
- [ ] CI passing

## Docker image and deploy guide

**Description**

Container and deployment notes.

**Acceptance Criteria**

- [ ] Dockerfile and compose example
- [ ] Env/config documented
- [ ] Healthchecks

---

## Project 9 — Public transportation data panel

Repository: https://github.com/simovilab/infobus-data

## KPI dictionary and definitions

**Description**

Define KPIs (OTP, headway adherence, avg delay, feed freshness, API latency, gaps, occupancy if available).

**Acceptance Criteria**

- [ ] Written dictionary with formulas and assumptions
- [ ] Edge cases noted
- [ ] Linked in README

## Data adapters

**Description**

Query Infobús API, read Schedule (PostgreSQL), aggregate KPIs.

**Acceptance Criteria**

- [ ] Adapters implemented with tests
- [ ] Caching strategy (optional) documented
- [ ] Error handling for partial data

## Prometheus exporter service

**Description**

Expose KPIs as Prometheus metrics.

**Acceptance Criteria**

- [ ] Metrics endpoints implemented
- [ ] Naming/labels consistent
- [ ] Load-tested minimally

## PromQL examples

**Description**

Provide query snippets.

**Acceptance Criteria**

- [ ] Query examples for each KPI
- [ ] Saved as docs/snippets

## Grafana dashboards

**Description**

Dashboards for network, route, stop, and API/feed health.

**Acceptance Criteria**

- [ ] JSON dashboards in repo
- [ ] Variables and drill-downs
- [ ] Screenshots in README

## Alertmanager rules

**Description**

Alerts for feed freshness, 5xx/latency, drop in reporting vehicles.

**Acceptance Criteria**

- [ ] Alert rules YAML in repo
- [ ] Thresholds documented
- [ ] Test playbook for alerts

## Deployment and docs

**Description**

Document deployment steps.

**Acceptance Criteria**

- [ ] README with exporter setup
- [ ] Prometheus scrape jobs documented
- [ ] Grafana/Alertmanager config steps included

---

## Project 10 — Infobús MCP (server and client)

Repository: https://github.com/simovilab/infobus-mcp

## MCP server: tools/resources/prompts

**Description**

Implement server exposing Infobús capabilities.

**Acceptance Criteria**

- [ ] Tools: get_eta, get_stop, search_stops, get_route, service_status, get_alerts
- [ ] Resources: GTFS refs, OpenAPI, examples
- [ ] Prompts: guided templates for FAQs

## I/O contracts and validation (Pydantic)

**Description**

Define typed inputs/outputs and logging.

**Acceptance Criteria**

- [ ] Pydantic models with enums/ranges
- [ ] Structured logging with correlation IDs
- [ ] Error surfaces consistent

## Transport and authorization

**Description**

JSON-RPC over WebSocket/stdio and basic auth controls.

**Acceptance Criteria**

- [ ] WebSocket/stdio transports implemented
- [ ] Allowed-origins list and client tokens (if used)
- [ ] Timeouts and rate limits

## Security limits and filters

**Description**

Token limits, per-client quotas, tool filtering.

**Acceptance Criteria**

- [ ] Configurable quotas and limits
- [ ] Tool allow/deny lists
- [ ] Tests for abuse scenarios

## Minimal Nuxt/Vue client

**Description**

Chat UI with tool invocation.

**Acceptance Criteria**

- [ ] Chat with streaming and tool selection
- [ ] Disambiguation flows
- [ ] Shareable conversation links

## Playbooks (assisted sequences)

**Description**

Example flows for common tasks.

**Acceptance Criteria**

- [ ] Plan simple trip, check delays, quick panel for stop/route
- [ ] Docs and sample JSON

## Tests (unit/integration/latency)

**Description**

Validate tools, schemas, and performance.

**Acceptance Criteria**

- [ ] Unit tests for each tool
- [ ] Integration against Infobús API sandbox
- [ ] Latency thresholds checked

---

## Project 11 — Signage CLI and library

Repository: https://github.com/simovilab/infobus-py

## Template schema (YAML/JSON)

**Description**

Define template format for dimensions, grid, fonts (Inter), palette, icons, dynamic fields.

**Acceptance Criteria**

- [ ] Pydantic models and JSON Schema exported
- [ ] Examples for stop/vehicle/station
- [ ] Validation errors are human-friendly

## SVG + Jinja2 composition engine

**Description**

Render SVG from templates and data; convert to PDF/PNG.

**Acceptance Criteria**

- [ ] Jinja2 environment with autoescape for SVG/XML
- [ ] CairoSVG conversion to PDF/PNG
- [ ] Deterministic outputs with pinned versions

## CLI subcommands integrated into existing Click CLI (infobus)

**Description**

Add `signage` group with `stop`, `vehicle`, `route`, `station`, `custom`.

**Acceptance Criteria**

- [ ] Commands and options implemented (`--format`, `--size`, `--dpi`, `--theme`, `--lang`, `--qr-url`)
- [ ] Help text and examples
- [ ] Backward compatibility preserved

## Infobús/GTFS data integration (optional)

**Description**

Populate fields from API or local files when IDs provided.

**Acceptance Criteria**

- [ ] `--stop-id` and `--route-id` supported
- [ ] HTTP client with retries/timeouts
- [ ] Local fallback documented

## QR generation and print features

**Description**

Generate QR codes and add bleed/crop marks.

**Acceptance Criteria**

- [ ] segno/qrcode integrated for QR
- [ ] High-contrast text and accessibility checks
- [ ] Bleed/crop configurable

## Validation and rich error output

**Description**

Validate inputs/templates with Pydantic and show nice errors.

**Acceptance Criteria**

- [ ] Clear, structured errors printed with Rich
- [ ] Non-zero exit codes on failure
- [ ] Tests for invalid inputs

## Starter templates and themes

**Description**

Provide base templates for stop/vehicle/station.

**Acceptance Criteria**

- [ ] Vertical/horizontal stop templates
- [ ] Vehicle interior/exterior (A4/A3) templates
- [ ] Station modular template

## Golden-image tests

**Description**

Assert rendered SVG/PNG match approved baselines.

**Acceptance Criteria**

- [ ] Baselines in tests/golden
- [ ] Normalized SVG diff and pixel/perceptual diff for PNG
- [ ] Simple command to regenerate baselines

## Packaging and pre-release to PyPI

**Description**

Package with pyproject and publish pre-release.

**Acceptance Criteria**

- [ ] Entry points for Click CLI (`infobus signage`)
- [ ] Wheels/sdist built in CI
- [ ] Pre-release published and tagged

## Docker image for consistent rendering

**Description**

Provide container to ensure font/render parity.

**Acceptance Criteria**

- [ ] Dockerfile bundling CairoSVG and Inter fonts
- [ ] Example usage in README
- [ ] Determinism notes included

## Documentation and examples

**Description**

Minimal docs to get started and preview locally.

**Acceptance Criteria**

- [ ] README quick start and options
- [ ] Example commands and outputs
- [ ] Notes on font licensing (Inter) and usage
