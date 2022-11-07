# Godot VR apple thinning project

Godot VR project to simulate apple thinning process. 

![Game Scene Screenshot](https://github.com/uc-vision/apple-thinning/blob/main/apple-thinning_27042022.png)

## Running this project

The project is built on Godot game engine v3.4 with GLES2. It is designed to be played on Oculus Quest 2. The following plugins are required to be installed in under `addons` folder:

- [Godot Open VR](https://github.com/GodotVR/godot_openvr)
- [Godot Oculus Mobile Asset](https://github.com/GodotVR/godot-oculus-mobile-asset)
- [Godot XR Tools](https://github.com/GodotVR/godot-xr-tools) 

## Design Decision

#### Apple thinning in the real world

According to [How to thin Apples](https://www.youtube.com/watch?v=5f4QxlYihnw&ab_channel=HuwRichards), the key points of apple thinning are:

- Leave not more than 2 apples on each cluster
- Each cluster should be apart for 10 to 15 cm
- Leave apples that are large and healthy, in other words, pick damaged, diseased, or small apples
- When picking apples, lift the apple up against the gravity. Never twist or pull hard downwards, otherwise the whole cluster may fall

#### The goal of the MVP

To simulate and quantify good apple thinning process, the game can have functionalities:

- Apple trees have clustered apples of different size and condition
- The apples are interactable. When a hand gets close to an apple, the apple will be highlighted and the player can grab it.  
- The apple can be thinned by pulling upward when holding. If pulled down, the whole cluster will fall or some damage may happen. 
- The score can be shown as a money. 
- The players can teleport to travel around the apple tree field. It should also support locomotion. 
- The world has skybox, grass field, and trees. Audio of successful thinning maybe a good feedback to the players.

## Resources

#### Textures

- Grass, ground, and rock texture: https://ambientcg.com/ (CC0 license)
- Skybox: https://polyhaven.com/ (CC0 license)

#### Audio

- `apple-branch-hit-sound.wav`: https://freesound.org/people/ArrowheadProductions/sounds/566685/
- `apple-cluster-falling-sound.wav`: https://freesound.org/people/waveplaySFX/sounds/399933/
- `apple-cluster-thinned-sound.wav`: https://freesound.org/people/Kenneth_Cooney/sounds/463067/  
- `apple-tree-thinned-sound.wav`: https://freesound.org/people/Kenneth_Cooney/sounds/457547/
- `poor-apple-thinning-sound.wav`: https://freesound.org/people/Isaac200000/sounds/188013/
- `dialog-pop-up-sound.wav`, `platform-up-sound.wav`, `platform-down-sound.wav`, `button-press-sound.wav`: https://pixabay.com/sound-effects/game-ui-sounds-14857/
- `game-play-bgm.wav`: https://pixabay.com/music/upbeat-happy-funny-kids-111912/
- `training-game-bgm.wav`: https://pixabay.com/music/beautiful-plays-cinematic-documentary-115669/
- `ready-voice.wav`, `set-voice.wav`, `go-voice.wav`: https://freesound.org/people/Alivvie/sounds/451271/
- `times-up-whistle.wav`: https://pixabay.com/sound-effects/metal-whistle-6121/

#### Images

- `arrow.png`, `exclamation.png`, `exit.png`, `pause.png`, and `tick.png` icons: https://icons8.com

#### Fonts

- Calistoga: https://fonts.google.com/share?selection.family=Calistoga
