%This Script calculates 
%1) Gm - avarage Green intensity on the membrane region (0,8um around the red peak). 
%2) Gcyto - avarage Green intensity in the cytoplasmic region (2um length from membrane into the cell). 

%3) calculates ratio Gm/Gcyto 

%Script eliminates profiles in which: 1) there is obvious green speckle = max green
% intensity is >> max red intensity; 2) Green intensity is too low, <1.5 of
% background level. 3) Ratio Gmemb/Gcyto is <0; 4) Membrane signal
% is much wider than 1um (peak red-channel signal at membrane is<= 1.5*mean cytoplam signal)

clear all

d = '1*.txt'; 
files = dir(d)
N=length(files) %number of all txt files in this folder (all ROIs in all images from 1 genotype)
fileID = fopen('Results_mem_to_cyto_ratio.txt','w');
%A=load('1p0.txt')
for id=1:N
    A=load(files(id).name);
    Name=files(id).name;
    figure 
    plot(A(:,1), A(:,2), 'magenta', 'LineWidth',2);
    title(files(id).name);
    hold on
    %find a peak in Y (red channel)
    [M,I]=max(A(:,2))
    
     %Avearge of the green background (z)
     %Background_G=mean(A(I-30:I-10,3));
     edge=max(1,(I-30));
     Background_G=mean(A(edge:(I-10),3));
     
     %Substract background from Green channel
     G=A(:,3)-Background_G;
     
     %Average intensity on membrane 
     Gm=mean(G((I-4):(I+4)))
     
     %Average intensity in cytoplasm, not on membrane 
     Cyto=min((I+25), size(G)); % cytoplasm signal is calculated in 2um-long piece of profile immediately to the right of membrane edge
     Gcyt=mean(G((I+5):Cyto))

     %Ratio of membrane to cytoplasm
     Dia_mc_ratio=Gm/Gcyt
     
     %profiles which are eliminated by the following conditions (ratio=NaN) will be shown in magenta 
     if (Gm >= Background_G/2) | (Gcyt >= Background_G/2)  %Signal after substructing background should be above background = signal should be 2 times higher than background)
         if Dia_mc_ratio>0  % Ratio memb/cyto should be >0
            Dia_mc_ratioA(id)= Dia_mc_ratio; 
            else  Dia_mc_ratioA(id)= NaN;
                plot(A(:,1), A(:,2), 'red', 'LineWidth',2);       %profiles which are eliminated by the following conditions (ratio=NaN) will be shown in red 
         end
         else Dia_mc_ratioA(id)= NaN;
             plot(A(:,1), A(:,2), 'red', 'LineWidth',2);
     end    
     
     if (max(A(:,3))>=100) % green signal should not be affected by speckles (intensity>100)
         Dia_mc_ratioA(id)= NaN;
             plot(A(:,1), A(:,2), 'red', 'LineWidth',2);
     else
     end
     
     if (max(G)<=10) %green signal (Dia-GFP) should not be too low 
         Dia_mc_ratioA(id)= NaN;
             plot(A(:,1), A(:,2), 'red', 'LineWidth',2);
     else
     end
     
     if (max(A(1:I-6,3))>=max(A(I-4:I+4,3))) %outside the cell should be no high peaks (speckles), higher than maximum inside cell (such speckles will affect background calculation) 
         Dia_mc_ratioA(id)= NaN;
             plot(A(:,1), A(:,2), 'red', 'LineWidth',2);
     else
     end
     
      if (mean(A(I-4:I+4,2))<=1.5*mean(A(I+5:I+15,2))) %red signal (membrane marker) should be sharp: at membrane >= 1.5*cytoplasmic 
         Dia_mc_ratioA(id)= NaN;
             plot(A(:,1), A(:,2), 'red', 'LineWidth',2);
     else
      end
      
      
       Dia_mc_ratioA  
    % Write to file
    fprintf(fileID, '%2.3f \n', Dia_mc_ratioA(id));
    
    
    plot(A(:,1), A(:,3), '--g','LineWidth', 0.5);  %plot initial green channel
    plot(A(:,1), G, 'green','LineWidth',2);  %plot initial green channel with substracted background
    sz = size(A(edge:(I-10),1));
    plot(A(edge:(I-10),1), ones(sz)*Background_G, '--black', 'LineWidth',2)  %plot avarage GREEN background
    plot(A(edge:(I-10),1), ones(sz)*0, 'black', 'LineWidth',2) %plot zero of GREEN channel
    sz = size(A((I-4):(I+4),1));
    plot(A((I-4):(I+4),1), ones(sz)*Gm, 'blue', 'LineWidth',3) %plot avarage membrane intensity
    sz = size(A((I+5):Cyto,1));
    plot(A((I+5):Cyto,1), ones(sz)*Gcyt, 'blue','LineWidth',3)  %plot avarage cytoplasmic intensity

    
end

Dia_mc_ratioA_clean=Dia_mc_ratioA(Dia_mc_ratioA>0)
Mean_Dia_mc=mean(Dia_mc_ratioA_clean)
SD_Dia_mc=std(Dia_mc_ratioA_clean)
N=size(Dia_mc_ratioA_clean)

fileID = fopen('Mean_SD.txt','w');
    fprintf(fileID, 'Mean    SD     N \n%2.4f  %2.4f  %2.0f', Mean_Dia_mc, SD_Dia_mc, N(2));

fileID = fopen('Results_column.txt','w');
fprintf(fileID, '%2.4f \n', Dia_mc_ratioA_clean);
    %close all