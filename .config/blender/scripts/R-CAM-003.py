import bpy
from pathlib import Path

SCENE = bpy.context.scene
SOURCE_CAMERA = bpy.data.objects['003-CAM']
MAIN_CAMERA = bpy.data.objects['1-Camera.002']
SCREEN = bpy.data.objects['003CAM_View_Plane']
FRAME = bpy.data.objects['LiveCam_View_Frame']
FEED_WIDTH, FEED_HEIGHT = 640, 360
CACHE_DIR = Path(bpy.path.abspath('//render_cache/003cam_feed'))
FRAME_RANGE = (1, 60)  # Example: render 003-CAM frames 1 through 60.
SET_MAIN_FRAME_RANGE = True  # Keep the final render limited to FRAME_RANGE.
RENDER_MAIN_ANIMATION = False  # Set True only when you intentionally want the full timeline rendered.

def make_feed_scene():
    """Create a lightweight scene with normal PNG still settings for the source pass."""
    feed = bpy.data.scenes.new('003-CAM Feed Render')
    feed.world = SCENE.world
    feed.camera = SOURCE_CAMERA
    for collection in SCENE.collection.children:
        feed.collection.children.link(collection)
    feed.render.engine = 'BLENDER_EEVEE'
    feed.render.use_compositing = False
    feed.render.resolution_x, feed.render.resolution_y, feed.render.resolution_percentage = FEED_WIDTH, FEED_HEIGHT, 100
    feed.render.image_settings.file_format = 'PNG'
    return feed

def set_plane_image(first_path, frame_start, frame_duration):
    mesh = SCREEN.data
    uv_layer = mesh.uv_layers.get('UVMap') or mesh.uv_layers.new(name='UVMap')
    # Match the quad corners to standard image coordinates.
    uv_coords = ((0.0, 0.0), (1.0, 0.0), (1.0, 1.0), (0.0, 1.0))
    for poly in mesh.polygons:
        for loop_index, vertex_index in zip(poly.loop_indices, poly.vertices):
            uv_layer.data[loop_index].uv = uv_coords[vertex_index % 4]
    material = bpy.data.materials.get('003CAM_Plane_Sequence_Material') or bpy.data.materials.new('003CAM_Plane_Sequence_Material')
    material.use_nodes = True
    nodes, links = material.node_tree.nodes, material.node_tree.links
    nodes.clear()
    output = nodes.new('ShaderNodeOutputMaterial')
    emission = nodes.new('ShaderNodeEmission')
    texture = nodes.new('ShaderNodeTexImage')
    texture.name = '003-CAM Render Sequence'
    image = bpy.data.images.get('003CAM_Render_Sequence')
    if image:
        bpy.data.images.remove(image)
    image = bpy.data.images.load(str(first_path), check_existing=False)
    image.name = '003CAM_Render_Sequence'
    image.source = 'SEQUENCE' if frame_duration > 1 else 'FILE'
    texture.image = image
    if frame_duration > 1:
        texture.image_user.frame_start = frame_start
        texture.image_user.frame_duration = frame_duration
        texture.image_user.use_auto_refresh = True
    emission.inputs['Strength'].default_value = 1.0
    links.new(texture.outputs['Color'], emission.inputs['Color'])
    links.new(emission.outputs['Emission'], output.inputs['Surface'])
    SCREEN.data.materials.clear()
    SCREEN.data.materials.append(material)

def main():
    CACHE_DIR.mkdir(parents=True, exist_ok=True)
    original_camera = SCENE.camera
    original_engine = SCENE.render.engine
    original_x, original_y, original_scale = SCENE.render.resolution_x, SCENE.render.resolution_y, SCENE.render.resolution_percentage
    feed_scene = None
    try:
        # Source pass: fast, low-res, with the display itself hidden to prevent recursion.
        SCREEN.hide_render = True
        FRAME.hide_render = True
        feed_scene = make_feed_scene()
        range_start, range_end = FRAME_RANGE
        if range_start < SCENE.frame_start or range_end > SCENE.frame_end or range_start > range_end:
            raise ValueError(f'FRAME_RANGE must be within {SCENE.frame_start}–{SCENE.frame_end}')
        for source_frame in range(range_start, range_end + 1):
            SCENE.frame_set(source_frame)
            feed_scene.frame_set(source_frame)
            frame_path = CACHE_DIR / f'003cam_{source_frame:06d}.png'
            feed_scene.render.filepath = str(frame_path)
            print(f'Rendering 003-CAM frame {source_frame} of {range_end}...')
            bpy.ops.render.render(scene=feed_scene.name, write_still=True)
        set_plane_image(CACHE_DIR / f'003cam_{range_start:06d}.png', range_start, range_end - range_start + 1)

        # Main pass: use the scene's usual quality and output settings.
        SCREEN.hide_render = False
        FRAME.hide_render = False
        SCENE.camera = MAIN_CAMERA
        SCENE.render.engine = original_engine
        SCENE.render.resolution_x, SCENE.render.resolution_y, SCENE.render.resolution_percentage = original_x, original_y, original_scale
        if SET_MAIN_FRAME_RANGE:
            SCENE.frame_start, SCENE.frame_end = range_start, range_end
        bpy.ops.wm.save_as_mainfile(filepath=bpy.data.filepath)
        if RENDER_MAIN_ANIMATION:
            print(f'Rendering main animation: {SCENE.frame_start}–{SCENE.frame_end}')
            bpy.ops.render.render(animation=True)
        else:
            print('Plane setup complete; main animation render skipped.')
    finally:
        SCENE.camera = original_camera
        SCENE.render.engine = original_engine
        SCENE.render.resolution_x, SCENE.render.resolution_y, SCENE.render.resolution_percentage = original_x, original_y, original_scale
        SCREEN.hide_render = False
        FRAME.hide_render = False
        if feed_scene and feed_scene.name in bpy.data.scenes:
            bpy.data.scenes.remove(feed_scene, do_unlink=True)

main()
