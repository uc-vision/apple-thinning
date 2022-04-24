# Godot VR apple thinning project

Godot VR project to simulate apple thinning process. 

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

Apple mesh: https://www.cgtrader.com/free-3d-models/food/fruit/low-poly-apples