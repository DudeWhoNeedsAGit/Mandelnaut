# Master Cline YAML for Mandelnaut 3D Unity Game
project_name: Mandelbrot3D_Unity
instructions:

# =========================
# 1. Folder Structure
# =========================
- action: create_folder
  path: Assets/Scripts/Engine
- action: create_folder
  path: Assets/Scripts/Gameplay
- action: create_folder
  path: Assets/Scripts/Rendering
- action: create_folder
  path: Assets/Scripts/Utils
- action: create_folder
  path: Assets/Shaders
- action: create_folder
  path: Assets/Materials
- action: create_folder
  path: Assets/Prefabs
- action: create_folder
  path: Assets/Textures
- action: create_folder
  path: Assets/Palettes
- action: create_folder
  path: Assets/Scenes
- action: create_folder
  path: Assets/Tests

# =========================
# 2. Engine Scripts
# =========================
- action: create_file
  path: Assets/Scripts/Engine/FractalGenerator.cs
  content: |
    public class FractalGenerator {
        public void Generate(string mode="raymarch", float power=2, int maxIterations=512, float bailout=4.0f) {
            // TODO: implement 3D Mandelbrot generation
        }
    }

# =========================
# 3. Gameplay Scripts
# =========================
- action: create_file
  path: Assets/Scripts/Gameplay/Explorer.cs
  content: |
    using UnityEngine;
    public class Explorer : MonoBehaviour {
        public void Move(Vector3 direction, float speed) { }
        public void Rotate(Vector3 eulerAngles) { }
        public void Zoom(float factor) { }
        public void AdjustParameters(float power, int iterations, string palette) { }
        public void SaveViewpoint(string name) { }
        public void LoadViewpoint(string name) { }
        public void Interact() { }
    }

- action: create_file
  path: Assets/Scripts/Gameplay/GameTracker.cs
  content: |
    public class GameTracker {
        public void LogDiscovery(string description) { }
    }

# =========================
# 4. Rendering Scripts
# =========================
- action: create_file
  path: Assets/Scripts/Rendering/Renderer.cs
  content: |
    public class Renderer {
        public void Render() { }
        public void ApplyPalette(string paletteName) { }
    }

# =========================
# 5. Utility Scripts
# =========================
- action: create_file
  path: Assets/Scripts/Utils/MathUtils.cs
  content: |
    using UnityEngine;
    public static class MathUtils {
        public static float Clamp(float value, float min, float max) {
            return Mathf.Clamp(value, min, max);
        }
    }

# =========================
# 6. Shaders
# =========================
- action: create_file
  path: Assets/Shaders/MandelbrotRaymarch.compute
  content: "// TODO: implement raymarch compute shader for 3D Mandelbrot"
- action: create_file
  path: Assets/Shaders/MandelbrotVoxel.compute
  content: "// TODO: implement voxel-based compute shader for 3D Mandelbrot"

# =========================
# 7. Materials & Prefabs
# =========================
- action: create_file
  path: Assets/Materials/MandelbrotMaterial.mat
  content: "// TODO: link compute shader to material"
- action: create_file
  path: Assets/Prefabs/Explorer.prefab
  content: "// TODO: prefab with camera and Explorer component"

# =========================
# 8. Scene
# =========================
- action: create_file
  path: Assets/Scenes/Main.unity
  content: "// TODO: main scene with camera, light, Explorer prefab"

# =========================
# 9. Example Palette
# =========================
- action: create_file
  path: Assets/Palettes/DefaultPalette.json
  content: |
    {
      "name": "Default",
      "colors": ["#FF0000", "#00FF00", "#0000FF"]
    }

# =========================
# 10. Tests
# =========================
- action: create_file
  path: Assets/Tests/TestExplorer.cs
  content: |
    using UnityEngine;
    using UnityEngine.TestTools;
    public class TestExplorer {
        public void TestMove() {
            // TODO: unit test for Explorer.Move
        }
    }

# =========================
# 11. Gameplay Loop Tasks (for tracking)
# =========================
- action: create_task
  task_id: GL-01
  name: Player Movement
  script: Assets/Scripts/Gameplay/Explorer.cs
  method: Move
  description: "Allow player to move in 3D fractal space."
  status: TODO

- action: create_task
  task_id: GL-02
  name: Camera Rotation
  script: Assets/Scripts/Gameplay/Explorer.cs
  method: Rotate
  description: "Rotate player camera using yaw, pitch, and roll."
  status: TODO

- action: create_task
  task_id: GL-03
  name: Zoom / Scale
  script: Assets/Scripts/Gameplay/Explorer.cs
  method: Zoom
  description: "Zoom in/out of fractal to explore structures."
  status: TODO

- action: create_task
  task_id: GL-04
  name: Fractal Generation
  script: Assets/Scripts/Engine/FractalGenerator.cs
  method: Generate
  description: "Generate 3D Mandelbrot fractal using raymarch/voxel."
  status: TODO

- action: create_task
  task_id: GL-05
  name: Fractal Rendering
  script: Assets/Scripts/Rendering/Renderer.cs
  method: Render
  description: "Render fractal using shaders."
  status: TODO

- action: create_task
  task_id: GL-06
  name: Adjust Fractal Parameters
  script: Assets/Scripts/Gameplay/Explorer.cs
  method: AdjustParameters
  description: "Change fractal parameters live (power, iterations, palette)."
  status: TODO

- action: create_task
  task_id: GL-07
  name: Save / Load Viewpoints
  script: Assets/Scripts/Gameplay/Explorer.cs
  method: SaveViewpoint / LoadViewpoint
  description: "Bookmark current positions and parameters."
  status: TODO

- action: create_task
  task_id: GL-08
  name: Apply Color Palette
  script: Assets/Scripts/Rendering/Renderer.cs
  method: ApplyPalette
  description: "Change fractal coloring dynamically."
  status: TODO

- action: create_task
  task_id: GL-09
  name: Interaction / Physics
  script: Assets/Scripts/Gameplay/Explorer.cs
  method: Interact
  description: "Optional collision, particle triggers, or interactions."
  status: TODO

- action: create_task
  task_id: GL-10
  name: Exploration Tracking
  script: Assets/Scripts/Gameplay/GameTracker.cs
  method: LogDiscovery
  description: "Track discoveries, special regions, achievements."
  status: TODO
