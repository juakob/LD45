let project = new Project('LudumDare45');
project.windowOptions.width = 1280;
project.windowOptions.height = 720;

project.addDefine('debugInfo');
project.addAssets('Assets/**',{ quality: 0.9 });
project.addShaders('Shaders/**');
project.addSources('Sources');

await project.addProject('khawy');
project.addLibrary('tiled');

project.addDefine('kha_no_ogg');
project.addDefine('analyzer-optimize');
project.addParameter('-dce full');
project.targetOptions.html5.disableContextMenu = true;

if (process.argv.includes("--watch")) {
	project.addLibrary('hotml');
	project.addDefine('js_classic');
	const path = require('path');
	const Server = new require(path.resolve('./server/bin/server.js')).Main;
	const server = new Server(`${path.resolve('.')}/build/${platform}`, 'kha.js');
	callbacks.postHaxeRecompilation = () => {
		server.reload();
	};
}

resolve(project);
