%Griffin Shea
%griffin.shea@carleton.ca
%101082400

%PLEASE USE THE helper.m INCLUDED IN THIS FOLDER (I did not know how to
%access QIT from the outside so I needed to add some functions to helper.m)
initialize();

% Section 3.1
gate = invQFT2();
gate;

% Section 3.2
gate = invQFTN(3);
gate;

% Section 3.3
% unitary operation with the eigenvalue phases 1, 1/2, 1//4, and 1/8
U = [
    1 0 0 0
    0 exp(2*pi*1i*1/2) 0 0
    0 0 exp(2*pi*1i*1/4) 0
    0 0 0 exp(2*pi*1i*1/8)
];
U = lmap(U, {[2, 2], [2, 2]});

% generate the quantum phase estimation gate
qpeGate = QPEMN(2, 2, U);

% run a series of experiments using each eigenvector
runExperiment(state('00'), qpeGate);
runExperiment(state('01'), qpeGate);
runExperiment(state('10'), qpeGate);
runExperiment(state('11'), qpeGate);

function runExperiment(reg2, gate)
    disp("Running QPE with eigenvector:");
    reg2

    buckets = [0 0 0 0];
    experiments = 0;
    for i = 1 : 10000
        % prepare the register
        reg1 = state('00');
        reg = tensor(reg1, reg2);

        %apply QPE gate
        reg = u_propagate(reg, gate);
        if (i == 1)
            disp("example state before measurement:")
            reg
        end

        %measure phi
        [~, b1, reg]=measure(reg, 1);b1=b1-1;
        [~, b2, reg]=measure(reg, 2);b2=b2-1;
        
        % add a drop to the corresponding bucket and increment experiments
        if (b1 == 0 && b2 == 0)
            buckets(1) = buckets(1) + 1;
        elseif (b1 == 0 && b2 == 1)
            buckets(2) = buckets(2) + 1;
        elseif (b1 == 1 && b2 == 0)
            buckets(3) = buckets(3) + 1;
        elseif (b1 == 1 && b2 == 1)
            buckets(4) = buckets(4) + 1;
        end
        experiments = experiments + 1;
    end

    disp("measurements over total experiments for 0,1,2,3:")
    percentage = buckets/experiments*100

end