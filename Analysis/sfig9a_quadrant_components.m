% Supplementary Fig. 9a: MATLAB components
% Plot the mean reference directions and object coordinates, and assign objects to quadrants.
package_dir = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(package_dir, 'function'));
load(fullfile(package_dir, 'Source_Data', 'sfig9a_quadrant_components.mat'));

ppanglefake = zeros(1,length(pol_mean));
ppanglereal = zeros(1,length(pol_mean));

for i = 1:length(pol_mean)
    temp = angle(mean(exp(1i*pol_mean{i}(1,:,:)),3));
    ppanglefake(i) = temp(1,1);
    ppanglereal(i) = temp(1,2);
end

ppanglemean = angle(mean(exp(1i*[ppanglefake;ppanglereal]),1));

figure
polarplot(repmat(ppanglemean(1),1,length(0:0.1:10)),0:0.1:10);hold on
polarplot(repmat(ppanglemean(2),1,length(0:0.1:10)),0:0.1:10);hold on
polarplot(repmat(ppanglemean(3),1,length(0:0.1:10)),0:0.1:10);hold on

figure;
plot(predimg_axis1,predimg_axis2,'r.');hold on
plot(sc1,sc2,'b.');hold on
plot(repmat([0],1,length(-40:40)),-40:40);hold on
plot(-40:40,repmat([0],1,length(-40:40)));
axis([-40 40 -40 40])
axis square

for tt = 1:2
    if tt == 1
        type = 'fake';
        xx = predimg_axis1;
        yy = predimg_axis2;
    elseif tt == 2
        type = 'real';
        xx = sc1;
        yy = sc2;
    end
    quadrantindex = zeros(length(xx),length(ppanglemean));
    for i = 1:length(ppanglemean)
        ag = -ppanglemean(i);

        sc2_aa = xx*sin(ag) + yy*cos(ag);
        sc1_aa = xx*cos(ag) - yy*sin(ag);

        a = -45*pi/180;
        y2 = sc1_aa*sin(a) + sc2_aa*cos(a);
        x2 = sc1_aa*cos(a) - sc2_aa*sin(a);
        for q = 1:length(y2)
            if x2(q)>0 && y2(q)>0
                quadrantindex(q,i) = 2;
            elseif x2(q)<0 && y2(q)>0
                quadrantindex(q,i) = 3;
            elseif x2(q)<0 && y2(q)<0
                quadrantindex(q,i) = 4;
            elseif x2(q)>0 && y2(q)<0
                quadrantindex(q,i) = 1;
            end
        end
    end
    eval(['quadrantindex_' type ' = quadrantindex;'])
end
