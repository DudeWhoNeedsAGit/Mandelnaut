using UnityEngine;

public class FractalGenerator
{
    // Core mathematical functions for 3D Mandelbrot (Mandelbulb) generation
    public static class MandelbulbMath
    {
        /// <summary>
        /// Distance Estimator for 3D Mandelbrot set (Mandelbulb)
        /// </summary>
        /// <param name="pos">Position in 3D space</param>
        /// <param name="power">Fractal power parameter</param>
        /// <param name="maxIter">Maximum iterations</param>
        /// <returns>Estimated distance to fractal surface</returns>
        public static float DistanceEstimator(Vector3 pos, float power, int maxIter)
        {
            Vector3 z = pos;
            float dr = 1.0f;
            float r = 0.0f;

            for (int i = 0; i < maxIter; i++)
            {
                r = z.magnitude;
                if (r > 2.0f) break; // Bailout condition

                // Calculate next iteration
                float theta = Mathf.Acos(z.z / r);
                float phi = Mathf.Atan2(z.y, z.x);
                float zr = Mathf.Pow(r, power);

                theta *= power;
                phi *= power;

                z = new Vector3(
                    zr * Mathf.Sin(theta) * Mathf.Cos(phi),
                    zr * Mathf.Sin(theta) * Mathf.Sin(phi),
                    zr * Mathf.Cos(theta)
                );

                z += pos; // Add original position (c value)

                dr = Mathf.Pow(r, power - 1.0f) * power * dr + 1.0f;
            }

            return 0.5f * Mathf.Log(r) * r / dr;
        }

        /// <summary>
        /// Single iteration of Mandelbulb formula
        /// </summary>
        /// <param name="z">Current z value</param>
        /// <param name="c">Constant c value</param>
        /// <param name="power">Fractal power</param>
        /// <returns>Next iteration result</returns>
        public static Vector3 IteratePoint(Vector3 z, Vector3 c, float power)
        {
            float r = z.magnitude;
            if (r < Mathf.Epsilon) return c; // Avoid division by zero

            float theta = Mathf.Acos(Mathf.Clamp(z.z / r, -1.0f, 1.0f));
            float phi = Mathf.Atan2(z.y, z.x);
            float zr = Mathf.Pow(r, power);

            theta *= power;
            phi *= power;

            return new Vector3(
                zr * Mathf.Sin(theta) * Mathf.Cos(phi),
                zr * Mathf.Sin(theta) * Mathf.Sin(phi),
                zr * Mathf.Cos(theta)
            ) + c;
        }

        /// <summary>
        /// Check if point is in Mandelbulb set
        /// </summary>
        /// <param name="c">Constant c value</param>
        /// <param name="power">Fractal power</param>
        /// <param name="maxIter">Maximum iterations</param>
        /// <returns>True if point is in set</returns>
        public static bool IsInSet(Vector3 c, float power, int maxIter)
        {
            Vector3 z = Vector3.zero;
            float r = 0.0f;

            for (int i = 0; i < maxIter; i++)
            {
                if (r > 2.0f) return false; // Escaped

                z = IteratePoint(z, c, power);
                r = z.magnitude;
            }

            return true; // Didn't escape within max iterations
        }

        /// <summary>
        /// Calculate escape time for coloring
        /// </summary>
        /// <param name="c">Constant c value</param>
        /// <param name="power">Fractal power</param>
        /// <param name="maxIter">Maximum iterations</param>
        /// <returns>Normalized escape time (0.0 to 1.0)</returns>
        public static float EscapeTime(Vector3 c, float power, int maxIter)
        {
            Vector3 z = Vector3.zero;
            float r = 0.0f;

            for (int i = 0; i < maxIter; i++)
            {
                r = z.magnitude;
                if (r > 2.0f)
                {
                    // Smooth coloring based on escape time
                    return (float)i / maxIter + 1.0f - Mathf.Log(Mathf.Log(r)) / Mathf.Log(2.0f);
                }

                z = IteratePoint(z, c, power);
            }

            return 0.0f; // Didn't escape
        }
    }

    // Unity-specific generation methods
    public void Generate(string mode = "raymarch", float power = 8, int maxIterations = 32, float bailout = 2.0f)
    {
        Debug.Log($"Generating fractal with mode: {mode}, power: {power}, iterations: {maxIterations}, bailout: {bailout}");

        // TODO: Implement Unity compute shader integration
        // This will call the mathematical functions above
    }

    /// <summary>
    /// Generate fractal data for compute shader
    /// </summary>
    public float[] GenerateFractalData(Vector3 center, float scale, float power, int maxIterations, int resolution)
    {
        float[] data = new float[resolution * resolution * resolution];

        // Generate 3D grid of distance values
        for (int x = 0; x < resolution; x++)
        {
            for (int y = 0; y < resolution; y++)
            {
                for (int z = 0; z < resolution; z++)
                {
                    Vector3 pos = new Vector3(
                        (x - resolution / 2) * scale + center.x,
                        (y - resolution / 2) * scale + center.y,
                        (z - resolution / 2) * scale + center.z
                    );

                    int index = x + y * resolution + z * resolution * resolution;
                    data[index] = MandelbulbMath.DistanceEstimator(pos, power, maxIterations);
                }
            }
        }

        return data;
    }
}
