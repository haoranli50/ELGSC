function [A] = normalize_matrix(A)
[nt ns] = size(A);

D1 = sum(A,2);% sum of column nt*1
D2 = sum(A,1);% 1*ns
D1 = sqrt(D1);
D2 = sqrt(D2);

    for i = 1:nt
        if D1(i)~=0
            A(i,:) = A(i,:)/D1(i);
        end
    end
    for i = 1:ns
        if D2(i) ~=0
            A(:,i) = A(:,i)/D2(i);
        end
    end
end