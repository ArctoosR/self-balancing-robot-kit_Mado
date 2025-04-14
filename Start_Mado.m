clear all
clc

n1 = 50;
n2 = 50;

th3 = linspace(-15,15,n1);
om3 = linspace(-180,180,n2);

sys = readfis('FLC2.fis');

for i = 1:length(th3)
    for j = 1:length(om3)
        OUT(j, i) = evalfis([th3(i); om3(j)], sys);
    end
end

figure
h = surf(th3, om3, OUT);
xlim([-15 15]);
ylim([-180 180]);

colormap(jet)
shading interp
%%
[r1min, r2min, res1, res2, lut] = generateLUT('FLC2.fis', n1, n2);

figure
h2 = surf(th3, om3, lut');
xlim([-15 15]);
ylim([-180 180]);
zlim([-300 300]);

colormap(jet)

%%
for i = 1:length(th3)
    for j = 1:length(om3)
        OUT2(j, i) = FLCapprox(th3(i), om3(j), r1min, r2min, res1, res2, lut, n1, n2);
    end
end

figure
h3 = surf(th3, om3, OUT-OUT2);

xlim([-15 15]);
ylim([-180 180]);

colormap(jet)

% ?????????
n1 = 50; % ????? ???????
n2 = 50; % ????? ???????
in1min = -580.833; % ????? ????? ????? ???
in2min = -10.0; % ????? ????? ????? ???
res1 = 23.7075; % ??????? ???? ???
res2 = 0.408163; % ??????? ???? ???

% ???? LUT (?????)
lut = round(rand(n1, n2) * 400 - 200); % ????????? ?? LUT ?????? (????? ????)

% ????? LUT ?? ???? ??? ???? ???????
filename = 'FLC1.h';
fileID = fopen(filename, 'w');

% ????? ??????? ????? ?? ???? ???
fprintf(fileID, '#ifndef FLC1_H\n');
fprintf(fileID, '#define FLC1_H\n\n');

fprintf(fileID, 'const int NROW_FLC1 = %d;\n', n1);
fprintf(fileID, 'const int NCOL_FLC1 = %d;\n\n', n2);

fprintf(fileID, 'const float in1min_FLC1 = %.5e;\n', in1min);
fprintf(fileID, 'const float in2min_FLC1 = %.5e;\n', in2min);
fprintf(fileID, 'const float res1_FLC1 = %.5e;\n', res1);
fprintf(fileID, 'const float res2_FLC1 = %.5e;\n\n', res2);

fprintf(fileID, 'const PROGMEM int16_t FLC1[NROW_FLC1][NCOL_FLC1] = {\n');

% ????? ???????? LUT ?? ???? ????? C
for i = 1:n1
    fprintf(fileID, '  {');
    for j = 1:n2
        if j < n2
            fprintf(fileID, '%d, ', lut(i, j));
        else
            fprintf(fileID, '%d', lut(i, j));
        end
    end
    if i < n1
        fprintf(fileID, '},\n');
    else
        fprintf(fileID, '}\n');
    end
end

fprintf(fileID, '};\n\n');
fprintf(fileID, '#endif // FLC1_H\n');

fclose(fileID);

disp(['Lookup Table has been saved to ', filename]);
