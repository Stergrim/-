function [VecPInv, Iters, VecP, EVec, PM] = NelderMead(Coord2Dl, Coord2Dp, Matrix0, VecP0)
% ����������� ������
N = 6;

% ������� ����������
DeltaE = 10^(-6); % ����������� ���������� ������
DeltaT = 0.05; % ����� ����� �� ��� ��������
DeltaR = 0.005*pi/180; % ����� ����� �� ��� ��������

% ������������� ������ ���������
VecP = zeros(N,N+1);

% ����� �������� � �������
ItersMax = 500;
Iters = 0;

% ������������� ������� ������ ������ ���������
EVec = zeros(N+1,1);

% ������������� ����� ������ ���������
PM = 0;
%--------------------------------------------------------------------------
% ������������ ���������
%--------------------------------------------------------------------------
% ����� �1

% ��������� �����
VecP(:,1) = VecP0;

% ����� ���� ���������
stepT = 0.5;
stepR = 0.05*pi/180;

% ������ �������� ������������ ��������� �����
d1T = stepT*(sqrt(N+1) - 1)/(N*sqrt(2));
d2T = stepT*(sqrt(N+1) + N - 1)/(N*sqrt(2));

d1R = stepR*(sqrt(N+1) - 1)/(N*sqrt(2));
d2R = stepR*(sqrt(N+1) + N - 1)/(N*sqrt(2));

for i = 2:(N+1)
    for j = 1:3
        if (i ~= j)
            VecP(j,i) = VecP0(j) + d1T;
        else
            VecP(j,i) = VecP0(j) + d2T;
        end
    end
    
    for j = 4:6
        if (i ~= j)
            VecP(j,i) = VecP0(j) + d1R;
        else
            VecP(j,i) = VecP0(j) + d2R;
        end
    end
end
%--------------------------------------------------------------------------
% % ����� �2
% 
% % ��������� �����
% VecP(:,1) = VecP0;
% 
% % �������� ������������ ����������� �����
% stepT = 0.5;
% stepR = 0.05*pi/180;
% 
% % ������������� ������ ������������
% S = eye(N);
% 
% % �������� �������������� ����������� �� �� ���
% S = [stepT*S(1:3,:); stepR*S(4:6,:)];
% 
% for i = 2:(N+1)
%     VecP(:,i) = VecP0(:,i) + stepT*S(:,i-1);
% end
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% ����������� ���������
alfa = 1.0;

% ����������� ������
betta = 0.5;

% ����������� ����������
gamma = 2.0;

% ���������� �������� ������ � ��������
for i = 1:(N+1)
    [Coord2Dln, Coord2Dpn] = GetNewCoord2D(VecP(:,i), Matrix0, Coord2Dl, Coord2Dp);
    EVec(i) = ReprojectionErrorMod(Coord2Dl, Coord2Dp, Coord2Dln, Coord2Dpn, VecP0, VecP(:,i));
end

for k = 1:ItersMax
    
    % ������ ����� � ���������� ��������� ������
    [~,h] = max(EVec);
    
    % ����� ����� � ��������� ����� ������������ ������
    EVec(h) = 0;
    
    [~,g] = max(EVec);
    
    % ����������� ������� ������ � �������� ���������
    [Coord2Dln, Coord2Dpn] = GetNewCoord2D(VecP(:,h), Matrix0, Coord2Dl, Coord2Dp);
    EVec(h) = ReprojectionErrorMod(Coord2Dl, Coord2Dp, Coord2Dln, Coord2Dpn, VecP0, VecP(:,h));
    
    % ������ ����� � ���������� ��������� ������
    [~,l] = min(EVec);
    
    % ������ ������ ������� �� ����������� h
    VecPO = zeros(N,1);
    
    for i = 1:(N+1)
        if (i ~= h)
            VecPO = VecPO + VecP(:,i);
        end
    end
    
    VecPO = (1/N)*VecPO;
    
%     % �������� ������ � ������ �������
%     [Coord2Dln, Coord2Dpn] = GetNewCoord2D(VecPO, Matrix0, Coord2Dl, Coord2Dp);
%     EO = ReprojectionErrorMod(Coord2Dl, Coord2Dp, Coord2Dln, Coord2Dpn, VecP0, VecPO);
    
    % ��������� ����� � ������ ���������
    VecPR = (1+alfa)*VecPO - alfa*VecP(:,h);
    
    % �������� ������ � ��������� �����
    [Coord2Dln, Coord2Dpn] = GetNewCoord2D(VecPR, Matrix0, Coord2Dl, Coord2Dp);
    ER = ReprojectionErrorMod(Coord2Dl, Coord2Dp, Coord2Dln, Coord2Dpn, VecP0, VecPR);
    
    % ������� R � l
    
    % ���� ����� ������, �� ����������� � ������� ������
    if (ER < EVec(l))
        VecPE = gamma*VecPR + (1-gamma)*VecPO;
        
        [Coord2Dln, Coord2Dpn] = GetNewCoord2D(VecPE, Matrix0, Coord2Dl, Coord2Dp);
        EE = ReprojectionErrorMod(Coord2Dl, Coord2Dp, Coord2Dln, Coord2Dpn, VecP0, VecPE);
        
        % ������� E � l
        
        % ���� ����� ������, �� �������� ������ �����
        if (EE < EVec(l))
            VecP(:,h) = VecPE;
            EVec(h) = EE;
            % ������ �������� �� ����������--------------------------------
        else
            % (EE > EVec(l)). ����������� ����� E
            % � �������� ������ ����� �� R
            VecP(:,h) = VecPR;
            EVec(h) = ER;
            % ������ �������� �� ����������--------------------------------
        end
    else
        % (ER > EVec(l))
        
        % �� ����� g, �.�. ����� ���� ����� ���������
        if (ER < EVec(g))
            VecP(:,h) = VecPR;
            EVec(h) = ER;
            % ������ �������� �� ����������--------------------------------
        else
            % (ER > EVec(g))
            
            % �� ���������� R � h
            
            % ���� ������, �� ������� ����� � ������� ������
            if(ER > EVec(h))
                VecPC = betta*VecP(:,h) + (1-betta)*VecPO;
                [Coord2Dln, Coord2Dpn] = GetNewCoord2D(VecPC, Matrix0, Coord2Dl, Coord2Dp);
                EC = ReprojectionErrorMod(Coord2Dl, Coord2Dp, Coord2Dln, Coord2Dpn, VecP0, VecPC);
            else
                % (ER < EVec(h))
                % �������� �� R, ���������� ������ � ������� ������
                VecP(:,h) = VecPR;
                VecPC = betta*VecPR + (1-betta)*VecPO;
                [Coord2Dln, Coord2Dpn] = GetNewCoord2D(VecPC, Matrix0, Coord2Dl, Coord2Dp);
                EC = ReprojectionErrorMod(Coord2Dl, Coord2Dp, Coord2Dln, Coord2Dpn, VecP0, VecPC);
            end
            
            % ���������� � � h
            
            % ���� � ������ h, �� ��������
            if (EC < EVec(h))
                VecP(:,h) = VecPC;
                EVec(h) = EC;
                % ������ �������� �� ����������----------------------------
            else
                % (EC > EVec(h))
                % �� ������� �������� � ����� � ����������� ��������� ������
                VecP(:,i) = VecP(:,l) + 0.5*(VecP(:,i) - VecP(:,l));
                
                for i = 1:(N+1)
                    [Coord2Dln, Coord2Dpn] = GetNewCoord2D(VecP(:,i), Matrix0, Coord2Dl, Coord2Dp);
                    EVec(i) = ReprojectionErrorMod(Coord2Dl, Coord2Dp, Coord2Dln, Coord2Dpn, VecP0, VecP(:,i));
                end
                % ������ �������� �� ����������----------------------------
                PM = PM + 1;
            end
        end
    end
    
    % �������� �� ���������� �� ���� ���������
    flagS = 1;
    
    % ������ ������������ ���������� ������� ������
    % ������� �������� ������
    Emean = 0;
    
    for i = 1:(N+1)
        Emean = Emean + EVec(i);
    end
    
    Emean = (1/(N+1))*Emean;
    
    % ����������� ����������
    Sigma = 0;
    
    for i = 1:(N+1)
        Sigma = Sigma + (EVec(i) - Emean)^(2);
    end
    
    Sigma = sqrt(Sigma/(N+1));
    
    % �������� �� ������������ ��������
    if (Sigma > DeltaE)
        flagS = 0;
    end
    
    % ������ ���� ���� ��������� ������������ ������ �����
    if (flagS == 1)
        
        dm = zeros(N,N+1);

        for i = 1:(N+1)
            % ���������� ����� ��������� ���������
            dm(:,i) = VecP(:,i) - VecP(:,l);

            % ������� �� ���������� ������� ����� �� ��� ��������
            for j = 1:3
                if (abs(dm(j,i)) > DeltaT)
                    flagS = 0;
                    break
                end
            end

            % ���� ���������, �� ��������
            if (flagS == 0)
                break
            end

            % ������� �� ���������� ������� ����� �� ��� ��������
            for j = 4:6
                if (abs(dm(j,i)) > DeltaR)
                    flagS = 0;
                    break
                end
            end

            % ���� ���������, �� ��������
            if (flagS == 0)
                break
            end
        end
    end
    
    % ������� �� �����, �.�. ��������� ����������
    if (flagS == 1)
        break
    end
    
    Iters = Iters + 1;
end

[~,l] = min(EVec);
VecPInv = VecP(:,l);

end
