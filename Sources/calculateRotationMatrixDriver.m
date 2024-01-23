%a program that tests whether the output matrix gained from running the calculateRotationMatrix function is correct or not
clc

%input
xTheta = 45;
yTheta = 45;
zTheta = 30;

%expected output:
% 	0.6124   -0.3536    0.7071
%     0.7866    0.3624   -0.5000
%    -0.0795    0.8624    0.5000
rotationMatrix = calculateRotationMatrix(xTheta, yTheta, zTheta);
disp(rotationMatrix);
% result:
%     0.6124   -0.3536    0.7071
%     0.7866    0.3624   -0.5000
%    -0.0795    0.8624    0.5000

%input
xTheta = 0;
yTheta = 0;
zTheta = 0;
%expected output -> identity matrix because we changed nothing
rotationMatrix = calculateRotationMatrix(xTheta, yTheta, zTheta);
disp(rotationMatrix);
% result:
%      1     0     0
%      0     1     0
%      0     0     1

%input
xTheta = 90;
yTheta = 90;
zTheta = 90;
%expected output
%     0   0    1
%     0   -1   0
%     1   0    0
rotationMatrix = calculateRotationMatrix(xTheta, yTheta, zTheta);
disp(rotationMatrix);
% result:
%		0.0000   -0.0000    1.0000
%		0.0000   -1.0000   -0.0000
%		1.0000    0.0000    0.0000 for some reason it has -0 but that
%		should not affect anything