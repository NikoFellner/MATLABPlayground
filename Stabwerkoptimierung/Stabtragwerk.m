function [u,S]=Stabtragwerk(EA,nKnoten,nStab,koord,konn,lager,F)

%Definition der Freiheitsgrad (dofs)
alldofs=1:2*nKnoten;
fixeddofs=[];
for i=1: size(lager, 1)
    if lager(i,2)==1
        dofs=lager(i,1)*2-1;
    else
        dofs=lager(i,1)*2;
    end
    fixeddofs=union(fixeddofs,dofs);
end
freedofs=setdiff(alldofs,fixeddofs);

%Aufbau des Kraftvektors
f=zeros(2*nKnoten,1);
for i=1: size(F, 1)
    f(F(i,1)*2-1)=F(i,2);
    f(F(i,1)*2)=F(i,3);
end

%Ermitteln der Balkenlängen LL
LL=((koord(konn(1:nStab,2),1)-koord(konn(1:nStab,1),1)).^2+(koord(konn(1:nStab,2),2)...
    -koord(konn(1:nStab,1),2)).^2).^0.5;

%Ermitteln der Verdrehung der einzelnen Staebe
for i=1:nStab
    y(i+1)=koord(konn(i,2),2);
    y(i)=koord(konn(i,1),2);
    x(i+1)=koord(konn(i,2),1);
    x(i)=koord(konn(i,1),1);
    
    if (y(i+1)>y(i)) && (x(i+1)>x(i))
        v(i)=atan((y(i)-y(i+1))/(x(i)-x(i+1)));
    end
    if (y(i+1)>y(i)) && (x(i+1)<x(i))
        v(i)=pi+atan((y(i)-y(i+1))/(x(i)-x(i+1)));
    end
    if (y(i+1)<y(i)) && (x(i+1)<x(i))
        v(i)=pi+atan((y(i)-y(i+1))/(x(i)-x(i+1)));
    end
    if (y(i+1)<y(i)) && (x(i+1)>x(i))
        v(i)=atan((y(i)-y(i+1))/(x(i)-x(i+1)));
    end
    
    if (y(i+1)==y(i)) && (x(i+1)>x(i))
        v(i)=0;
    end
    if (y(i+1)==y(i)) && (x(i+1)<x(i))
        v(i)=pi;
    end
    if (y(i+1)<y(i)) && (x(i+1)==x(i))
        v(i)=pi+pi/2;
    end
    if (y(i+1)>y(i)) && (x(i+1)==x(i))
        v(i)=pi/2;
    end
end

%Austellen der Steifigkeitsmatrix
K=zeros(length(alldofs),length(alldofs));
for i=1:nStab
    
    %Zuordnungsmatrix
    A=zeros(2,2*nKnoten);
    for j=1:2
        A((2*(j-1)+1),(2*(konn(i,j))-1))=1;
        A((2*(j-1)+2),(2*(konn(i,j))))=1;
    end
    cellA{i,1}=A;
    
    %Transformationsmatrix
    D=zeros(2,4);
    D=[cos(v(i)) sin(v(i)) 0 0;...
        0 0 cos(v(i)) sin(v(i))];
    cellD{i,1}=D;
    
    %Elementsteifigkeitsmatrix
    ks=EA(i)/LL(i)*[1 -1;...
        -1 1];
    
    %Aussummieren der Steifigkeitsmatrix
    K=K+A'*D'*ks*D*A;
end

%Berechnung der Verschiebung
u(fixeddofs)=0;
u(freedofs)=K(freedofs,freedofs)\f(freedofs);

%Berechnung der Stabkräfte
for i=1:nStab
    S(i)=EA(i)/LL(i)*[-1 1]*cellD{i,1}*cellA{i,1}*u';
end
