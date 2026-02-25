%Griffin Shea
%griffin.shea@carleton.ca
%101082400

%create inverse quantum Fourier transform for q qubits
%see the recursive definitions in the paper
function gate = invQFTN(q)
    gate = swapperGate(q);
    gate = gate * superInvQFTN(q);
end

function gate = swapperGate(q)
    gate = identityN(q);
    
    %there will be q columns, each made of SWAP filling the entire column,
    %or as much as possible, starting on the second row on odd columns.
    %for example:
    %q=3:
    %   ...S...I...S...
    %   ...S...S...S...
    %   ...I...S...I...
    %q=4:
    %   ...S...I...S...I...
    %   ...S...S...S...S...
    %   ...S...S...S...S...
    %   ...S...I...S...I...

    for i = 0 : q - 1
        remSize = q;
        if (rem(i, 2) == 0)
            remSize = remSize - 2;
            subgate = helper.SWAP;
        else
            remSize = remSize - 1;
            subgate = helper.I;
        end

        while (remSize > 0)
            if (remSize > 1)
                remSize = remSize - 2;
                subgate = tensor(subgate, helper.SWAP);
            else
                remSize = remSize - 1;
                subgate = tensor(subgate, helper.I);
            end
        end

        gate = gate * subgate;
    end
end

function gate = superInvQFTN(q)
    if (q == 1)
        gate = helper.H;
    else
        gate = tensor(helper.I, superInvQFTN(q-1));

        gate = gate * subInvQFTN(q);
    end

end

function gate = subInvQFTN(q)
    if (q == 1)
        gate = helper.H;
    else
        gate = SCPS(q) * tensor(subInvQFTN(q-1), helper.I);
    end
end

function gate = SCPS(q)
    CP = [
        1 0 0 0;
        0 1 0 0;
        0 0 1 0;
        0 0 0 exp(-1i*pi/pow2(q-1));
    ];
    CP = lmap(CP, {[2, 2], [2, 2]});

    if (q == 2)
        gate = CP;
    else
        gate = identityN(q);
        for i = 1 : q - 2
            gate = gate * singleSwap(q, q - i);
        end
        gate = gate * tensor(CP, identityN(q - 2));
        for i = 1 : q - 2
            gate = gate * singleSwap(q, i + 1);
        end
    end
end

function gate = identityN(n)
    if (n == 1)
        gate = helper.I;
    else
        gate = tensor(helper.I, identityN(n - 1));
    end
end

function gate = singleSwap(q, n)
    if (n == 1)
        gate = tensor(helper.SWAP, identityN(q - 2));
    elseif (n == q - 1)
        gate = tensor(identityN(q - 2), helper.SWAP);
    else
        gate = tensor(identityN(n - 1), helper.SWAP, identityN(q - n - 1));
    end
end
