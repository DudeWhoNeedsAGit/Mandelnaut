using UnityEngine;

public class Explorer : MonoBehaviour
{
    public void Move(Vector3 direction, float speed)
    {
        // TODO: implement player movement in 3D fractal space
        transform.Translate(direction * speed * Time.deltaTime);
    }

    public void Rotate(Vector3 eulerAngles)
    {
        // TODO: implement camera rotation using yaw, pitch, and roll
        transform.Rotate(eulerAngles * Time.deltaTime);
    }

    public void Zoom(float factor)
    {
        // TODO: implement zoom in/out of fractal to explore structures
        Camera.main.fieldOfView *= factor;
    }

    public void AdjustParameters(float power, int iterations, string palette)
    {
        // TODO: implement live parameter adjustment (power, iterations, palette)
        Debug.Log($"Adjusting parameters - Power: {power}, Iterations: {iterations}, Palette: {palette}");
    }

    public void SaveViewpoint(string name)
    {
        // TODO: implement viewpoint bookmarking
        Debug.Log($"Saving viewpoint: {name}");
    }

    public void LoadViewpoint(string name)
    {
        // TODO: implement viewpoint loading
        Debug.Log($"Loading viewpoint: {name}");
    }

    public void Interact()
    {
        // TODO: implement optional collision, particle triggers, or interactions
        Debug.Log("Interaction triggered");
    }
}
