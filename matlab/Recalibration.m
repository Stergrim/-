function [E0, EInv, AngleP, AngleInv, Tp0, TInv, dC0, dCInv, VecPBest, EVecBest] = Recalibration(Matrix0, Rp, Tp, Number, Value)
%PMV, ItersV
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
%          
% Tp = [-315, 115, 40];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ������������ ������ ����� �������������� ������������� ������ �����
Coord3D = WingPattern(1000, 60, 40, 45, 6, 4);

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

% ��� ������ ������� ��� ��������
Tp0 = Tp;

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

% ���������������� ��� ������
Coord3D = Coord3D';
Coord3D = Coord3D(:,1:3);

% ���� ������������� ���������(���� �����������) 2d ��������� ����� � ����
% ����� ��� ����������� ��������������. ����� �������� ��������
% ������������� ������� �����.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �������� ���������

% ����������� ��������� ����� ������
[heading0, attitude0, bank0] = Decomposition(Rp);

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

if (Number == 4)
    heading0 = heading0 + Value*pi/180;
end

% Number = 5 ������������ �������� Attitude. Value � ����������
% �������� � ��������

if (Number == 5)
    attitude0 = attitude0 + Value*pi/180;
end

% Number = 6 ������������ �������� Bank. Value � ����������
% �������� � ��������

if (Number == 6)
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

% ������������� 2d ��������� �� �����������
Coord2Dln = zeros(N,3);
Coord2Dpn = zeros(N,3);

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

dC0 = 0; % ��� ���������� � ��

for n = 1:N
    dC0 = (C0(n,1) - Coord3D(n,1))^(2) + (C0(n,2) - Coord3D(n,2))^(2) + (C0(n,3) - Coord3D(n,3))^(2);
end

dC0 = sqrt(dC0/N);

%--------------------------------------------------------------------------
% ������ � ������ ���� ����������
VecP = [Tn(1); Tn(2); Tn(3); heading0; attitude0; bank0];

%--------------------------------------------------------------------------
% ����� �������-����
% [VecPInv, Iters, VecPB, EVec, PM] = NelderMead(Coord2Dl, Coord2Dp, Matrix0, VecP);

% ����� �������-���� � ����������� ���������� �������
 [VecPInv, VecPBest, EVecBest] = MultiNelderMead(Coord2Dl, Coord2Dp, Matrix0, VecP);

% ��� ����������� ������� ������ � �������
VecPBest(4:6,:) = (180/pi)*VecPBest(4:6,:);

%--------------------------------------------------------------------------
% ������ 3d ��������� � ����� R � T

TInv = [VecPInv(1), VecPInv(2), VecPInv(3)];

RInv = Eiler(VecPInv(4), VecPInv(5), VecPInv(6));

RTn = [RInv TInv'];

MatrixP = Matrix0*RTn;

% ����������� 3d ��������� �����
CInv = TriangulationCustom(Coord2Dl, Coord2Dp, MatrixL, MatrixP);

% ���������� ��������� ������� �� ������
CInv = [CInv One];

% ������������� 2d ��������� �� �����������
Coord2Dln = zeros(N,3);
Coord2Dpn = zeros(N,3);

% ���������������� ��� ���������
CInv = CInv';

for n = 1:N
    Coord2Dln(n,:) = MatrixL*CInv(:,n);
    Coord2Dpn(n,:) = MatrixP*CInv(:,n);
    Coord2Dln(n,:) = Coord2Dln(n,:)/Coord2Dln(n,3);
    Coord2Dpn(n,:) = Coord2Dpn(n,:)/Coord2Dpn(n,3);
end

% ������� �������� ������ ����������
EInv = ReprojectionError(Coord2Dl, Coord2Dp, Coord2Dln, Coord2Dpn);

% ���������������� � �������� ���������� ������� ������ ��� ������ �
% ������� ���, ����������� � ��
CInv = CInv';
CInv = CInv(:,1:3);

dCInv = 0; % ��� ���������� � ��

for n = 1:N
    dCInv = (CInv(n,1) - Coord3D(n,1))^(2) + (CInv(n,2) - Coord3D(n,2))^(2) + (CInv(n,3) - Coord3D(n,3))^(2);
end

dCInv = sqrt(dCInv/N);

% ������ ����� ������ ��� ��������� �����������
% ��������� ����
AngleInv = [VecPInv(4), VecPInv(5), VecPInv(6)]*(180/pi);

% �������� ���� (��� ��������� ��������)
[headingP, attitudeP, bankP] = Decomposition(Rp);
AngleP = [headingP, attitudeP, bankP]*(180/pi);

end

