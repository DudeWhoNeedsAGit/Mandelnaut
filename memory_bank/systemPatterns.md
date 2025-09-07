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

# Development & Testing Approach

## Development Methodology
- **Iterative Unity Development**: 1-2 week sprints focusing on gameplay loop tasks
- **Vertical Slicing**: Complete end-to-end features rather than horizontal layers
- **Frequent Playtesting**: Test in Unity Editor after each major implementation
- **Memory Bank Updates**: Document decisions and progress after each sprint

## Version Control Strategy
- **Unity-specific .gitignore**: Exclude Library/, Temp/, and build artifacts
- **Feature Branches**: `feature/GL-01-player-movement`, `feature/GL-04-fractal-generation`
- **Asset Serialization**: Use Force Text mode for better merge conflict resolution
- **Pre-commit Hooks**: Run basic validation before commits

## Testing Strategy

### Multi-Layer Testing Approach

**1. Unit Testing (C# Logic)**
- Test mathematical functions in isolation
- Mock Unity dependencies using Unity Test Framework
- Focus on parameter validation and edge cases

**2. Integration Testing (Unity Components)**
- Test Explorer movement with actual Unity transforms
- Verify shader parameter passing
- Test JSON palette loading and application
- Validate prefab instantiation and component interactions

**3. Performance Testing**
- **GPU Profiling**: Monitor compute shader execution time
- **Frame Rate Testing**: Ensure 60fps target with fractal rendering
- **Memory Usage**: Track texture and buffer allocations
- **LOD Testing**: Performance at different zoom levels

**4. Playtesting & UX Testing**
- **Exploration Flow**: Test fractal navigation intuitiveness
- **Parameter Adjustment**: Verify real-time feedback
- **Viewpoint Saving/Loading**: Test persistence reliability
- **Cross-Platform**: Windows, Linux, potentially WebGL

### Automated Testing Pipeline
- **Unity Test Runner**: For Edit Mode and Play Mode tests
- **CI/CD Integration**: GitHub Actions with Unity builders
- **Performance Benchmarks**: Automated frame rate monitoring
- **Shader Validation**: Compile-time shader checking

## Quality Assurance Process

### Code Quality
- **Code Reviews**: Required for all shader and mathematical code
- **Static Analysis**: Use Unity's built-in code analysis
- **Documentation**: Update memory bank after each implementation
- **Code Standards**: Consistent C# naming and Unity patterns

### Performance Optimization
- **Profiling Workflow**: Unity Profiler for CPU/GPU bottlenecks
- **Optimization Targets**:
  - Fractal generation: <16ms per frame
  - Memory usage: <2GB for complex scenes
  - Shader compilation: Fast iteration times
- **Fallback Systems**: Graceful degradation on lower-end hardware

## Recommended Development Tools

### Unity-Specific Tools
- **Unity Profiler**: Performance analysis and optimization
- **Frame Debugger**: Shader and rendering pipeline inspection
- **Test Runner**: Automated testing framework
- **Addressables**: Asset management and loading optimization

### Development Environment
- **IDE**: Visual Studio 2022 with Unity extensions
- **Version Control**: Git with GitHub for collaboration
- **Documentation**: Memory bank system for persistent context
- **Asset Management**: Unity Asset Store integration

## Risk Mitigation

### Technical Risks
- **Mathematical Complexity**: Start with simplified 2D Mandelbrot before 3D
- **GPU Compatibility**: Test on multiple hardware configurations
- **Performance Scaling**: Implement LOD and quality settings early

### Project Risks
- **Scope Creep**: Stick to core gameplay loop tasks
- **Technical Debt**: Regular refactoring sessions
- **Testing Gaps**: Automated tests for critical mathematical functions

## Success Metrics
- **Performance**: Maintain 60fps with complex fractal rendering
- **Stability**: <5 crashes per hour of gameplay
- **Usability**: <5 minute learning curve for basic navigation
- **Code Quality**: >80% test coverage for core mathematical functions

# Unity Package Manager

## Overview
Unity Package Manager (UPM) is Unity's built-in package management system that handles dependencies, versions, and package resolution automatically.

## Key Differences from Python pip
- **No manual installation**: Packages install automatically when opening project
- **No virtual environments**: Unity manages package isolation internally
- **Automatic resolution**: No manual dependency conflict resolution needed
- **Visual management**: Package Manager window in Unity Editor
- **Scoped registries**: Support for private and custom package sources

## Package Structure
```
Packages/
├── manifest.json          # Dependencies and configuration
└── packages-lock.json     # Auto-generated lock file
```

## Essential Packages for Mandelnaut
```json
{
  "dependencies": {
    "com.unity.test-framework": "1.1.33",    // Unit testing framework
    "com.unity.mathematics": "1.2.6",       // High-performance math
    "com.unity.burst": "1.8.4",             // Compiler optimization
    "com.unity.collections": "1.2.4",       // Efficient data structures
    "com.unity.jobs": "0.70.0-preview.7"    // Multithreaded processing
  },
  "scopedRegistries": [],
  "testables": ["com.unity.test-framework"]
}
```

## Makefile Integration
```makefile
# Initialize project with packages
init:
	@echo "🔧 Initializing Unity project with package management..."
	@if [ ! -d "Packages" ]; then mkdir -p Packages; fi
	@if [ ! -f "Packages/manifest.json" ]; then \
		echo '{"dependencies": {...}}' > Packages/manifest.json; \
	fi

# Validate package installation
packages:
	@echo "📦 Validating Unity package installation..."
	@grep '"com\.' Packages/manifest.json | sed 's/.*"com\./   • com./'

# Update packages (requires Unity Editor)
packages-update:
	@echo "⚠️  Package updates require Unity Editor"

# Clean package cache
packages-clean:
	@echo "🧹 Cleaning Unity package cache..."
	@echo "⚠️  Requires Unity Editor: Delete Library/ and Temp/ directories"
```

## Workflow
1. **Setup**: Run `make init` to create package structure
2. **Installation**: Open project in Unity (packages download automatically)
3. **Management**: Use Unity Editor Package Manager window
4. **Updates**: Check for updates in Package Manager UI
5. **Validation**: Run `make packages` to verify configuration

## Benefits for Mandelnaut
- **Test Framework**: Automated testing of mathematical functions
- **Performance**: Burst compilation for fractal generation
- **Mathematics**: Optimized vector/matrix operations
- **Collections**: Efficient 3D data structures for voxels
- **Jobs**: Multithreaded fractal computation

## Best Practices
- Keep manifest.json in version control
- Use specific version numbers for stability
- Test package compatibility before major updates
- Document package purposes in code comments
- Use scoped registries for custom packages
