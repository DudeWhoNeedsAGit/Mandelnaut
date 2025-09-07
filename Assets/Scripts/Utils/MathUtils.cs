using UnityEngine;

public static class MathUtils
{
    public static float Clamp(float value, float min, float max)
    {
        return Mathf.Clamp(value, min, max);
    }
}
