function B = StrainDisp(XY,A2)
    B = zeros(3,6);    
    index = [1 2 3 1 2];
    for j = 1:3
        B(1,2*j-1) = XY(index(j+1),2)-XY(index(j+2),2);
        B(2,2*j) = XY(index(j+2),1)-XY(index(j+1),1);
        
        B(3,2*j-1) = XY(index(j+2),1)-XY(index(j+1),1);
        B(3,2*j) = XY(index(j+1),2)-XY(index(j+2),2);
    end
    B = B/A2;
end