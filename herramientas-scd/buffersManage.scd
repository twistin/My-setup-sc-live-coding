
         ////// Buffers ////////



// Enfoque cargar buffer como eventos y llamarlos por simbolo
(
Buffer.freeAll;
~path = PathName(thisProcess.nowExecutingPath).parentPath;
b =(
	coro1:Buffer.read(s,~path ++ "coro1.wav"),
	coro2:Buffer.read(s,~path ++"coro2.wav"),
	melodia1:Buffer.read(s,~path ++ "melodia1.wav"),
	melodia2:Buffer.read(s,~path ++"melodia2.wav"),
	melodia3:Buffer.read(s,~path ++"melodia3.wav"),
	perc1:Buffer.read(s,~path ++"perc1.wav"),
	perc2: Buffer.read(s,~path ++"perc2.wav"),
	perc3:Buffer.read(s,~path ++"perc3.wav")
		);


)


////Enfoque diccionario

 Task({
 	3.wait;
  	d = Dictionary.new;
  	d.add(\foldernames -> PathName(thisProcess.nowExecutingPath.dirname +/+ "/samples").entries);
	for (0, d[\foldernames].size-1,
		{arg i; d.add(d[\foldernames][i].folderName -> d[\foldernames][i].entries.collect({
			arg sf;
			Buffer.read(s,sf.fullPath);
		});
	)});