// Macro to turn .ser's into .tif's
Dialog.create("Folder Clean");
Dialog.addCheckbox(": Delete .emi",1);
Dialog.addCheckbox(": Delete .ser",1);
Dialog.addCheckbox(": Bonus Mini Version",1);

Dialog.show();
emiDel=Dialog.getCheckbox();
serDel=Dialog.getCheckbox();
Mini8=Dialog.getCheckbox();

dir = getDirectory("Choose a Directory");
list = getFileList(dir);

setBatchMode(true);
showStatus("Running...");
for (i=0; i<list.length; i++) {
	path = dir+list[i];
	
	
	if(endsWith(path, ".ser")){//Could be any ending like ".tif" !
		run("TIA Reader", ".ser-reader...=path"); // Uses a plugin to open
							// would be simply "open(path);" for normal image format
//----------------------------- CAN PUT ANY MANIPULTION BETWEEN HERE!!!!
		pathser=path;
		dotIndex = lastIndexOf(path, ".");//Finds the dot and therefore checks the file ends in .something
		if (dotIndex!=-1){
			
			path = substring(path, 0, dotIndex-2); // finds 2 characters before dot to remove "_1.ser" extension
			pathemi=path+".emi";
		}
			
			
//---------------------------- AND HERE!!!!

		save(path+".tif");// could add any ending like 'manipulation.tiff'

//---------------------------- 8bit mini versions			
		if(Mini8==1){
				
				run("Enhance Contrast", "saturated=0.35");
				run("8-bit");
				w=getWidth;
				h=getHeight;
				neww=1024;
				newh=h/(w/neww);
				run("Size...", "width="+neww+" height="+newh+" constrain average interpolation=Bilinear");
				save(path+" mini.tif");
		}


//----------------------------Deletes orginal files if box is checked			
			if(emiDel==1){
				File.delete(pathser);
			}
			if(serDel==1){
				File.delete(pathemi);
			}
//----------------------------			
		
		if(isOpen(list[i])){
			close(); //Closes open image
		}
	}	
}
print("End");
selectWindow("Log");// Selects Log box created by File.delete command
run("Close");// Closes it

showStatus("Done");