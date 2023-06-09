% LikhithaNScript.m: CVS Homework 1 Assignment
% 9-1-2021 
%% Question 1: matrix addressing and properties%1a create the matrix 
mat1 = [41 36 18; 21 72 7; 2 12 95]
%1b element (2,1)
mat1(2,1)
%1c inverse matrix
mat2= inv(mat1)
%1d sum of column
mat3= sum(mat1)
%1e sum of row 
mat4= sum(mat1,2)
mat5 = sum(mat1')' %taking transpose of mat1 will change columns and rows and viseversa ,mat4&mat5 results are hence the same

%% Question 2:Variable creation and random numbers
%2a. 5x12 zeros matrix
notMuch= zeros(5,12)
%2b. random integer 9-15 ,14x3
Renny= randi([9 15],14,3)
%2c.  normally distributed random number
M = 50;
SD = 10;
Billy = SD.*randn(300,1) + M; 
%2d checking 
mean(Billy)
std(Billy)
histogram(Billy)
%2e 
Fiver= [1:5]
%2f
manyFivers = repmat (Fiver,5,1)

%% Question 3: Linear systems
%1a 
a= inv(mat1)* [20;20;20]
%1b
b= inv(mat1)* [41.1 47.5 95;2.1 50 100;0.2 54.5 109]
%1c
mat1 * mat1

%% Question 4: Loops and logic
%4a 
for i = 1:50
    disp([num2str(i.^2)])
end
%4b
D= zeros(4,4)
c=1; 
for i = 1:4
    for j = 1:4
        D(j,i)= c
        c=c+1;  
    end
end
D=zeros(4,4);
% different method of 4b
for j=1
  for i=1:4
      D(i,1) = i
      D(i,2) = i+4
      D(i,3) = i+8
      D(i,4) = i+12
  end
end
%% Question 5
%calling function
varStats = LikhithaStats (reshape(1:45,9,5));
%To save values to variable statsout
[statsout,szout]=LikhithaStats(varStats);
        

