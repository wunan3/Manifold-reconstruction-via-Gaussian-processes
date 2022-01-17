% data: the points to be fit
% center: set center = data.
% eps, delta: chosen by the user.
% d: dim of the manifold.
% A , rho, sig: paramters in normal GP determined by maximizing the marginal likelihood.

function [M] = Mfit1(data,center,eps,delta,d,A,rho,sig)
% p: dimension of the ambient space.
[k,p]=size(center);

M=[];


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




%C: Combine Ball1 and Ball2 and rotate them so that the basis in U are along the coordinate directions.
C= Ball1*U;



X2=zeros(1,d); 
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
Q1=mean(C(:,d+1:p))+W(m1+1:m,1:m1)/(W(1:m1,1:m1)+sig*eye(m1))*(C(:,d+1:p)-mean(C(:,d+1:p)));
Q2=[X2 Q1];
Q2=Q2*U';
Q2=Q2+center(i,:);
M=[M;Q2];
end

