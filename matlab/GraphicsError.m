function [E0, dC, Coord3D, C0] = GraphicsError(Matrix0, Rp, Tp, Number, Value)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ��� �������� ������

% ������� ���������� ���������� ������
% Matrix0 = [7500, 0, 1250;
%            0, 7500,  980;
%            0,      0,      1];

% ������� � �������� ������ ������ ����������� ������
% Rp = [ 0.9780, 0.0297,  0.2065;
%       -0.0175, 0.9980, -0.0610;
%       -0.2079, 0.0561,  0.9765]; 
          
% Tp = [-315, 115, 40];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ������������ ������ ����� �������������� ������������� ������ �����
Coord3D = WingPattern(1500, 300, 200, 45, 30, 20);

N = size(Coord3D, 1); % ����������� ����� �����

% ���������� ��������� ������� �� ������
One = zeros(N,1);

for n = 1:N
    One(n) = 1;
end

Coord3D = [Coord3D One];
       
% ����� ������ ������ �� ������ ������� ���������
Rl = [1, 0, 0;
      0, 1, 0;
      0, 0, 1];
   
Tl = [0, 0, 0];

RTl = [Rl Tl'];

% ������ ������
RTp = [Rp Tp'];

% ������� ����� 3-�� � 2-�� ������ ��������
MatrixL = Matrix0*RTl;
MatrixP = Matrix0*RTp;

% ������������� 2d ��������� �� �����������
Coord2Dl = zeros(N,3);
Coord2Dp = zeros(N,3);

% ���������������� ������� ��������� ��� ���������
Coord3D = Coord3D';

for n = 1:N
    Coord2Dl(n,:) = MatrixL*Coord3D(:,n);
    Coord2Dp(n,:) = MatrixP*Coord3D(:,n);
    Coord2Dl(n,:) = Coord2Dl(n,:)/Coord2Dl(n,3);
    Coord2Dp(n,:) = Coord2Dp(n,:)/Coord2Dp(n,3);
end

% ���������� �������� ������� �� ������ ��� ������� �� ���������� �������
% ������������
Coord2Dl = Coord2Dl(:,1:2);
Coord2Dp = Coord2Dp(:,1:2);

% ��� ������ ��������� �������� ����� 3D ������������ 
Coord3D = Coord3D';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ����� �������� 3D ����� �� ������
for n = 1:N
    subplot(2,2,3)
    plot(Coord2Dl(n,1), Coord2Dl(n,2),'*');
    xlim([0 2500])
    ylim([0 1960])
    hold on
    grid on
    title('����������� ����� ������');
    xlabel('���������� � ��������');
    ylabel('���������� � ��������');
    subplot(2,2,4)
    plot(Coord2Dp(n,1), Coord2Dp(n,2),'*');
    xlim([0 2500])
    ylim([0 1960])
    hold on
    grid on
    title('����������� ������ ������');
    xlabel('���������� � ��������');
    ylabel('���������� � ��������');
end

% ����� ��������� �������� 3D �����
subplot(2,2,1:2)
plot3(Coord3D(:,3), Coord3D(:,1), Coord3D(:,2), '*');
grid on
title('������ ���������');
xlabel('���������� � ��');
ylabel('���������� � ��');
zlabel('���������� � ��');

% ����� ��� ��������� ��������. ��������� �������� �� ����� ������
pause('on');
pause;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ���� ������������� ���������(���� �����������) 2d ��������� ����� � ����
% ����� ��� ����������� ��������������. ����� �������� ��������
% ������������� ������� �����.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �������� ���������

% ����������� ��������� ����� ������
[heading0, attitude0, bank0] = Decomposition(Rp);
% y, z, x.
% ������ ����������� ������� ��������
Tn = Tp;

% ���� Namber ��������� 1 �� 3, �� ���������� ������ �������� T

% Number = 1 ������������ �������� �� ��� X ��� Tx. Value � ����������
% �������� � ��

if (Number == 1)
    Tn(1) = Tn(1) + Value;
end

% Number = 2 ������������ �������� �� ��� Y ��� Ty. Value � ����������
% �������� � ��

if (Number == 2)
    Tn(2) = Tn(2) + Value;
end

% Number = 3 ������������ �������� �� ��� Z ��� Tz. Value � ����������
% �������� � ��

if (Number == 3)
    Tn(3) = Tn(3) + Value;
end

% ���� Namber ��������� 4 �� 6, �� ���������� ������� �������� R

% Number = 4 ������������ �������� Heading. Value � ����������
% �������� � ��������

if (Number == 5)
    heading0 = heading0 + Value*pi/180;
end

% Number = 5 ������������ �������� Attitude. Value � ����������
% �������� � ��������

if (Number == 6)
    attitude0 = attitude0 + Value*pi/180;
end

% Number = 6 ������������ �������� Bank. Value � ����������
% �������� � ��������

if (Number == 4)
    bank0 = bank0 + Value*pi/180;
end


% ���� Namber ��������� 7, �� ���������� ��� �������� �������� � ����������
% ����������� �� ��������� ������������ ����������. Value � ���������

% ��������� ��������� Tmax � �� � Rmax � ��������
Tmax = 10;
Rmax = 2*pi/180;

if (Number == 7)
    Tn(1) = Tn(1) + Tmax*(2*rand(1) - 1)*Value/100;
    Tn(2) = Tn(2) + Tmax*(2*rand(1) - 1)*Value/100;
    Tn(3) = Tn(3) + Tmax*(2*rand(1) - 1)*Value/100;
    heading0 = heading0 + Rmax*(2*rand(1) - 1)*Value/100;
    attitude0 = attitude0 + Rmax*(2*rand(1) - 1)*Value/100;
    bank0 = bank0 + Rmax*(2*rand(1) - 1)*Value/100;
end


if (Number == 8)
    Tn(1) = Value(1);% + Tn(1);
    Tn(2) = Value(2);% + Tn(2);
    Tn(3) = Value(3);% + Tn(3);
    heading0 = Value(4)*pi/180;% + heading0;
    attitude0 = Value(5)*pi/180;% + attitude0;
    bank0 = Value(6)*pi/180;% + bank0;
end
    

% ������ ����� ����������� �������� ��������
Tp = Tn;

% ������ ���������� ������� ��������
Rn = Eiler(heading0, attitude0, bank0);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ���� �� ������ ��������� ��������� ����� � ������������� ������
% ����������� ���������� � ����� ������ ����������

RTn = [Rn Tn'];

MatrixP = Matrix0*RTn;

% ����������� 3d ��������� �����
C0 = TriangulationCustom(Coord2Dl, Coord2Dp, MatrixL, MatrixP);

% ���������� ��������� ������� �� ������ � ���������������� ��� ���������
C0 = [C0 One];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % ����� �������� 3D ����� � �������������� � ��������� �����������
subplot(2,1,1)
plot3(Coord3D(:,1), Coord3D(:,2), Coord3D(:,3), '*');
grid on

subplot(2,1,2)
plot3(C0(:,1), C0(:,2), C0(:,3), '*');
grid on

% ����� ��� ��������� ��������. ��������� �������� �� ����� ������
pause('on');
pause;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ���������������� ��� ���������
Coord3D = Coord3D';
% ������������� 2d ��������� �� �����������
Coord2Dln = zeros(N,3);
Coord2Dpn = zeros(N,3);

for n = 1:N
    Coord2Dln(n,:) = MatrixL*Coord3D(:,n);
    Coord2Dpn(n,:) = MatrixP*Coord3D(:,n);
    Coord2Dln(n,:) = Coord2Dln(n,:)/Coord2Dln(n,3);
    Coord2Dpn(n,:) = Coord2Dpn(n,:)/Coord2Dpn(n,3);
end

% ���������������� ��� ������
Coord3D = Coord3D';
Coord3D = Coord3D(:,1:3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % ����� �������� 3D ����� �� ������
for n = 1:N
    subplot(2,2,1)
    plot(Coord2Dl(n,1), Coord2Dl(n,2),'*');
    grid on
    hold on
    subplot(2,2,2)
    plot(Coord2Dp(n,1), Coord2Dp(n,2),'*');
    grid on
    hold on
end

% ����� �������� 3D ����� �� ������ � ����������
for n = 1:N
    subplot(2,2,3)
    plot(Coord2Dln(n,1), Coord2Dln(n,2),'*');
    grid on
    hold on
    subplot(2,2,4)
    plot(Coord2Dpn(n,1), Coord2Dpn(n,2),'*');
    grid on
    hold on
end

pause('on');
pause;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ���������������� ��� ���������
C0 = C0';

for n = 1:N
    Coord2Dln(n,:) = MatrixL*C0(:,n);
    Coord2Dpn(n,:) = MatrixP*C0(:,n);
    Coord2Dln(n,:) = Coord2Dln(n,:)/Coord2Dln(n,3);
    Coord2Dpn(n,:) = Coord2Dpn(n,:)/Coord2Dpn(n,3);
end

% ������� ��������� ������ ����������
E0 = ReprojectionError(Coord2Dl, Coord2Dp, Coord2Dln, Coord2Dpn);

% ���������������� � �������� ���������� ������� ������ ��� ������ �
% ������� ���, ����������� � ��
C0 = C0';
C0 = C0(:,1:3);

dC = 0; % ��� ���������� � ��

for n = 1:N
    dC = (C0(n,1) - Coord3D(n,1))^(2) + (C0(n,2) - Coord3D(n,2))^(2) + (C0(n,3) - Coord3D(n,3))^(2);
end

dC = sqrt(dC/N);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ������ ����������� ������ �� ��������

% �������� ��������
Delta = 10;

% ��� ��������
step = 1;

% ����� �����
K = 2*Delta/step + 1;

% ������ �� ��� �
EVecX = zeros(K,1);

for k = 1:K
    Tn(1) = Tp(1) - Delta + step*(k-1);
    RTn = [Rn Tn'];
    MatrixP = Matrix0*RTn;
    C = TriangulationCustom(Coord2Dl, Coord2Dp, MatrixL, MatrixP);
    
    for n = 1:N
        C(n, 4) = 1;
    end
    
    C = C';
    
    for n = 1:N
        Coord2Dln(n,:) = MatrixL*C(:,n);
        Coord2Dpn(n,:) = MatrixP*C(:,n);
        Coord2Dln(n,:) = Coord2Dln(n,:)/Coord2Dln(n,3);
        Coord2Dpn(n,:) = Coord2Dpn(n,:)/Coord2Dpn(n,3);
    end
    
    EVecX(k) = ReprojectionError(Coord2Dl, Coord2Dp, Coord2Dln, Coord2Dpn);
end

% ����������� �������� �������� � �������� ���������
Tn(1) = Tp(1);

% ������ �� ��� y
EVecY = zeros(K,1);

for k = 1:K
    Tn(2) = Tp(2) - Delta + step*(k-1);
    RTn = [Rn Tn'];
    MatrixP = Matrix0*RTn;
    C = TriangulationCustom(Coord2Dl, Coord2Dp, MatrixL, MatrixP);
    
    for n = 1:N
        C(n, 4) = 1;
    end
    
    C = C';
    
    for n = 1:N
        Coord2Dln(n,:) = MatrixL*C(:,n);
        Coord2Dpn(n,:) = MatrixP*C(:,n);
        Coord2Dln(n,:) = Coord2Dln(n,:)/Coord2Dln(n,3);
        Coord2Dpn(n,:) = Coord2Dpn(n,:)/Coord2Dpn(n,3);
    end
    
    EVecY(k) = ReprojectionError(Coord2Dl, Coord2Dp, Coord2Dln, Coord2Dpn);
end

% ����������� �������� �������� � �������� ���������
Tn(2) = Tp(2);

% ������ �� ��� z
EVecZ = zeros(K,1);

for k = 1:K
    Tn(3) = Tp(3) - Delta + step*(k-1);
    RTn = [Rn Tn'];
    MatrixP = Matrix0*RTn;
    C = TriangulationCustom(Coord2Dl, Coord2Dp, MatrixL, MatrixP);
    
    for n = 1:N
        C(n, 4) = 1;
    end
    
    C = C';
    
    for n = 1:N
        Coord2Dln(n,:) = MatrixL*C(:,n);
        Coord2Dpn(n,:) = MatrixP*C(:,n);
        Coord2Dln(n,:) = Coord2Dln(n,:)/Coord2Dln(n,3);
        Coord2Dpn(n,:) = Coord2Dpn(n,:)/Coord2Dpn(n,3);
    end
    
    EVecZ(k) = ReprojectionError(Coord2Dl, Coord2Dp, Coord2Dln, Coord2Dpn);
end

% ����������� �������� �������� � �������� ���������
Tn(3) = Tp(3);

% ����������� ��� �������� � ����������� ��������� ������ ��������
% ���������� ��������

sx = zeros(K,1);
sy = zeros(K,1);
sz = zeros(K,1);

for k = 1:K
    sx(k) = -Delta + step*(k-1) + Tp(1);
    sy(k) = -Delta + step*(k-1) + Tp(2);
    sz(k) = -Delta + step*(k-1) + Tp(3);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ������ ����������� ������ �� ��������

% �������� ��������
Delta = 2;

% ��� ��������
step = 0.1;

% ����� �����
K = 2*Delta/step + 1;

% ������ �������� Heading
EVecHeading = zeros(K,1);


for k = 1:K
    heading = heading0*180/pi - Delta + step*(k-1);
    heading = heading*pi/180;
    Rn = Eiler(heading, attitude0, bank0);
    RTn = [Rn Tn'];
    MatrixP = Matrix0*RTn;
    C = TriangulationCustom(Coord2Dl, Coord2Dp, MatrixL, MatrixP);
    
    for n = 1:N
        C(n, 4) = 1;
    end
    
    C = C';
    
    for n = 1:N
        Coord2Dln(n,:) = MatrixL*C(:,n);
        Coord2Dpn(n,:) = MatrixP*C(:,n);
        Coord2Dln(n,:) = Coord2Dln(n,:)/Coord2Dln(n,3);
        Coord2Dpn(n,:) = Coord2Dpn(n,:)/Coord2Dpn(n,3);
    end
    
    EVecHeading(k) = ReprojectionError(Coord2Dl, Coord2Dp, Coord2Dln, Coord2Dpn);
end

% ������ �������� attitude
EVecAttitude = zeros(K,1);

for k = 1:K
    attitude = attitude0*180/pi - Delta + step*(k-1);
    attitude = attitude*pi/180;
    Rn = Eiler(heading0, attitude, bank0);
    RTn = [Rn Tn'];
    MatrixP = Matrix0*RTn;
    C = TriangulationCustom(Coord2Dl, Coord2Dp, MatrixL, MatrixP);
    
    for n = 1:N
        C(n, 4) = 1;
    end
    
    C = C';
    
    for n = 1:N
        Coord2Dln(n,:) = MatrixL*C(:,n);
        Coord2Dpn(n,:) = MatrixP*C(:,n);
        Coord2Dln(n,:) = Coord2Dln(n,:)/Coord2Dln(n,3);
        Coord2Dpn(n,:) = Coord2Dpn(n,:)/Coord2Dpn(n,3);
    end
    
    EVecAttitude(k) = ReprojectionError(Coord2Dl, Coord2Dp, Coord2Dln, Coord2Dpn);
end

% ������ �������� Bank
EVecBank = zeros(K,1);

for k = 1:K
    bank = bank0*180/pi - Delta + step*(k-1);
    bank = bank*pi/180;
    Rn = Eiler(heading0, attitude0, bank);
    RTn = [Rn Tn'];
    MatrixP = Matrix0*RTn;
    C = TriangulationCustom(Coord2Dl, Coord2Dp, MatrixL, MatrixP);
    
    for n = 1:N
        C(n, 4) = 1;
    end
    
    C = C';
    
    for n = 1:N
        Coord2Dln(n,:) = MatrixL*C(:,n);
        Coord2Dpn(n,:) = MatrixP*C(:,n);
        Coord2Dln(n,:) = Coord2Dln(n,:)/Coord2Dln(n,3);
        Coord2Dpn(n,:) = Coord2Dpn(n,:)/Coord2Dpn(n,3);
    end
    
    EVecBank(k) = ReprojectionError(Coord2Dl, Coord2Dp, Coord2Dln, Coord2Dpn);
end

% ����������� ��� �������� � ����������� ��������� ������ ��������
% ���������� ��������

sh = zeros(K,1);
sa = zeros(K,1);
sb = zeros(K,1);

for k = 1:K
    sh(k) = -Delta + step*(k-1) + heading0*180/pi;
    sa(k) = -Delta + step*(k-1) + attitude0*180/pi;
    sb(k) = -Delta + step*(k-1) + bank0*180/pi;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ����� ���������� ������������

% ��������

% subplot(2,3,1)
% plot(sx,EVecX,'blue');
% xlim([min(sx) max(sx)])
% ylim([min(EVecX) max(EVecX)])
% grid on;
% title('������ �� �������� �� ��� x');
% xlabel('�������� � ��');
% ylabel('��� � ��������');
% 
% subplot(2,3,2)
% plot(sy,EVecY,'blue');
% xlim([min(sy) max(sy)])
% ylim([min(EVecY) max(EVecY)])
% grid on;
% title('������ �� �������� �� ��� y');
% xlabel('�������� � ��');
% ylabel('��� � ��������');
% 
% subplot(2,3,3)
% plot(sz,EVecZ,'blue');
% xlim([min(sz) max(sz)])
% ylim([min(EVecZ) max(EVecZ)])
% grid on;
% title('������ �� �������� �� ��� z');
% xlabel('�������� � ��');
% ylabel('��� � ��������');
% 
% 
% % �������
% 
% subplot(2,3,5)
% plot(sh,EVecHeading,'blue');
% xlim([min(sh) max(sh)])
% ylim([min(EVecHeading) max(EVecHeading)])
% grid on;
% title('������ �������� ������ ��� y');
% xlabel('�������� � ����');
% ylabel('��� � ��������');
% 
% subplot(2,3,6)
% plot(sa,EVecAttitude,'blue');
% xlim([min(sa) max(sa)])
% ylim([min(EVecAttitude) max(EVecAttitude)])
% grid on;
% title('������ �������� ������ ��� z');
% xlabel('�������� � ����');
% ylabel('��� � ��������');
% 
% subplot(2,3,4)
% plot(sb,EVecBank,'blue');
% xlim([min(sb) max(sb)])
% ylim([min(EVecBank) max(EVecBank)])
% grid on;
% title('������ �������� ������ ��� x');
% xlabel('�������� � ����');
% ylabel('��� � ��������');

subplot(2,3,1)
plot(sx,EVecX,'blue');
xlim([min(sx) max(sx)])
ylim([min(EVecX) max(EVecX)])
grid on;
title('Error from offset along x-axis');
xlabel('Offset in mm');
ylabel('MSE in pixels');

subplot(2,3,2)
plot(sy,EVecY,'blue');
xlim([min(sy) max(sy)])
ylim([min(EVecY) max(EVecY)])
grid on;
title('Error from offset along y-axis');
xlabel('Offset in mm');
ylabel('MSE in pixels');

subplot(2,3,3)
plot(sz,EVecZ,'blue');
xlim([min(sz) max(sz)])
ylim([min(EVecZ) max(EVecZ)])
grid on;
title('Error from offset along z-axis');
xlabel('Offset in mm');
ylabel('MSE in pixels');


% �������

subplot(2,3,5)
plot(sh,EVecHeading,'blue');
xlim([min(sh) max(sh)])
ylim([min(EVecHeading) max(EVecHeading)])
grid on;
title('Error from rotation around the y-axis');
xlabel('Offset in degrees');
ylabel('MSE in pixels');

subplot(2,3,6)
plot(sa,EVecAttitude,'blue');
xlim([min(sa) max(sa)])
ylim([min(EVecAttitude) max(EVecAttitude)])
grid on;
title('Error from rotation around the z-axis');
xlabel('Offset in degrees');
ylabel('MSE in pixels');

subplot(2,3,4)
plot(sb,EVecBank,'blue');
xlim([min(sb) max(sb)])
ylim([min(EVecBank) max(EVecBank)])
grid on;
title('Error from rotation around the x-axis');
xlabel('Offset in degrees');
ylabel('MSE in pixels');

end

