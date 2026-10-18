# Examples

One folder per TV model, each with a `debloat.txt` listing the packages that are safe to disable
on that firmware, grouped and commented. These are starting points: comment out anything you use.

| Folder | TV | OS | Notes |
|---|---|---|---|
| `xiaomi-mitv-axso0/` | Xiaomi Mi TV (MiTV-AXSO0, dangal) | Android TV 9 | PatchWall, Mi analytics; MiLink, Cast and Miracast kept |
| `xiaomi-mi-tv-4a/` | Xiaomi Mi TV 4A (MiTV-MOOQ1) | Android TV 10 | PatchWall, Mi analytics, SmartShare, MiLink |

To add a TV, see the original repo, [Gathin23/tv-vibehack](https://github.com/Gathin23/tv-vibehack). The quickest way to get a list is to
run the prompt in [PROMPT.md](../PROMPT.md) and copy the packages your assistant disabled.
