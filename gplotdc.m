function gplotdc(A,xy,a,occ,varargin)

% a: if a=0 plot grayscale, else 'a' defines the color {COLOR=['b','r','g','c','y','k','m','w'] "a=1 -> Blue", "a=2 -> Red",...}
% xy=[start_node x coordinate , start_node y coordinate; end_node x coordine, end_node y coordinate]
% A=[0 1;0 0]
% occ: occupancy data for specific link

% Process Inputs
if nargin < 2
    error('Not enough input arguments.');
end
[nr,nc] = size(A);
[n,dim] = size(xy);
if (~n) || (nr ~= n) || (nc ~= n) || (dim < 2)
    eval(['help ' mfilename]);
    error('Invalid input. See help notes above.');
end
params = struct();
for var = 1:2:length(varargin)-2
    params.(varargin{var}) = varargin{var+1};
end

% Parse the Adjacency Matrix
A = double(logical(A));
iA = diag(diag(A));         % self-connecting edges
dA = A.*(1-A');             % directed edges (1-way)
uA = A-dA-iA;               % undirected edges (2-way)

% Make NaN-Separated XY Vectors
[ix,iy] = makeXY(iA,xy);
[dx,dy] = makeXY(dA,xy);
[ux,uy] = makeXY(tril(uA,0),xy);

% Add Curvature to Directed Edges
dX = dx;
dY = dy;
pct = 0.09;
for k = 1:4
    [dX,dY,pct] = makeCurved(dX,dY,pct);
end

% Plot the Graph
plot(ux,uy,'b-',params)
hold on

%%
if (a==0) %grayscale plot
    plot(dX,dY,'color',(1-(occ/(100)))*[1 1 1],params,'Linewidth',2)
else %color plot
    COLOR=['b','r','g','c','y','k','m','w'];
    plot(dX,dY,COLOR(a),params,'Linewidth',2)
end

%%
plot(xy(:,1),xy(:,2),'k.','Markersize',7)

    function [x,y] = makeXY(A,xy)
        if any(A(:))
            [J,I] = find(A');
            m = length(I);
            xmat = [xy(I,1) xy(J,1) NaN(m,1)]';
            ymat = [xy(I,2) xy(J,2) NaN(m,1)]';
            x = xmat(:);
            y = ymat(:);
        else
            x = NaN;
            y = NaN;
        end
    end

    function [X,Y,PCT] = makeCurved(x,y,pct)
        N = length(x);
        if N < 2
            X = x;
            Y = y;
        else
            M = 2*N-1;
            X = zeros(1,M);
            Y = zeros(1,M);
            X(1:2:M) = x;
            Y(1:2:M) = y;
            X(2:2:M-1) = 0.5*(x(1:N-1)+x(2:N))+pct*diff(y);
            Y(2:2:M-1) = 0.5*(y(1:N-1)+y(2:N))-pct*diff(x);
        end
        PCT = 0.5*pct;
    end
end