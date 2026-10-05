

// This macro performs stack registration (http://bigwww.epfl.ch/thevenaz/stackreg/) and/or image stabilization (https://www.cs.cmu.edu/~kangli/code/Image_Stabilizer.html) in batch.
// Before run, please make sure you have installed the plugins below:
// (i) StackReg_.jar
// (ii) TurboReg_.jar
// (iii) Image_Stabilizer.class
// (iv) Image_Stabilizer_Log_Applier.class
// 
// The input folder should consist of multiple .tif files. Each .tif file is a 1 channel 2d movie.
// 
// Written by hui ting, 22 July 2021.


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

stack_reg = 1; // if stack_reg = 1, do stack registration.
stack_stb = 1; // if stack_stb = 1, do stack stabilization.

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

dir_input = getDirectory("Select input folder that consists of multiple .tif files");

list = getFileList(dir_input);

if (stack_stb==1){
dir_output_stb = dir_input+"stabilized";
File.makeDirectory(dir_output_stb);
}

if (stack_reg==1){
dir_output_reg = dir_input+"registered";
File.makeDirectory(dir_output_reg);
}


if (stack_stb!=1){
setBatchMode(true);
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


for (i = 0; i < list.length; i++) {

	if (endsWith(list[i], ".tif")){
		
filename = list[i];
open(dir_input+filename);
rename(filename);

if (stack_stb==1){
selectWindow(filename);
setSlice(round(nSlices/2));
run("Image Stabilizer", "transformation=Translation maximum_pyramid_levels=1 template_update_coefficient=0.90 maximum_iterations=200 error_tolerance=0.0000001 output_to_a_new_stack");
output_filename_stb = replace(filename, ".tif", "_stb.tif");
saveAs("Tiff", dir_output_stb+File.separator+output_filename_stb);
}

if (stack_reg==1){
selectWindow(filename);
setSlice(round(nSlices/2));
run("StackReg ", "transformation=Translation");
output_filename_reg = replace(filename, ".tif", "_reg.tif");
saveAs("Tiff", dir_output_reg+File.separator+output_filename_reg);
}


run("Close All");

				
	}
}

			






