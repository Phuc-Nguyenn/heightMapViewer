%this function draws the coordinates pntsArray onto an imageArray by
%changing imageArray to 255 that corresponds to pntsarray x and y. Also
%must make sure that it is within bounds otherwise it will throw indexing
%error

function [imageArray] = drawPoints(imageArray, pntsArray, params)
	%draw points on image if they are within bounds of the image size
	for i = 1:params.maxYDimension
		for j = 1:params.maxXDimension %loops through pnts Array function note that maxXYDimension is for the pntsArrray (object) and not the image size
			if pntsArray(i,j).x >= 1 && pntsArray(i,j).x <= params.imageSizeX && pntsArray(i,j).y >= 1 && pntsArray(i,j).y <= params.imageSizeY %check if in bounds
				imageArray(pntsArray(i,j).y, pntsArray(i,j).x) = uint8(255);
			end
		end
	end
end