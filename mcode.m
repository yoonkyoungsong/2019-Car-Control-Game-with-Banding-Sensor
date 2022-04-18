%% Program Initialization
instrreset; clear all; close all; clc;
fprintf('Program setting ');
global V_L V_R time_stack mydaq;         % DAQ  
global FLAG_START Rate_Plot TYPE_TRACK;  % CarModel
global mydaq close_data1 close_data2 close_data3 open_data1 open_data2 open_data3 flt_data_1 flt_data_2 flt_data_3


Rate_Plot = 20;

mydaq = daq.createSession('ni');
mydaq.Rate = 1000;
mydaq.IsContinuous = 1;
mydaq.NotifyWhenDataAvailableExceeds = mydaq.Rate/Rate_Plot;

ch0 = addAnalogInputChannel(mydaq, 'Dev2', 'ai0', 'Voltage') ;
ch1 = addAnalogInputChannel(mydaq, 'Dev2', 'ai1', 'Voltage') ;
ch2 = addAnalogInputChannel(mydaq, 'Dev2', 'ai3', 'Voltage') ;

ch0.Range = [-10.0 10.0];   ch0.TerminalConfig = 'SingleEnded';
ch1.Range = [-10.0 10.0];   ch1.TerminalConfig = 'SingleEnded';
ch2.Range = [-10.0 10.0];   ch2.TerminalConfig = 'SingleEnded';

'finish'

%% calibration
f=440; d=1; fs=44100; n=d*fs;
t=(1:n)/fs; y=sin(2*pi*f*t);
sound(y,fs)
disp('calibration start')
disp('손을 펴세요')

pause(2)
data_bend1_calib=[];
data_bend2_calib=[];
data_bend3_calib=[];

for i=1:500
    data = inputSingleScan(mydaq);
    data_bend1_calib=[data_bend1_calib data(1)];
    data_bend2_calib=[data_bend2_calib data(2)];
    data_bend3_calib=[data_bend3_calib data(3)];
end

open_data1 = mean(data_bend1_calib);
open_data2 = mean(data_bend2_calib);
open_data3 = mean(data_bend3_calib);

sound(y,fs)
disp('주먹을 쥐세요')

pause(2)
data_bend1_calib=[];
data_bend2_calib=[];
data_bend3_calib=[];

for i=1:500
    data = inputSingleScan(mydaq);
    data_bend1_calib=[data_bend1_calib data(1)];
    data_bend2_calib=[data_bend2_calib data(2)];
    data_bend3_calib=[data_bend3_calib data(3)];
end

close_data1 = mean(data_bend1_calib);
close_data2 = mean(data_bend2_calib);
close_data3 = mean(data_bend3_calib);


[open_data1 open_data2 open_data3 close_data1 close_data2 close_data3]

%% Filter 초기값 지정 (7개단위)

ini_data = inputSingleScan(mydaq);

flt_data_1 = [];
for i=1:6
    data=inputSingleScan(mydaq);
    flt_data_1 = [flt_data_1 ini_data(1)]
end

flt_data_2 = [];
for i=1:6
    data=inputSingleScan(mydaq);
    flt_data_2 = [flt_data_2 ini_data(2)]
end

flt_data_3 = [];
for i=1:6
    data=inputSingleScan(mydaq);
    flt_data_3 = [flt_data_3 ini_data(3)]
end

%% 실시간 데이터 받기

lh = addlistener(mydaq, 'DataAvailable', @RunCarModel);
fprintf('DONE\n\nREADY\n\n');
load('TrackData_TrackA.mat');
load('TrackData_TrackB.mat');
load('TrackData_TrackC.mat');
load('TrackData_TrackD.mat');
load('TrackData_TrackE.mat');

%% Track Trial Start
% Available Track : A, B, C, D, E
TYPE_TRACK = 'E';
StartCarModel(mydaq,TYPE_TRACK);

%% Track Trial Finish
FinishCarModel(mydaq,TYPE_TRACK); 
close all; 
