# oneko.gd

A very silly and simple port of [github.com/](https://github.com/adryd325/oneko.js)](oneko.js) to GDScript.
All I really did was copy and paste the JavaScript code and change it to Godot's syntax and functions.
I have a very high suspicion that some aspects of this program may not behave like the original script,
so if you find out why, please report it as an [issue](https://www.github.com/JaegerwaldDev/OnekoGD/issues)!

## Known issues, that I couldn't manage to fix

1. The window is actually 64x64 in size, which causes the cat to have a margin, and not fully go to the edge
of windows. I tried setting it in the project settings, and in the script, but I couldn't figure it out.
The intended size is 32x32 (same size as the sprite).

2. I am not sure if I could describe this as an issue, but I don't think the border scratch animations are
ever able to play, the code is the same as the original, so it might work, if it does, please let me know!

3. Something's off about the animation timers and random functions. I don't know what, but it just doesn't
feel _exactly_ like the original. I might be crazy, but I don't think the original has flashing
animations like this one.
