using UnityEngine;

public class FractalGenerator
{
    public void Generate(string mode = "raymarch", float power = 2, int maxIterations = 512, float bailout = 4.0f)
    {
        // TODO: implement 3D Mandelbrot generation
        Debug.Log($"Generating fractal with mode: {mode}, power: {power}, iterations: {maxIterations}, bailout: {bailout}");
    }
}
