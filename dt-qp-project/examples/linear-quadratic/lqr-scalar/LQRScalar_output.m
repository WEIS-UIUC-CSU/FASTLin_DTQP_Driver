%--------------------------------------------------------------------------
% LQRScalar_output.m
% Output function for LQRScalar example
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/dt-qp-project
%--------------------------------------------------------------------------
function [O,sol] = LQRScalar_output(T,U,Y,P,F,in,opts)

% extract parameter structure
p = in.p;

% constants
c1 = LQRScalar_C1(p.a,p.b,p.q,p.r);
c2 = LQRScalar_C2(p.a,p.b,c1,p.m,p.r,in.tf);
c3 = LQRScalar_C3(c1,c2,p.r,in.t0,p.x0);

% solution on T
sol(1).T = T;
sol(1).U = real(LQRScalar_U(p.a,p.b,c1,c2,c3,p.r,T));
sol(1).Y = real(LQRScalar_Y(c1,c2,c3,p.r,T));
sol(1).F = real(LQRScalar_F(p.a,p.b,c1,c2,c3,p.m,p.q,p.r,in.t0,in.tf));

% solution on high resolution T
if opts.general.plotflag
    sol(2).T = linspace(in.t0,in.tf,1e4)';
    sol(2).U = real(LQRScalar_U(p.a,p.b,c1,c2,c3,p.r,sol(2).T));
    sol(2).Y = real(LQRScalar_Y(c1,c2,c3,p.r,sol(2).T));
    sol(2).F = sol(1).F;
end

% errors
errorU = abs(U-sol(1).U);
errorY = abs(Y-sol(1).Y);
errorF = abs(F-sol(1).F);

% outputs
O(1).value = max(errorY(:,1));
O(1).label = 'Xmax';
O(2).value = max(errorU(:,1));
O(2).label = 'Umax';
O(3).value = max(errorF);
O(3).label = 'F';
O(4).value = max(in.QPcreatetime);
O(4).label = 'QPcreatetime';
O(5).value = max(in.QPsolvetime);
O(5).label = 'QPsolvetime';

end