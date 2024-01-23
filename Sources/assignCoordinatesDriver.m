%driver for assignCoordinatesfunction -> is called in the main function
%go to main function and uncomment the line assignCoordinatesDriver(...);

%this is a function because it needs data from the main program
function [] = assignCoordinatesDriver(pntsArray, params)
	for i = 1:params.maxYDimension
		for j = 1:params.maxXDimension %loops through pnts array and prints out the value of x y and z for the ith jth element
			fprintf("%.1f %.1f %.1f\n", pntsArray(i,j).x, pntsArray(i,j).y, pntsArray(i,j).z);
		end
	end
end