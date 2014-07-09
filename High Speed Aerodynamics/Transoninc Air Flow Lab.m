%% Transonic Flow Code
clear all
close all
clc

% Dimensionless airfoil data
af_dat = importdata('rae2822lower.dat'); % imported data of lower airfoil surface

% Grid Sizing
dy=0.05; % vertical grid size
dx=0.05; % horiontal grid size

% upper surface airfoil coordinates defined
x_dat=af_dat(:,1)-0.5; % centering airfoil at -0.5m and 0.5m
y_dat=af_dat(:,2); % vertical airfoil coords

% Grid coordinates and spatial coordinates
xI=-4:dx:4; % Grid x & spatial x
y_int=interp1(x_dat,y_dat,xI(71:91)); % interpolated airfoil coordinates
y_j=[zeros(1,70), y_int, zeros(1,70)]; % spatial coordinates of y
y_i=0:dy:8; % grid y

% Known Variables
c=1;  % chord length, meters
t_c=.12; % thickness to chord ratio
L=c/2;  % half chord length, meters
t=t_c*c; % airfoil thickness, meters
% air properties
R=287;     % gas constant
gamma=1.4; % specific wheight

phi=ones(length(xI),length(y_j)); % initial guess of phi
phi_g=ones(length(xI),length(y_j)); % initial phi for calculating error
M_inf=0.8; % free stream mach number

% solve for free stream velocity
T_inf=298.15;  % free stream temp.
a_inf=sqrt(gamma*R*T_inf); % free stream speed of sound
U_inf=M_inf*a_inf; % free stream velocity

% Name sub variables for simplification
k=t_c*U_inf;
a=(gamma+1)/2;

% Calculation of df/dx
for i = 1:length(phi(:,1))
    
    % left boundry values
    if i == 1
        df_dx(i)=(y_j(i+1)-y_j(i))/dy;
        
    % right boundry values
    elseif i == length(phi(:,1))
        df_dx(i)=(y_j(i)-y_j(i-1))/dy;
        
    % middle values 
    else
        df_dx(i)=(y_j(i+1)-y_j(i-1))/(2*dy);
    end
end

% Calculation of phix
for x=1:500 % loop to continously update phi for solution convergence [275 for M=0.4& 500 for M=0.9
for i = 1:length(phi(:,1))
   for j = 1:length(phi(1,:))
  
   % left boundry values
       if i==1
           phix(i,j)=((-3*phi(i,j))+(4*phi(i+1,j))-phi(i+2,j))/(2*dx);
           
   % right boundry values       
       elseif i==length(phi(:,1))
           phix(i,j)=(phi(i-2,j)-(4*phi(i-1,j))+(3*phi(i,j)))/(2*dx);
    
   % middle values        
       else
           phix(i,j)=(phi(i+1,j)-phi(i-1,j))/(2*dx);
           
       end
   end
end

 % Calculation of Doublet
        D = k*(trapz(xI,y_j))+(a*(1/k))*(trapz(trapz(phix.^2))*dx*dy);
        
 % Calculation of B constant in phi equation
        B(i,j)=1-(M_inf^2)-(((M_inf^2)/U_inf)*(gamma+1)*phix(i,j));

 % Phi Calculations
for i = 1:length(phi(:,1))
   for j = 1:length(phi(1,:))       
       
  % Calculate exterior phi, left
       if i==1
           phi(i,j) = (D/(2*pi))*((xI(i))/((xI(i)^2) + ((y_i(j))^2)));
       
  % Calculate exterior phi, right
       elseif i==length(phi(:,1))
           phi(i,j) = (D/(2*pi))*((xI(i))/((xI(i)^2) + ((y_i(j))^2)));
       
  % Calculate exterior phi, top     
       elseif j==length(phi(1,:))
           phi(i,j) = (D/(2*pi))*((xI(i))/((xI(i)^2) + ((y_i(j))^2)));
           
  % Calculate exterior phi, bottom
       elseif j==1 && i~=1 && 1~=length(phi(:,1))
           
           if B > 0
               
  % subsonic case
               phi(i,j)=(((B(i,j)/(dx^2))*(phi(i+1,j)+phi(i-1,j)))+((1/(dy^2))*(phi(i,j+1)+(phi(i,j+1)+(2*dy*U_inf*(df_dx(i)))))))/(2*((B(i,j)/(dx^2))+(1/(dy^2))));
           else 
               
  % supersonic case
               phi(i,j)=(((B(i,j)/(dx^2))*((2*phi(i-1,j))-phi(i-2,j)))-((1/(dy^2))*((phi(i,j+1))+(phi(i,j+1)+(2*dy*U_inf*(df_dx(i)))))))/(2*((B(i,j)/(dx^2))+(1/(dy^2))));          
           end
           
  % Calculate interior of phi
       else 
           
           if B > 0
               
  % subsonic case  
               phi(i,j)=(((B(i,j)/(dx^2))*(phi(i+1,j)+phi(i-1,j)))+((1/(dy^2))*(phi(i,j+1)+phi(i,j-1))))/(2*((B(i,j)/(dx^2))+(1/(dy^2))));
           
  % supersonic case         
           else 
               phi(i,j)=(((B(i,j)/(dx^2))*((2*phi(i-1,j))-phi(i-2,j)))-((1/(dy^2))*((phi(i,j+1))+phi(i,j-1))))/(2*((B(i.j)/(dx^2))+(1/(dy^2))));            
           end
       end
       
    end
end

% error tracker
clc
% error calculation
error=norm(abs(phi-phi_g))
% replaces phi_g as newly iterated value for next loop error calculation
phi_g=phi;

end

% calculate Cp at airfoil
Cp=(-2*phix(:,1))/U_inf;


