let project = new Project('LudumDare45');
project.windowOptions.width = 1280;
project.windowOptions.height = 720;
project.addDefine('debugInfo');
project.addAssets('Assets/**',{ quality: 0.9 });
project.addShaders('Shaders/**');
project.addSources('Sources');
await project.addProject('khawy');
project.addLibrary('tiled');

resolve(project);
