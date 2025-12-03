# Job Cleaner for OpenShift

Job Cleaner es una aplicación que limpia logs antiguos de contenedores y jobs en OpenShift/Kubernetes.

## Características

- Elimina pods terminados/fallidos más antiguos de N días
- Elimina jobs completados/fallidos más antiguos de N días
- Se ejecuta como CronJob (configurable)
- Logging detallado de todas las operaciones
- Control de RBAC con ServiceAccount

## Estructura del Proyecto

```
job_cleaner/
├── job_cleaner.py       # Script principal en Python
├── Dockerfile           # Imagen Docker
├── k8s/                 # Manifiestos de Kubernetes/OpenShift
│   ├── namespace.yaml
│   ├── serviceaccount.yaml
│   ├── clusterrole.yaml
│   ├── clusterrolebinding.yaml
│   └── cronjob.yaml
└── README.md
```

## Requisitos

- OpenShift/Kubernetes 1.19+
- Docker para construir la imagen
- kubectl o oc para deployar

## Variables de Entorno

- `NAMESPACE`: Namespace donde ejecutar la limpieza (default: `edygc1988-dev`)
- `DAYS_TO_KEEP`: Días de logs a mantener (default: `7`)

## Deployment

### Opción 1: Deployment Automático con GitHub Actions (Recomendado)

El repositorio incluye CI/CD que despliega automáticamente en OpenShift cuando haces push a `main`.

**Requisitos:**

1. Configura los secrets de GitHub (ver `.github/CICD_SETUP.md`)
2. Haz push a la rama `main`
3. El workflow se ejecutará automáticamente

Ver estado en: GitHub → Actions

**Secrets necesarios:**

- `OPENSHIFT_TOKEN`: Token de autenticación de OpenShift
- `OPENSHIFT_SERVER`: URL del servidor de OpenShift

Instrucciones detalladas en `.github/CICD_SETUP.md`

### Opción 2: Deployment Manual

```bash
# Aplicar todos los manifiestos
oc apply -f k8s/namespace.yaml
oc apply -f k8s/serviceaccount.yaml
oc apply -f k8s/clusterrole.yaml
oc apply -f k8s/clusterrolebinding.yaml
oc apply -f k8s/cronjob.yaml
```

O en una sola línea:

```bash
oc apply -f k8s/
```

### Verificar el deployment

```bash
# Ver el CronJob
oc get cronjob -n edygc1988-dev

# Ver los jobs generados
oc get jobs -n edygc1988-dev

# Ver los logs
oc logs -n edygc1988-dev job/job-cleaner-<timestamp>
```

## Configuración del Schedule

Por defecto, el job se ejecuta todos los días a las 2 AM. Para cambiar esto, editar `k8s/cronjob.yaml`:

```yaml
spec:
  schedule: "0 2 * * *" # Formato cron estándar
```

## Licencia

MIT
