addpath(genpath('C:\Users\Rafael\sir\TL-Approf.-BCI\obj'))

load('herve001.txt');
load('herve002.txt');
load('herve003.txt');

H1 = (herve001(:,1)+herve001(:,2))/2;
H2 = (herve002(:,1)+herve002(:,2))/2;
H3 = (herve003(:,1)+herve003(:,2))/2;

% rien01 = H1(1:1280);
% save('rien01.txt','rien01','-ascii','-double'); 
% avance01 = H1(1281:2560);
% save('avance01.txt','avance01','-ascii','-double'); 
% droite01 = H1(2561:3840);
% save('droite01.txt','droite01','-ascii','-double'); 
% gauche01 = H1(3841:7424);
% save('gauche01.txt','gauche01','-ascii','-double'); 
% rien02 = H1(7425:9216);
% save('rien02.txt','rien02','-ascii','-double'); 
% avance02 = H1(9217:11008);
% save('avance02.txt','avance02','-ascii','-double'); 
% gauche02 = H1(11009:13312);
% save('gauche02.txt','gauche02','-ascii','-double'); 
% droite02 = H1(13313:end);
% save('droite02.txt','droite02','-ascii','-double'); 
% 
% rien03 = H2(1:1792);
% save('rien03.txt','rien03','-ascii','-double'); 
% gauche03 = H2(1793:3072);
% save('gauche03.txt','gauche03','-ascii','-double'); 
% avance03 = H2(3073:4608);
% save('avance03.txt','avance03','-ascii','-double'); 
% droite03 = H2(4609:6144);
% save('droite03.txt','droite03','-ascii','-double'); 
% avance04 = H2(6145:8448);
% save('avance04.txt','avance04','-ascii','-double'); 
% droite04 = H2(8449:9472);
% save('droite04.txt','droite04','-ascii','-double'); 
% avance05 = H2(9473:11776);
% save('avance05.txt','avance05','-ascii','-double'); 
% gauche04 = H2(11777:13824);
% save('gauche04.txt','gauche04','-ascii','-double'); 
% avance06 = H2(13825:16384);
% save('avance06.txt','avance06','-ascii','-double');
% gauche05 = H2(16385:17920);
% save('gauche05.txt','gauche05','-ascii','-double');
% avance07 = H2(17921:end);
% save('avance07.txt','avance07','-ascii','-double');
% 
% rien04 = H3(1:2304);
% save('rien04.txt','rien04','-ascii','-double');
% droite05 = H3(2305:3328);
% save('droite05.txt','droite05','-ascii','-double');
% avance08 = H3(3329:4864);
% save('avance08.txt','avance08','-ascii','-double');
% gauche06 = H3(4865:6144);
% save('gauche06.txt','gauche06','-ascii','-double');
% avance09 = H3(6145:9216);
% save('avance09.txt','avance09','-ascii','-double');
% droite06 = H3(9217:10496);
% save('droite06.txt','droite06','-ascii','-double');
% rien05 = H3(10497:12288);
% save('rien05.txt','rien05','-ascii','-double');
% gauche07 = H3(12289:15104);
% save('gauche07.txt','gauche07','-ascii','-double');
% avance10 = H3(15105:17408);
% save('avance10.txt','avance10','-ascii','-double');
% gauche08 = H3(17409:20224);
% save('gauche08.txt','gauche08','-ascii','-double');
% avance11 = H3(20225:23296);
% save('avance11.txt','avance11','-ascii','-double');

%%
% Avance = [avance01' avance02' avance03' avance04' avance05' avance06' avance07' avance08' avance09' avance10' avance11']';
% save('total_avance.txt','Avance','-ascii','-double');
% Rien = [rien01' rien02' rien03' rien04' rien05']';
% save('total_rien.txt','Rien','-ascii','-double');
% Droite = [droite01' droite02' droite03' droite04' droite05' droite06']';
% save('total_droite.txt','Droite','-ascii','-double');
% Gauche = [gauche01' gauche02' gauche03' gauche04' gauche05' gauche06' gauche07' gauche08']';
% save('total_gauche.txt','Gauche','-ascii','-double');

%%

label1 = zeros(size(H1));
label2 = zeros(size(H2));
label3 = zeros(size(H3));

label1(1:1280)=0;
label1(1281:2560)=1;
label1(2561:3840)=2;
label1(3841:7424)=3;
label1(7425:9216)=0;
label1(9217:11008)=1;
label1(11009:13312)=3;
label1(13313:end)=2;

label2(1:1792)=0;
label2(1793:3072)=3;
label2(3073:4608)=1;
label2(4609:6144)=2;
label2(6145:8448)=1;
label2(8449:9472)=2;
label2(9473:11776)=1;
label2(11777:13824)=3;
label2(13825:16384)=1;
label2(16385:17920)=3;
label2(17921:end)=1;

label3(1:2304)=0;
label3(2305:3328)=2;
label3(3329:4864)=1;
label3(4865:6144)=3;
label3(6145:9216)=1;
label3(9217:10496)=2;
label3(10497:12288)=0;
label3(12289:15104)=3;
label3(15105:17408)=1;
label3(17409:20224)=3;
label3(20225:23296)=1;

H1 = [H1 label1];
save('herve001_labeled.txt','H1','-ascii','-double');
H2 = [H2 label2];
save('herve002_labeled.txt','H2','-ascii','-double');
H3 = [H3 label3];
save('herve003_labeled.txt','H3','-ascii','-double');



