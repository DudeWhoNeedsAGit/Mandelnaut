# Mandelnaut Unity Project Makefile
# Comprehensive build and test automation for Unity 3D fractal exploration project

.PHONY: help unit integration test test-results test-log clean-tests build clean setup init packages packages-update packages-clean

# Unity Configuration
UNITY_PATH ?= /Applications/Unity/Hub/Editor/2021.3.16f1/Unity.app/Contents/MacOS/Unity
PROJECT_PATH := $(shell pwd)
TEST_RESULTS := $(PROJECT_PATH)/test-results.xml
TEST_LOG := $(PROJECT_PATH)/unity-test.log
BUILD_PATH := $(PROJECT_PATH)/Builds
BUILD_TARGET := StandaloneWindows64

# Colors for output
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[1;33m
BLUE := \033[0;34m
NC := \033[0m

# Help target
help:
	@echo "$(BLUE)Mandelnaut Unity Project Makefile$(NC)"
	@echo "=================================="
	@echo ""
	@echo "$(YELLOW)Available targets:$(NC)"
	@echo "  $(GREEN)unit$(NC)         - Run unit tests (EditMode) - MandelbulbMath tests"
	@echo "  $(GREEN)integration$(NC)  - Run integration tests (PlayMode)"
	@echo "  $(GREEN)test$(NC)         - Run all tests (unit + integration)"
	@echo "  $(GREEN)test-results$(NC) - Display test results summary"
	@echo "  $(GREEN)test-log$(NC)     - Show detailed test log"
	@echo "  $(GREEN)build$(NC)        - Build project for $(BUILD_TARGET)"
	@echo "  $(GREEN)clean$(NC)       - Clean build artifacts"
	@echo "  $(GREEN)clean-tests$(NC) - Clean test artifacts"
	@echo "  $(GREEN)setup$(NC)       - Setup development environment"
	@echo "  $(GREEN)init$(NC)        - Initialize project with package management"
	@echo "  $(GREEN)packages$(NC)    - Validate package installation"
	@echo "  $(GREEN)packages-update$(NC) - Update Unity packages"
	@echo "  $(GREEN)packages-clean$(NC) - Clean package cache"
	@echo ""
	@echo "$(YELLOW)Configuration:$(NC)"
	@echo "  UNITY_PATH: $(UNITY_PATH)"
	@echo "  PROJECT_PATH: $(PROJECT_PATH)"
	@echo ""
	@echo "$(YELLOW)Usage:$(NC)"
	@echo "  make unit                    # Run unit tests"
	@echo "  make test                    # Run all tests"
	@echo "  make UNITY_PATH=/path/to/unity unit  # Custom Unity path"

# Unit Tests (EditMode) - Our MandelbulbMath tests
unit: check-packages
	@echo "$(BLUE)🧪 Running Unity Unit Tests (EditMode)...$(NC)"
	@echo "Testing: MandelbulbMathTests"
	@echo "Unity Path: $(UNITY_PATH)"
	@echo "Project Path: $(PROJECT_PATH)"
	@echo ""

	@if [ ! -f "$(UNITY_PATH)" ]; then \
		echo "$(RED)❌ Unity not found at: $(UNITY_PATH)$(NC)"; \
		echo "$(YELLOW)💡 Set UNITY_PATH environment variable:$(NC)"; \
		echo "   export UNITY_PATH=/path/to/Unity.app/Contents/MacOS/Unity  # macOS"; \
		echo "   export UNITY_PATH=/path/to/Unity.exe                      # Windows"; \
		echo "   export UNITY_PATH=/path/to/Unity                         # Linux"; \
		exit 1; \
	fi

	@echo "$(YELLOW)Starting Unity test execution...$(NC)"
	@"$(UNITY_PATH)" \
		-batchmode \
		-projectPath "$(PROJECT_PATH)" \
		-runTests \
		-testPlatform EditMode \
		-testResults "$(TEST_RESULTS)" \
		-logFile "$(TEST_LOG)" \
		-testFilter "MandelbulbMathTests" \
		-quit

	@echo ""
	@echo "$(BLUE)Test execution completed.$(NC)"
	$(MAKE) test-results

# Check if packages are installed before running tests
check-packages:
	@echo "$(BLUE)📦 Checking package installation status...$(NC)"

	@if [ ! -d "Library/PackageCache" ] && [ ! -d "Library/ScriptAssemblies" ]; then \
		echo "$(RED)❌ Unity packages not installed!$(NC)"; \
		echo ""; \
		echo "$(YELLOW)💡 Required setup:$(NC)"; \
		echo "   1. Run: $(GREEN)make init$(NC) (if not done already)"; \
		echo "   2. $(YELLOW)Open project in Unity Editor$(NC)"; \
		echo "   3. $(YELLOW)Wait for packages to download & install$(NC)"; \
		echo "   4. $(YELLOW)Close Unity Editor$(NC)"; \
		echo "   5. $(GREEN)Run 'make unit' again$(NC)"; \
		echo ""; \
		echo "$(BLUE)Note: Unity CLI cannot download packages - Unity Editor required$(NC)"; \
		exit 1; \
	fi

	@echo "$(GREEN)✅ Unity packages appear to be installed$(NC)"
	@echo ""

# Integration Tests (PlayMode)
integration: check-packages
	@echo "$(BLUE)🔗 Running Unity Integration Tests (PlayMode)...$(NC)"
	@echo "Unity Path: $(UNITY_PATH)"
	@echo "Project Path: $(PROJECT_PATH)"
	@echo ""

	@if [ ! -f "$(UNITY_PATH)" ]; then \
		echo "$(RED)❌ Unity not found at: $(UNITY_PATH)$(NC)"; \
		exit 1; \
	fi

	@echo "$(YELLOW)Starting integration test execution...$(NC)"
	@"$(UNITY_PATH)" \
		-batchmode \
		-projectPath "$(PROJECT_PATH)" \
		-runTests \
		-testPlatform PlayMode \
		-testResults "$(TEST_RESULTS)" \
		-logFile "$(TEST_LOG)" \
		-quit

	@echo ""
	@echo "$(BLUE)Integration test execution completed.$(NC)"
	$(MAKE) test-results

# Run all tests
test: unit integration

# Parse and display test results
test-results:
	@echo ""
	@echo "$(BLUE)📊 Test Results Summary:$(NC)"
	@echo "=========================="

	@if [ -f "$(TEST_RESULTS)" ]; then \
		total=$$(grep -c "<test-case" $(TEST_RESULTS) 2>/dev/null || echo "0"); \
		passed=$$(grep -c "success=\"true\"" $(TEST_RESULTS) 2>/dev/null || echo "0"); \
		failed=$$(grep -c "success=\"false\"" $(TEST_RESULTS) 2>/dev/null || echo "0"); \
		inconclusive=$$(grep -c "success=\"false\"" $(TEST_RESULTS) 2>/dev/null || echo "0"); \
		\
		echo "📈 $(YELLOW)Total Tests:$(NC) $$total"; \
		echo "✅ $(GREEN)Passed:$(NC) $$passed"; \
		echo "❌ $(RED)Failed:$(NC) $$failed"; \
		\
		if [ "$$failed" -eq "0" ] && [ "$$total" -gt "0" ]; then \
			echo ""; \
			echo "$(GREEN)🎉 All tests passed!$(NC)"; \
			echo "$(BLUE)🌀 Mandelbulb mathematical functions validated.$(NC)"; \
		elif [ "$$total" -eq "0" ]; then \
			echo ""; \
			echo "$(YELLOW)⚠️  No tests found - check test configuration.$(NC)"; \
		else \
			echo ""; \
			echo "$(RED)⚠️  Some tests failed - check $(TEST_RESULTS) for details.$(NC)"; \
			echo "$(YELLOW)💡 Run 'make test-log' for detailed error information.$(NC)"; \
		fi \
	else \
		echo "$(RED)❌ Test results file not found.$(NC)"; \
		echo "$(YELLOW)💡 Run tests first with 'make unit' or 'make test'.$(NC)"; \
	fi

# Show detailed test log
test-log:
	@echo "$(BLUE)📋 Unity Test Execution Log:$(NC)"
	@echo "=============================="

	@if [ -f "$(TEST_LOG)" ]; then \
		echo "$(YELLOW)Test Log Contents:$(NC)"; \
		echo ""; \
		cat "$(TEST_LOG)"; \
	else \
		echo "$(RED)❌ Test log not found.$(NC)"; \
		echo "$(YELLOW)💡 Run tests first with 'make unit' or 'make test'.$(NC)"; \
	fi

# Build project
build:
	@echo "$(BLUE)🔨 Building Unity Project...$(NC)"
	@echo "Target: $(BUILD_TARGET)"
	@echo "Output: $(BUILD_PATH)"
	@echo ""

	@if [ ! -f "$(UNITY_PATH)" ]; then \
		echo "$(RED)❌ Unity not found at: $(UNITY_PATH)$(NC)"; \
		exit 1; \
	fi

	@mkdir -p "$(BUILD_PATH)"

	@echo "$(YELLOW)Starting Unity build...$(NC)"
	@"$(UNITY_PATH)" \
		-batchmode \
		-projectPath "$(PROJECT_PATH)" \
		-buildTarget "$(BUILD_TARGET)" \
		-buildWindows64Player "$(BUILD_PATH)/Mandelnaut.exe" \
		-logFile "$(BUILD_PATH)/build.log" \
		-quit

	@if [ -f "$(BUILD_PATH)/Mandelnaut.exe" ]; then \
		echo ""; \
		echo "$(GREEN)✅ Build completed successfully!$(NC)"; \
		echo "$(BLUE)📁 Build output: $(BUILD_PATH)$(NC)"; \
	else \
		echo ""; \
		echo "$(RED)❌ Build failed.$(NC)"; \
		echo "$(YELLOW)💡 Check $(BUILD_PATH)/build.log for details.$(NC)"; \
	fi

# Clean build artifacts
clean:
	@echo "$(BLUE)🧹 Cleaning build artifacts...$(NC)"
	rm -rf "$(BUILD_PATH)"
	@echo "$(GREEN)✅ Build directory cleaned.$(NC)"

# Clean test artifacts
clean-tests:
	@echo "$(BLUE)🧹 Cleaning test artifacts...$(NC)"
	rm -f "$(TEST_RESULTS)" "$(TEST_LOG)"
	@echo "$(GREEN)✅ Test artifacts cleaned.$(NC)"

# Setup development environment
setup:
	@echo "$(BLUE)🔧 Setting up development environment...$(NC)"
	@echo ""

	@echo "$(YELLOW)Checking Unity installation...$(NC)"
	@if [ -f "$(UNITY_PATH)" ]; then \
		echo "$(GREEN)✅ Unity found at: $(UNITY_PATH)$(NC)"; \
	else \
		echo "$(RED)❌ Unity not found at: $(UNITY_PATH)$(NC)"; \
		echo "$(YELLOW)💡 Install Unity or set UNITY_PATH:$(NC)"; \
		echo "   export UNITY_PATH=/path/to/unity"; \
	fi

	@echo ""
	@echo "$(YELLOW)Checking project structure...$(NC)"
	@if [ -d "Assets" ] && [ -d "Assets/Scripts" ]; then \
		echo "$(GREEN)✅ Unity project structure valid$(NC)"; \
	else \
		echo "$(RED)❌ Invalid Unity project structure$(NC)"; \
	fi

	@echo ""
	@echo "$(YELLOW)Checking test files...$(NC)"
	@if [ -f "Assets/Tests/TestExplorer.cs" ]; then \
		echo "$(GREEN)✅ Test files present$(NC)"; \
	else \
		echo "$(RED)❌ Test files missing$(NC)"; \
	fi

	@echo ""
	@echo "$(YELLOW)Environment setup complete.$(NC)"
	@echo "$(BLUE)🎮 Ready for development and testing!$(NC)"

# Initialize Unity project with package management
init:
	@echo "$(BLUE)🔧 Initializing Unity project with package management...$(NC)"
	@echo ""

	@if [ ! -d "Packages" ]; then \
		mkdir -p Packages; \
		echo "$(GREEN)✅ Created Packages directory$(NC)"; \
	fi

	@if [ ! -f "Packages/manifest.json" ]; then \
		echo '{\n  "dependencies": {\n    "com.unity.test-framework": "1.1.33",\n    "com.unity.mathematics": "1.2.6",\n    "com.unity.burst": "1.8.4",\n    "com.unity.collections": "1.2.4",\n    "com.unity.jobs": "0.70.0-preview.7"\n  },\n  "scopedRegistries": [],\n  "testables": [\n    "com.unity.test-framework"\n  ]\n}' > Packages/manifest.json; \
		echo "$(GREEN)✅ Created manifest.json with essential packages$(NC)"; \
	else \
		echo "$(YELLOW)ℹ️  manifest.json already exists$(NC)"; \
	fi

	@echo ""
	@echo "$(GREEN)🎉 Unity project initialized!$(NC)"
	@echo ""
	@echo "$(YELLOW)📦 What make init accomplished:$(NC)"
	@echo "   ✅ Created Packages/ directory"
	@echo "   ✅ Created manifest.json with essential packages:"
	@echo "      • Unity Test Framework (for unit tests)"
	@echo "      • Unity Mathematics (optimized math operations)"
	@echo "      • Unity Burst (high-performance compilation)"
	@echo "      • Unity Collections (efficient data structures)"
	@echo "      • Unity Jobs (multithreaded processing)"
	@echo "   ✅ Project structure ready for Unity"
	@echo ""
	@echo "$(BLUE)📦 Required next step (manual):$(NC)"
	@echo "   1. $(YELLOW)Open project in Unity Editor$(NC) (first time only)"
	@echo "   2. $(YELLOW)Wait for Unity to download & install packages$(NC)"
	@echo "   3. $(YELLOW)Close Unity Editor$(NC)"
	@echo "   4. $(GREEN)Run 'make unit' for CLI testing$(NC)"
	@echo ""
	@echo "$(BLUE)💡 Note: Unity CLI cannot download packages - Unity Editor required$(NC)"

# Validate package installation
packages:
	@echo "$(BLUE)📦 Validating Unity package installation...$(NC)"
	@echo ""

	@if [ ! -f "Packages/manifest.json" ]; then \
		echo "$(RED)❌ manifest.json not found$(NC)"; \
		echo "$(YELLOW)💡 Run 'make init' first$(NC)"; \
		exit 1; \
	fi

	@echo "$(GREEN)✅ manifest.json found$(NC)"
	@echo "$(YELLOW)📋 Configured packages:$(NC)"
	@grep '"com\.' Packages/manifest.json | sed 's/.*"com\./   • com./' | sed 's/".*//' || echo "   No packages found"

	@echo ""
	@echo "$(BLUE)ℹ️  Package validation complete$(NC)"
	@echo "$(YELLOW)Note: Full validation requires Unity Editor$(NC)"

# Update packages (requires Unity Editor)
packages-update:
	@echo "$(BLUE)🔄 Updating Unity packages...$(NC)"
	@echo ""
	@echo "$(YELLOW)⚠️  Package updates require Unity Editor$(NC)"
	@echo "   1. Open project in Unity"
	@echo "   2. Go to Window → Package Manager"
	@echo "   3. Check for updates and install"
	@echo ""
	@echo "$(BLUE)Alternative: Modify Packages/manifest.json versions manually$(NC)"

# Clean package cache (Unity-specific)
packages-clean:
	@echo "$(BLUE)🧹 Cleaning Unity package cache...$(NC)"
	@echo ""
	@echo "$(YELLOW)⚠️  This requires Unity Editor$(NC)"
	@echo "   1. Close Unity Editor"
	@echo "   2. Delete Library/ and Temp/ directories"
	@echo "   3. Reopen project to rebuild cache"
	@echo ""
	@echo "$(BLUE)Manual cleanup:$(NC)"
	@echo "   rm -rf Library/ Temp/ Logs/"

# Default target
.DEFAULT_GOAL := help
