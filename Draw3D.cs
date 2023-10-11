using Godot;

public static class Draw3D
{
  public static MeshInstance3D Line(Vector3 pos1, Vector3 pos2, Color? color = null)
  {
    var meshInstance = new MeshInstance3D();
    var immediateMesh = new ImmediateMesh();
    var material = new StandardMaterial3D();

    meshInstance.Mesh = immediateMesh;
    meshInstance.CastShadow = GeometryInstance3D.ShadowCastingSetting.Off;

    immediateMesh.SurfaceBegin(Mesh.PrimitiveType.Lines, material);
    immediateMesh.SurfaceAddVertex(pos1);
    immediateMesh.SurfaceAddVertex(pos2);
    immediateMesh.SurfaceEnd();

    material.ShadingMode = StandardMaterial3D.ShadingModeEnum.Unshaded;
    material.AlbedoColor = color ?? Colors.WhiteSmoke;

    (Engine.GetMainLoop() as SceneTree).Root.AddChild(meshInstance);

    return meshInstance;
  }

  public static MeshInstance3D Point(Vector3 pos, float radius = 0.05f, Color? color = null)
  {
    var meshInstance = new MeshInstance3D();
    var sphereMesh = new SphereMesh();
    var material = new StandardMaterial3D();

    meshInstance.Mesh = sphereMesh;
    meshInstance.CastShadow = GeometryInstance3D.ShadowCastingSetting.Off;
    meshInstance.Position = pos;

    sphereMesh.Radius = radius;
    sphereMesh.Height = radius * 2f;
    sphereMesh.Material = material;

    material.ShadingMode = StandardMaterial3D.ShadingModeEnum.Unshaded;
    material.AlbedoColor = color ?? Colors.WhiteSmoke;

    (Engine.GetMainLoop() as SceneTree).Root.AddChild(meshInstance);

    return meshInstance;
  }

}
