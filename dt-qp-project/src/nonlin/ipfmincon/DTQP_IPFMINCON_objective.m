%--------------------------------------------------------------------------
% DTQP_IPFMINCON_objective.m
% Compute objective function value and gradient
%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/dt-qp-project
%--------------------------------------------------------------------------
function [fo,go] = DTQP_IPFMINCON_objective(X,obj,in,opts,Hin,fin)

% extract
p = in.p; t = in.t; np = in.np; nt = in.nt; ini = in.i; param = in.param;
quadrature = opts.dt.quadrature;

% store initial optimization variable vector
Xo = X;

% reshape optimization variables
P = X(end-np+1:end);
X = reshape(X(1:end-np),nt,[]);
P = repelem(P',nt,1);
X = [X,P,repmat(X(1,ini{2}),nt,1),repmat(X(end,ini{2}),nt,1)];

%--------------------------------------------------------------------------
% compute objective
%--------------------------------------------------------------------------
% initialize objective function value
fo = 0;

% handle nonlinear term
if ~isempty(obj)

    % extract
    f = obj.f;

    % calculate objective function values
    fi = DTQP_QLIN_update_tmatrix(f,[],X,param);
    ft = DTQP_tmultiprod(fi,p,t);

    % integrate nonlinear term
    % TODO: add more methods
    switch upper(quadrature)
    case 'CEF'
        error(' ')
    case 'CTR'
        fo = fo + trapz(t,ft);
    case 'CQHS'
        error(' ')
    case 'G'
        fo = fo + (in.tf - in.t0)/2*in.w'*ft;
    case 'CC'
        error(' ')
    end

end

% handle quadratic term
if ~isempty(find(Hin,1))

    % compute intermediate value for the gradient
    XH = Xo'*Hin;

    % add to objective
    fo = fo + XH*Xo;

end

% handle linear term
if ~isempty(find(fin,1))

    % add to objective
	fo = fo + fin'*Xo;

end

%--------------------------------------------------------------------------
% compute gradient
%--------------------------------------------------------------------------
if nargout > 1

    % initial value (use linear term directly)
    go = fin';

    % handle nonlinear term
    if ~isempty(obj)

        % extract
        h = in.h; w = in.w;

        % calculate gradient of objective function values
        Dft = DTQP_jacobian(obj,p,t,X,param,opts.method.derivatives);

        % integrate nonlinear term
        % TODO: add more methods
        switch upper(quadrature)
            case 'CEF'
                error(' ')
            case 'CTR'
                % augment step size vector
                h0 = [0;h/2];

                % compute circshifted step size sums
                H0 = (h0 + circshift(h0,[-1 0]));

                % compute product
                Dft = Dft.*H0;

            case 'CQHS'
                error(' ')
            case 'G'
                % compute product
                Dft = Dft.*w*(in.tf - in.t0)/2;

            case 'CC'
                error(' ')
        end

        % extract submatrices
        Dft_UY = squeeze(Dft(:,:,1:(in.nu+in.ny))); % controls and states
        Dft_P = Dft(:,:,(in.nu+in.ny+1):(in.nu+in.ny+in.np)); % parameters

        % sum parameter jacobian
        Dft_P = sum(Dft_P,1);

        % combine
        Dft = [Dft_UY(:);Dft_P(:)]';

        % add to gradient
        go = go + Dft;

    end

    % handle quadratic term
    if ~isempty(find(Hin,1))

        % add to gradient
        go = go + 2*XH;

    end

end
end