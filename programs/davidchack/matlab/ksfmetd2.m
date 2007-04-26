function [tt, aa, da, fa] = ksfmetd2(a0, d, h, tend, np)
% Solution (with Jacobian) of Kuramoto-Sivashinsky equation 
% by ETDRK4 scheme till given time (using cubic interpolation)
%
% u_t = -u*u_x - u_xx - u_xxxx, periodic BCs on [0, d]
%   h - stepsize,  tend - final time,
%   np - output every np-th step (np = 0 - output only the final value)
%   da - Jacobian, fa - f(a(tend)) obtained from interpolation.
%
%  Computation is based on v = fft(u), so linear term is diagonal.
%  Adapted from: AK Kassam and LN Trefethen, SISC 2005

  if nargin < 5, np = 0; end
  N = length(a0)+2;  Nh = N/2;  % N should be even (preferably power of 2)
  if nargout < 3,
    v = [0; a0(1:2:end-1)+1i*a0(2:2:end); 0; a0(end-1:-2:1)-1i*a0(end:-2:2)];
  else
    v = [zeros(1,N-1); [a0(1:2:end-1)+1i*a0(2:2:end) zeros(Nh-1,N-2)]; ...
         zeros(1,N-1); [a0(end-1:-2:1)-1i*a0(end:-2:2) zeros(Nh-1,N-2)]];
    v(N+2:2*N+1:end) = 1;  v(2*N+2:2*N+1:end) = 1i;
    v(2*N:2*N-1:end) = 1;  v(3*N:2*N-1:end) = -1i; end
  
  k = (2.*pi./d).*[0:Nh-1 0 -Nh+1:-1]';     % wave numbers
  L = k.^2 - k.^4;                          % Fourier multipliers
  E = exp(h*L);  E2 = exp(h*L/2);
  M = 16;                                   % no. of points for complex means
  r = exp(1i*pi*((1:M)-.5)/M);              % roots of unity
  LR = h*L(:,ones(M,1)) + r(ones(N,1),:);
  Q = h*real(mean((exp(LR/2)-1)./LR ,2));
  f1 = h*real(mean((-4-LR+exp(LR).*(4-3*LR+LR.^2))./LR.^3 ,2));
  f2 = h*real(mean((2+LR+exp(LR).*(-2+LR))./LR.^3 ,2));
  f3 = h*real(mean((-4-3*LR-LR.^2+exp(LR).*(4-LR))./LR.^3 ,2));
  aa = a0;  tt = 0;  g = 0.5i*k*N;  nstp = ceil(tend/h);
  if nargout < 3,
    for n = 1:nstp,
      t = n*h;                   Nv = g.*fft(real(ifft(v)).^2);
      a = E2.*v + Q.*Nv;         Na = g.*fft(real(ifft(a)).^2);
      b = E2.*v + Q.*Na;         Nb = g.*fft(real(ifft(b)).^2);
      c = E2.*a + Q.*(2*Nb-Nv);  Nc = g.*fft(real(ifft(c)).^2);
      if n == nstp, v0 = v; end,     % save penultimate 
      v = E.*v + Nv.*f1 + 2*(Na+Nb).*f2 + Nc.*f3;
      if np > 0 & mod(n,np)==0 & n < nstp, 
        y1 = [real(v(2:Nh)) imag(v(2:Nh))]'; 
        aa = [aa, y1(:)];  tt = [tt, t]; end, end
    if np > 0, y1 = [real(v(2:Nh)) imag(v(2:Nh))]'; end
  else
    E =  repmat(E,1,N-1);   E2 = repmat(E2,1,N-1);  Q = repmat(Q,1,N-1);
    f1 = repmat(f1,1,N-1);  f2 = repmat(f2,1,N-1);  f3 = repmat(f3,1,N-1);
    g = [g repmat(2.*g,1,N-2)];
    for n = 1:nstp,
      t = n*h;                   rfv = real(ifft(v));   Nv = g.*fft(repmat(rfv(:,1),1,N-1).*rfv);
      a = E2.*v + Q.*Nv;         rfv = real(ifft(a));   Na = g.*fft(repmat(rfv(:,1),1,N-1).*rfv);
      b = E2.*v + Q.*Na;         rfv = real(ifft(b));   Nb = g.*fft(repmat(rfv(:,1),1,N-1).*rfv);
      c = E2.*a + Q.*(2*Nb-Nv);  rfv = real(ifft(c));   Nc = g.*fft(repmat(rfv(:,1),1,N-1).*rfv);
      if n == nstp, v0 = v; end,     % save penultimate 
      v = E.*v + Nv.*f1 + 2*(Na+Nb).*f2 + Nc.*f3;
      if np > 0 & mod(n,np)==0 & n < nstp,
        y1 = [real(v(2:Nh,1)) imag(v(2:Nh,1))]'; 
        aa = [aa, y1(:)];  tt = [tt,t]; end, end, end
%%% 3rd order interpolation based on derivatives at end points: 
%%% y(s) = y0 + h*y0p*s + (3*(y1-y0)-h*(y1p-2*y0p))*s^2 + (h*(y1p+y0p)-2*(y1-y0))*s^3;
%%% dy/dt = y0p + 2*(3*(y1-y0)/h-(y1p-2*y0p))*s + 3*((y1p+y0p)-2*(y1-y0)/h)*s^2;
  s = (tend-t)./h + 1;

  if nargout < 3, 
    v0p = L(2:Nh).*v0(2:Nh) + Nv(2:Nh);  Nv = g.*fft(real(ifft(v)).^2);
    vp = L(2:Nh).*v(2:Nh) + Nv(2:Nh);
    y0 = reshape([real(v0(2:Nh)) imag(v0(2:Nh))]',[],1);
    y0p = reshape([real(v0p) imag(v0p)]',[],1);
    y1 = reshape([real(v(2:Nh)) imag(v(2:Nh))]',[],1);
    y1p = reshape([real(vp) imag(vp)]',[],1);
    dy = (y1 - y0)./h;
    ys = y0 + h.*(y0p.*s + (3.*dy-y1p-2.*y0p).*s^2 + (y1p+y0p-2.*dy).*s^3);
    if np > 0, aa = [aa, ys];  tt = [tt, tend]; else aa = ys;  tt = tend; end
  else
    v0p = repmat(L(2:Nh),1,N-1).*v0(2:Nh,:) + Nv(2:Nh,:);
    rfv = real(ifft(v));   Nv = g.*fft(repmat(rfv(:,1),1,N-1).*rfv);
    vp = repmat(L(2:Nh),1,N-1).*v(2:Nh,:) + Nv(2:Nh,:);
    y0 = zeros(N-2,N-1);  y0(1:2:end,:) = real(v0(2:Nh,:));  y0(2:2:end,:) = imag(v0(2:Nh,:));
    y0p = zeros(N-2,N-1);  y0p(1:2:end,:) = real(v0p);  y0p(2:2:end,:) = imag(v0p);
    y1 = zeros(N-2,N-1);  y1(1:2:end,:) = real(v(2:Nh,:));  y1(2:2:end,:) = imag(v(2:Nh,:));
    y1p = zeros(N-2,N-1);  y1p(1:2:end,:) = real(vp);  y1p(2:2:end,:) = imag(vp);  
    dy = (y1 - y0)./h;
    ys = y0 + h.*(y0p.*s + (3.*dy-y1p-2.*y0p).*s^2 + (y1p+y0p-2.*dy).*s^3);
    da = ys(:,2:end);
    if nargout > 3, 
      fa = y0p(:,1) + 2.*(3.*dy(:,1)-y1p(:,1)-2.*y0p(:,1)).*s +...
           3.*(y1p(:,1)+y0p(:,1)-2.*dy(:,1)).*s^2; end
    if np > 0, aa = [aa, ys(:,1)];  tt = [tt, tend];
    else aa = ys(:,1);  tt = tend; end
  end