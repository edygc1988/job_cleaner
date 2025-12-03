# Configuración de CI/CD en GitHub

## Secrets Requeridos

Para que el CI/CD funcione, necesitas configurar los siguientes secrets en GitHub:

### 1. `OPENSHIFT_TOKEN`

Token de autenticación de OpenShift con permisos para deployar.

**Cómo obtenerlo:**

```bash
oc whoami -t
```

### 2. `OPENSHIFT_SERVER`

URL del servidor de OpenShift.

**Cómo obtenerlo:**

```bash
oc cluster-info | grep 'Kubernetes master' | awk '/https/ {print $NF}'
```

O simplemente:

```bash
oc config view --minify -o jsonpath='{.clusters[0].cluster.server}'
```

## Configurar Secrets en GitHub

1. Ve a tu repositorio en GitHub
2. Settings → Secrets and variables → Actions
3. Haz clic en "New repository secret"
4. Añade los dos secrets:
   - Name: `OPENSHIFT_TOKEN` → Value: (tu token de OC)
   - Name: `OPENSHIFT_SERVER` → Value: (tu URL de OpenShift)

## Disparadores del CI/CD

El workflow se ejecuta automáticamente cuando:

- Haces push a la rama `main` y cambias archivos en `k8s/` o el workflow
- Usas "Run workflow" manualmente desde GitHub Actions

## Verificar el Deploy

En GitHub, ve a:

- Actions → Deploy to OpenShift → Ver logs del último run

O en la terminal:

```bash
oc get cronjob -n edygc1988-dev
oc describe cronjob job-cleaner -n edygc1988-dev
```
