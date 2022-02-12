% DONE: 1. Read and display the image using Matlab (10 points). 
% DONE: 2. Display each band (Red, Green and Blue) of the image file (15 points) 
%       Hint: Red = I[:][:][1] captures the read component of the image and stores it into 
%       array Red.    
% DONE: 3. Convert the image into YCbCr color space: (5 points) 
%       3.1. Matlab provides a command “rgb2ycbcr” to convert an RGB image into a 
%       YCbCr image.  
%       3.2. Matlab also provides a command "ycbcr2rgb" to convert a YCbCr image into 
%       RGB format.   
% DONE: 4. Display each band separately (Y, Cb and Cr bands). (10 points) 
% DONE: 5. Subsample Cb and Cr bands using 4:2:0 and display both bands. (10 points) 
% DONE: 6. Upsample and display the Cb and Cr bands using: (15 points) 
%       6.1. Linear interpolation 
%       6.2. Simple row or column replication. 

% TODO: 7. Convert the image into RGB format. (5 points) 
% TODO: 8. Display the original and reconstructed images (the image restored from the YCbCr 
%       coordinate). (5 points) 
% TODO: 9. Comment on the visual quality of the reconstructed image for both the upsampling 
%       cases. (5 points) 
% TODO: 10. Measure MSE between the original and reconstructed images (obtained using linear 
%       interpolation only). Comment on the results. (10 points) 
% TODO: 11. Comment on the compression ratio achieved by subsampling Cb and Cr components 
%       for 4:2:0 approach. Please note that you do not send the pixels which are made zero in 
%       the row and columns during subsampling. (5 points) 


% Read and display the image using Matlab (10 points). 
% EXAMPLE
% imfinfo('landscape.jpg')
% RGBImage = imread(‘landscape.jpg’,’jpg’);
% imshow(RGBImage);
% size(RGBImage)

clc;	% Clear command window.
clear;
close all;	% Close all figure windows except those created by imtool.
workspace;	% Make sure the workspace panel is showing.

%% 1. shows project 1 image
% figure(1);
subplot(2,2,1);
imfinfo("Flooded_house.jpg");
RGB_image = imread("Flooded_house.jpg", "jpg");
imshow(RGB_image);
size(RGB_image);
title("RGB Image");

%% 2. Display each band
% Extracts RGB components

% store image in 3 variables with one line
[red_components, green_components, blue_components] = deal(RGB_image);
red_components(:,:,[2,3]) = 0; % set G,B to zero // shows up as red
green_components(:,:,[1,3]) = 0; % set R,B to zero // shows up as green
blue_components(:,:,[1,2]) = 0; % set R,G to zero // shows up as blue

% ****** REVIEW ******
% shows up as gray scale images
% red_components = RGB_image(:,:,1);
% green_components = RGB_image(:,:,2);
% blue_components = RGB_image(:,:,3);

% Displays components
% figure(2);
subplot(2,2,2);
imshow(red_components, []);
title("Red Component");
% figure(3);
subplot(2,2,3);
imshow(green_components, []);
title("Green Component");
% figure(4)
subplot(2,2,4);
imshow(blue_components, []);
title("Blue Component")

%% 3. Convert image from RGB to YCbCr color space
YCbCr_image = rgb2ycbcr(RGB_image);
% figure(5);
% figure(2);
% imshow(YCbCr_image, []);
% title("YCbCr Colorspace Image of Figure 1");

% separate components into their own variables and plot them
[Y_components, Cb_components, Cr_components] = imsplit(YCbCr_image);
% figure(3);
figure(2);
subplot(2,2,1);
imshow(YCbCr_image, []);
title("YCbCr Colorspace Image RGB Image");
subplot(2,2,2);
imshow(Y_components, []);
title("Luminance Y Component");
subplot(2,2,3);
imshow(Cb_components, []);
title("Cb Component");
subplot(2,2,4);
imshow(Cr_components, []);
title("Cr Component");

% %% 5. Subsample Cb and Cr bands using 4:2:0 and display both bands.
% % create System object for Sampling
% % https://www.mathworks.com/help/vision/ref/vision.chromaresampler-system-object.html#mw_57bd7bcc-9f89-491f-b859-bdd3b7029323
% 
% % subsampling is the procedure of removing pixels and reducing image size
% 
% % setting up subsample using 4:2:0
% resampler = vision.ChromaResampler;
% resampler.Resampling = '4:4:4 to 4:2:0 (MPEG1)';
% % apply subsample to Cb and Cr components
% [Cb_components_subsampled, Cr_components_subsampled] = resampler(Cb_components, Cr_components);
% % plot
% figure(3);
% subplot(3,2,1);
% imshow(Cb_components_subsampled, []);
% title("Cb 4:2:0 Subsampling");
% subplot(3,2,2);
% imshow(Cr_components_subsampled, []);
% title("Cr 4:2:0 Subsampling");
% 
% %% 6.1 Upsample and display the Cb and Cr bands using linear interpolation
% % setting up upscale using linear interpolation
% release(resampler);
% resampler.Resampling = '4:2:0 (MPEG1) to 4:4:4';
% resampler.InterpolationFilter = "Linear"; % LINEAR IS THE DEFAULT
% % apply upsample to Cb and Cr components
% [Cb_components_upsample_lint_int, Cr_components_upsample_lin_int] = resampler(Cb_components_subsampled, Cr_components_subsampled);
% % plot
% subplot(3,2,3);
% imshow(Cb_components_upsample_lint_int, []);
% title("Cb Lin. Int. Upsampling.");
% subplot(3,2,4);
% imshow(Cr_components_upsample_lin_int, []);
% title("Cr Lin. Int. Upsampling");
% %% 6.2 Upsample and display the Cb and Cr bands using Simple row or column replication
% % setting up upsample using pixel replication
% release(resampler);
% resampler.Resampling = '4:2:0 (MPEG1) to 4:4:4';
% resampler.InterpolationFilter = 'Pixel replication';
% % apply upsample to Cb and Cr components
% [Cb_components_upsample_pix_rep, Cr_components_upsample_pix_rep] = resampler(Cb_components_subsampled, Cr_components_subsampled);
% % plot
% subplot(3,2,5);
% imshow(Cb_components_upsample_pix_rep, []);
% title("Cr Pix. Rep. Upsampling");
% subplot(3,2,6);
% imshow(Cr_components_upsample_pix_rep, []);
% title("Cr Pix. Rep. Upsampling");