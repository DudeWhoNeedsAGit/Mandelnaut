Mandelnaut/
│
├─ Assets/
│   ├─ Scripts/
│   │   ├─ Engine/             # Fractal generation scripts
│   │   │   └─ FractalGenerator.cs
│   │   ├─ Gameplay/           # Player navigation & exploration
│   │   │   └─ Explorer.cs
│   │   ├─ Rendering/          # Procedural rendering & shader management
│   │   │   └─ Renderer.cs
│   │   └─ Utils/              # Math helpers, input, logging
│   │       └─ MathUtils.cs
│   │
│   ├─ Shaders/                # Compute or raymarch shaders
│   │   ├─ MandelbrotRaymarch.compute
│   │   └─ MandelbrotVoxel.compute
│   │
│   ├─ Materials/              # Materials using the shaders
│   │   └─ MandelbrotMaterial.mat
│   │
│   └─ Prefabs/                # Camera, player prefab
│       └─ Explorer.prefab
│
├─ ProjectSettings/             # Unity settings
├─ Packages/                    # Unity packages
├─ README.md
└─ Main.unity                   # Scene entry point
