# Pipeline CI/CD - Explication étape par étape

## Déclencheur

Le pipeline se déclenche automatiquement lors d'un **Push** ou **Pull Request** sur la branche `master`.

---

## Architecture du Pipeline

```
┌─────────────────────────────────────────────────────────────────┐
│                         DÉCLENCHEUR                             │
│         Push ou Pull Request sur la branche "master"            │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                      JOB 1 : BUILD                              │
├─────────────────────────────────────────────────────────────────┤
│ 1. Checkout      → Télécharge le code source                    │
│ 2. Set SHA       → Crée un tag unique (ex: c711dd9)             │
│ 3. Build image   → Construit l'image Docker                     │
│ 4. Save image    → Sauvegarde en fichier .tar                   │
│ 5. Upload        → Stocke le .tar pour le job suivant           │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                      JOB 2 : PUSH                               │
├─────────────────────────────────────────────────────────────────┤
│ 1. Download      → Récupère le fichier .tar                     │
│ 2. Load image    → Charge l'image Docker                        │
│ 3. Login         → Connexion à Docker Hub                       │
│ 4. Push image    → Envoie l'image sur Docker Hub                │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                      JOB 3 : DEPLOY                             │
├─────────────────────────────────────────────────────────────────┤
│ 1. Checkout      → Télécharge le code source                    │
│ 2. Update YAML   → Modifie deployment.yaml avec nouveau tag     │
│ 3. Commit/Push   → Enregistre les changements sur GitHub        │
└─────────────────────────────────────────────────────────────────┘
```

---

## Résumé des Jobs

| Job | Rôle |
|-----|------|
| **Build** | Construit l'image Docker et la sauvegarde |
| **Push** | Envoie l'image sur Docker Hub |
| **Deploy** | Met à jour le fichier Kubernetes avec le nouveau tag |

---

## Flux des données

```
Code source
    │
    ▼
Image Docker (grassa77/gitomyapp:xxxxxxx)
    │
    ▼
Docker Hub (registre cloud)
    │
    ▼
deployment.yaml mis à jour → ArgoCD détecte → Déploie sur Kubernetes
```

---

## Pourquoi 3 jobs séparés ?

- **Isolation** : Chaque job tourne sur une VM différente
- **Parallélisme** : Possibilité d'ajouter des jobs en parallèle
- **Réutilisation** : On peut relancer un seul job si besoin

---

## Fichiers importants

| Fichier | Description |
|---------|-------------|
| `.github/workflows/build-deploy.yml` | Définition du pipeline CI/CD |
| `k8s/deployment.yaml` | Manifest Kubernetes (mis à jour automatiquement) |
| `Dockerfile` | Instructions de build de l'image |

---

## Utilisation

1. Modifie ton code
2. Commit et push sur `master`
3. Le pipeline s'exécute automatiquement
4. L'image est déployée sur Kubernetes via ArgoCD

## a la fin lancer git pull pour synchroniser avec le repo local 
1. git pull 