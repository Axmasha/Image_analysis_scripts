
//Open image, set path and image-id
//run("Open...");
dir = getDirectory("image"); 
id = getTitle();

// Clean older messages:
print("\\Clear")

 
print(dir); 


baseNameEnd=indexOf(id, ".czi"); 
baseName=substring(id, 0, baseNameEnd);
newDir= dir + "/"+ baseName+ "/"; 
print(newDir); 
File.makeDirectory(newDir); 

      //   saveAs("Tiff",  splitDir + baseName "-AnkG.tif"); 

//ask user to set all ROIs to be analysed, using 'line' selection tool
		
		selectImage(id);			// select image window
		roiManager("Add ALL YOUR ROIs");
		roiManager("Show All");
		roiManager("Show All with labels");
		waitForUser("Please draw all ROIs in all stacks" + "\n" + "! click OK only when done");
		Dialog.create("select your ROIs");

Stack.getDimensions(w, h, channels, slices, frames)
Stack.getPosition(ch, sl, fr)	

print("Channels="+channels);

//take profile from first channel
	for (roi=0 ; roi<roiManager("count"); roi++) {
   		selectImage(id);			// select image window
   		RoiNumber=roi+1;
   		print('Current ROI=' + RoiNumber);
   		roiManager("select", roi); 
   		Stack.setChannel(1);
   	   		Stack.getPosition(ch, sl, fr);	
			print('Current ch=' + ch);
	
		run( "Plot Profile" );

		Plot.getValues( x, y );  //get values of coordinate and intensity

		//waitForUser; // waits to check membrane profile and press ok 
	
		selectImage(id);			// select image window		
		Stack.getDimensions(w, h, channels, slices, frames)
	
//take profile from second channel	
		
		Stack.setChannel(2);
			Stack.getPosition(che, sl, fr);	
			print("Current channel=" + che);
		roiManager("select", roi);
		run( "Plot Profile" );
		Plot.setColor("green");
		Plot.getValues( x, z );

		//waitForUser; // waits to check GFP profile and press ok 
			str = "";
		
		for ( j = 0; j < x.length; j++ ) { str +=  "" + x[j] + "\t" + y[j] + "\t" + z[j] + "\n"; }
		FileNumber=100+RoiNumber;
				File.saveString( str, newDir + FileNumber + ".txt" ); } //getDirectory("current")
		
		
	
		selectImage(id);			// select image window	
		close("\\Others")
