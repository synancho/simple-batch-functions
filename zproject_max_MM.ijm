//Batch z-projection (max) of .ome.tif files acquired from MM
//Created on 2023-11-27
//Contact SoYeon Kim for questions: soyeon.kim@ucsf.edu

//Show all the images opens up
setBatchMode("show"); 

//Assign the input file type and output file type
sourceImgType = ".ome.tif";
resultImgType = ".ome.tif";

//Comanand for enabling Bio-Formats functions
run("Bio-Formats Macro Extensions");

//Choose folders for input and output images
sourceMainDir=getDirectory("Select source directory with input images");								
destDir=getDirectory("Select or create destination directory for output images and data");
waitForUser("Please do not interrupt the process!");

//Listing the subfolders within the main source folder
subfolderList=getFileList(sourceMainDir); 

//Conversion loop
for (i=0; i<subfolderList.length; i++) { //Looping through all the subfolders 	
	print(subfolderList[i]);

	sourceDir = sourceMainDir+subfolderList[i];
	imgList=getFileList(sourceDir); //Listing the files within the subfolder
	
	for (j=0; j<imgList.length; j++) { 	//Looping through all the files	
		if (endsWith(imgList[j],sourceImgType)) {	//Check the file type is .ome.tif		
			zProject(imgList[j], subfolderList[i], sourceDir);
		}
	 					
  } 									

}

waitForUser("Process is now complete!");

function zProject(file, inFileName, inDir) {
	filePath = inDir + file;  //Filepath for the input	
	run("Bio-Formats Importer", "open=[" + filePath + "] color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT use_virtual_stack"); //Import the file
	run("Z Project...", "projection=[Max Intensity]"); //Z projection for max intensity
	
	outFileName = replace(inFileName,"/","");  //Generate the name without the slash	
	outFilePath = destDir + "MAX_" + outFileName + resultImgType; 	//Filepath for the ouput 			
	run("Bio-Formats Exporter", "save=[" + outFilePath + "] compression=Uncompressed"); 	//Exporting using bioformats
	print(outFilePath);  //Print the input file location
	run("Close All"); //Closing two image files
}
