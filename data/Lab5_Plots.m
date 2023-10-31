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
    
figure;
hold on;
plot(a,Fd,'k.','MarkerSize',15);
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
    
figure;
hold on;
plot(a,Fl,'k.','MarkerSize',15);
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
    
figure;
hold on;
plot(a,M,'k.','MarkerSize',15);
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

CD0012 = load('CD_0012.txt','ascii');

orange = '#FA4616';
blue = '#0021A5';

figure;
hold on;
plot(a,CDun,'^','MarkerEdgeColor',orange,'MarkerFaceColor',orange);
plot(acor,CDcor,'square','MarkerEdgeColor',blue,'MarkerFaceColor',blue);
plot(CD0012(:,1),CD0012(:,2),'k-','LineWidth',1.25);
ylabel('C_D')
xlabel('Angle of Attack (deg)')
legend({'Experimental Without Correction','Experimental With Correction','XFOIL'},'Location','northwest')
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

CL0012 = load('CL_0012.txt','ascii');

orange = '#FA4616';
blue = '#0021A5';

figure;
hold on;
plot(a,CLun,'^','MarkerEdgeColor',orange,'MarkerFaceColor',orange);
plot(acor,CLcor,'square','MarkerEdgeColor',blue,'MarkerFaceColor',blue);
plot(CL0012(:,1),CL0012(:,2),'k-','LineWidth',1.25);
ylabel('C_L')
xlabel('Angle of Attack (deg)')
legend({'Experimental Without Correction','Experimental With Correction','XFOIL'},'Location','northwest')
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

CM0012 = load('CM_0012.txt','ascii');

orange = '#FA4616';
blue = '#0021A5';

figure;
hold on;
plot(a,CMun,'^','MarkerEdgeColor',orange,'MarkerFaceColor',orange);
plot(acor,CMcor,'square','MarkerEdgeColor',blue,'MarkerFaceColor',blue);
plot(CM0012(:,1),CM0012(:,2),'k-','LineWidth',1.25);
ylabel('C_M')
xlabel('Angle of Attack (deg)')
legend({'Experimental Without Correction','Experimental With Correction','XFOIL'},'Location','northwest')
grid on;
box off;
matlab2tikz('CM.tex','height','\fheight','width','\fwidth')