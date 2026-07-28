# RemoteFlow

Aplicación Flutter para encontrar y organizar vacantes remotas publicadas por
[Remotive](https://remotive.com/). Cada vacante enlaza a su publicación original.

## Funciones

- Vacantes reales desde la API pública oficial de Remotive.
- Caché local de seis horas para respetar el límite recomendado de cuatro consultas diarias.
- Búsqueda por puesto o empresa y filtros por categoría, ubicación y modalidad.
- Estados de carga, error y resultados vacíos.
- Detalle, salario cuando está disponible y apertura de la oferta original.
- Favoritos persistentes.
- Seguimiento por estado: guardada, postulada, entrevista, rechazada y oferta.
- Notas personales, tema claro y oscuro.
- Arquitectura MVVM con Provider y widgets reutilizables.
- Pruebas de view models y persistencia.

## Arquitectura

```text
lib/
├── core/          tema visual
├── data/          API, caché y persistencia
├── models/        entidades de dominio
├── viewmodels/    estado y lógica de presentación
├── views/         pantallas
└── widgets/       componentes reutilizables
```

## Ejecutar

Requiere Flutter estable con Dart 3.3 o superior.

```bash

flutter pub get
flutter run
```

La primera ejecución necesita internet. Después, las vacantes permanecen disponibles
desde el caché. Los favoritos, estados, notas y preferencia de tema siempre se guardan
localmente.

## Calidad

```bash
flutter analyze
flutter test
dart format --set-exit-if-changed lib test
```

## Decisiones

- `SharedPreferences` mantiene el alcance pequeño y evita adaptadores generados.
- La búsqueda y los filtros son locales, por lo que no provocan solicitudes adicionales.
- Pull-to-refresh fuerza una consulta solo cuando la persona lo solicita.
- No incluye cuenta, backend, chat, push ni sincronización entre dispositivos.

## Fuente de datos

Los datos pertenecen a Remotive y se obtienen de
`https://remotive.com/api/remote-jobs`. RemoteFlow no replica ni altera los enlaces de
postulación.
