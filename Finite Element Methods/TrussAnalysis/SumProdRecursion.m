function sp = SumProdRecursion(x,num_prod)

num_term = numel(x);

if num_prod>num_term, error('num_prod cannot be more than num_term'); end

if num_prod == 0
    sp = 1;
elseif num_prod == 1
    sp = sum(x);
else
    sp = 0;
    for i = 1:num_term-num_prod+1
        sp = sp + x(i)*SumProdRecursion(x(i+1:num_term),num_prod-1);
    end
end

end