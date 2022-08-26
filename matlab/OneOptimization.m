function [Lam] = OneOptimization(Coord2Dl, Coord2Dp, Matrix0, VecP, S, VecP0, Tmax, Rmax)
% ���������� ����������� ��� ������� ��������� ������, � ������ �����������
% ������(�������� �����������)

% ���������� ��������� ��� ������������ ��������
TmaxD = Tmax + (1/2)*Tmax;
RmaxD = Rmax + (1/2)*Rmax;

% ������
VecP1 = VecP;

% ����� ��������
Iters = 2;

% ��������� ���������� ���������
P = 2;

% ��������� ������� ���������� �� ��������(��������)
Delta = VecP - VecP0;

% ������������� ��� ������� ������������ ������ �������������� �������
% ����������
Ratio1 = zeros(6,1);
Ratio2 = zeros(6,1);

% ����� �������� �� ������� ����������� �������� (����� + 1)
N = 20;

% ������������� ������� ������
EVec = zeros(N+1,1);

% ���� ��� ������������ ���������� (S == 0)
flag1 = 1;

if (S == 0)
    flag1 = 0;
end

% ������ ������ ��� ��������� ��������� ������ � ���� ������
if (flag1 == 1)
    
    for i = 1:3
        Ratio1(i) = abs(S(i)*(TmaxD/(TmaxD - Delta(i))));
    end
    
    for i = 4:6
        Ratio1(i) = abs(S(i)*(RmaxD/(RmaxD - Delta(i))));
    end
    
    for i = 1:3
        Ratio2(i) = abs(S(i)*(TmaxD/(TmaxD + Delta(i))));
    end
    
    for i = 4:6
        Ratio2(i) = abs(S(i)*(RmaxD/(RmaxD + Delta(i))));
    end
    
    [~,imaxLam] = max(Ratio1);
    [~,iminLam] = max(Ratio2);
    
    if ((imaxLam > 0)&&(imaxLam <= 3))
        LamMax = (TmaxD - Delta(imaxLam))/S(imaxLam);
    elseif ((imaxLam > 3)&&(imaxLam <= 6))
        LamMax = (RmaxD - Delta(imaxLam))/S(imaxLam);
    end
    
    if ((iminLam > 0)&&(iminLam <= 3))
        LamMin = -(TmaxD + Delta(iminLam))/S(iminLam);
    elseif ((iminLam > 3)&&(iminLam <= 6))
        LamMin = -(RmaxD + Delta(iminLam))/S(iminLam);
    end
    
    LamStep = (LamMax - LamMin)/N;
end

% �������� ���� ���������� �����������
for k = 1:Iters
    
    if (flag1 == 0)
        Lam = 0; 
        break
    end
    
    for t = 1:(N+1)
        VecP = VecP1 + (LamMin + LamStep*(t-1))*S;
        [Coord2Dln, Coord2Dpn] = GetNewCoord2D(VecP, Matrix0, Coord2Dl, Coord2Dp);
        EVec(t) = ReprojectionError(Coord2Dl, Coord2Dp, Coord2Dln, Coord2Dpn);
    end
    % ����������� ������� ����������� ������
    [~,tmin] = min(EVec);
    % ������ ��������������� ��������� ������
    Lam = LamMin + LamStep*(tmin-1);
    
    Lam0 = (LamMax - LamMin)/2;
    
    if (Lam >= Lam0)
        LD = abs(LamMax - Lam);
    else
        LD = abs(LamMin - Lam);
    end
    
    LamMin = (Lam - LD)/P;
    LamMax = (Lam + LD)/P;
    LamStep = (LamMax - LamMin)/N;
end


end

