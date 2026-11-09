% Supplementary Fig. 10a
% Sort and scale object-space projections to display task-instruction examples.
package_dir = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(package_dir, 'function'));
load(fullfile(package_dir, 'Source_Data', 'sfig10a_instruction_images.mat'));

[~, idxSort] = sort(predimg1_axis1, 'descend');

v = predimg1_axis1(:);
vmin = min(v);
vmax = max(v);

if abs(vmax - vmin) < eps
    vNml = zeros(size(v));
else

    vNml = 100 - (v - vmin) * (200 / (vmax - vmin));
end
vShow = vNml(idxSort);

%% Axis 1 examples

nRow = 4;
nCol = 25;
assert(nRow*nCol == 100, 'nRow*nCol must be 100.');

imgH = 227;
imgW = 227;

bannerH = 32;
rowH = bannerH + imgH;

mosaicH = nRow * rowH;
mosaicW = nCol * imgW;

mosaic = uint8(255 * ones(mosaicH, mosaicW, 3));

for rr = 1:nRow
    for cc = 1:nCol
        k  = (rr-1)*nCol + cc;
        id = idxSort(k);

        tile = imall(:,:,id);
        tile = repmat(tile,1,1,3);

        r0 = (rr-1)*rowH + bannerH + 1;
        c0 = (cc-1)*imgW + 1;
        mosaic(r0:r0+imgH-1, c0:c0+imgW-1, :) = tile;
    end
end

%% Axis 2 examples

figure;
imshow(mosaic); hold on

xShiftRight = 18;
yInBanner   = round(bannerH*0.70);

for rr = 1:nRow
    for cc = 1:nCol
        k = (rr-1)*nCol + cc;
        if k > numel(vShow), continue; end

        xText = (cc-1)*imgW + imgW/2 + xShiftRight;

        yText = (rr-1)*rowH + yInBanner;

        if vShow(k) < 0
            tColor = 'b';
        else
            tColor = 'r';
        end

        text(xText, yText, sprintf('%.0f', vShow(k)), ...
            'Color', tColor, ...
            'FontSize', 12, 'FontWeight', 'bold', ...
            'HorizontalAlignment','center', ...
            'VerticalAlignment','middle');
    end
end
hold off
