% EAS 4810C Lab 5
% Plot generation

%% Plot drag force vs alpha

clc; clear; close all;

Fd = [1.958206345
1.704549533
1.592962649
1.817184317
2.625310249
4.99126022
5.728481418
10.07077517
13.20591133
14.65105534];

a = [0
3
5
7
8
9
10
11
12
13];

err = 0.3*ones(size(a));

figure;
hold on;
errorbar(a,Fd,err,'both','k.','MarkerSize',15);
ylabel('Drag Force (N)')
xlabel('Angle of Attack (deg)')
grid on;
box off;
matlab2tikz('dragForce.tex','height','\fheight','width','\fwidth')

%% Plot lift force vs alpha

clc; clear; close all;

Fl = [0
27.35742964
38.72684467
49.70505638
55.98542969
66.32375174
73.4976954
65.60831974
63.19365752
61.79559985];

a = [0
3
5
7
8
9
10
11
12
13];

err = 2*ones(size(a));

figure;
hold on;
errorbar(a,Fl,err,'both','k.','MarkerSize',15);
ylabel('Lift Force (N)')
xlabel('Angle of Attack (deg)')
grid on;
box off;
matlab2tikz('liftForce.tex','height','\fheight','width','\fwidth')

%% Plot moment vs alpha

clc; clear; close all;

M = [0
-1.845242185
-1.516790206
-0.9641498
-0.283300244
0.37970687
1.103431109
2.041708102
0.785569658
-2.105218776];

a = [0
3
5
7
8
9
10
11
12
13];

err = 0.1*ones(size(a));

figure;
hold on;
errorbar(a,M,err,'both','k.','MarkerSize',15);
ylabel('Moment (Nm)')
xlabel('Angle of Attack (deg)')
grid on;
box off;
matlab2tikz('moment.tex','height','\fheight','width','\fwidth')

%% Plot CD stuff vs alpha

clc; clear; close all;

CDun = [0.024098266
0.02097669
0.019603469
0.022362807
0.032307843
0.061423923
0.070496385
0.123933934
0.162515846
0.180300215];

CDcor = [0.023524806
0.020477514
0.019136971
0.021830646
0.031539023
0.059962236
0.068818803
0.120984715
0.158648504
0.176009664];

a = [0
3
5
7
8
9
10
11
12
13];

acor = [0
3.051219576
5.083739423
7.117555465
8.140641138
9.173948407
10.19552088
11.17868962
12.17634195
13.1769283];

err = 0.03*ones(size(a));

CD0012 = load('CD_0012.txt','ascii');

orange = '#FA4616';
blue = '#0021A5';

figure;
hold on;
errorbar(a,CDun,err,'both','^','MarkerEdgeColor',orange,'MarkerFaceColor',orange);
errorbar(acor,CDcor,err,'both','square','MarkerEdgeColor',blue,'MarkerFaceColor',blue);
plot(CD0012(:,1),CD0012(:,2),'k-','LineWidth',1.25);
ylabel('C_D')
xlabel('Angle of Attack (deg)')
legend({'Uncorrected','Corrected','XFOIL'},'Location','northwest')
grid on;
box off;
matlab2tikz('CD.tex','height','\fheight','width','\fwidth')

%% Plot CL stuff vs alpha

clc; clear; close all;

CLun = [0
0.336668611
0.476583991
0.611685107
0.688973236
0.816199681
0.904484351
0.807395364
0.777679817
0.760474906];

CLcor = [0
0.32308476
0.457573009
0.586722313
0.658572369
0.77226345
0.853060434
0.74710964
0.709611403
0.689404208];

a = [0
3
5
7
8
9
10
11
12
13];

acor = [0
3.051219576
5.083739423
7.117555465
8.140641138
9.173948407
10.19552088
11.17868962
12.17634195
13.1769283];

err = 0.07*ones(size(a));

CL0012 = load('CL_0012.txt','ascii');

orange = '#FA4616';
blue = '#0021A5';

figure;
hold on;
errorbar(a,CLun,err,'both','^','MarkerEdgeColor',orange,'MarkerFaceColor',orange);
errorbar(acor,CLcor,err,'both','square','MarkerEdgeColor',blue,'MarkerFaceColor',blue);
plot(CL0012(:,1),CL0012(:,2),'k-','LineWidth',1.25);
ylabel('C_L')
xlabel('Angle of Attack (deg)')
legend({'Uncorrected','Corrected','XFOIL'},'Location','northwest')
grid on;
box off;
matlab2tikz('CL.tex','height','\fheight','width','\fwidth')

%% Plot CM stuff vs alpha

clc; clear; close all;

CMun = [0
-0.022708095
-0.018666068
-0.011865112
-0.003486376
0.004672785
0.013579149
0.025125863
0.009667452
-0.025907444];

CMcor = [0
-0.020465173
-0.015734457
-0.008300816
0.00034931
0.008938898
0.017988604
0.028090809
0.013055235
-0.020211753];

a = [0
3
5
7
8
9
10
11
12
13];

acor = [0
3.051219576
5.083739423
7.117555465
8.140641138
9.173948407
10.19552088
11.17868962
12.17634195
13.1769283];

err = 0.005*ones(size(a));

CM0012 = load('CM_0012.txt','ascii');

orange = '#FA4616';
blue = '#0021A5';

figure;
hold on;
errorbar(a,CMun,err,'both','^','MarkerEdgeColor',orange,'MarkerFaceColor',orange);
errorbar(acor,CMcor,err,'both','square','MarkerEdgeColor',blue,'MarkerFaceColor',blue);
plot(CM0012(:,1),CM0012(:,2),'k-','LineWidth',1.25);
ylabel('C_M')
xlabel('Angle of Attack (deg)')
legend({'Uncorrected','Corrected','XFOIL'},'Location','northwest')
grid on;
box off;
matlab2tikz('CM.tex','height','\fheight','width','\fwidth')

%% Monte Carlo for uncorrected lift slope uncertainty

clc; clear; close all;

CL =   [0
0.336668611
0.476583991
0.611685107
0.688973236];

UCL = 0.07*ones(size(CL));

a = [0
3
5
7
8];

Ua = 0.1*ones(size(a));

plotFigure = true;

coeff = polyfit(CL,a,1);
originalSlope = coeff(1)
numPts = 10000;

% Use parfor to speed up computation if necessary
for i = 1:numPts
    xptemp = zeros(1, length(CL));
    yptemp = zeros(1, length(CL));
    for j = 1:length(CL)
        xptemp(j) = norminv(rand,a(j),Ua(j)/2);
        yptemp(j) = norminv(rand,CL(j),UCL(j)/2);
    end
    coeff = polyfit(xptemp,yptemp,1);
    slope(i) = coeff(1);
    ap(i,:) = xptemp;
    CLp(i,:) = yptemp;
end

avgSlope = mean(slope)
stdDevSlope = std(slope)
uncertainty = 1.96*(stdDevSlope/sqrt(numPts))

if plotFigure
    figure;
    ax = gca;
    hold on;
    plot(a,CL,'--ro',...
        'LineWidth',2,...
        'MarkerSize',7.5,...
        'MarkerEdgeColor','k',...
        'MarkerFaceColor','r');
    
    xlabel('alpha')
    ylabel('C_L')

    for i = 1:10
        p(i,:) = polyfit(ap(i,:),CLp(i,:),1);
        trend(i,:) = polyval(p(i,:),a);
        plot(a,trend(i,:),'k');
    end
    grid on;
end
matlab2tikz('monteLift.tex','height','\fheight','width','\fwidth')

%% Monte Carlo for corrected lift slope uncertainty

clc; clear; close all;

CL =   [0
0.32308476
0.457573009
0.586722313
0.658572369];

UCL = 0.07*ones(size(CL));

a = [0
3
5
7
8];

Ua = 0.1*ones(size(a));

plotFigure = true;

coeff = polyfit(CL,a,1);
originalSlope = coeff(1)
numPts = 10000;

% Use parfor to speed up computation if necessary
for i = 1:numPts
    xptemp = zeros(1, length(CL));
    yptemp = zeros(1, length(CL));
    for j = 1:length(CL)
        xptemp(j) = norminv(rand,a(j),Ua(j)/2);
        yptemp(j) = norminv(rand,CL(j),UCL(j)/2);
    end
    coeff = polyfit(xptemp,yptemp,1);
    slope(i) = coeff(1);
    ap(i,:) = xptemp;
    CLp(i,:) = yptemp;
end

avgSlope = mean(slope)
stdDevSlope = std(slope)
uncertainty = 1.96*(stdDevSlope/sqrt(numPts))

if plotFigure
    figure;
    ax = gca;
    hold on;
    plot(a,CL,'--ro',...
        'LineWidth',2,...
        'MarkerSize',7.5,...
        'MarkerEdgeColor','k',...
        'MarkerFaceColor','r');
    
    xlabel('alpha')
    ylabel('C_L')

    for i = 1:10
        p(i,:) = polyfit(ap(i,:),CLp(i,:),1);
        trend(i,:) = polyval(p(i,:),a);
        plot(a,trend(i,:),'k');
    end
    grid on;
end
matlab2tikz('monteLiftCor.tex','height','\fheight','width','\fwidth')

%% Plot velocity profile

clc; clear; close all;

pos = [-8.0
-7.0
-6.0
-5.0
-4.0
-3.0
-2.0
-1.0
0.0
1.0
2.0
3.0
4.0
5.0
6.0
7.0
8.0
1.0
-0.9];

Vel = [17.63302121
17.66766483
17.57029602
17.36951483
17.09044626
16.76010295
15.86014131
14.5694144
14.01914389
15.00864139
16.22321569
16.80958078
17.15024428
17.41338612
17.52997475
17.53175424
17.57363723
15.0918459
14.46785862];

err = 0.04*ones(size(Vel));

figure;
hold on;
errorbar(Vel,pos,err,'k.','MarkerSize',20);
ylabel('Position (cm)')
xlabel('Velocity (m/s)')
grid on;
box off;
matlab2tikz('vProfile.tex','height','\fheight','width','\fwidth')