# Course: Computer Graphics  (level id "deep-cse-5-2", lesson ids "deep-cse-5-2-01".."-25")
Builds on Linear Algebra (deep-cse-2-5: vectors, dot/cross product, matrix multiplication, inverse, lesson 19 already introduces
2D scaling/rotation/shear and homogeneous coordinates), Structured Programming (deep-cse-1-2) and Computer Architecture (deep-cse-3-2).
Those are only recapped; here the focus is the classic Hearn & Baker style graphics syllabus: raster algorithms, 2D/3D transformations,
viewing and clipping, hidden surfaces, colour, lighting and shading, curves, plus a modern GPU/shader overview. All worked numbers verified.
01 What computer graphics is: uses (games, CAD, maps, medical imaging, UI, films), Sketchpad 1963, pixels and resolution, raster vs vector images, image space vs object space, interactive vs passive graphics, course map
02 Display hardware and the frame buffer: CRT idea, raster scan vs random (vector) scan, refresh rate, interlacing, LCD/LED/OLED, frame buffer size worked (1920x1080x24 bit), bit depth, colour lookup table, double buffering and tearing, aspect ratio
03 Line drawing with DDA: output primitives, pixel coordinates, slope-intercept form, why y = mx + b per pixel is slow, DDA steps, worked (2,3)-(10,8), rounding and floating point cost, steep lines
04 Bresenham's line algorithm: integer-only idea, decision parameter derivation, p0 = 2dy - dx, update rules, worked (2,3)-(10,8) table, all slopes and octants, why GPUs and plotters liked it
05 Midpoint circle algorithm: circle equation, why sqrt and trig are slow, 8-way symmetry, circle function sign test, p0 = 1 - r, update rules, worked r = 10, non-origin centres
06 Midpoint ellipse algorithm: ellipse equation, 4-way symmetry, region 1 and region 2 by slope, decision parameters, worked rx = 8, ry = 6, common mistakes
07 Scan-line polygon fill: polygon types (convex, concave), inside tests (even-odd rule, nonzero winding), scan-line idea, intersections and pairing, vertex special cases, edge table and active edge list, worked polygon
08 Flood fill, boundary fill and antialiasing: seed fill, 4-connected vs 8-connected, recursive and stack-based fill, span fill, fill patterns, aliasing (jaggies), supersampling and area sampling, line attributes
09 2D transformations and homogeneous matrices: translation, scaling, rotation, reflection, shear as equations, why 3x3 homogeneous matrices, matrix forms, worked rotations and scalings, inverse transforms
10 Composite 2D transformations: concatenation and order (AB != BA), rotation about a pivot, scaling about a fixed point, reflection about y = x and arbitrary lines, worked triangle, efficiency of one combined matrix
11 Windowing and the viewport: world, window, viewport, device coordinates, normalized device coordinates, window-to-viewport mapping formula worked, aspect distortion, zooming and panning, 2D viewing pipeline
12 Line clipping with Cohen-Sutherland: point clipping, why clip, region codes (TBRL), trivial accept and reject with AND/OR, intersection formulas, full worked example
13 Liang-Barsky line clipping: parametric line, p and q values, entering vs leaving, u1 and u2, worked example, why it is faster than Cohen-Sutherland, Cyrus-Beck mention
14 Polygon clipping with Sutherland-Hodgman: why line clipping fails for polygons, clip against one edge at a time, four in/out cases, worked triangle, concave polygon artefacts, Weiler-Atherton idea, text clipping
15 3D objects and 3D transformations: right-handed coordinates, polygon meshes, vertex/edge/face tables, plane equation and normals, 4x4 homogeneous matrices, 3D translation, scaling, rotation about x/y/z, rotation about an arbitrary axis steps
16 Projections: projection plane, parallel (orthographic, oblique: cavalier, cabinet) vs perspective, similar triangles worked, perspective matrix and divide by w, vanishing points (1/2/3 point), foreshortening
17 The 3D viewing pipeline: modelling, world, viewing (camera) coordinates, eye, look-at and up vectors, u-v-n frame, view volume and frustum, near/far planes, normalized view volume, clipping, viewport, field of view
18 Hidden surface removal: object space vs image space, back-face culling with N.V, z-buffer (depth buffer) worked, painter's algorithm and depth sort problems, scan-line method, comparison and memory cost
19 Colour models: light and the eye, RGB additive, CMY/CMYK subtractive, conversions worked, HSV with RGB to HSV worked, colour depth, gamma idea briefly, where each model is used
20 Illumination models: light sources (point, directional, ambient), ambient term, Lambert diffuse, Phong specular with shininess, attenuation, full Phong formula worked, Blinn-Phong halfway vector
21 Shading models: flat shading, Gouraud (vertex lighting and interpolation) worked, Phong shading (normal interpolation), Mach bands, specular highlight problems, comparison and cost
22 Curves: why parametric curves, continuity C0/C1/C2 and G1, Bezier curves (Bernstein form, cubic, convex hull), de Casteljau worked, B-splines (local control, knots, uniform cubic), joining curves
23 Texture mapping: texture, texel, u-v coordinates, mapping triangle to texture, nearest vs bilinear filtering worked, mipmaps, perspective-correct mapping idea, bump and normal mapping briefly
24 The GPU rendering pipeline and shaders: CPU vs GPU, APIs (OpenGL, Vulkan, DirectX, Metal, WebGL), vertex processing, primitive assembly, rasterization, fragment processing, depth test and blending, vertex and fragment shaders (tiny GLSL), frame rate
25 Animation basics, ray tracing and wrap-up: frames and fps, keyframes and in-betweening (lerp), easing, morphing, sprites, physics idea; ray tracing (rays, ray-sphere worked, shadows, reflection, recursion), rasterization vs ray tracing, course recap, what next
