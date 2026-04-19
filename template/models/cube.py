import cadquery as cq
from ocp_vscode import show_object


cube = cq.Workplane("XY").box(10, 10, 10)

# OCP CAD Viewer picks this up when the script is run inside VS Code.
show_object(cube, name="cube")

