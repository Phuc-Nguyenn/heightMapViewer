function [pntsArray] = calculateProjection(pntsArray, rotMatrix, params, view)
	%for loop to transform
	for j = 1:+1:params.maxYDimension
			for i = 1:+1:params.maxXDimension
				%transform 3d into 2d using isometric projection equations and matrix
				%algebra
				x = pntsArray(j,i).x * view.xDilation;
				y = pntsArray(j,i).y * view.yDilation;
				z = pntsArray(j,i).z * view.zDilation/5;
				
				%multiplying the rotation matrix to [x,y,z] and
				%discarding the z
				pntsArray(j,i).x = round((rotMatrix(1,1) * x + rotMatrix(1,2) * y + rotMatrix(1,3) * z)) + view.xTransform;
				pntsArray(j,i).y = round((rotMatrix(2,1) * x + rotMatrix(2,2) * y + rotMatrix(2,3) * z)) + view.yTransform;
				pntsArray(j,i).z = 0; %no longer need z's anymore because we will only be using the projected x and y from now on
			end
	end
end