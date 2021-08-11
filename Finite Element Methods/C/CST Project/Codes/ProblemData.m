% GEOMETRY DETAILS
WallHeight = 5.1; % in m
WallWidth = 0.35; % in m
Thickness = 1; % unit thickness

% CONCRETE DETAILS
E = 5000*sqrt(25)*1e6; % in N/m^3
nu = 0.1; % Poisson's ratio
GammaConcrete = 24e3; % N/m^3

% SOIL (COHESIONLESS C = 0)
Phi = 26; % in degree
GammaSoil = 18e3; % N/m^3

% EARTH PRESSURE CALCULATION
Ka = (1-sin(Phi/180*pi))/(1+sin(Phi/180*pi)); % coefficient of active earth pressure
TractionWallRight = @(y)-Ka*GammaSoil*(WallHeight-y); % traction variation on right face

% CONSTITUTIVE MATRIX
D = E/(1+nu)/(1-2*nu)*[1-nu nu 0;nu 1-nu 0;0 0 (1-2*nu)/2]; % constitutive relation for plane strain problem