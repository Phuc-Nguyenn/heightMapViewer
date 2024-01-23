%testing this function is just done through running the program on
%different files and seeing that if works

% a function that draws lines between a point and points next to it
% it does this for all points
function [imageArray] = drawLines(imageArray, pntsArray, params)
	for j = 1:params.maxYDimension %goes through pnts array
		for i = 1:params.maxXDimension
			%if current point is in bounds of image -> actually does not
			%need to check this because setline will check it in there we
			%just need to check every point if we check it here then it
			%will not draw line between point on image and out of image,
			%but the line willl still be in the image. 
			%if pntsArray(j,i).x >= 1 && pntsArray(j,i).x <= params.imageSizeX && pntsArray(j,i).y >= 1 && pntsArray(j,i).y < params.imageSizeY
			if i+1<=params.maxXDimension %if not the last column or row
				imageArray = setLine(pntsArray(j,i).x, pntsArray(j,i).y, pntsArray(j,i+1).x, pntsArray(j,i+1).y, params, imageArray);
			end
			if j+1<=params.maxYDimension
				imageArray = setLine(pntsArray(j,i).x, pntsArray(j,i).y, pntsArray(j+1,i).x, pntsArray(j+1,i).y, params, imageArray);
			end
		end
	end
end

%______________________________________________________________________
%Below is called brehensam's line algorithm, it allows us to rasterize
	%a line between two poiints onto computer graphics. the algorithm
	%avoids floating point arithmatic which is very much slower. There is a
	%derivation for it but i cannot write it here in comments. 
	%-> understanding and code was gained from here: https://www.youtube.com/watch?v=RGB-wlatStc&ab_channel=AbdulBari

%function is in the same file because it does not need to be called in
%other files

function [imageArray] = setLine(x1, y1, x2, y2, params, imageArray)
	dx = abs(x2-x1); %calculate the difference in x values
	dy = abs(y2-y1); %calculate the difference in y values
	error = dx - dy; %the error/disparity is the difference between dy and dx -> ie. how much more you need to travel in y than x
	%note that if dy = dx then there would be no error and incrementing it
	%would be simply the diagonal
	%also if dy or dx equals 0 then the error is just how far you are
	%horizontally or vertically. if > 0 then horizontal if < 0 then
	%vertical
	x = x1; %being with x1
	y = y1; %begin with y1
	xStep = -1; %decide if you need to increment left or right
	if (x1 < x2)
		xStep = 1;
	end
	yStep = 1; %decide if you need to increment up or down, essentially getting the direction that you need to travel
	if (y1 < y2)
		yStep = -1; %it is -1 because y increases downwards
	end
	if x >= 1 && y >= 1 && x < params.imageSizeX && y < params.imageSizeY %set the first point outside the while loop and check if in bounds
		imageArray(y, x) = uint8(255);
	end
	while(x ~= x2 || y ~= y2) %while we haven't arrived out our second point yet
		errorTwo = error; %we have to store the error value for the next interation -> never forgets what error is
		if (errorTwo > -dy) %the reason we have to work with -dy is that the coordinate system of the computer is reverse from normal for y ie. moving down is increasing y and moving up is decreasing y 
			error = error - dy; %if we take the x step, we decrease the error
			x = x + xStep; 
		end
		if(errorTwo < dx) %if the error is less than the difference in x,
			error = error + dx; %if we take the y step we increase the error
			y = y - yStep; 
		end
		if x >= 1 && y >= 1 && x < params.imageSizeX && y < params.imageSizeY %if in bounds
			imageArray(y, x) = uint8(255); %put the pixel onto image array
		end
	end
end
%________________________________________________________________________