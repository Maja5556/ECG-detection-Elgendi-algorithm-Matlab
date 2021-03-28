path_to_data='database/';
path_to_annotation='annotations/';
MyFolderInfoData = dir(path_to_data);
MyFolderInfoAnnotation = dir(path_to_annotation);
TP=0;
FN=0;
FP=0;
num=0;
TP_sum=0;
FN_sum=0;
FP_sum=0;
Se_sum=0;
P_sum=0;
duration=0;
time_duration=0;
ID = fopen('accuracy.txt', 'w');
fprintf(ID,'Signal    TP    FP    FN     Se    +P    execution_time \r\n');
all_signal=0;
one_or_all = ('Do you want to load ONE or ALL signal?\n');
x=lower(input(one_or_all,'s'));
if x == "one"
    signal = input('Which? Need to give signal number!\n','s')
    data_length=1;
    EKG_data=load(path_to_data+string(signal));
    if (string(signal)=='200')|(string(signal)=='108')
       ekg=(EKG_data.val(1,:))*(-1);    
    elseif (string(signal)=='114')
       ekg=(EKG_data.val(2,:));
    else
       ekg=(EKG_data.val(1,:));  
    end
    [TP,FN,FP,duration]=QRSdetection_elgendi(string(signal),string(signal),ekg);
    Se= TP/(TP+FN);
    P=TP/(TP+FP);
    TP_sum=TP;
    FN_sum=FN;
    FP_sum=FP;
    Se_sum=Se;
    P_sum=P;
    time_duration=duration;
    num=1;
    fprintf(ID,'%5d   %4d  %4d  %4d   %4.3f   %4.3f   %4.3f  \r\n',str2num(signal), TP,FP,FN,Se,P,duration);
elseif x == "all"
    all_signal = 1;
    size_d=numel(MyFolderInfoData); 
    size_a=numel(MyFolderInfoAnnotation);
end
if all_signal==1
    for i=3:size_d
    data_length=size_d;
    nameData=str2num(MyFolderInfoData(i).name(1:3));
    nameData=MyFolderInfoData(i).name(1:3);
    
    nameAnnotation=MyFolderInfoAnnotation(i).name(1:3);
    EKG_data=load(path_to_data+string(nameData));
    if (string(nameData)=='200')|(string(nameData)=='108')
       ekg=(EKG_data.val(1,:))*(-1);    
    elseif (string(nameData)=='114')
       ekg=(EKG_data.val(2,:));
    else
       ekg=(EKG_data.val(1,:));  
    end
    [TP,FN,FP,duration]=QRSdetection_elgendi(string(nameData),string(nameAnnotation),ekg);
    Se= TP/(TP+FN);
    P=TP/(TP+FP);
    fprintf(ID,'%5d   %4d  %4d  %4d   %4.3f   %4.3f   %4.3f  \r\n',str2num(nameData), TP,FP,FN,Se,P,duration);
    TP_sum=TP_sum + TP;
    FN_sum=FN_sum + FN;
    FP_sum=FP_sum + FP;
    num=num+1;
    time_duration=time_duration+duration;
    end
end
P_mean=TP_sum/(TP_sum+FP_sum);
Se_mean=TP_sum/(TP_sum+FN_sum);
duration_sum=time_duration / num;
fprintf(ID,'Total: %4d  %4d  %4d  %4.3f   %4.3f   %4.3f \r\n', TP_sum, FP_sum, FN_sum, Se_mean, P_mean, duration_sum);
fclose(ID); 