%function generates a .avi video file using all the .png images in the current directory
function [a] = make_movie1(prefix,movName)

%finding all the .png files in the directory
[times,pngFile] = retrieve_times_files(prefix);

%sorting according to date added
[times,I] = sort(times);
pngFiles = pngFile(I);

%initializing video 
writeObj = VideoWriter(movName);
fps= 12; %frames per second
writeObj.FrameRate = fps;
writeObj.Quality= 100; % video quality (integer 0 < 100)
open(writeObj);
for t= 1:length(pngFiles)
     Frame=imread([pngFile(t).folder '/' pngFiles(t).name]); %converting images to frames for the movie
     writeVideo(writeObj,Frame);
end
close(writeObj);

end
