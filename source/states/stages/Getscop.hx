package states.stages;

import openfl.display.BitmapData;
import away3d.textures.BitmapTexture;
import away3d.entities.Sprite3D;
import openfl.utils.AssetType;
import away3d.library.assets.Asset3DType;
import away3d.events.Asset3DEvent;
import away3d.loaders.parsers.OBJParser;
import away3d.loaders.Loader3D;
import openfl.Assets;
import away3d.loaders.misc.AssetLoaderContext;
import away3d.utils.Cast;
import away3d.materials.TextureMaterial;
import away3d.materials.lightpickers.StaticLightPicker;
import away3d.lights.DirectionalLight;
import away3d.entities.Mesh;
import flx3D.FlxView3D;
import backend.BaseStage;

class Getscop extends BaseStage
{
	var stage:StageMesh;
	override function create()
	{
		camGame.visible = false;

		stage = new StageMesh();
		stage.scrollFactor.set(0, 0);
		stage.cameras = [game.camBehind];
		add(stage);

		var originalBitmap = Assets.getBitmapData(Paths.getPath('models/getscop/helpme.png', AssetType.IMAGE, "shared"));

		// Calculate the next power of 2 dimensions
		var powerOfTwoWidth:Int = nextPowerOfTwo(originalBitmap.width);
		var powerOfTwoHeight:Int = nextPowerOfTwo(originalBitmap.height);
		
		// Create a new bitmap with transparent background and power of 2 dimensions
		var newBitmapData:BitmapData = new BitmapData(powerOfTwoWidth, powerOfTwoHeight, true, 0x00000000);
		
		// Draw the original bitmap onto the new bitmap with transparency
		newBitmapData.copyPixels(originalBitmap, originalBitmap.rect, new openfl.geom.Point(), null, null, true);

		var material = new TextureMaterial(new BitmapTexture(newBitmapData));
		var character:Sprite3D = new Sprite3D(material, 256, 256);
		character.z = 600;
		stage.view.scene.addChild(character);
	}
	
	function nextPowerOfTwo(value:Int):Int {
		var result:Int = 1;
		while (result < value) {
			result *= 2;
		}
		return result;
	}
}

class StageMesh extends FlxView3D {
	var meshes:Array<Mesh> = [];

	var light:DirectionalLight;
	var lightPicker:StaticLightPicker;

	public function new() {
		super();

		light = new DirectionalLight();
		light.ambient = 0.5;
		light.z -= 10;

		view.scene.addChild(light);

		lightPicker = new StaticLightPicker([light]);

		for (meshName in ['baseplate', 'family', 'speakers', 'stairs', 'treehouse', 'quagmires']) {
			var material = new TextureMaterial(Cast.bitmapTexture(Paths.getPath('models/getscop/$meshName.png', AssetType.IMAGE, "shared")));
			material.lightPicker = lightPicker;
	
			var _model = Assets.getBytes(Paths.getPath('models/getscop/$meshName.obj', AssetType.BINARY, "shared"));
			var assetLoaderContext = new AssetLoaderContext();
			assetLoaderContext.mapUrlToData('$meshName.mtl', Assets.getBytes(Paths.getPath('models/getscop/$meshName.mtl', AssetType.BINARY, "shared")));
	
			var _loader = new Loader3D();
			_loader.loadData(_model, assetLoaderContext, null, new OBJParser());
			_loader.addEventListener(Asset3DEvent.ASSET_COMPLETE, (event:Asset3DEvent) -> {
				if (event.asset.assetType == Asset3DType.MESH) {
					var mesh:Mesh = cast(event.asset, Mesh);
					mesh.scale(5);
					mesh.material = material;
					meshes.push(mesh);
				}
			});
	
			view.scene.addChild(_loader);
		}
	}	

	override function update(elapsed:Float) {
		super.update(elapsed);

		var move = 10;

		if (FlxG.keys.justPressed.S)
			moveMesh(0, 0, move);
		if (FlxG.keys.justPressed.W)
			moveMesh(0, 0, -move);

		if (FlxG.keys.justPressed.A)
			moveMesh(move, 0, 0);
		if (FlxG.keys.justPressed.D)
			moveMesh(-move, 0, 0);

		if (FlxG.keys.justPressed.Q)
			moveMesh(0, move, 0);
		if (FlxG.keys.justPressed.E)
			moveMesh(0, -move, 0);
	}

	function moveMesh(x:Float, y:Float, z:Float) {
		for (i in meshes) {
			i.x += x;
			i.y += y;
			i.z += z;

			trace(i.x, i.y, i.z);
		}
	}

	override function destroy() {
		super.destroy();
	}
}