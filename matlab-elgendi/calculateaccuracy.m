function [TP,FN,FP] = calculateaccuracy(x,a)
    TP=0;
    FN=0;
    FP=0;
    fs=360;
    annotation=[];
    path='annotations\' + string(a)+'.txt';
    
    fileID = fopen(path, 'r');
    A=fscanf(fileID,'%c');
    C = strsplit(A,' ');
    for i= 16:6:length(C)
        if (C{i+1}==('N'))|(C{i+1}==('L'))|(C{i+1}==('R'))|(C{i+1}==('B'))|(C{i+1}==('A'))|(C{i+1}==('a'))|(C{i+1}==('J'))|(C{i+1}==('S'))|(C{i+1}==('V'))|(C{i+1}==('r'))|(C{i+1}==('F'))|(C{i+1}==('e'))|(C{i+1}==('j'))|(C{i+1}==('n'))|(C{i+1}==('E'))|(C{i+1}==('f'))|(C{i+1}==('Q'))|(C{i+1}==('?'))|(C{i+1}==('/'))
        annotation=[annotation (str2num(C{i})+1)];
        end
    end
    fclose(fileID);
    
    a_num = length(annotation);
    x_num = length(x);
    max_samples_vary=round(0.078*fs);
    for i=1:x_num
        beat_flag=0;
        for j=1:a_num
            %diff=(abs(x(i)- str2num(annotation{j})));
            diff=(abs(x(i)-(annotation(j))));
            if diff<=max_samples_vary
                TP=TP+1;
                beat_flag=1;
                break;
            end
        end
        if beat_flag==0
            FP=FP+1;
        end
    end
    
    for i=1:a_num
        annotation_flag=0;
        for j=1:x_num
            %diff=abs(str2num(annotation{i})- x(j));
            diff=abs((annotation(i))- x(j));
            if diff<=max_samples_vary
                annotation_flag=1;
                break;
            end
        end
        if annotation_flag==0
                FN=FN+1;
        end
    end        
end