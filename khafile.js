let project = new Project('LudumDare45');
project.windowOptions.width = 1280;
project.windowOptions.height = 720;
project.addDefine('debugInfo');
project.addAssets('Assets/**');
project.addShaders('Shaders/**');
project.addSources('Sources');
await project.addProject('khawy');

resolve(project);
