%a function to input data into a 2D array where each element is a struct
%containing a coordinate's x,y,z values.
function [pntsArray] = assignCoordinates(params, FileSingleArray) %takes in params and returns pnts array which is a 2D function
	k = 1;
	for j = 1:+1:params.maxYDimension
		for i = 1:+1:params.maxXDimension %choice was made to use structs instead of just index position j and i because it made it easier to conceptualise for me and do calculations on
		pntsArray(j, i).x = i; %since we know the dimensions of the map we know when how much to move horizontally per line
		pntsArray(j, i).y = j; %we know how many rows there are as well
		pntsArray(j, i).z = FileSingleArray(k); %read down the string to get each z value
		k = k+1;
		end
	end
end