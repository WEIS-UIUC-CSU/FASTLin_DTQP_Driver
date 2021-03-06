function I = BrysonHo166_F(tf,v0,x0)
%BRYSONHO166_F
%    I = BRYSONHO166_F(TF,V0,X0)

%    This function was generated by the Symbolic Math Toolbox version 6.3.
%    22-Oct-2015 00:01:01

t2 = sin(tf);
t3 = tf.*2.0;
t4 = sin(t3);
t5 = v0.^2;
t6 = x0.^2;
t7 = t2.^2;
I = -(t4.*t5.*(-1.0./2.0)+t4.*t6.*(1.0./2.0)+t5.*tf+t6.*tf+v0.*x0+v0.*x0.*(t7.*2.0-1.0))./(t7-tf.^2);
