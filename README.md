# Pipeline CI/CD - Explication étape par étape

## Déclencheur

Le pipeline se déclenche automatiquement lors d'un **Push** ou **Pull Request** sur la branche `master`.
Voici la version avec SAST intégré.Le SAST après le build et avant le push, ce qui est la bonne pratique : analyser le code source ET l'image avant de publier quoi que ce soit.

# Outils SAST intégrés :

1- Semgrep → analyse statique du code source (OWASP, secrets, vulnérabilités)
2- Trivy → scan de l'image Docker pour les CVE

---

## Architecture du Pipeline

```mermaid
flowchart TD
    TRIGGER(["🚀 Push / Pull Request\nsur la branche **main**"])

    subgraph JOB1["⚙️ Job 1 — Build"]
        B1["1. Checkout — code source"]
        B2["2. Set SHA — tag unique ex: c711dd9"]
        B3["3. Build — image Docker"]
        B4["4. Save — sauvegarde en .tar"]
        B5["5. Upload — artifact pour jobs suivants"]
        B1 --> B2 --> B3 --> B4 --> B5
    end

    subgraph JOB2["🔍 Job 2 — SAST Code · Semgrep"]
        S1["1. Checkout — code source"]
        S2["2. Semgrep — OWASP Top 10, secrets, Docker"]
        S3["3. SARIF — upload GitHub Security"]
        S1 --> S2 --> S3
    end

    subgraph JOB3["🔍 Job 3 — SAST Image · Trivy"]
        T1["1. Download — récupère le .tar"]
        T2["2. Load — charge l'image Docker"]
        T3["3. Trivy — scan CRITICAL / HIGH"]
        T4["4. SARIF — upload GitHub Security"]
        T1 --> T2 --> T3 --> T4
    end

    subgraph JOB4["📦 Job 4 — Push · Docker Hub"]
        P1["1. Download — récupère le .tar"]
        P2["2. Load — charge l'image Docker"]
        P3["3. Login + Push — Docker Hub"]
        P1 --> P2 --> P3
    end

    subgraph JOB5["🚢 Job 5 — Deploy · GitOps"]
        D1["1. Checkout — code source"]
        D2["2. Update YAML — nouveau tag dans deployment.yaml"]
        D3["3. Commit + Push — mise à jour sur GitHub"]
        D1 --> D2 --> D3
    end

    TRIGGER --> JOB1
    JOB1 --> JOB2
    JOB1 --> JOB3
    JOB2 --> JOB4
    JOB3 --> JOB4
    JOB4 --> JOB5

    style TRIGGER fill:#4a4a8a,color:#fff,stroke:#3a3a7a
    style JOB1   fill:#dbeafe,stroke:#3b82f6,color:#1e3a5f
    style JOB2   fill:#d1fae5,stroke:#10b981,color:#064e3b
    style JOB3   fill:#d1fae5,stroke:#10b981,color:#064e3b
    style JOB4   fill:#ede9fe,stroke:#7c3aed,color:#2e1065
    style JOB5   fill:#fee2e2,stroke:#ef4444,color:#7f1d1d
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
