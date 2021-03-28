function [TP,FN,FP,b_]=QRSdetection_elgendi(nameData,nameAnnotation,ekg)
close all;
b_=0;
tic
fs=360;                      %ecg_3=ecg_filtered,ecg_5=ecg_sqr
N=length(ekg);          
Blockofinterest=zeros(1,N);
[bw,aw] = butter(3,[8,20]/(360/2),'bandpass');
ekg_filtered=filtfilt(bw,aw,ekg);
%figure(1)
%plot(ekg(1:5*360));
%title('EKG signal --100--');
%figure(2)
%plot(ekg_filtered(1:5*360));
%title('Filtrirani EKG signal');
%figure(3)
ekg_sqr=ekg_filtered.^2;
%plot(ekg_sqr(1:5*360));
%title('Kvadrirani EKG signal');
%MAqrs
matrix_i=ones(1,round(0.097*fs))/round(0.097*fs);  %ecg_6=ma_qrs
%ecg_7=ma_beat
ma_qrs=conv(ekg_sqr,matrix_i,'same');
figure(4)
plot(ma_qrs(1:5*360));
title('MAqrs');
%MAbeat
matrix_i=ones(1,round(0.611*fs))/round(0.611*fs);
ma_beat=conv(ekg_sqr,matrix_i,'same');
figure(5)
plot(ma_beat(1:5*360));
title('MAbeat');
z=statistical_mean(ekg_sqr);
beta=0.08;
alfa=beta*z;
%prag THR1
THR1=(ma_beat+alfa);
N=length(ma_qrs);
for i=1:N
    if(ma_qrs(i))>THR1(i)
        Blockofinterest(i)=0.1;
    else
        Blockofinterest(i)=0;
    end
end
n=length(Blockofinterest);
THR2=round(0.097*fs);
a=zeros(1,n);
b=zeros(1,n);
w1=1;
w2=1;
for j=1:n
    if((j==1)&&(Blockofinterest(1)==0.1))
            a(1)=1;
            w1=w1+1;
    end
    if (j==n)
        if (Blockofinterest(j)==0.1)
            b(w2)=j;
        end
    else
       if((Blockofinterest(j)==0)&&(Blockofinterest(j+1)==0.1))
        a(w1)=j+1;
        w1=w1+1;
       end
       if((Blockofinterest(j)==0.1)&&(Blockofinterest(j+1)==0))
        b(w2)=j;
        w2=w2+1;
       end
    end
   
end
a(a==0)=[];
b(b==0)=[];
Blocks=zeros(1,length(a));
for i=1:length(a)
    Blocks(i)=(b(i)+1)-a(i);
end
%figure(6)
%plot(Blockofinterest(1:5*360));
%title('Blokovi interesa');
x=zeros(1,length(a));
y=zeros(1,length(a));
w4=1;
for i=1:length(a)
    if (Blocks(i)>=THR2)
         [y_i2,x_i_index] = max((ekg_filtered((a(i)):(b(i)))));
         x_i_index=x_i_index+a(i)-1;
         if (x(1)==0)%za prvi element
              x(w4)=x_i_index;
              w4=w4+1;
         elseif (abs(x_i_index-x(w4-1))>round(0.3*fs))
                  x(w4)=x_i_index;
                  w4=w4+1;
          end
    end
end
x(x==0)=[];
y(y==0)=[];
x_kon=[];
%y_kon=[];
for i=1:length(x)
    if ((x(i)-round(0.03*fs))<1)
        begin=1;
    else
        begin=(x(i)-round(0.03*fs));
    end
    if ((x(i)+round(0.03*fs))>N)
        e_n_d=N;
    else
        e_n_d=(x(i)+round(0.03*fs));
    end
    [q1_ampl,q1_index]=max((ekg(begin:e_n_d)));
    q1_index=q1_index+begin-1;
        x_kon=[x_kon q1_index];
       % y_kon=[y_kon q1_ampl];

end
b_=toc;
%figure(7)
%plot(ekg(1:5*360));
%hold on;
%plot(x_kon(1:6),y_kon(1:6),'+');
%title('Detektirani QRS kompleks');
[TP,FN,FP] = calculateaccuracy(x_kon,nameAnnotation);
end
