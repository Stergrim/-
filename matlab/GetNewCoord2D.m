function [Coord2Dln, Coord2Dpn] = GetNewCoord2D(VecP, Matrix0, Coord2Dl, Coord2Dp)

% ������� ����� �����
N = size(Coord2Dl,1);

% ������ ������� ��������
Tn = [VecP(1), VecP(2), VecP(3)];

% ������ ������� ��������
heading = VecP(4);
attitude = VecP(5);
bank = VecP(6);

Rn = Eiler(heading, attitude, bank);

% ������������ ������������� ������� ������ ������
Rl = [1, 0, 0;
      0, 1, 0;
      0, 0, 1];
   
Tl = [0, 0, 0];

RTl = [Rl Tl'];

MatrixL = Matrix0*RTl;

% ������������ ������������� ������� ������ ������
RTn = [Rn Tn'];

MatrixP = Matrix0*RTn;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ������ ����� ��������� ����������, ��� Xcorect = X*(1+k1r^(2)...)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ����������� 3d ��������� �����
C = TriangulationCustom(Coord2Dl, Coord2Dp, MatrixL, MatrixP);

% ���������� ��������� ������� �� ������
One = zeros(N,1);

for n = 1:N
    One(n) = 1;
end

C = [C One];

% ������������� 2d ��������� �� �����������
Coord2Dln = zeros(N,3);
Coord2Dpn = zeros(N,3);

% ���������������� ��� ���������
C = C';

% ������ ����� 2d ���������
for n = 1:N
    Coord2Dln(n,:) = MatrixL*C(:,n);
    Coord2Dpn(n,:) = MatrixP*C(:,n);
    Coord2Dln(n,:) = Coord2Dln(n,:)/Coord2Dln(n,3);
    Coord2Dpn(n,:) = Coord2Dpn(n,:)/Coord2Dpn(n,3);
end

end

