# Godot Interactive Comic Plugin

## Page.tscn

- Contains a number of Panels (Panel.tscn) and an animation player. 
- In the animation player you can animate the position and opacity of panels. 
- You can create an animation for each transition naming them "1", "2", "3", etc..
- Any other name (e.g: "_1") will be ignored an can be used to disable a transition without eliminating it
- There will be a button to automatically add a new transition with the correct name
- next() will play the first transition, then subsequent calls will be passed to the panel(internal panel transitions) until the panel reaches the end of it's internal transitions. At than point the next page-level transition is played
- previous() will do the reverse

## Panel.tscn

- 