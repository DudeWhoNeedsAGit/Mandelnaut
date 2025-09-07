# Mandelnaut Unity Project Makefile
# Comprehensive build and test automation for Unity 3D fractal exploration project

.PHONY: help unit integration test test-results test-log clean-tests build clean setup

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
unit:
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

# Integration Tests (PlayMode)
integration:
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

# Default target
.DEFAULT_GOAL := help
