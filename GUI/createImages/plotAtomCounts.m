function plotAtomCounts(ax,ax2,coor,counts,nameTag,scaleMarker,range,cmap)
% plotAtomCounts - plot the atom counts
%
%   syntax: plotAtomCounts(ax1,ax2,coor,counts,nameTag,scaleMarker,sColBar,range)
%       ax      - handle to axes
%       ax2     - handle to 2nd axes
%       coor    - array with the coordinates
%       counts  - array with the atom counts
%       sColBar - Show colorbar
%       range   - colormap limits of axes (optional)
%       cmap    - colormap (optional)
%

%--------------------------------------------------------------------------
% This file is part of StatSTEM
%
% Copyright: 2016, EMAT, University of Antwerp
% License: Open Source under GPLv3
% Contact: sandra.vanaert@uantwerpen.be
%--------------------------------------------------------------------------

if nargin<5
    nameTag = 'Atom Counts';
end
if nargin<6
    scaleMarker = 1;
end
if nargin<7
    range = [0,max(counts)];
else
    if isempty(range)
        range = [0,max(counts)];
    end
end
if nargin<8
    cmap = colormap('jet');
else
    if isempty(cmap)
        cmap = colormap('jet');
    end
end

c_x = linspace(range(1),range(2),size(cmap,1));
RGBvec = getRGBvec(cmap,c_x,counts,'exact');

% Plot
msize = coorMarkerSize(ax,'s',scaleMarker);
hold(ax, 'on')
h = scatter(ax,coor(:,1),coor(:,2),msize,RGBvec,'filled','Marker','s','ZData',counts,'Tag','atom counts');
hold(ax,'off')


% Add colorbar in second axes
% Check matlab version, and switch opengl
v = version('-release');
v = str2double(v(1:4));
% Old version of MATLAB cannot handle two colormaps, convert image to rgb values
if v<2015
    warning('off','all')
    % Change observation back to original non-rgb image
    child = get(ax,'Children');
    warning('on','all')
    for i=1:length(child)
        if strcmp(get(child(i),'Tag'),'Image')
            obs = get(child(i),'CData');
            if size(obs,3)==1
                minplaneimg = min(min(obs));
                obs = (floor(((obs - minplaneimg) ./ (max(max(obs)) - minplaneimg)) * 255)); 
                obs = ind2rgb(obs,gray(256));
                set(child(i),'CData',obs);
            end
            break
        end
    end
end

colormap(ax2,'jet')
caxis(ax2,range);

% Store reference to histogram
data = get(ax,'Userdata');
set(ax,'Userdata',[data;{nameTag h}])