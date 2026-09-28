bl_info = {
    "name": "Models Resource Importer (Direct URL)",
    "author": "ok",
    "version": (1, 0, 0),
    "blender": (5, 2, 0),
    "location": "3D Viewport > Sidebar > Models Resource",
    "description": "Download and import one The Models Resource model page",
    "category": "Import-Export",
}

import re
import zipfile
from pathlib import Path
from urllib.parse import urljoin, urlparse

import bpy
import requests
from bs4 import BeautifulSoup
from bpy.props import BoolProperty, StringProperty
from bpy.types import Operator, Panel

ALLOWED_HOSTS = {
    "www.models-resource.com",
    "models-resource.com",
    "models.spriters-resource.com",
}
MODEL_PAGE_PATTERN = re.compile(r"/(?:model|asset)/(\d+)/?$")
IMPORT_EXTENSIONS = (".fbx", ".dae", ".obj", ".glb", ".gltf")


def model_id(page_url: str) -> str:
    parsed = urlparse(page_url)
    if parsed.scheme not in {"http", "https"} or parsed.netloc.lower() not in ALLOWED_HOSTS:
        raise ValueError("Use a URL from models.spriters-resource.com or www.models-resource.com")
    match = MODEL_PAGE_PATTERN.search(parsed.path)
    if not match:
        raise ValueError("Use one model page ending in /model/<id>/ or /asset/<id>/")
    return match.group(1)


def find_zip_url(page_url: str, html: str) -> str:
    soup = BeautifulSoup(html, "html.parser")
    for anchor in soup.find_all("a", href=True):
        candidate = urljoin(page_url, anchor["href"])
        parsed = urlparse(candidate)
        if parsed.netloc.lower() in ALLOWED_HOSTS and parsed.path.lower().endswith(".zip"):
            return candidate
    raise RuntimeError("No ZIP download link was found on that model page")


def extract_archive(archive: Path, destination: Path) -> None:
    destination.mkdir(parents=True, exist_ok=True)
    root = destination.resolve()
    with zipfile.ZipFile(archive) as zip_file:
        for member in zip_file.infolist():
            target = (destination / member.filename).resolve()
            if target != root and root not in target.parents:
                raise RuntimeError("Archive contains an unsafe file path")
        zip_file.extractall(destination)


def first_importable_file(directory: Path) -> Path:
    files = [file for file in directory.rglob("*") if file.is_file()]
    for extension in IMPORT_EXTENSIONS:
        matches = sorted(file for file in files if file.suffix.lower() == extension)
        if matches:
            return matches[0]
    raise RuntimeError("The archive has no FBX, DAE, OBJ, GLB, or GLTF file")


def import_file(filepath: Path) -> None:
    extension = filepath.suffix.lower()
    if extension == ".fbx":
        bpy.ops.import_scene.fbx(filepath=str(filepath))
    elif extension == ".dae":
        bpy.ops.wm.collada_import(filepath=str(filepath))
    elif extension == ".obj":
        bpy.ops.wm.obj_import(filepath=str(filepath))
    elif extension in {".glb", ".gltf"}:
        bpy.ops.import_scene.gltf(filepath=str(filepath))


class MODELSRESOURCE_OT_download_import(Operator):
    bl_idname = "models_resource.download_import"
    bl_label = "Download and Import"
    bl_description = "Download one model ZIP from The Models Resource and import its first supported model file"

    def execute(self, context):
        scene = context.scene
        try:
            asset_id = model_id(scene.models_resource_url.strip())
            cache_dir = Path(bpy.path.abspath(scene.models_resource_cache_dir)).expanduser()
            session = requests.Session()
            session.headers["User-Agent"] = "Mozilla/5.0 (Blender Models Resource Importer)"
            page = session.get(scene.models_resource_url, timeout=30)
            page.raise_for_status()
            archive_url = find_zip_url(scene.models_resource_url, page.text)

            archive = cache_dir / f"models-resource-{asset_id}.zip"
            if not archive.exists() or scene.models_resource_redownload:
                cache_dir.mkdir(parents=True, exist_ok=True)
                temporary = archive.with_suffix(".zip.part")
                with session.get(archive_url, stream=True, timeout=(30, 120)) as response:
                    response.raise_for_status()
                    with temporary.open("wb") as file:
                        for chunk in response.iter_content(1024 * 1024):
                            if chunk:
                                file.write(chunk)
                temporary.replace(archive)

            extracted = cache_dir / f"models-resource-{asset_id}"
            extract_archive(archive, extracted)
            model_file = first_importable_file(extracted)
            import_file(model_file)
        except (OSError, requests.RequestException, RuntimeError, ValueError, zipfile.BadZipFile) as error:
            self.report({"ERROR"}, str(error))
            return {"CANCELLED"}

        self.report({"INFO"}, f"Imported {model_file.name}")
        return {"FINISHED"}


class MODELSRESOURCE_PT_panel(Panel):
    bl_label = "Models Resource"
    bl_idname = "MODELSRESOURCE_PT_panel"
    bl_space_type = "VIEW_3D"
    bl_region_type = "UI"
    bl_category = "Models Resource"

    def draw(self, context):
        layout = self.layout
        scene = context.scene
        layout.prop(scene, "models_resource_url", text="Model page URL")
        layout.prop(scene, "models_resource_cache_dir", text="Cache folder")
        layout.prop(scene, "models_resource_redownload", text="Download again")
        layout.operator(MODELSRESOURCE_OT_download_import.bl_idname, icon="IMPORT")
        layout.label(text="One model page at a time.", icon="INFO")


CLASSES = (MODELSRESOURCE_OT_download_import, MODELSRESOURCE_PT_panel)


def register():
    for class_ in CLASSES:
        bpy.utils.register_class(class_)
    bpy.types.Scene.models_resource_url = StringProperty(
        name="Model page URL",
        description="The Models Resource URL for one model",
    )
    bpy.types.Scene.models_resource_cache_dir = StringProperty(
        name="Cache folder",
        subtype="DIR_PATH",
        default=str(Path.home() / "Documents" / "ModelsResourceCache"),
    )
    bpy.types.Scene.models_resource_redownload = BoolProperty(
        name="Download again",
        description="Download the ZIP again even when it is already cached",
        default=False,
    )


def unregister():
    del bpy.types.Scene.models_resource_redownload
    del bpy.types.Scene.models_resource_cache_dir
    del bpy.types.Scene.models_resource_url
    for class_ in reversed(CLASSES):
        bpy.utils.unregister_class(class_)


if __name__ == "__main__":
    register()
