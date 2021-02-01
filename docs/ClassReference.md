# Godot Interactive Comic Plugin

## Page.tscn

- Contains a number of Panels (Panel.tscn) and an animation player. 
- In the animation player you can animate the position and opacity of panels. 
- Each transition ends at round second intervals. E.g: if the animation is set to last 5 seconds it will transition to 1, 2, 3, 4 and 5
- You can set up the transition speed by keying transition_lenght
- There will be a button to automatically add a new transition with the correct name
- next() will play the first transition, then subsequent calls will be passed to the panel(internal panel transitions) until the panel reaches the end of it's internal transitions. At than point the next page-level transition is played
- previous() will do the reverse

## Panel.tscn

- 