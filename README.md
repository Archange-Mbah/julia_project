# README-Projekt 📖
Name: Mbah Tchategouang\
Vorname: Archange\
Matrikelnummer: 5451016

Name: Djomkam Moukam \
Vorname:Manuela
Matrikelnummer:5032714


##  🐍 SnakeGame (Revised Edition) 🐍

Inhaltsübersicht:
1. Präsentation und Beschreibung
2. Starten des Programms
3. Ein biscchen über die Hauptklassen
4. Start des Spiels in Jshell
5. Verwendete Bibliotheken

## Präsentation und Bechreibung.

Ein Snake-Spiel ist ein unterhaltsames Spiel, bei dem der Spieler eine Schlange steuert.
Die Schlange bewegt sich geschmeidig über den Bildschirm und kann ihre Länge vergrößern, indem sie Krebstiere (Good Food) frisst.
Dadurch erhöht sich der Score des Spielers. Andererseits nimmt die Länge der Schlange ab, und der Score verringert sich, wenn die Schlange schlechtes Essen (Bad Food) konsumiert.
Der Spieler hat die Herausforderung, die Schlange so zu steuern, dass sie das schlechte Essen vermeidet, aber gleichzeitig versucht, die maximale Punktzahl zu erreichen,
bevor der Countdown abläuft. 
Die Steuerung des Spiels erfolgt intuitiv über die Pfeiltasten auf der Tastatur, wodurch der Spieler die Schlange nach oben, unten, links und rechts lenken kann. 
Es erfordert Geschicklichkeit und Strategie, um die Schlange geschickt zu steuern und den Score zu maximieren, während man gleichzeitig die Gefahr des schlechten Essens meidet.

#### wann ist das Spiel zum Ende 
- Wenn die Schlange sich selbst isst.
- Wenn der Countdown abläuft, ohne dass der Spieler die maximale Punktzahl erreicht hat.
- Wenn der Spieler schlechtes Essen (Bad Food) isst, bis der Score negativ wird.
Viel Spaß beim Spielen!

##  🛫 Starten des Programms ins Terminal
 - Ausführen von Julia/Game/SnakeGame
 - Dann Julia eingeben
 - julia> using GameZero (falls das Packet noch nicht vorhanden ist, bitte installieren)
 - julia> rungame("snake.jl")