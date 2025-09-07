#!/bin/bash

# Unity Project Analyzer
# Comprehensive analysis tool for Unity projects with LLM-optimized output

# set -e  # Temporarily disabled for debugging

TARGET_DIR="${1:-.}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🎮 Unity Project Analysis"
echo "========================"

# Colors for output (LLM-friendly with clear indicators)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# LLM Optimization: Structured output markers
SECTION_START="===SECTION_START==="
SECTION_END="===SECTION_END==="
ANALYSIS_START="===ANALYSIS_START==="
ANALYSIS_END="===ANALYSIS_END==="

print_header() {
    echo -e "\n${BLUE}=== $1 ===${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${CYAN}ℹ️  $1${NC}"
}

print_fractal() {
    echo -e "${PURPLE}🌀 $1${NC}"
}

# Change to target directory
if [ "$TARGET_DIR" != "." ]; then
    echo "Analyzing Unity project: $TARGET_DIR"
    cd "$TARGET_DIR" || {
        print_error "Cannot access directory: $TARGET_DIR"
        exit 1
    }
fi

# Function to analyze Unity project structure
analyze_unity_structure() {
    print_header "Unity Project Structure Analysis"

    local project_name=$(basename "$(pwd)")
    echo "Project: $project_name"
    echo ""

    # Check for Unity project markers (flexible detection)
    if [ -f "ProjectSettings/ProjectSettings.asset" ]; then
        print_success "Valid Unity project detected"
    elif [ -d "Assets" ] && [ -d "Assets/Scripts" ]; then
        print_success "Unity project structure detected (scaffolded)"
        echo "   ℹ️  Note: This appears to be a scaffolded Unity project"
        echo "   ℹ️  Full Unity project will be created when opened in Unity Editor"
    else
        print_error "Unity project markers not found"
        return 1
    fi

    # Analyze Assets directory structure
    echo ""
    echo "📁 Assets Directory Structure:"

    if [ -d "Assets" ]; then
        find Assets/ -maxdepth 2 -type d | sort | while read -r dir; do
            local depth=$(echo "$dir" | tr -cd '/' | wc -c)
            local indent=""
            for ((i=1; i<depth; i++)); do
                indent="│   $indent"
            done

            local dirname=$(basename "$dir")

            # Add descriptions for known directories
            case $dirname in
                "Scripts")
                    echo "${indent}├── $dirname/          # C# scripts and logic"
                    ;;
                "Shaders")
                    echo "${indent}├── $dirname/          # Compute and fragment shaders"
                    ;;
                "Materials")
                    echo "${indent}├── $dirname/          # Material assets"
                    ;;
                "Prefabs")
                    echo "${indent}├── $dirname/          # Reusable game objects"
                    ;;
                "Scenes")
                    echo "${indent}├── $dirname/          # Unity scenes"
                    ;;
                "Textures")
                    echo "${indent}├── $dirname/          # Image assets"
                    ;;
                "Palettes")
                    echo "${indent}├── $dirname/          # Color palette configurations"
                    ;;
                "Tests")
                    echo "${indent}├── $dirname/          # Unit and integration tests"
                    ;;
                *)
                    echo "${indent}├── $dirname/"
                    ;;
            esac
        done
    else
        print_error "Assets directory not found"
    fi
}

# Function to analyze core game systems (LLM-optimized)
analyze_core_systems() {
    echo "$SECTION_START CORE_SYSTEMS $SECTION_END"
    print_header "Core Game Systems Analysis"

    echo "🎯 Analyzing core game architecture and systems..."
    echo ""

    # Analyze script organization
    echo "📊 Script Architecture:"
    local script_subdirs=$(find Assets/Scripts/ -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l || echo "0")
    local total_scripts=$(find Assets/Scripts/ -name "*.cs" 2>/dev/null | wc -l || echo "0")

    echo "   • 📁 $script_subdirs script directories found"
    echo "   • 📄 $total_scripts total C# scripts"

    # Check for common Unity patterns
    echo ""
    echo "🔍 Unity Patterns Detected:"

    # MonoBehaviour analysis
    local mb_count=$(find Assets/Scripts/ -name "*.cs" -exec grep -l "MonoBehaviour" {} \; 2>/dev/null | wc -l)
    echo "   • 🎭 $mb_count MonoBehaviour classes"

    # Singleton pattern
    local singleton_count=$(find Assets/Scripts/ -name "*.cs" -exec grep -l "Instance\|instance" {} \; 2>/dev/null | wc -l)
    echo "   • 🔄 $singleton_count potential singleton patterns"

    # Event system usage
    local event_count=$(find Assets/Scripts/ -name "*.cs" -exec grep -l "UnityEvent\|AddListener\|RemoveListener" {} \; 2>/dev/null | wc -l)
    echo "   • 📡 $event_count event-driven components"

    # Coroutine usage
    local coroutine_count=$(find Assets/Scripts/ -name "*.cs" -exec grep -l "IEnumerator\|StartCoroutine" {} \; 2>/dev/null | wc -l)
    echo "   • 🔄 $coroutine_count coroutine implementations"

    echo "$SECTION_END"
}

# Function to analyze gameplay systems (LLM-optimized)
analyze_gameplay_systems() {
    echo "$SECTION_START GAMEPLAY_SYSTEMS $SECTION_END"
    print_header "Gameplay Systems Analysis"

    echo "🎮 Analyzing gameplay mechanics and player interaction systems..."
    echo ""

    # Analyze input systems
    echo "🎯 Input Systems:"
    local input_count=$(find Assets/Scripts/ -name "*.cs" -exec grep -l "Input\.Get\|InputSystem\|KeyCode" {} \; 2>/dev/null | wc -l)
    echo "   • 🎮 $input_count input handling components"

    # Analyze physics systems
    echo ""
    echo "⚙️  Physics Systems:"
    local physics_count=$(find Assets/Scripts/ -name "*.cs" -exec grep -l "Rigidbody\|Collider\|Physics\." {} \; 2>/dev/null | wc -l)
    echo "   • 🔧 $physics_count physics-based components"

    # Analyze UI systems
    echo ""
    echo "🖥️  UI Systems:"
    local ui_count=$(find Assets/Scripts/ -name "*.cs" -exec grep -l "UnityEngine\.UI\|TextMeshPro\|Canvas" {} \; 2>/dev/null | wc -l)
    echo "   • 📱 $ui_count UI management components"

    # Analyze save/load systems
    echo ""
    echo "💾 Persistence Systems:"
    local save_count=$(find Assets/Scripts/ -name "*.cs" -exec grep -l "PlayerPrefs\|JsonUtility\|BinaryFormatter" {} \; 2>/dev/null | wc -l)
    echo "   • 💾 $save_count data persistence components"

    echo "$SECTION_END"
}

# Function to analyze rendering system
analyze_rendering_system() {
    print_header "Rendering & Shader System"

    echo "🎨 Analyzing rendering pipeline..."

    # Check for Renderer script
    if [ -f "Assets/Scripts/Rendering/Renderer.cs" ]; then
        print_success "Renderer.cs found"

        # Check for rendering methods
        if grep -q "Render(" "Assets/Scripts/Rendering/Renderer.cs"; then
            echo "   • ✅ Render method implemented"
        else
            echo "   • ❌ Render method missing"
        fi

        # Check for palette application
        if grep -q "ApplyPalette(" "Assets/Scripts/Rendering/Renderer.cs"; then
            echo "   • ✅ Palette system implemented"
        else
            echo "   • ❌ Palette application missing"
        fi
    else
        print_error "Renderer.cs not found"
    fi

    # Analyze shader files
    echo ""
    echo "🔍 Shader Analysis:"
    find Assets/Shaders/ -name "*.compute" -o -name "*.shader" 2>/dev/null | while read -r shader; do
        if [ -f "$shader" ]; then
            local shader_name=$(basename "$shader")
            local line_count=$(wc -l < "$shader")
            echo "   📄 $shader_name (${line_count} lines)"

            # Check for kernel functions
            if grep -q "#pragma kernel" "$shader"; then
                echo "      • ✅ Compute kernel defined"
            fi

            # Check for shader parameters
            if grep -q "RWTexture\|Texture" "$shader"; then
                echo "      • ✅ Texture bindings found"
            fi
        fi
    done
}

# Function to analyze color palette system
analyze_palette_system() {
    print_header "Color Palette System"

    echo "🎨 Analyzing color palette configuration..."

    # Check for palette directory
    if [ -d "Assets/Palettes" ]; then
        print_success "Palettes directory found"

        # Analyze palette files
        find Assets/Palettes/ -name "*.json" 2>/dev/null | while read -r palette; do
            if [ -f "$palette" ]; then
                local palette_name=$(basename "$palette")
                echo "   📄 $palette_name"

                # Validate JSON structure
                if grep -q '"name"' "$palette" && grep -q '"colors"' "$palette"; then
                    echo "      • ✅ Valid palette structure"
                else
                    echo "      • ❌ Invalid palette structure"
                fi

                # Count colors
                local color_count=$(grep -o '"#[0-9A-Fa-f]\{6\}"' "$palette" | wc -l)
                echo "      • 🎨 $color_count colors defined"
            fi
        done
    else
        print_warning "Palettes directory not found"
    fi
}

# Function to analyze testing setup
analyze_testing_setup() {
    print_header "Testing Infrastructure"

    echo "🧪 Analyzing test framework setup..."

    # Check for test directory
    if [ -d "Assets/Tests" ]; then
        print_success "Tests directory found"

        # Analyze test files
        find Assets/Tests/ -name "*.cs" 2>/dev/null | while read -r test_file; do
            if [ -f "$test_file" ]; then
                local test_name=$(basename "$test_file")
                echo "   📄 $test_name"

                # Check for test methods
                local test_count=$(grep -c "\[Test\]\|\[UnityTest\]" "$test_file")
                echo "      • 🧪 $test_count test methods found"

                # Check for test fixtures
                if grep -q "\[TestFixture\]" "$test_file"; then
                    echo "      • ✅ Test fixture configured"
                fi
            fi
        done
    else
        print_warning "Tests directory not found"
    fi

    # Check for Unity Test Framework references
    local test_refs=0
    find Assets/Scripts/ -name "*.cs" 2>/dev/null | xargs grep -l "UnityEngine.TestTools\|NUnit" 2>/dev/null | while read -r file; do
        echo "   📋 Test framework reference in: $(basename "$file")"
        ((test_refs++))
    done

    if [ $test_refs -eq 0 ]; then
        print_info "No Unity Test Framework references found"
    fi
}

# Function to analyze Unity project settings
analyze_unity_settings() {
    print_header "Unity Project Configuration"

    echo "⚙️  Analyzing Unity project settings..."

    # Check ProjectSettings
    if [ -d "ProjectSettings" ]; then
        print_success "ProjectSettings directory found"

        # Check for key settings files
        local settings_files=("ProjectSettings.asset" "ProjectVersion.txt" "GraphicsSettings.asset" "QualitySettings.asset")
        for setting_file in "${settings_files[@]}"; do
            if [ -f "ProjectSettings/$setting_file" ]; then
                echo "   • ✅ $setting_file present"
            else
                echo "   • ⚠️  $setting_file missing"
            fi
        done
    else
        print_error "ProjectSettings directory not found"
    fi

    # Check for Packages directory
    if [ -d "Packages" ]; then
        print_success "Packages directory found"

        # Check for manifest
        if [ -f "Packages/manifest.json" ]; then
            print_success "Unity Package Manager manifest found"
        else
            print_warning "Package manifest missing"
        fi
    else
        print_info "Packages directory not found (using built-in packages)"
    fi
}

# Function to analyze performance considerations
analyze_performance_factors() {
    print_header "Performance Analysis"

    echo "⚡ Analyzing performance-critical components..."

    # Check for compute shader optimization
    local compute_shaders=$(find Assets/Shaders/ -name "*.compute" 2>/dev/null | wc -l)
    if [ $compute_shaders -gt 0 ]; then
        print_success "$compute_shaders compute shaders found"
        echo "   • GPU acceleration available for fractal generation"
    else
        print_warning "No compute shaders found"
    fi

    # Check script optimization
    echo ""
    echo "🔧 Script Performance Analysis:"

    find Assets/Scripts/ -name "*.cs" 2>/dev/null | while read -r script; do
        if [ -f "$script" ]; then
            local script_name=$(basename "$script")
            local line_count=$(wc -l < "$script")

            # Performance warnings
            if [ $line_count -gt 1000 ]; then
                echo "   ⚠️  $script_name is large (${line_count} lines) - consider splitting"
            fi

            # Check for Update() method usage
            if grep -q "void Update()" "$script"; then
                echo "   📊 $script_name uses Update() - monitor performance"
            fi

            # Check for coroutines
            if grep -q "IEnumerator\|StartCoroutine" "$script"; then
                echo "   🔄 $script_name uses coroutines"
            fi
        fi
    done
}

# Function to analyze memory bank integration
analyze_memory_bank() {
    print_header "Memory Bank Integration"

    echo "🧠 Analyzing memory bank documentation..."

    # Check for memory bank directory
    if [ -d "memory_bank" ]; then
        print_success "Memory bank directory found"

        # Check for key documentation files
        local mb_files=("projectbrief.md" "techContext.md" "activeContext.md" "progress.md" "systemPatterns.md")
        for mb_file in "${mb_files[@]}"; do
            if [ -f "memory_bank/$mb_file" ]; then
                echo "   • ✅ $mb_file present"
            else
                echo "   • ⚠️  $mb_file missing"
            fi
        done

        # Count total documentation files
        local doc_count=$(find memory_bank/ -name "*.md" 2>/dev/null | wc -l)
        echo ""
        echo "📚 Total documentation files: $doc_count"

    else
        print_warning "Memory bank directory not found"
    fi
}

# Function to provide Unity optimization recommendations (LLM-optimized)
unity_optimization_recommendations() {
    echo "$SECTION_START OPTIMIZATION_RECOMMENDATIONS $SECTION_END"
    print_header "Unity Development Recommendations"

    echo "🚀 General Unity project optimization suggestions:"
    echo ""

    # Performance recommendations
    echo "⚡ Performance Optimizations:"
    echo "   • Use object pooling for frequently instantiated objects"
    echo "   • Implement LOD (Level of Detail) for distant objects"
    echo "   • Cache component references in Awake()/Start()"
    echo "   • Use FixedUpdate() only for physics operations"
    echo "   • Profile with Unity Profiler regularly"

    echo ""
    echo "🔧 Code Quality:"
    echo "   • Follow Unity coding best practices"
    echo "   • Use Unity's serialization system effectively"
    echo "   • Implement proper error handling"
    echo "   • Document public methods and properties"
    echo "   • Use UnityEvents for component communication"

    echo ""
    echo "🧪 Testing Strategy:"
    echo "   • Write unit tests for pure C# logic"
    echo "   • Use UnityTest for coroutine and time-based tests"
    echo "   • Test prefab instantiations and destructions"
    echo "   • Validate scene loading and transitions"
    echo "   • Test input handling across different devices"

    echo ""
    echo "📦 Build Optimization:"
    echo "   • Use Unity Addressables for asset management"
    echo "   • Implement proper build pipelines"
    echo "   • Optimize texture compression settings"
    echo "   • Configure quality settings appropriately"
    echo "   • Test on target platforms regularly"

    echo ""
    echo "🎯 Development Workflow:"
    echo "   • Use version control with Unity-specific .gitignore"
    echo "   • Set up automated builds with Unity Cloud Build"
    echo "   • Implement continuous integration for testing"
    echo "   • Document architecture decisions"
    echo "   • Plan for multiple platform deployment"

    echo "$SECTION_END"
}

# Function to analyze project health (LLM-optimized)
project_health_check() {
    echo "$SECTION_START PROJECT_HEALTH $SECTION_END"
    print_header "Project Health Assessment"

    local health_score=0
    local total_checks=0

    # Unity project structure check (flexible for scaffolded projects)
    ((total_checks++))
    if [ -f "ProjectSettings/ProjectSettings.asset" ] && [ -d "Assets" ]; then
        print_success "Valid Unity project structure"
        ((health_score++))
    elif [ -d "Assets" ] && [ -d "Assets/Scripts" ] && [ "$(find Assets/ -name "*.cs" 2>/dev/null | wc -l)" -gt 0 ]; then
        print_success "Valid scaffolded Unity project structure"
        ((health_score++))
    else
        print_error "Invalid Unity project structure"
    fi

    # Script organization check
    ((total_checks++))
    local script_count=$(find Assets/Scripts/ -name "*.cs" 2>/dev/null | wc -l)
    if [ $script_count -gt 0 ]; then
        print_success "Scripts directory populated ($script_count files)"
        ((health_score++))
    else
        print_warning "No C# scripts found"
    fi

    # Testing check
    ((total_checks++))
    if [ -d "Assets/Tests" ] && [ "$(find Assets/Tests/ -name "*.cs" 2>/dev/null | wc -l)" -gt 0 ]; then
        print_success "Testing framework established"
        ((health_score++))
    else
        print_warning "Testing framework not established"
    fi

    # Documentation check
    ((total_checks++))
    if [ -d "memory_bank" ] && [ "$(find memory_bank/ -name "*.md" 2>/dev/null | wc -l)" -gt 3 ]; then
        print_success "Documentation well-established"
        ((health_score++))
    else
        print_warning "Documentation incomplete"
    fi

    # Calculate health percentage
    local health_percent=$((health_score * 100 / total_checks))

    echo ""
    echo "🏥 Project Health Score: $health_score/$total_checks ($health_percent%)"

    if [ $health_percent -ge 80 ]; then
        print_success "Project health is excellent!"
    elif [ $health_percent -ge 60 ]; then
        print_info "Project health is good, minor improvements needed"
    else
        print_warning "Project health needs attention"
    fi

    echo "$SECTION_END"
}

# Main execution with LLM-optimized output
echo "$ANALYSIS_START"
echo "Project: $(basename "$(pwd)")"
echo "Analysis Date: $(date)"
echo "Analysis Tool: Unity Project Analyzer v1.0"
echo "Optimization: LLM-Ready Output Format"
echo ""

analyze_unity_structure

echo "$SECTION_START RENDERING_SYSTEM $SECTION_END"
analyze_rendering_system
echo "$SECTION_END"

echo "$SECTION_START PALETTE_SYSTEM $SECTION_END"
analyze_palette_system
echo "$SECTION_END"

echo "$SECTION_START TESTING_INFRA $SECTION_END"
analyze_testing_setup
echo "$SECTION_END"

echo "$SECTION_START UNITY_CONFIG $SECTION_END"
analyze_unity_settings
echo "$SECTION_END"

echo "$SECTION_START PERFORMANCE $SECTION_END"
analyze_performance_factors
echo "$SECTION_END"

echo "$SECTION_START MEMORY_BANK $SECTION_END"
analyze_memory_bank
echo "$SECTION_END"

analyze_core_systems
analyze_gameplay_systems
project_health_check
unity_optimization_recommendations

print_header "Analysis Complete"
echo "🎮 Unity project analysis finished."
echo "Use this information to guide development and optimization efforts."
echo "$ANALYSIS_END"
