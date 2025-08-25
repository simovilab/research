# Electrical Projects 2025 II

## Overall Objective

> Design and implement an end-to-end prototype public transport information platform based on GTFS (Schedule and Realtime), with operational APIs (Databús/Infobús), arrival-time prediction, a screens server, a data panel, and an MCP client/server, validated with data and simulation during the 2025 II term.

## Projects

### Project 1 — Databús API

#### General Objective

Build a production-grade API to collect public transport tracking and telemetry data and support operational service management tasks.

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

### Project 5 — Long-term arrival-time prediction method

(Doctoral work)

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

### Project 10 — Infobús MCP server and client

#### General Objective

Develop an MCP (Model Context Protocol) server and client that exposes Infobús capabilities as tools and resources discoverable by assistants/LLMs, enabling natural-language queries and assisted flows.

#### Specific Objectives

- Implement an MCP server in Python that integrates the Infobús API as:
  - Tools: `get_eta(stop_id)`, `get_stop(stop_id)`, `search_stops(q)`, `get_route(route_id)`, `service_status()`, `get_alerts()`.
  - Resources: reference documents (local GTFS), OpenAPI endpoints, example queries/responses.
  - Prompts: guided templates for frequently asked questions ("When does the next bus arrive at X?", "Routes from A to B", "Service status").
- Define input/output contracts with validation (Pydantic) and traceability (structured logging).
- Implement MCP transport (JSON-RPC over WebSocket/stdio) and basic authorization (allowed origins list, client tokens if applicable).
- Design security controls: token limits, per-client quotas, tool filtering, and rate limiting.
- Build a minimal client (Nuxt/Vue) that supports:
  - Natural-language chat with transparent tool selection.
  - Input disambiguation (e.g., multiple stops with the same name).
  - History and shareable links to reproducible conversations.
- Create example playbooks (sequences) for common tasks (plan a simple trip, check delays, generate a quick panel for a stop/route).
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

#### Proposed structure

- `src/infobus/signage/` (module and CLI commands)
- `signage` subcommand registered in the current Click CLI group (`infobus`)
- `templates/` (YAML/JSON templates + base SVG per theme)
- `assets/icons/`, `assets/fonts/` (iconography and typefaces)
- `examples/` (sample data and scripts)
- `tests/` (CLI + golden images)

#### Usage examples

```sh
# Vertical stop sign 1080x1920 px, default theme, SVG output
infobus signage stop --stop-id JF83 --routes SJ12 CA23 --size 1080x1920 --format svg

# Vehicle interior sign in A4 PDF in Spanish
infobus signage vehicle --route SJ12 --direction 1 --format pdf --paper A4 --lang es

# Custom sign from a YAML template and JSON data at 300 dpi
infobus signage custom --template templates/station.yaml --data examples/station.json --format png --dpi 300
```

#### Deliverables

- Installable CLI (`infobus`) and composition library.
- Base templates (stop, vehicle, station) with style guide/themes.
- Package publishable on PyPI and Docker container.
- Test suite (golden) + CI with lint/format/tests.
- README with Quick start and template/options docs.
- Font package included (Inter) with license/usage note.

## Documentation

Documentation for all projects will be centralized on the SIMOVI site (details pending). Meanwhile, each repository must include a solid README and a `docs/` folder with the minimum useful content to get started quickly.

- General conventions

  - Language: English by default (add a short Spanish summary when helpful).
  - Single source of truth per API: OpenAPI in the repository and (if possible) generated from code.
  - Semantic versioning and `CHANGELOG.md` for relevant changes.
  - Diagrams with Mermaid (architecture, ER, flows).
