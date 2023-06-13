function [C,Z,obj,time] = ELGSC(X,alpha,beta,gamma,anchor_num)

%% Initialize variable
max_iter =15;
[~, sample_num] = size(X);
C = rand(sample_num,anchor_num);
Z = eye(sample_num);
W = zeros(sample_num);
obj  =  [];
time = 0;
options = optimoptions('quadprog','Algorithm','interior-point-convex','Display','off');
%% iterative optimal
for iter = 1:max_iter
    Zold = Z;
    D1 = sum(Z,2);% sum of column nt*1
    D2 = sum(Z,1);% 1*ns
    D1 = sqrt(D1);
    D2 = sqrt(D2);
    for i=1:sample_num
        for j=1:sample_num
            W(i,j)=(norm(((C(i,:)*D1(i)-C(j,:)*D2(j))),'fro'))^2;
        end
    end
    %% cal P
    P = find_projection(C);
    
    %% slover for C
    G = X'*X*P;
    C = gpi(W,alpha*G/(2*beta));
    
    %% slover for Z
    B = (X'*X-beta/2*W)/(1-beta/2+gamma);
    parfor col = 1:sample_num
        Z(:,col) = projection_m(B(:,col),1);
    end
    Z = (Z+Z')/2;
    
    %% cal stop
    obj(iter) = norm(Zold-Z,'fro')^2/norm(Zold,'fro')^2;
    if iter > 2
        if obj(iter) < 10^-5
            fprintf('Warning: STOP at %d: \n', iter);
            break
        end
    end
end
end

function [Ap] = find_projection(A)
[U , ~, V] = svd(A,0);
Ap = U*V';
assert(norm(Ap'*Ap - eye(size(Ap,2)),'fro')<0.000000001,'wrong projection');
end

