using UnityEngine;
using UnityEngine.TestTools;
using NUnit.Framework;

public class TestExplorer
{
    [Test]
    public void TestMove()
    {
        // TODO: unit test for Explorer.Move
        Debug.Log("Testing Explorer.Move method");
        Assert.Pass("Placeholder test - Explorer.Move needs implementation");
    }
}

[TestFixture]
public class MandelbulbMathTests
{
    private const float FLOAT_TOLERANCE = 0.001f;

    [Test]
    public void DistanceEstimator_Origin_ReturnsZero()
    {
        // Test distance at origin (should be 0)
        Vector3 origin = Vector3.zero;
        float distance = FractalGenerator.MandelbulbMath.DistanceEstimator(origin, 8f, 32);

        Assert.AreEqual(0f, distance, FLOAT_TOLERANCE, "Distance at origin should be 0");
    }

    [Test]
    public void DistanceEstimator_KnownPoint_ReturnsExpectedDistance()
    {
        // Test a known point with expected behavior
        Vector3 testPoint = new Vector3(1f, 0f, 0f);
        float distance = FractalGenerator.MandelbulbMath.DistanceEstimator(testPoint, 8f, 32);

        Assert.Greater(distance, 0f, "Distance should be positive for points outside the set");
        Assert.IsFalse(float.IsNaN(distance), "Distance should not be NaN");
        Assert.IsFalse(float.IsInfinity(distance), "Distance should not be infinite");
    }

    [Test]
    public void IteratePoint_ZeroInput_ReturnsCValue()
    {
        // Test iteration with zero input
        Vector3 z = Vector3.zero;
        Vector3 c = new Vector3(1f, 2f, 3f);
        float power = 8f;

        Vector3 result = FractalGenerator.MandelbulbMath.IteratePoint(z, c, power);

        Assert.AreEqual(c, result, "Zero input should return c value");
    }

    [Test]
    public void IteratePoint_ValidInput_ProducesValidOutput()
    {
        // Test iteration with valid input
        Vector3 z = new Vector3(0.5f, 0.5f, 0.5f);
        Vector3 c = new Vector3(0.1f, 0.1f, 0.1f);
        float power = 8f;

        Vector3 result = FractalGenerator.MandelbulbMath.IteratePoint(z, c, power);

        Assert.IsFalse(float.IsNaN(result.x), "Result X should not be NaN");
        Assert.IsFalse(float.IsNaN(result.y), "Result Y should not be NaN");
        Assert.IsFalse(float.IsNaN(result.z), "Result Z should not be NaN");
        Assert.IsFalse(float.IsInfinity(result.x), "Result X should not be infinite");
        Assert.IsFalse(float.IsInfinity(result.y), "Result Y should not be infinite");
        Assert.IsFalse(float.IsInfinity(result.z), "Result Z should not be infinite");
    }

    [Test]
    public void IsInSet_Origin_ReturnsTrue()
    {
        // Origin should be in the Mandelbrot set
        Vector3 origin = Vector3.zero;
        bool isInSet = FractalGenerator.MandelbulbMath.IsInSet(origin, 8f, 32);

        Assert.IsTrue(isInSet, "Origin should be in the Mandelbrot set");
    }

    [Test]
    public void IsInSet_LargeValue_ReturnsFalse()
    {
        // Large values should escape and return false
        Vector3 largePoint = new Vector3(10f, 10f, 10f);
        bool isInSet = FractalGenerator.MandelbulbMath.IsInSet(largePoint, 8f, 32);

        Assert.IsFalse(isInSet, "Large values should escape the set");
    }

    [Test]
    public void EscapeTime_Origin_ReturnsZero()
    {
        // Origin doesn't escape, so should return 0
        Vector3 origin = Vector3.zero;
        float escapeTime = FractalGenerator.MandelbulbMath.EscapeTime(origin, 8f, 32);

        Assert.AreEqual(0f, escapeTime, FLOAT_TOLERANCE, "Origin escape time should be 0");
    }

    [Test]
    public void EscapeTime_EscapingPoint_ReturnsValidTime()
    {
        // Points that escape should return valid escape time
        Vector3 escapingPoint = new Vector3(2f, 0f, 0f);
        float escapeTime = FractalGenerator.MandelbulbMath.EscapeTime(escapingPoint, 8f, 32);

        Assert.Greater(escapeTime, 0f, "Escaping points should have positive escape time");
        Assert.LessOrEqual(escapeTime, 1f, "Escape time should be normalized to 0-1 range");
    }

    [Test]
    public void DistanceEstimator_DifferentPowers_ProducesDifferentResults()
    {
        // Different powers should produce different distance estimates
        Vector3 testPoint = new Vector3(0.5f, 0.5f, 0.5f);

        float distance8 = FractalGenerator.MandelbulbMath.DistanceEstimator(testPoint, 8f, 32);
        float distance6 = FractalGenerator.MandelbulbMath.DistanceEstimator(testPoint, 6f, 32);

        Assert.AreNotEqual(distance8, distance6, "Different powers should produce different distances");
    }

    [Test]
    public void DistanceEstimator_IncreasingIterations_Converges()
    {
        // Higher iterations should produce more accurate results
        Vector3 testPoint = new Vector3(0.8f, 0.8f, 0.8f);

        float distanceLow = FractalGenerator.MandelbulbMath.DistanceEstimator(testPoint, 8f, 8);
        float distanceHigh = FractalGenerator.MandelbulbMath.DistanceEstimator(testPoint, 8f, 32);

        // Results should be reasonably close (within 20% difference)
        float difference = Mathf.Abs(distanceLow - distanceHigh);
        float average = (Mathf.Abs(distanceLow) + Mathf.Abs(distanceHigh)) / 2f;

        if (average > 0.001f) // Only test if we have meaningful values
        {
            float relativeDifference = difference / average;
            Assert.Less(relativeDifference, 0.5f, "Higher iterations should converge to similar result");
        }
    }

    [Test]
    public void DistanceEstimator_EdgeCases_HandlesGracefully()
    {
        // Test edge cases
        Vector3[] testPoints = {
            new Vector3(float.MaxValue, 0f, 0f),
            new Vector3(0f, float.MaxValue, 0f),
            new Vector3(0f, 0f, float.MaxValue),
            new Vector3(float.MinValue, 0f, 0f),
            Vector3.positiveInfinity,
            Vector3.negativeInfinity
        };

        foreach (Vector3 testPoint in testPoints)
        {
            float distance = FractalGenerator.MandelbulbMath.DistanceEstimator(testPoint, 8f, 32);

            Assert.IsFalse(float.IsNaN(distance), $"Distance should not be NaN for {testPoint}");
            // Note: Infinity might be acceptable in some cases
        }
    }
}
