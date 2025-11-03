# ⚡ CrypT - Swordburst 2 Automation Hub

![CrypT Banner](assets/banner.png)

---

## 🔐 Présentation
**CrypT** est un hub d’automatisation et d’assistance complet pour *Swordburst 2*.  
Un design minimaliste, un cœur puissant, et une touche de glitch néon qui te plonge directement dans le code.  
Conçu pour être **rapide, modulaire et stylé**.

---

## 🧩 Fonctionnalités principales

### ⚔️ Autofarm intelligent
- Farm automatique avec ciblage intelligent des mobs.
- Ajustement de la distance, de la hauteur et du rayon.
- Repositionnement automatique après mort.
- Ignoration des entités selon leur rareté.

---

### 💥 Killaura & Skills
- Attaque automatique des mobs proches.
- Activation intelligente des compétences.
- Gestion des cooldowns et de l’endurance.
- Support de toutes les armes (mêlée et distance).

---

### 🚶 Autowalk / Pathfinding
- Déplacement automatique jusqu’aux mobs.
- Système de pathfinding dynamique et fluide.
- Waypoint personnalisable.
- Téléportations rapides vers les zones clés.

---

### 🧠 Automations & Webhooks
- Webhook Discord intégré (avec embeds stylés).
- Notifications en temps réel (farm, drop, mort).
- Ping personnalisé via ID Discord (`<@id>`).
- Gestion directe depuis l’interface.

---

## 🖥️ Interface utilisateur
Basée sur la **Library Obsidian**, l’UI offre :
- Un thème sombre avec effets néon.
- Des sliders fluides et précis.
- Des dropdowns intuitifs.
- Des boutons arrondis au style CrypT.
- Sauvegarde automatique des paramètres (`autoexec`).

---

## ⚙️ Installation

1. Lance *Swordburst 2*.
2. Ouvre ton exécuteur Roblox (Synapse X, Fluxus, etc.)
3. Copie-colle ce code :
   ```lua
   loadstring(game:HttpGet('https://raw.githubusercontent.com/turpez/CrypT/main/Swordburst2.lua'))()
