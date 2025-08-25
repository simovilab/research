# Proyectos Eléctricos 2025 II

## Objetivo generalísimo

> Diseñar e implementar un prototipo _end-to-end_ de plataforma de información de transporte público basada en GTFS (Schedule y Realtime), con APIs operativas (Databús/Infobús), predicción de llegadas, servidor de pantallas, panel de datos y cliente/servidor MCP, validado con datos y simulación durante el ciclo 2025 II.

## Proyectos

### 1. Databús API

#### Objetivo general

Crear una API de nivel de producción para recolectar datos de rastreo y telemetría del transporte público y apoyar tareas de gestión operativa del servicio.

#### Objetivos específicos

- Actualizar y completar los _endpoints_ (lectura/escritura, validación y paginación).
- Actualizar y completar la documentación (OpenAPI) con ejemplos de solicitud/respuesta.
- Definir e implementar una estrategia CRUD para almacenamiento en diferentes tipos de bases de datos.
- Implementar autenticación por _tokens_ y control de acceso por roles.
- Gestionar clientes (vehículos, dispositivos, personas, agencias, otros): registro y ciclo de vida.
- Gestionar permisos, seguridad y desempeño (límites y cuotas básicas).
- Crear un prototipo de panel de administración.
- Crear pruebas unitarias y de integración.

#### Tecnologías

Repositorio: https://github.com/simovilab/databus

- Python
- Django
- Django REST Framework
- PostgreSQL, Redis, Apache Jena Fuseki
- OpenAPI
- Vue (documentación)

### 2. Aplicación de Django GTFS (versión _Schedule_)

#### Objetivo general

Desarrollar una aplicación de Django que provea modelos, validaciones y utilidades para la gestión de datos GTFS _Schedule_.

#### Objetivos específicos

- Actualizar y completar los modelos de la base de datos con base en GTFS v2.0, con restricciones de integridad referencial
- Crear un documento de esquema (_schema_) como fuente de verdad, alineado a la especificación oficial y usado para generar modelos y documentación
- Migrar a llaves primarias compuestas (Django 5.2) según las llaves definidas por GTFS
- Implementar herramienta de creación de _fixtures_ (comandos de _management_)
- Crear utilidad de **importación** de GTFS desde ZIP (comando `import_gtfs`)
- Crear utilidad de **exportación** de GTFS hacia ZIP (comando `export_gtfs`)
- Módulo de construcción de tabla `stop_times.txt` con el estimador de tiempos de llegada
- Publicar como extensión de Django en PyPI (actualmente es submódulo de Git), con versionado semántico
- Crear documentación con ejemplos mínimos de uso

#### Tecnologías

Repositorio: https://github.com/simovilab/django-app-gtfs

- Python
- Django 5.2 (llaves primarias compuestas)
- PostgreSQL/PostGIS (soporte espacial para `shapes.txt` y paradas)
- Vue (documentación)

### 3. Aplicación de Django GTFS (versión _Realtime_)

#### Objetivo general

Desarrollar una aplicación de Django con modelos y utilidades para la gestión de datos GTFS _Realtime_ (_Protocol Buffers_) y su integración con _Schedule_.

#### Objetivos específicos

- Actualizar y completar los modelos alineados a la especificación GTFS _Realtime_, con relaciones a entidades _Schedule_ (viajes, paradas)
- Crear un documento de esquema (_schema_) como fuente de verdad
- Definir identificadores/llaves coherentes con _Schedule_ y, cuando aplique, compuestos
- Módulo de construcción de la entidad `TripUpdates` con el estimador de tiempos de llegada
- Implementar herramienta de creación de _fixtures_
- Módulos de serialización/decodificación (_Protocol Buffers_) para `VehiclePositions`, `TripUpdates` y `Alerts`
- Validación de suministros de datos (_feeds_) (_timestamps_, consistencia de identificadores) y utilidades de conversión a JSON
- Publicar como extensión de Django en PyPI (actualmente es submódulo de Git)
- Crear documentación con ejemplos de publicación/consumo

#### Tecnologías

Repositorio: https://github.com/simovilab/django-app-gtfs

- Python
- Django
- _Protocol Buffers_
- `gtfs-realtime-bindings` (Python)
- Vue (documentación)

### 4. Creador de modelos de predicción con datos históricos

#### Objetivo general

Construir un módulo de entrenamiento e inferencia de modelos para estimar tiempos de llegada (ETA) a partir de datos históricos y telemetría, integrado con las aplicaciones GTFS (_Schedule_ y _Realtime_).

#### Objetivos específicos

- Diseñar la estrategia de recolección y depuración de datos históricos (fuentes, esquema y ETL): deduplicación, manejo de vacíos temporales, muestreo y alineación con entidades _Schedule_.
- Implementar generación de variables (hora del día, día de semana/feriado, clima opcional, secuencia de paradas, distancia al próximo _stop_, _headway_, congestión aproximada).
- Implementar modelos base: mediana histórica y regresión polinómica por ruta-tramo-parada, con niveles de respaldo (fallbacks) cuando no haya suficiente historial.
- Definir protocolo de entrenamiento y evaluación temporal (_rolling_): métricas MAE, RMSE y MAPE y selección automática del mejor modelo por segmento.
- Diseñar e implementar el registro de modelos (versionado): almacenamiento de parámetros/coeficientes en PostgreSQL y caché en Redis para baja latencia.
- Desarrollar la función de inferencia `estimate_stop_times()` utilizable desde _Schedule_ y _Realtime_, que debe soportar inferencia por lote (_batch_) y en línea.
- Programar reentrenamientos periódicos (diario/semanal), _backfill_ del histórico y monitoreo de deriva de error.
- Integrar con los módulos de los 2 y 3 (claves coherentes, contratos de entrada/salida) y exponer _hooks_ para APIs.
- Crear pruebas unitarias/integración y un conjunto de datos sintéticos de validación reproducible.

#### Tecnologías

Repositorio: https://github.com/simovilab/django-app-gtfs

- Python
- Pandas
- NumPy
- SciPy
- scikit-learn
- PostgreSQL
- Redis

### 5. Método de predicción de largo plazo de tiempos de llegada

(Trabajo doctoral)

### 6. Simulador de buses en movimiento

#### Objetivo general

Crear un módulo de simulación determinista y reproducible del movimiento de buses basado en GTFS _Schedule_, para pruebas _end-to-end_ del sistema y sus etapas intermedias.

#### Objetivos específicos

- Ingerir un conjunto GTFS y generar escenarios de simulación (rutas, viajes, frecuencias) parametrizables.
- Simular movimiento de vehículos por _ticks_ (1-5 s) con perfiles de velocidad, tiempos de detención por parada y variabilidad estocástica controlada (semilla, _seed_).
- Generar y enviar posiciones de vehículo (y opcionalmente _TripUpdates_ / _Alerts_ sintéticos) hacia Databús API para validar canalizaciones de datos(_pipelines_).
- Implementar perturbaciones simples (retrasos, desvíos, _holding_ para control de _headway_) para pruebas de robustez.
- Orquestar la simulación con Celery (tareas periódicas y colas por escenario).
- Proveer configuración de escenarios vía YAML/JSON (número de buses, rutas a simular, horarios, _jitter_, semilla).
- Registrar eventos y métricas básicas (puntualidad, _on-time performance_, brechas de servicio) para validación.
- Exponer comandos de _management_: `generate_scenario`, `start_sim`, `stop_sim`, `list_sims`.
- Crear pruebas unitarias y _fixtures_ sintéticos.

#### Tecnologías

Repositorio: https://github.com/simovilab/simbus

- Python
- Django
- Celery
- NumPy (perfiles de velocidad/ruido)
- YAML/JSON para configuración de escenarios

#### Entregables

- Contenedor Docker para instalación en servidor
- Módulo con componentes de escenario, motor de simulación y conectores a Databús.
- Escenarios de ejemplo (pequeño/mediano) y datos sintéticos.
- Comandos de _management_ para ejecutar la simulación.
- Documentación extensiva.

### 7. Infobús API

#### Objetivo general

Proveer una API pública de información al pasajero basada en GTFS (_Schedule_/_Realtime_) y métricas derivadas, para consumo por sitios web, aplicaciones móviles, pantallas y chatbots.

#### Objetivos específicos

- Actualizar y completar los _endpoints_ de lectura: paradas, rutas, viajes, llegadas/ETAs por parada y por ruta, estado del servicio, alertas y (si aplica) _headways_/ocupación.
- Agregar búsqueda/autocompletado de paradas y rutas, y _health checks_ básicos.
- Actualizar y completar la documentación (OpenAPI) con ejemplos de solicitud/respuesta y códigos de error.
- Definir e implementar la estrategia de almacenamiento/lectura: PostgreSQL para _Schedule_, Redis para caché/_Realtime_ y Fuseki si se exponen vistas semánticas.
- Implementar autenticación por _tokens_ (p. ej., JWT) para clientes registrados y definir _rate limits_ para _endpoints_ públicos.
- Gestionar clientes (sitios, apps, pantallas, chatbots): registro, claves, cuotas y métricas de uso.
- Gestionar permisos, seguridad y desempeño: CORS, paginación, ETag/HTTP caching, límites de consulta y _rate limiting_.
- Crear un prototipo de panel de administración (Django admin/panel dedicado) con métricas básicas (tráfico, latencia, errores).
- Crear pruebas unitarias, de integración y de contrato (validación contra el esquema OpenAPI).

#### Tecnologías

Repositorio: https://github.com/simovilab/infobus

- Python
- Django
- Django REST Framework
- PostgreSQL, Redis, Apache Jena Fuseki
- OpenAPI
- Vue (documentación)

### 8. Servidor de pantallas

#### Objetivo general

Implementar el servidor que consume datos de Infobús API y gestiona la información enviada en tiempo real a pantallas informativas instaladas en buses y paradas.

#### Objetivos específicos

- Plataforma de configuración de pantallas: registro/desregistro de dispositivos, agrupación (por ruta, terminal, zona), variables de entorno y _overrides_ por dispositivo.
- Conexión permanente con las pantallas mediante WebSockets/SSE con reconexión exponencial y _heartbeats_.
- Estrategia de persistencia de la conexión y entrega confiable: colas por dispositivo, reintentos, y _backoff_.
- Plantillas de presentación (_layouts_) para contextos: a bordo (siguiente parada, ETA, correspondencias) y parada (próximas salidas, alertas, ocupación si disponible).
- Integración con Infobús API: consultas eficientes, uso de caché y actualización diferencial.
- Programación de contenidos por horario y ubicación (ventanas, _playlists_) y manejo de emergencias/alertas.
- Seguridad: autenticación de dispositivos (_tokens_/llaves por dispositivo), CORS, firma de mensajes y registro de auditoría.
- Observabilidad: métricas de entrega/latencia, disponibilidad por dispositivo, bitácoras y panel básico de monitoreo.
- Pruebas unitarias e integración (incluye _fixtures_ de dispositivos y pantallas simuladas).

#### Tecnologías

Repositorio: https://github.com/simovilab/infobus-screens

- Python
- Django
- Django Channels (WebSockets, SSE)
- Redis (canalización y caché)
- httpx (cliente HTTP hacia Infobús API)
- Vue / TypeScript
- VueUse
- Tailwind
- Vite

#### Entregables

- Módulo de servidor con administración de dispositivos, canales de distribución y plantillas.
- Panel de administración para configuración y monitoreo.
- Plantillas de pantalla (a bordo y en parada) listas para uso y personalización.
- Contenedor Docker y guía de despliegue.

### 9. Panel de datos de transporte público

#### Objetivo general

Desarrollar un panel de monitoreo y analítica básica (tiempo real y cercano a tiempo real) del transporte público a partir de GTFS _Schedule_, GTFS _Realtime_ e indicadores derivados de Databús/Infobús.

#### Objetivos específicos

- Definir y operacionalizar índice claves de desempeño (KPI, _Key Performance Indicators_): puntualidad (_on-time performance_), adherencia de _headway_, retraso promedio por ruta, frescura de _feeds_, latencia de APIs, brechas de servicio y ocupación (si está disponible).
- Implementar adaptadores de datos: consultas a Infobús API, lectura de GTFS _Schedule_ (PostgreSQL) y agregaciones para KPIs.
- Exponer KPIs como métricas de Prometheus (_exporter_ en Python).
- Habilitar la construcción de búsquedas con PromQL.
- Construir tableros en Grafana: vista general (red), por ruta, por parada y salud de APIs/_feeds_.
- Configurar alertas (Alertmanager): frescura de _feeds_, errores 5xx/latencia de APIs, caída de vehículos reportando.
- Documentar definiciones de KPIs, supuestos y limitaciones.

#### Tecnologías

- Python
- FastAPI o _exporter_ simple para Prometheus
- Prometheus
- Prometheus Alertmanager
- Grafana
- PostgreSQL (Schedule)
- Redis (caché opcional)

#### Entregables

- Exporter de Prometheus con KPIs operacionales.
- Tableros de gráficos (_dashboards_) de Grafana (JSON) para red, rutas, paradas y salud del sistema.
- Reglas de alertas (Alertmanager) y guías de umbrales iniciales.
- Documento breve de definiciones de KPIs y procedimiento de despliegue.

### 10. Servidor y cliente Infobús MCP

#### Objetivo general

Desarrollar un servidor y cliente MCP (_Model Context Protocol_) que exponga capacidades de Infobús como herramientas y recursos descubiertos por asistentes/LLMs, habilitando consultas en lenguaje natural y flujos asistidos.

#### Objetivos específicos

- Implementar un servidor MCP en Python que integre Infobús API como:
  - **Tools**: `get_eta(stop_id)`, `get_stop(stop_id)`, `search_stops(q)`, `get_route(route_id)`, `service_status()`, `get_alerts()`.
  - **Resources**: documentos de referencia (GTFS local), endpoints OpenAPI, ejemplos de consultas/respuestas.
  - **Prompts**: plantillas guiadas para preguntas frecuentes ("¿Cuándo llega el próximo bus en X?", "Rutas desde A hasta B", "Estado del servicio").
- Definir contratos de entrada/salida con validación (Pydantic) y trazabilidad (logging estructurado).
- Implementar transporte MCP (JSON-RPC sobre WebSocket/stdio) y autorización básica (lista de orígenes permitidos, _tokens_ de cliente si aplica).
- Diseñar controles de seguridad: límites de _tokens_, cuotas por cliente, filtrado de herramientas y _rate limiting_.
- Construir un cliente mínimo (Nuxt/Vue) que permita:
  - Chat en lenguaje natural con selección transparente de herramientas.
  - Desambiguación de entradas (por ejemplo, múltiples paradas con el mismo nombre).
  - Historial y compartir enlace a conversaciones reproducibles.
- Crear ejemplos de _playbooks_ (secuencias) para tareas comunes (planificar viaje simple, verificar atrasos, generar panel rápido para una parada/ruta).
- Pruebas unitarias/integración: simulación de llamadas a tools, validación de _schemas_ y pruebas de latencia.

#### Tecnologías

Repositorio: https://github.com/simovilab/infobus-mcp

- Python (servidor)
- SDK MCP (Python) / especificación MCP
- WebSocket / stdio (transporte)
- Pydantic (validación de I/O)
- httpx (cliente HTTP hacia Infobús API)
- Nuxt / Vue (cliente)

#### Entregables

- Servidor MCP con _tools_/_resources_/_prompts_ documentados.
- Cliente mínimo (Nuxt/Vue) con chat e invocación de herramientas.
- Documentos de contexto y ejemplos de _playbooks_.
- Suite de pruebas y guía de despliegue/local.

### 11. Editor de señalética

#### Objetivo general

Crear una herramienta CLI y biblioteca Python para la generación programática de señalética (rótulos) de transporte público -paradas, vehículos, estaciones— con salida en SVG/PDF/PNG, parametrizable por tamaño, tema e idioma, pensada para uso sin GUI y escalable a un servidor de plantillas en el futuro.

#### Objetivos específicos

- Diseñar un esquema de plantilla (YAML/JSON) para describir rótulos: dimensiones, rejillas, tipografías, paletas, iconografía y campos dinámicos (códigos, rutas, nombres, QR).
- Implementar un motor de composición basado en SVG + Jinja2 con conversión a PDF/PNG; soporte de fuentes empotradas y perfiles de color básicos.
- Exponer una CLI con subcomandos: `stop`, `vehicle`, `route`, `station`, `custom`, con opciones: `--format svg|pdf|png`, `--size 1080x1920|mm`, `--dpi`, `--theme`, `--lang`, `--qr-url`.
- Integrar datos de Infobús/GTFS: si se provee `--stop-id` o `--route-id`, completar textos/códigos desde la API o archivos locales.
- Generar QR y códigos legibles (alto contraste), márgenes/bleed y marcas de corte para impresión.
- Validar entradas y archivos de plantilla con Pydantic y una salida de errores amigable (Rich).
- Integrar el subcomando `signage` al CLI existente `infobus` (Click), sin romper compatibilidad, empaquetar con `pyproject.toml` y publicar en PyPI.
- Incluir un set mínimo de plantillas: parada vertical/horizontal, vehículo (interior/exterior), estación modular.
- Pruebas con imágenes doradas (golden) para SVG/PNG y tests de CLI; lint/format automáticos.
- Documentación breve con ejemplos reproducibles y previsualización local; Dockerfile para renderizado consistente.

#### Tecnologías

Repositorio: https://github.com/simovilab/infobus-py

- Python
- Click (CLI existente)
- Jinja2 (plantillas)
- CairoSVG (render/convertir SVG a/desde PNG/PDF)
- Pillow (composición raster y postproceso)
- Pydantic (validación de I/O)
- PyYAML / JSON (plantillas/configuración)
- `segno` o `qrcode` (códigos QR)
- Rich (salida CLI)
- Inter (tipografía principal) + fuentes complementarias libres (p. ej., Noto Symbols/Emoji)

#### Estructura propuesta

- `src/infobus/signage/` (módulo y comandos CLI)
- Subcomando `signage` registrado en el grupo Click del CLI actual (`infobus`)
- `templates/` (plantillas YAML/JSON + SVG base por tema)
- `assets/icons/`, `assets/fonts/` (iconografía y tipografías)
- `examples/` (datos de ejemplo y scripts)
- `tests/` (CLI + golden images)

#### Ejemplos de uso

```sh
# Rótulo de parada vertical 1080x1920 px, tema por defecto, salida SVG
infobus signage stop --stop-id JF83 --routes SJ12 CA23 --size 1080x1920 --format svg

# Rótulo de vehículo interior en PDF A4 en español
infobus signage vehicle --route SJ12 --direction 1 --format pdf --paper A4 --lang es

# Rótulo personalizado desde plantilla YAML y datos JSON a 300 dpi
infobus signage custom --template templates/station.yaml --data examples/station.json --format png --dpi 300
```

#### Entregables

- CLI instalable (`infobus`) y biblioteca de composición.
- Plantillas base (parada, vehículo, estación) con guía de estilo/temas.
- Paquete publicable en PyPI y contenedor Docker.
- Suite de pruebas (_golden_) + CI con lint/format/pruebas.
- README con Quick start y docs de plantillas/opciones.
- Paquete de fuentes incluido (Inter) y nota de licencia/uso.

## Documentación

La documentación de todos los proyectos estará centralizada en el sitio de SIMOVI (detalles pendientes). Mientras tanto, cada repositorio debe incluir un README sólido y una carpeta `docs/` con lo mínimo útil para empezar rápido.

- Convenciones generales

  - Idioma: inglés por defecto (añadir resumen corto en español cuando ayude).
  - Una sola fuente de verdad por API: OpenAPI en el repositorio y (si es posible) generado desde el código.
  - Versionado semántico y `CHANGELOG.md` por cambios relevantes.
  - Diagramas con Mermaid (arquitectura, ER, flujos).
