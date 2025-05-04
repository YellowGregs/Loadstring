if you want to use the silent aim for you arsenal script here:

```lua
local silentAim = {
    Enabled       = false,
    TeamCheck     = false,
    WallCheck     = false,
    UseRandomPart = false,
    BodyParts     = { "Head" },
    Prediction    = { Enabled = false, Amount = 0.145 },
    Fov           = 1000,
    FovSettings   = {
        Visible   = false,
        Color     = Color3.new(1, 0, 0),
        Thickness = 2,
        Filled    = false
    }
}
```

---

| Setting                 | Default               | What It Does                                             |
| ----------------------- | --------------------- | -------------------------------------------------------- |
| `Enabled`               | `false`               | Turns silent aim on or off.                              |
| `TeamCheck`             | `false`               | Ignores teammates.                                       |
| `WallCheck`             | `false`               | Checks if the target is behind a wall.                   |
| `UseRandomPart`         | `false`               | Picks a random body part from the list to aim at.        |
| `BodyParts`             | `{ "Head" }`          | Parts you want to aim for (like "Head" or "Torso").      |
| `Prediction.Enabled`    | `false`               | Helps hit moving targets by predicting where they'll go. |
| `Prediction.Amount`     | `0.145`               | How much prediction is used (higher = more lead).        |
| `Fov`                   | `1000`                | Radius of the silent aim circle on your screen           |
| `FovSettings.Visible`   | `false`               | Shows or hides the silent aim circle.                    |
| `FovSettings.Color`     | `Color3.new(1, 0, 0)` | Color of the circle.                                     |
| `FovSettings.Thickness` | `2`                   | How thick the circle outline is.                         |
| `FovSettings.Filled`    | `false`               | Fill the circle or just draw the outline.                |
