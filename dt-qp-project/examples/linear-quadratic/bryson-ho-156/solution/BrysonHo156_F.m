function I = BrysonHo156_F(c,t0,tf,v0,w,x0)
%BRYSONHO156_F
%    I = BRYSONHO156_F(C,T0,TF,V0,W,X0)

%    This function was generated by the Symbolic Math Toolbox version 8.0.
%    19-Dec-2017 11:48:06

t2 = t0-tf;
t3 = t2.*w;
t7 = w.^2;
t8 = cos(t3);
t10 = sin(t3);
t4 = t7.*t8.*x0.*-4.0+t10.*v0.*w.*4.0;
t5 = t2.*w.*2.0;
t6 = sin(t5);
t9 = 1.0./w;
t11 = t8.*x0-t9.*t10.*v0;
I = t4.^2.*(t0.*(-1.0./2.0)+tf.*(1.0./2.0)+t6.*t9.*(1.0./4.0)).*1.0./(-t5+t6+(t7.*w.*4.0)./c).^2.*(1.0./2.0)+c.*t11.^2.*1.0./(c.*t7.*w.*(t5-t6).*(1.0./4.0)-1.0).^2.*(1.0./2.0);
