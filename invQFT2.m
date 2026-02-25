%Griffin Shea
%griffin.shea@carleton.ca
%101082400

function gate = invQFT2()
    gate = helper.SWAP;
    gate = gate * tensor(helper.I, helper.H);
    gate = gate * CP(-pi/2);
    gate = gate * tensor(helper.H, helper.I);
end

function gate = CP(phi)
    gate = [
        1 0 0 0;
        0 1 0 0;
        0 0 1 0;
        0 0 0 exp(1i*phi);
    ];
    gate = lmap(gate, {[2, 2], [2, 2]});
end

