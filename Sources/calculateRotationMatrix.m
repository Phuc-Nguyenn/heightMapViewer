%function that takes in 3 parameters: how many degrees to rotate by x, how
%many degrees to rotate by y, and how many degrees to rotate by z axis's.
%The out put is a 3x3 matrix (2D array) that corresponds to a rotation of
%the given x y and z. 

function [rotationMatrix] = calculateRotationMatrix(xRotate, yRotate, zRotate)
	xRotate = deg2rad(xRotate); %convert to radians because trig works in rad
	yRotate = deg2rad(yRotate);
	zRotate = deg2rad(zRotate);
	rotateXMatrix = [1 0 0; 0 cos(xRotate) -sin(xRotate); 0 sin(xRotate) cos(xRotate)]; %calculate rotation matrices individually
	rotateYMatrix = [cos(yRotate) 0 sin(yRotate); 0 1 0; -sin(yRotate) 0 cos(yRotate)];
	rotateZMatrix = [cos(zRotate) -sin(zRotate) 0; sin(zRotate) cos(zRotate) 0; 0 0 1];
	rotationMatrix = rotateXMatrix * rotateYMatrix * rotateZMatrix; %multiply them together (matlab does this with * for you) to get final rotation matrix
end