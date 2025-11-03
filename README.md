
# CrypT — The Silent Operator

> ⚡ Toolkit discret, modulaire et orienté performance pour automatiser et optimiser Swordburst 2.  
> Style : sombre / minimaliste / hacker.

![banner](./assets/banner.png)

---

## Sommaire
1. [Présentation](#présentation)  
2. [Screenshots & icônes](#screenshots--icônes)  
3. [Fonctionnalités](#fonctionnalités)  
4. [Installation rapide](#installation-rapide)  
5. [Configuration](#configuration)  
6. [Utilisation](#utilisation)  
7. [Architecture du repo](#architecture-du-repo)  
8. [Contribuer](#contribuer)  
9. [Sécurité & éthique](#sécurité--éthique)  
10. [Changelog](#changelog)  
11. [Licence (MIT)](#licence-mit)

---

## Présentation
CrypT est un projet pensé pour les scripters cherchant une solution fiable, tunable et propre pour Swordburst 2.  
Il regroupe : autofarm, killaura, pathfinding, webhooks Discord, UI modulaire, gestion d’items, et quelques protections anti-AFK / mod-detection.  
Objectif : code maintenable, UI propre, config en fichiers, assets faciles à remplacer.

---

## Screenshots & icônes
Place les images dans `assets/` :

- `./assets/banner.png` — bannière (1600×400 recommandé)  
- `./assets/CrypT.png` — icône principale (512×512, fond transparent recommandé)  
- `./assets/icon_small.png` — icône petit format (64×64)  

Exemple d’inclusion dans le README (déjà présent ci-dessus) :
```md
![banner](./assets/banner.png)
```

---

## Fonctionnalités clés
- 🔧 Autofarm intelligent (offsets dynamiques, priorité de mobs)  
- ⚔️ Killaura avec gestion de skills et threads adaptatifs  
- 🧭 Pathfinding & Autowalk (PathfindingService + fallback)  
- 🔔 Webhooks Discord (drops, kicks, erreurs)  
- 🛡 Anti-AFK & ModDetector  
- 🎛 UI modulaire (SaveManager, ThemeManager)  
- 🗂 Configs en fichiers (`autoexec`, `config.json`) et assets séparés

---

## Installation rapide

```bash
# cloner le repo
git clone https://github.com/<TON_COMPTE>/CrypT.git
cd CrypT
```

Depuis ton exploit (ex. Synapse/other), tu peux charger directement le script :
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/<TON_COMPTE>/CrypT/main/Swordburst2/CrypT_Swordburst2.lua"))()
```
Remplace `<TON_COMPTE>` par ton user GitHub / path.

> Si tu veux qu'il s'auto-exécute, ajoute `Bluu/Swordburst 2/autoexec` ou `Swordburst2/autoexec` (selon organisation) contenant `true`.

---

## Configuration

### Exemple `config.json`
Crée `Swordburst2/config.json` (ou `config/config.json`) — **NE PAS** committer les secrets.
```json
{
  "drop_webhook": "https://discord.com/api/webhooks/XXXXX/YYYYY",
  "ping_id": "987654321012345678",
  "autoexec": true,
  "defaults": {
    "autofarm_speed": 300,
    "autofarm_radius": 20000
  }
}
```

### `autoexec`
Fichier simple `Swordburst2/autoexec` contenant `true` ou `false`.

### .gitignore (recommandé)
```
# Secrets/config
Swordburst2/config.json
Swordburst2/autoexec
*.log
node_modules/
.vscode/
.DS_Store
```

---

## Utilisation (exemples)

1. Mettre les images dans `assets/` : `CrypT.png` et `banner.png`.  
2. Définir ton webhook dans l’UI ou `config.json`.  
3. Charger le script via exploit ou exécuter l’autoexec.  
4. Dans l’UI : ajuste `Autofarm`, `Killaura`, `DropWebhook` etc.  
5. Tester le webhook : utiliser l’input `DropWebhook` puis cliquer pour `sendTestMessage` (si présent).

### Modifier le nom / titre UI
Dans le script, cherche la création de la fenêtre (ex : `Library:CreateWindow({ Title = 'Bluu', ... })`) et remplace `'Bluu'` par `'CrypT'` ou ton nom perso :
```lua
local Window = Library:CreateWindow({
    Title = 'CrypT',
    Footer = 'Swordburst 2 | CrypT | Updated ' .. lastUpdated,
    ...
})
```

---

## Architecture suggérée du repo
```
CrypT/
├─ assets/
│  ├─ CrypT.png
│  ├─ icon_small.png
│  └─ banner.png
├─ Swordburst2/
│  ├─ CrypT_Swordburst2.lua
│  ├─ autoexec
│  └─ config.json
├─ UI/
│  ├─ Library.lua
│  └─ addons/
│     ├─ ThemeManager.lua
│     └─ SaveManager.lua
├─ README.md
├─ LICENSE
└─ .gitignore
```

---

## Contribuer
Tu veux contribuer ? Fork → branch → PR.
- Règle d’or : never commit secrets (webhooks, cookies…).  
- Tests manuels avant PR.  
- Commit message clair : `feat: add ...` / `fix: ...`.

---

## Sécurité & éthique
- Utilise CrypT à tes risques. Ce projet peut enfreindre les TOS du jeu.  
- Ne pas utiliser pour nuire à d'autres joueurs ni pour tricher sur des compétitions officielles.  
- Ne partage jamais tes webhooks/token en clair. Ajoute-les à `.gitignore`.

---

## Changelog (exemple)
```
## [Unreleased]
### Added
- UI improvements
- Autofarm vertical auto offset
### Fixed
- Killaura debounce bug
```

---

## Licence (MIT)
Fichier `LICENSE` :
```
MIT License

Copyright (c) 2025 <TonNom>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software...
```

---
