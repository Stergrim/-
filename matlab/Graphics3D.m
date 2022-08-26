function [E0, EVec] = Graphics3D(Matrix0, Rp, Tp, Number, Value, N1, N2)
% ������� ������� ������� ������������, ��� ��� Z - ��� ������, ��� X -
% �������� �� ������ N1, ��� Y - �������� �� ������ N2. ��������� 1 = Tx,
% 2 = Ty, 3 = Tz, 4 = Heading, 5 = Attitude, 6 = Bank.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ��� �������� ������

% ������� ���������� ���������� ������
% Matrix0 = [1684.1, 0, 1295.5;
%            0, 1681.8,  971.5;
%            0,      0,      1];

% ������� � �������� ������ ������ ����������� ������
% Rp = [1, 6.9*10^(-5), 9.1*10^(-6);
%      -6.9*10^(-5), 1, -1.8*10^(-5);
%      -9.1*10^(-6), 1.8*10^(-5),  1];
%          
% Tp = [-150.5, 0, 1];
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

% ������ � ������ �����
Angle0 = [heading0, attitude0, bank0];
Angle = Angle0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ���� �� ������ ��������� ��������� ����� � ������������� ������
% ����������� ���������� � ����� ������ ����������

RTn = [Rn Tn'];

MatrixP = Matrix0*RTn;

% ����������� 3d ��������� �����
C0 = TriangulationCustom(Coord2Dl, Coord2Dp, MatrixL, MatrixP);

% ���������� ��������� ������� �� ������ � ���������������� ��� ���������
C0 = [C0 One];

% ���������������� ��� ���������
C0 = C0';

% ������������� 2d ��������� �� �����������
Coord2Dln = zeros(N,3);
Coord2Dpn = zeros(N,3);

for n = 1:N
    Coord2Dln(n,:) = MatrixL*C0(:,n);
    Coord2Dpn(n,:) = MatrixP*C0(:,n);
    Coord2Dln(n,:) = Coord2Dln(n,:)/Coord2Dln(n,3);
    Coord2Dpn(n,:) = Coord2Dpn(n,:)/Coord2Dpn(n,3);
end

% ������� ��������� ������ ����������
E0 = ReprojectionError(Coord2Dl, Coord2Dp, Coord2Dln, Coord2Dpn);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���� ������� �������� � ���������� �� ���������� N1 � N2

if (((N1 > 0)&&(N1 < 4))&&((N2 > 0)&&(N2 < 4)))
    Delta = 10;
    step = 1;
    K = 2*Delta/step + 1;
    EVec = zeros(K,K);
    for k1 = 1:K
        Tn(N1) = Tp(N1) - Delta + step*(k1-1);
        for k2 = 1:K
            Tn(N2) = Tp(N2) - Delta + step*(k2-1);
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
            
            EVec(k1,k2) = ReprojectionError(Coord2Dl, Coord2Dp, Coord2Dln, Coord2Dpn);
        end
    end
    
    X = zeros(K,1);
    Y = zeros(K,1);
    
    for k = 1:K
        X(k) = -Delta + step*(k-1) + Tp(N1);
        Y(k) = -Delta + step*(k-1) + Tp(N2);
    end
    
    surf(Y,X,EVec);
    xlabel('Y'); % xlabel('�������� �� ��� Y, ��');
    ylabel('X'); % ylabel('�������� �� ��� X, ��');
    zlabel('Z'); % zlabel('��� � ��������');
    
    
elseif (((N1 > 0)&&(N1 <= 3))&&((N2 > 3)&&(N2 <= 6)))
    Delta1 = 10;
    Delta2 = 2;
    step1 = 1;
    step2 = 0.1;
    K1 = 2*Delta1/step1 + 1;
    K2 = 2*Delta2/step2 + 1;
    EVec = zeros(K1,K2);
    for k1 = 1:K1
        Tn(N1) = Tp(N1) - Delta1 + step1*(k1-1);
        for k2 = 1:K2
            Angle(N2-3) = Angle0(N2-3)*180/pi - Delta2 + step2*(k2-1);
            Angle(N2-3) = Angle(N2-3)*pi/180;
            Rn = Eiler(Angle(1), Angle(2), Angle(3));
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
            
            EVec(k1,k2) = ReprojectionError(Coord2Dl, Coord2Dp, Coord2Dln, Coord2Dpn);
        end
    end
    
    X = zeros(K1,1);
    Y = zeros(K2,1);
    
    for k1 = 1:K1
        X(k1) = -Delta1 + step1*(k1-1) + Tp(N1);
    end
    
    for k2 = 1:K2
        Y(k2) = -Delta2 + step2*(k2-1) + Angle0(N2-3)*180/pi;
    end
    
    surf(Y,X,EVec);
    xlabel('Y'); % xlabel('������� ������ ��� Z, �������');
    ylabel('X'); % ylabel('�������� �� ��� X, ��');
    zlabel('Z'); % zlabel('��� � ��������');
    
    
elseif (((N1 > 3)&&(N1 <= 6))&&((N2 > 3)&&(N2 <= 6)))
    Delta = 2;
    step = 0.1;
    K = 2*Delta/step + 1;
    EVec = zeros(K,K);
    for k1 = 1:K
        Angle(N1-3) = Angle0(N1-3)*180/pi - Delta + step*(k1-1);
        Angle(N1-3) = Angle(N1-3)*pi/180;
        for k2 = 1:K
            Angle(N2-3) = Angle0(N2-3)*180/pi - Delta + step*(k2-1);
            Angle(N2-3) = Angle(N2-3)*pi/180;
            Rn = Eiler(Angle(1), Angle(2), Angle(3));
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
            
            EVec(k1,k2) = ReprojectionError(Coord2Dl, Coord2Dp, Coord2Dln, Coord2Dpn);
        end
    end
    
    X = zeros(K,1);
    Y = zeros(K,1);
    
    for k = 1:K
        X(k) = -Delta + step*(k-1) + Angle0(N1-3)*180/pi;
        Y(k) = -Delta + step*(k-1) + Angle0(N2-3)*180/pi;
    end
    
    surf(Y,X,EVec);
    xlabel('Y');
    ylabel('X');
    zlabel('Z');
    
    
elseif (((N1 > 3)&&(N1 <= 6))&&((N2 > 0)&&(N2 <= 3)))
    Delta1 = 2;
    Delta2 = 10;
    step1 = 0.1;
    step2 = 1;
    K1 = 2*Delta1/step1 + 1;
    K2 = 2*Delta2/step2 + 1;
    EVec = zeros(K1,K2);
    for k1 = 1:K1
        Angle(N1-3) = Angle0(N1-3)*180/pi - Delta1 + step1*(k1-1);
        Angle(N1-3) = Angle(N1-3)*pi/180;
        Rn = Eiler(Angle(1), Angle(2), Angle(3));
        for k2 = 1:K2
            Tn(N2) = Tp(N2) - Delta2 + step2*(k2-1);
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
            
            EVec(k1,k2) = ReprojectionError(Coord2Dl, Coord2Dp, Coord2Dln, Coord2Dpn);
        end
    end
    
    X = zeros(K1,1);
    Y = zeros(K2,1);
    
    for k1 = 1:K1
        X(k1) = -Delta1 + step1*(k1-1) + Angle0(N1-3)*180/pi;
    end
    
    for k2 = 1:K2
        Y(k2) = -Delta2 + step2*(k2-1) + Tp(N2);
    end
    
    surf(Y,X,EVec);
    xlabel('Y');
    ylabel('X');
    zlabel('Z');
end

end

