%Griffin Shea
%griffin.shea@carleton.ca
%101082400

% generates a quantum phase estimation gate for a given estimation qubit
% register size m, and unitary operator U of size n
function gate = QPEMN(m, n, U)
    % apply Hadamard to the estimation register
    gate = tensor(hadamardN(m), identityN(n));

    % apply exponentiated controlled U gates
    for i = 1 : m
        controlVec = -1 * ones(m, 1);
        controlVec(m + 1 - i) = 1;
        gate = helper.controlled(U^(2^(i-1)), controlVec) * gate;
    end

    % apply inverse quantum fourier transform
    gate = tensor(invQFTN(m), identityN(n)) * gate;
end

function gate = hadamardN(n)
    if (n == 1)
        gate = helper.H;
    else
        gate = tensor(helper.H, hadamardN(n - 1));
    end
end

function gate = identityN(n)
    if (n == 1)
        gate = helper.I;
    else
        gate = tensor(helper.I, identityN(n - 1));
    end
end
