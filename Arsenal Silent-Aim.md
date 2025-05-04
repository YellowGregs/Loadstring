if you want to use the silent aim for you arsenal script here:


```lua
local silentAim = loadstring(game:HttpGet("https://raw.githubusercontent.com/YellowGregs/Loadstring/refs/heads/main/Arsenal_Silent-Aim.luau"))()
```

---


| Setting                 | Default               | Description                                               |
| ----------------------- | --------------------- | --------------------------------------------------------- |
| `Enabled`               | `false`               | Turns silent aim on or off.                               |
| `TeamCheck`             | `false`               | If true, it won’t target people on your team.             |
| `WallCheck`             | `false`               | Checks if there’s a wall between you and the target.      |
| `UseRandomPart`         | `false`               | Picks a random body part from the list to aim at.         |
| `BodyParts`             | `{ "Head" }`          | Parts it’ll aim for — can be `"Head"`, `"Torso"`, etc.    |
| `Prediction.Enabled`    | `false`               | Helps lead shots if the target is moving.                 |
| `Prediction.Amount`     | `0.145`               | How much to lead the target by (based on their velocity). |
| `Fov`                   | `1000`                | Size of the silent aim FOV circle on your screen.         |
| `FovSettings.Visible`   | `false`               | Show or hide the FOV circle.                              |
| `FovSettings.Color`     | `Color3.new(1, 0, 0)` | Color of the FOV circle.                                  |
| `FovSettings.Thickness` | `2`                   | How thick the circle outline is.                          |
| `FovSettings.Filled`    | `false`               | If true, the circle is filled instead of just outlined.   |

---

You can now turn it on by setting it up like this `silentAim.Enabled = true`.
