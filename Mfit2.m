% data: the points to be fit
% center: set center = data.
% eps, delta: chosen by the user.
% d: dim of the manifold.
% n: number of point to be added into each patch. 
% A , rho, sig:  paramters in normal GP

function [M] = Mfit2(data,center,eps,delta,d,n,A,rho,sig)
% p: dimension of the ambient space.
[k,p]=size(center);

M=[];
% X0: Create n random samples in a d dim unit ball. Those will be scaled to create unlabeled points in each patch.

s = randn(d,n);
r = rand(1,n);
c = r.^(1/d)./sqrt(sum(s.^2,1));
s = bsxfun(@times, s, c); 
X0=s'; 

% Start to fit for each patch

for i=1:k

n1=size(data);

% Find the eps nbhd around a center point.
Ball=[];
for j=1:n1(1)
if norm(data(j,:)-center(i,:))<eps
  Ball=[Ball; data(j,:)];
else
  Ball=Ball;
end
end

% cov: Local covariance matrix for Ball;
n2=size(Ball);
cov=zeros(p);
for j=1:n2(1)
    cov=cov+(Ball(j,:)-center(i,:))'*(Ball(j,:)-center(i,:));
end
cov=cov./n2(1);
[U,S]=eigs(cov,p);


% Find the delta nbhd from data1 around a center point. 
Ball1=[];
for j=1:n1(1)
if norm(data(j,:)-center(i,:))<delta
  Ball1=[Ball1; data(j,:)-center(i,:)];
else
  Ball1=Ball1;
end
end

Ball2=[];
% Find the delta nbhd from M around a center point. 
n3=size(M);
if n3(1)==0
   Ball2=[];
else  
for j=1:n3(1)
if norm(M(j,:)-center(i,:))<delta
  Ball2=[Ball2; M(j,:)-center(i,:)];
else
  Ball2=Ball2;
end
end
end


%C: Combine Ball1 and Ball2 and rotate them so that the basis in U are along the coordinate directions.
a1=size(Ball1);
a2=size(Ball2);
C= [Ball1;Ball2]*U;

% X1: labeled points in the tangent space. X2:  randomly generate n unlabeled points in the ball of radius a;
% a: The radius of the smallest ball containing all labeled points in the tangent space. 
s = randn(d,n);
r = rand(1,n);
c = r.^(1/d)./sqrt(sum(s.^2,1));
s = bsxfun(@times, s, c); 
X0=s'; 

X3=Ball1*U;
X3=X3(:,1:d);
a= diag((X3-mean(X3))*(X3-mean(X3))').^0.5;

% X2=mean(X3)+1.5*sqrt(var(a))*X0;
% X2=zeros(1,d); 
% X2=mean(X3)+mean(a)*X0;
X2=mean(X3)+(mean(a)-sqrt(var(a)))*X0;

X1=C(:,1:d);
%Fit all p-d normal components by normal GP with the same covariance. 

X=[X1;X2];
[m, ~] = size(X) ;
[m1, ~] = size(X1) ;
[m2, ~] = size(X2) ;
[index,distance]= knnsearch(X,X,'k', m);
distance(:,1)=0;
ker = A*exp(-distance.^2/rho);
ii = (1:m)'*ones(1,m);
W = sparse(ii, index, ker, m, m);
Q1=W(m1+1:m,1:m1)/(W(1:m1,1:m1)+sig*diag([ones(a1(1),1);ones(a2(1),1)]))*C(:,d+1:p);
Q2=[X2 Q1];
Q2=Q2*U';
Q2=Q2+center(i,:);

M=[M;Q2];
end

