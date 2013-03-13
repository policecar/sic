
function zzidx = zigzag(idx)
%ZIGZAG     Reorder index such as to zigzag through a 2-D matrix in
%           accordance with zero-tree specification.

    % instantiate some helper variables
    sz = sqrt(length(idx));
    A = reshape(idx,sz,sz);
    zzidx = zeros(size(idx));
    
    % process top right pixel first
    zzidx(1) = 1;
    
    z = 1;
    i = 2;
    while z < sz,
        
        sub = zeros(4,z,z);
        %sub(1,:,:) = A(1:z,1:z)';          % skip top left
        sub(2,:,:) = A(1:z,z+1:z+z)';       % top right
        sub(3,:,:) = A(z+1:z+z,1:z)';       % bottom left
        sub(4,:,:) = A(z+1:z+z,z+1:z+z)';   % bottom right

        for j = 2:4,
            for c = 1:z,
                for r = 1:z,
                    zzidx(i) = sub(j,r,c);
                    i = i + 1;
                end
            end
        end
        z = z * 2;
    end
    
end