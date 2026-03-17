# Pipeline CI/CD - Explication étape par étape

## Déclencheur

Le pipeline se déclenche automatiquement lors d'un **Push** ou **Pull Request** sur la branche `master`.

---

## Architecture du Pipeline

```
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Pipeline CI/CD avec SAST</title>
  <style>
    body {
      font-family: sans-serif;
      background: #f5f5f5;
      display: flex;
      flex-direction: column;
      align-items: center;
      padding: 32px 16px;
      margin: 0;
    }
    h1 {
      font-size: 18px;
      font-weight: 500;
      color: #1a1a1a;
      margin-bottom: 8px;
    }
    p {
      font-size: 13px;
      color: #666;
      margin-bottom: 24px;
    }
    .card {
      background: #fff;
      border-radius: 12px;
      box-shadow: 0 1px 4px rgba(0,0,0,0.10);
      padding: 24px;
      max-width: 720px;
      width: 100%;
    }
    svg text { font-family: sans-serif; }
  </style>
</head>
<body>
  <h1>Pipeline CI/CD avec SAST intégré</h1>
  <p>Pr Noureddine GRASSA — ISET Sousse</p>
  <div class="card">
<svg width="100%" viewBox="0 0 680 860" xmlns="http://www.w3.org/2000/svg">
<defs>
  <marker id="arrow" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse">
    <path d="M2 1L8 5L2 9" fill="none" stroke="context-stroke" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
  </marker>
</defs>

<!-- DÉCLENCHEUR -->
<rect x="120" y="20" width="440" height="56" rx="8" fill="#E8E7E1" stroke="#888780" stroke-width="0.5"/>
<text font-size="14" font-weight="500" fill="#444441" x="340" y="43" text-anchor="middle" dominant-baseline="central">Déclencheur</text>
<text font-size="12" fill="#5F5E5A" x="340" y="61" text-anchor="middle" dominant-baseline="central">Push ou Pull Request sur la branche "main"</text>

<!-- Arrow déclencheur → build -->
<line x1="340" y1="76" x2="340" y2="108" stroke="#888" stroke-width="1.5" marker-end="url(#arrow)"/>

<!-- JOB 1 : BUILD -->
<rect x="120" y="108" width="440" height="158" rx="8" fill="#E6F1FB" stroke="#378ADD" stroke-width="0.5"/>
<text font-size="14" font-weight="500" fill="#0C447C" x="340" y="130" text-anchor="middle" dominant-baseline="central">Job 1 — Build</text>
<rect x="136" y="144" width="408" height="114" rx="6" fill="none" stroke="#ccc" stroke-width="0.5"/>
<text font-size="12" fill="#185FA5" x="152" y="164" dominant-baseline="central">1. Checkout</text>
<text font-size="12" fill="#444" x="280" y="164" dominant-baseline="central">Télécharge le code source</text>
<text font-size="12" fill="#185FA5" x="152" y="183" dominant-baseline="central">2. Set SHA</text>
<text font-size="12" fill="#444" x="280" y="183" dominant-baseline="central">Crée un tag unique (ex: c711dd9)</text>
<text font-size="12" fill="#185FA5" x="152" y="202" dominant-baseline="central">3. Build image</text>
<text font-size="12" fill="#444" x="280" y="202" dominant-baseline="central">Construit l'image Docker</text>
<text font-size="12" fill="#185FA5" x="152" y="221" dominant-baseline="central">4. Save image</text>
<text font-size="12" fill="#444" x="280" y="221" dominant-baseline="central">Sauvegarde en fichier .tar</text>
<text font-size="12" fill="#185FA5" x="152" y="240" dominant-baseline="central">5. Upload</text>
<text font-size="12" fill="#444" x="280" y="240" dominant-baseline="central">Stocke le .tar comme artifact</text>

<!-- Arrow build → fork -->
<line x1="340" y1="266" x2="340" y2="290" stroke="#888" stroke-width="1.5"/>
<line x1="180" y1="290" x2="500" y2="290" stroke="#888" stroke-width="1.5"/>
<line x1="180" y1="290" x2="180" y2="318" stroke="#888" stroke-width="1.5" marker-end="url(#arrow)"/>
<line x1="500" y1="290" x2="500" y2="318" stroke="#888" stroke-width="1.5" marker-end="url(#arrow)"/>

<!-- JOB 2 : SAST-CODE -->
<rect x="40" y="318" width="280" height="170" rx="8" fill="#E1F5EE" stroke="#1D9E75" stroke-width="0.5"/>
<text font-size="14" font-weight="500" fill="#085041" x="180" y="340" text-anchor="middle" dominant-baseline="central">Job 2 — SAST code</text>
<text font-size="12" fill="#0F6E56" x="180" y="358" text-anchor="middle" dominant-baseline="central">Semgrep — analyse statique</text>
<rect x="56" y="370" width="248" height="110" rx="6" fill="none" stroke="#ccc" stroke-width="0.5"/>
<text font-size="12" fill="#0F6E56" x="68" y="390" dominant-baseline="central">1. Checkout</text>
<text font-size="12" fill="#444" x="156" y="390" dominant-baseline="central">Télécharge le code</text>
<text font-size="12" fill="#0F6E56" x="68" y="409" dominant-baseline="central">2. Semgrep</text>
<text font-size="12" fill="#444" x="156" y="409" dominant-baseline="central">OWASP, secrets, Docker</text>
<text font-size="12" fill="#0F6E56" x="68" y="428" dominant-baseline="central">3. SARIF</text>
<text font-size="12" fill="#444" x="156" y="428" dominant-baseline="central">Upload GitHub Security</text>
<text font-size="12" fill="#0F6E56" x="68" y="447" dominant-baseline="central">4. Résultat</text>
<text font-size="12" fill="#444" x="156" y="447" dominant-baseline="central">Bloque si findings critiques</text>

<!-- JOB 3 : SAST-IMAGE -->
<rect x="360" y="318" width="280" height="170" rx="8" fill="#E1F5EE" stroke="#1D9E75" stroke-width="0.5"/>
<text font-size="14" font-weight="500" fill="#085041" x="500" y="340" text-anchor="middle" dominant-baseline="central">Job 3 — SAST image</text>
<text font-size="12" fill="#0F6E56" x="500" y="358" text-anchor="middle" dominant-baseline="central">Trivy — scan CVE Docker</text>
<rect x="376" y="370" width="248" height="110" rx="6" fill="none" stroke="#ccc" stroke-width="0.5"/>
<text font-size="12" fill="#0F6E56" x="388" y="390" dominant-baseline="central">1. Download</text>
<text font-size="12" fill="#444" x="476" y="390" dominant-baseline="central">Récupère le .tar</text>
<text font-size="12" fill="#0F6E56" x="388" y="409" dominant-baseline="central">2. Load image</text>
<text font-size="12" fill="#444" x="476" y="409" dominant-baseline="central">Charge l'image Docker</text>
<text font-size="12" fill="#0F6E56" x="388" y="428" dominant-baseline="central">3. Trivy</text>
<text font-size="12" fill="#444" x="476" y="428" dominant-baseline="central">CRITICAL/HIGH → SARIF</text>
<text font-size="12" fill="#0F6E56" x="388" y="447" dominant-baseline="central">4. Résultat</text>
<text font-size="12" fill="#444" x="476" y="447" dominant-baseline="central">Table lisible en console</text>

<!-- Join vers push -->
<line x1="180" y1="488" x2="180" y2="512" stroke="#888" stroke-width="1.5"/>
<line x1="500" y1="488" x2="500" y2="512" stroke="#888" stroke-width="1.5"/>
<line x1="180" y1="512" x2="500" y2="512" stroke="#888" stroke-width="1.5"/>
<line x1="340" y1="512" x2="340" y2="536" stroke="#888" stroke-width="1.5" marker-end="url(#arrow)"/>

<!-- JOB 4 : PUSH -->
<rect x="120" y="536" width="440" height="136" rx="8" fill="#EEEDFE" stroke="#7F77DD" stroke-width="0.5"/>
<text font-size="14" font-weight="500" fill="#3C3489" x="340" y="558" text-anchor="middle" dominant-baseline="central">Job 4 — Push</text>
<text font-size="12" fill="#534AB7" x="340" y="575" text-anchor="middle" dominant-baseline="central">Conditionné au succès des deux jobs SAST</text>
<rect x="136" y="588" width="408" height="76" rx="6" fill="none" stroke="#ccc" stroke-width="0.5"/>
<text font-size="12" fill="#534AB7" x="152" y="608" dominant-baseline="central">1. Download</text>
<text font-size="12" fill="#444" x="280" y="608" dominant-baseline="central">Récupère le fichier .tar</text>
<text font-size="12" fill="#534AB7" x="152" y="627" dominant-baseline="central">2. Load image</text>
<text font-size="12" fill="#444" x="280" y="627" dominant-baseline="central">Charge l'image Docker</text>
<text font-size="12" fill="#534AB7" x="152" y="646" dominant-baseline="central">3. Login + Push</text>
<text font-size="12" fill="#444" x="280" y="646" dominant-baseline="central">Connexion et push vers Docker Hub</text>

<!-- Arrow push → deploy -->
<line x1="340" y1="672" x2="340" y2="704" stroke="#888" stroke-width="1.5" marker-end="url(#arrow)"/>

<!-- JOB 5 : DEPLOY -->
<rect x="120" y="704" width="440" height="136" rx="8" fill="#FAECE7" stroke="#D85A30" stroke-width="0.5"/>
<text font-size="14" font-weight="500" fill="#712B13" x="340" y="726" text-anchor="middle" dominant-baseline="central">Job 5 — Deploy</text>
<rect x="136" y="740" width="408" height="92" rx="6" fill="none" stroke="#ccc" stroke-width="0.5"/>
<text font-size="12" fill="#993C1D" x="152" y="760" dominant-baseline="central">1. Checkout</text>
<text font-size="12" fill="#444" x="280" y="760" dominant-baseline="central">Télécharge le code source</text>
<text font-size="12" fill="#993C1D" x="152" y="779" dominant-baseline="central">2. Update YAML</text>
<text font-size="12" fill="#444" x="280" y="779" dominant-baseline="central">Modifie deployment.yaml avec nouveau tag</text>
<text font-size="12" fill="#993C1D" x="152" y="798" dominant-baseline="central">3. Commit/Push</text>
<text font-size="12" fill="#444" x="280" y="798" dominant-baseline="central">Enregistre les changements sur GitHub</text>
</svg>
  </div>
</body>
</html>
<img width="1412" height="1786" alt="image" src="https://github.com/user-attachments/assets/776c92aa-76c2-41aa-b28a-375fdf5b9e76" />

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
