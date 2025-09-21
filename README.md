# Week 3 Activity

## What Was Done
1. **MultiUV shader**  
  Wrote shader that takes multiple UV maps, allowing for complicated visual effects. This involved understanding and copying HLSL code to blend/lerp textures based on different UV coordinates.

2. **WorldPos shader**  
  Wrote shader that calculates and outputs the color of a fragment based on the world position of the frag.

3. **Reflection sader**  
  Wrote shader to simulate reflections on materials, using cubemaps to give objects the appearance of reflecting their surroundings. This involved working with cubemaps.

4. **ViewDir shader**  
  Implemented a shader that calculates the view direction relative to the camera. Not exactly sure what this one does or how it’s useful, still working on that.

---

## Strengths
1. **Writing HLSL code**  
  I think I understand the basic HLSL syntax, since it’s really similar to C/C++. Built-in functions like sin are super useful since they’re extremely optimized and low level.

2. **Understanding compiler preprocessor macros**  
  What I was able to gather is `#pragma` directive works in HLSL to define and conditionally compile stuff, which further optimizes shaders at compile time
---
## Weaknesses
- **Understanding Properties syntax**  
  Had some difficulty with the syntax used for shader properties in Unity, particularly in how to expose parameters like textures or floats to the shader from the Unity editor.

- **Using cubemaps in Unity**  
  No idea how cubemaps work. As I understand them now, it’s just a collection of 6 images which forms a square skybox. Not sure why that needs to be its own type/object

- **Understanding ViewDir shader**  
  Had some confusion about the functionality of the ViewDir shader. It just looks white to me, even after I tried pasting exactly what was written on the board.

## Opportunities
- **Researching how cubemaps work in Unity**  
  I’m pretty sure cubemaps are a legacy object and are technically deprecated, which is interesting to me.

## Screenshot
<img width="2242" height="1286" alt="homers" src="https://github.com/user-attachments/assets/244ba6fb-66ec-455f-81ee-3646870d60e0" />
