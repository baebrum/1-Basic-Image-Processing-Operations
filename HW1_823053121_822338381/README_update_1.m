%% Compe565 Homework 1
% February 13th, 2022
% Names: Abraham Carranza (822338381)
%        Ryan Shimizu (823053121)
% Emails: acarranza4510@sdsu.edu
%         rshimizu3229@sdsu.edu
%
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
%       6.2. Simple row/column replication. 

% DONE: 7. Convert the image into RGB format. (5 points) 
% DONE: 8. Display the original and reconstructed images (the image restored from the YCbCr 
%       coordinate). (5 points) 
% DONE: 9. Comment on the visual quality of the reconstructed image for both the upsampling 
%       cases. (5 points) 
% DONE: 10. Measure MSE between the original and reconstructed images (obtained using linear 
%       interpolation only). Comment on the results. (10 points) 
% DONE: 11. Comment on the compression ratio achieved by subsampling Cb and Cr components 
%       for 4:2:0 approach. Please note that you do not send the pixels which are made zero in 
%       the row and columns during subsampling. (5 points) 

clc;	% Clear command window.
clear;
close all;	% Close all figure windows except those created by imtool.
workspace;	% Make sure the workspace panel is showing.

%% 1. Read and display "Flooded_house.jpg"
figure(1);
subplot(2,2,1);
imfinfo("Flooded_house.jpg");
RGB_image = imread("Flooded_house.jpg", "jpg");
imshow(RGB_image);
size(RGB_image);
title("RGB Image");

%% 2. Display each band
% Extracts RGB components
[red_components, green_components, blue_components] = deal(RGB_image); % store image in 3 variables with one line
red_components(:,:,[2,3]) = 0; % set G,B to zero // shows up as red
green_components(:,:,[1,3]) = 0; % set R,B to zero // shows up as green
blue_components(:,:,[1,2]) = 0; % set R,G to zero // shows up as blue

% Displays components
subplot(2,2,2);
imshow(red_components);
title("Red Component");

subplot(2,2,3);
imshow(green_components);
title("Green Component");

subplot(2,2,4);
imshow(blue_components);
title("Blue Component")

%% 3. Convert image from RGB to YCbCr color space
% RGB to YCbCr
YCbCr_image = rgb2ycbcr(RGB_image);

%% 4. Display each band separately (Y, Cb and Cr bands)
% separate components into their own variables and plot them
[Y_components, Cb_components, Cr_components] = imsplit(YCbCr_image);
figure(2);
subplot(2,2,1);
imshow(YCbCr_image);
title("YCbCr Colorspace Image RGB Image");

subplot(2,2,2);
imshow(Y_components);
title("Luminance Y Component");

subplot(2,2,3);
imshow(Cb_components);
title("Cb Component");

subplot(2,2,4);
imshow(Cr_components);
title("Cr Component");

%% 5. Subsample Cb and Cr bands using 4:2:0 and display both bands.
% subsampling is the procedure of removing pixels and reducing image size
Cb_420 = Cb_components(1:2:end,1:2:end);
Cr_420 = Cr_components(1:2:end,1:2:end);

figure(3);
subplot(1,2,1);
imshow(Cb_420);
title("Subsampled Cb 4:2:0");

subplot(1,2,2);
imshow(Cr_420);
title("Subsampled Cr 4:2:0");

%% 6.1 Upsample and display the Cb and Cr bands using linear interpolation

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% scaling up dimensions
upscaleFactor = 2;

elapsed_time_ryan = zeros(300,1);
elapsed_time_abraham = zeros(300,1);


counter = 0;
% linear interpolation
% compute odd rows

while counter < 300
    tic
    upsampled_cb = zeros(size(Cb_420,1)*upscaleFactor, length(Cb_420)*upscaleFactor);
    upsampled_cr = zeros(size(Cr_420,1)*upscaleFactor, length(Cr_420)*upscaleFactor);
    
    % map subsampled pixels to every other col/row of scaled up matrix
    for rows = 1:(height(Cr_420))
        for cols = 1:(width(Cr_420))
            upsampled_cr(rows*upscaleFactor-1,cols*upscaleFactor-1) = Cr_420(rows,cols);
            upsampled_cb(rows*upscaleFactor-1,cols*upscaleFactor-1) = Cb_420(rows,cols);
        end
    end
    
    rcr_cr = upsampled_cr;
    rcr_cb = upsampled_cb;
    li_cr = upsampled_cr;
    li_cb = upsampled_cb;
    
    
    
    for rows = 1:upscaleFactor:(height(li_cr))
        for cols = 2:upscaleFactor:width(li_cr)
            if cols+1>width(li_cr)  % edge case for out of bounds indexing
                li_cr(rows,cols) = li_cr(rows,cols-1);
                li_cb(rows,cols) = li_cb(rows,cols-1);
            else % truncate down for dec answers
                li_cr(rows,cols) = floor((li_cr(rows,cols-1) + li_cr(rows, cols+1))/upscaleFactor);
                li_cb(rows,cols) = floor((li_cb(rows,cols-1) + li_cb(rows, cols+1))/upscaleFactor);
            end
        end
    end
    
    % compute even rows
    for rows = 2:upscaleFactor:(height(li_cr))
        for cols = 1:width(li_cr)
            if rows+1>height(li_cr)  % edge case for out of bounds indexing
                li_cr(rows,cols) = li_cr(rows-1,cols);
                li_cb(rows,cols) = li_cb(rows-1,cols);
            else % truncate down for dec answers
                li_cr(rows,cols) = floor((li_cr(rows-1,cols) + li_cr(rows+1, cols))/upscaleFactor);
                li_cb(rows,cols) = floor((li_cb(rows-1,cols) + li_cb(rows+1, cols))/upscaleFactor);
            end
        end
    end
    
    counter = counter + 1;
    elapsed_time_ryan(counter) = toc;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% scaling up dimensions
counter = 0;
% linear interpolation
% compute odd rows

while counter < 300
    tic
    upsampled_cb = zeros(size(Cb_420,1)*upscaleFactor, length(Cb_420)*upscaleFactor);
    upsampled_cr = zeros(size(Cr_420,1)*upscaleFactor, length(Cr_420)*upscaleFactor);
    
    % map subsampled pixels to every other col/row of scaled up matrix
    for rows = 1:(height(Cr_420))
        for cols = 1:(width(Cr_420))
            upsampled_cr(rows*upscaleFactor-1,cols*upscaleFactor-1) = Cr_420(rows,cols);
            upsampled_cb(rows*upscaleFactor-1,cols*upscaleFactor-1) = Cb_420(rows,cols);
        end
    end
    
    rcr_cr = upsampled_cr;
    rcr_cb = upsampled_cb;
    li_cr = upsampled_cr;
    li_cb = upsampled_cb;
    
    % try
    for cols = 2:upscaleFactor:width(li_cr)-1
        li_cr(:,cols) = floor((li_cr(:,cols-1) + li_cr(:, cols+1))/upscaleFactor);
        li_cb(:,cols) = floor((li_cb(:,cols-1) + li_cb(:, cols+1))/upscaleFactor);
    end
    li_cr(:,cols+2) = li_cr(:,cols+1);
    li_cb(:,cols+2) = li_cb(:,cols+1);
    
    for rows = 2:upscaleFactor:height(li_cr)-1
        li_cr(rows,:) = floor((li_cr(rows-1,:) + li_cr(rows+1, :))/upscaleFactor);
        li_cb(rows,:) = floor((li_cb(rows-1,:) + li_cb(rows+1, :))/upscaleFactor);
    end
    li_cr(rows+2,:) = li_cr(rows+1,:);
    li_cb(rows+2,:) = li_cb(rows+1,:);
    
    
    counter = counter + 1;
    elapsed_time_abraham(counter) = toc;
end

%% 6.2 Upsample and display the Cb and Cr bands using and Simple row/column replication
% row column replication
% complete missing pixels and copy next row
for rows = 1:upscaleFactor:(height(rcr_cr))
    for cols = 2:upscaleFactor:(width(rcr_cr))
        rcr_cr(rows,cols) = rcr_cr(rows,cols-1);
        rcr_cb(rows,cols) = rcr_cb(rows,cols-1);
    end
    rcr_cr(rows+1,:) = rcr_cr(rows,:);
    rcr_cb(rows+1,:) = rcr_cb(rows,:);
end

%% 6.3 Plot results
figure(4);

subplot(3,2,1);
imshow(uint8(li_cb), [0, 255]);
title("Upsampled LI Cb 4:2:0");

subplot(3,2,2);
imshow(uint8(li_cr), [0,255]);
title("Upsampled LI Cr 4:2:0");

subplot(3,2,3);
imshow(uint8(rcr_cb), [0,255]);
title("Upsampled RCR Cb 4:2:0");

subplot(3,2,4);
imshow(uint8(rcr_cr), [0,255]);
title("Upsampled RCR Cr 4:2:0");

subplot(3,2,5);
imshow(Cb_components);
title("Original Cb");

subplot(3,2,6);
imshow(Cr_components);
title("Original Cr");

%% 7 Convert the image into RGB format
reconstructed_img_li = ycbcr2rgb(cat(3,Y_components,li_cb,li_cr));
reconstructed_img_rcr = ycbcr2rgb(cat(3,Y_components,rcr_cb,rcr_cr));

%% 8 Display the original and reconstructed images
figure(5);

subplot(2,2,1);
imshow(reconstructed_img_li);
title("Reconstructed LI Image");

subplot(2,2,2);
imshow(reconstructed_img_rcr);
title("Reconstructed RCR Image");

subplot(2,2,[3,4]);
imshow(RGB_image);
title("Original Image");

%% 9 Comment on the visual quality of the reconstructed image for both
%    upsampling cases.

% A: The visual quality between the two reconstructed images is virtually
%    identical from afar. Only minor differences can be seen in areas that 
%    are well defined, such as the Coke can in the bottom right floating on
%    water. In the RCR image, there is a black outline around the E whereas
%    this is not present in both the LI and original image. This could be
%    due to the fact that there is a black lettering ("diet"?) directly to
%    the left of the E. Since RCR fills the missing pixels by sampling the
%    pixel directly to the left, this makes sense. In the LI image, there
%    is a slight discoloration or "hue" surrounding areas where the
%    difference between pixels is large. Using the same example as before,
%    the E in the LI image has a slight red tint to the white pixels
%    surrounding it whereas this is not present in the original image. This
%    also makes sense since LI fills in the missing pixels with an average
%    of the pixels around it, leading to a "blur" effect on areas with high
%    contrast.

%% 10 Measure MSE between the original and reconstructed images using
%     linear interpolation only, Comment on the results.
MSE = sum(((RGB_image - reconstructed_img_li).^2), 'all')/(width(RGB_image)*height(RGB_image));

% Comment: This number is relatively small considering the size of our
% matrix: 506x704x3. Based on the image from Canvas, this number is 25.1865.
% This low number aligns with our previous observation that all the 
% reconstructed images look roughly the same as the original image. 

%% 11 Comment on the compression ratio achieved by subsampling Cb and Cr 
%     components for 4:2:0 approach.

%   Comment: Using the 4:2:0 approach, we can compress our original image
%   by a factor of essentially 4. This is because we scale down our Cb and 
%   Cr components by 2x2 and then recalculating those missing pixels by virtue
%   of the other surrounding pixels that we didn't throw away. 
%   By "throwing away" some of the redundancy information, we can deploy 
%   either the Linear interpolation or
%   Row column replication technique to reconstruct the compressed image
%   back into its size. As noted by our observations in 9 and
%   10, our losses are very minimal considering how many bits we had
%   actually thrown away in the process of compressing the image.
%   Essentialy despite throwing away 3/4 of the original bits, we are able
%   to reconstruct our original image with impressive quality.


%% Compute Difference of 4 Loops and 2 Loops Matrix Arithmetic linear interpolation
percent_difference = ((abs(elapsed_time_abraham-elapsed_time_ryan))./(elapsed_time_ryan))*100;
percent_difference_avg = mean(percent_difference);