%% Homework 6B
%% Problem 1
clear all; close all; clc

% PART A

x = -1:0.01:3;

t = [0 0.5 0.8];

for z = 1:length(x)
    
    if x(z) < 0
        
        P(z) = 1;
        
    elseif x(z) <= 1
        
        P(z) = 1-x(z);
        
    else
        
        P(z) = 0;
        
    end
    
end

for i = 1:length(t)
    
    for j = 1:length(x)
        
        if x(j) < (0.25*t(i)+2)*t(i)
            
            u(i,j) = 1+0.5*t(i);
    
        elseif x(j) <= (1-t(i))+((0.25*t(i)+2)*t(i))
            
            u(i,j) = (1+0.5*t(i))-((x(j)-((0.25*t(i)+2)*t(i)))/(1-t(i)));
    
        else
            
            u(i,j) = 0.5*t(i);
            
        end
        
    end
    
end

figure(1)
plot(x,P,':',x,u(1,:),'-.',x,u(2,:),'--',x,u(3,:),'-')
axis([-1 3 -0.5 1.75])
legend('P(x)','u @ t=0','u @ t=0.5', 'u @ t=0.8','Location','SouthWest')
xlabel('x'); ylabel('u(x,t)'); title('Solution for Problem 1, Part A')

% PART C

x0 = -2:2;

t0 = 0:0.1:1.5;

for i = 1:length(t0)
    
    for j = 1:length(x0)

        if x0(j) < 0
            
            xc(i,j) = x0(j)+(t0(i)*0.25+2)*t0(i);
            
        elseif x0 <= 1
            
            xc(i,j) = ((1-t0(i))*x0(j))+(t0(i)*0.25+2)*t0(i);
            
        else 
            
            xc(i,j) = x0(j)+(t0(i)*0.25+1)*t0(i);

        end
        
    end
    
end

figure(2)
plot(t0,xc(:,1),':',t0,xc(:,2),'-.',t0,xc(:,3),'--',t0,xc(:,4),'-',t0,xc(:,5),'*-')
xlabel('t'); ylabel('x'); title('Characterisitcs for Problem 1')
legend('x0=-2','x0=-1','x0=0','x0=1','x0=2','Location','NorthWest')

%% Problem 2

x2 = -1:0.01:2;

t2 = [0 0.5 1];

for z2 = 1:length(x2)
    
    if x2(z2) < 0
        
        P2(z2) = 0;
        
    elseif x2(z2) <= 1
        
        P2(z2) = x2(z2)^2;
        
    else
        
        P2(z2) = 1;
        
    end
    
end

for i2 = 1:length(t2)
    
    for j2 = 1:length(x2)
        
        if x2(j2) < -0.5*(t2(i2)^2)
            
            u2(i2,j2) = x2(j2)*t2(i2);
    
        elseif x2(j2) <= 1-0.5*(t2(i2)^2)
            
            u2(i2,j2) = ((x2(j2)+(0.5*(t2(i2)^2)))^2)+x2(j2)*t2(i2);
    
        else
            
            u2(i2,j2) = 1+(x2(j2)*t2(i2));
        end
        
    end
    
end

figure(3)
plot(x2,P2,':',x2,u2(1,:),'-.',x2,u2(2,:),'--',x2,u2(3,:),'-')
legend('P(x)','u @ t=0','u @ t=0.5', 'u @ t=0.8','Location','NorthWest')
xlabel('x'); ylabel('u(x,t)'); title('Solution for Problem 2')

%% Problem 3

x3 = -1:0.01:2;

t3 = [0 0.1 0.3];

for z3 = 1:length(x3)
    
    if x3(z3) < 0
        
        P3(z3) = 1;
        
    else
        
        P3(z3) = exp(-x(z3));
        
    end
    
end

for i3 = 1:length(t3)
    
    for j3 = 1:length(x3)
        
        if x3(j3) < 0
            
            u3(i3,j3) = (-2*x3(j3)*t3(i3))+1;
    
        else
            
            u3(i3,j3) = (-2*x3(j3)*t3(i3))+exp(-x3(j3)*(1-2*t3(i3)));
        end
        
    end
    
end

figure(4)
plot(x3,P3,':',x3,u3(1,:),'-.',x3,u3(2,:),'--',x3,u3(3,:),'-')
legend('P(x)','u @ t=0','u @ t=0.5', 'u @ t=0.8','Location','SouthWest')
xlabel('x'); ylabel('u(x,t)'); title('Solution for Problem 3')


