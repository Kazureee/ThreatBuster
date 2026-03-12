# ThreatBuster: A Gamified Cybersecurity Learning Experience 🛡️🎮

**Developed by:** DevSync  
**Status:** 🚧 Presented

---

## 📖 About the Project

The rapid growth of digital technology has also increased the number of cyber threats such as phishing, malware, and viruses. Many people are still unaware of how these attacks work, which makes them more vulnerable to security risks.

**ThreatBuster** is a gamified learning platform designed to improve cybersecurity awareness through interactive gameplay. Instead of traditional learning methods, players experience simulated cyber threats inside a game environment where they must recognize attacks and respond using the correct defensive tools.

By combining **game mechanics, strategy, and adaptive systems**, ThreatBuster creates a dynamic environment where players can learn cybersecurity concepts while actively engaging with evolving threats.

---

## 🎯 Core Objectives

### 🧠 Interactive Learning
Provide an engaging platform where players learn about different cyber threats and how to counter them using specialized defensive tools.

### 🔁 Knowledge Retention
Reinforce cybersecurity concepts through gameplay scenarios that simulate real-world attacks and decision-making situations.

### 📈 Adaptive Difficulty
Encourage continuous learning by gradually increasing the difficulty of threats and forcing players to adapt their defense strategies.

---

## 🏗️ System Architecture

The game uses a **modular scene-based architecture** built with **Godot Engine**, allowing a clean separation between game logic, visuals, and user interface.

### Core Systems

- **MainScene** – Main environment that holds all game components  
- **GameManager** – Handles overall game state and game loop  
- **GameWorldLayer** – Contains all physical entities such as player and enemies  
- **UI Layer** – Displays menus, HUD elements, and player information  
- **AudioManager** – Manages music and sound effects  
- **EffectSpawner** – Handles visual effects and feedback for gameplay events  

This modular design helps keep the project scalable and easier to maintain.

---

## 🧩 Gameplay Systems

ThreatBuster uses a component-based structure to manage different game mechanics.

### 👤 Player System
The **Player** and **ScoreManager** track player data such as:

- Username
- Score
- Health
- Game progress

### 👾 Enemy & Wave System
The **WaveManager** and **EnemyContainer** control enemy spawning and wave progression.

Players encounter threats such as:

- 🦠 Virus  
- 🎣 Phishing  
- 💻 Malware  

Each wave increases in difficulty to challenge the player’s ability to respond correctly.

### 👑 Boss System
Special boss enemies appear during key stages of the game.

Example:
- **Virus Boss**
- Higher health and stronger attack power
- Requires better strategy and faster decision making

### 🤖 Adaptive Learning System
An experimental **Machine Learning component** tracks player behavior such as:

- Selected defenses
- Weapon usage
- Success rate against threats

This system can dynamically adjust difficulty and personalize the learning experience.

---

## 🎮 User Interface

The interface is designed to be simple and intuitive.

### Main Menu
Players can:
- Start the game
- Exit the application

### HUD (Heads-Up Display)
Displays important information such as:

- Current wave
- Boss alerts
- Player status

### Pause Menu
Players can:
- Resume
- Restart
- Quit the session

### Game Over Screen
Allows players to restart the game and try again, encouraging replayability.

---

## 🚀 Getting Started

Clone the repository:

```bash
git clone https://github.com/Kazureee/ThreatBuster.git
cd ThreatBuster
