function [x,y,z,h]=paixu(p,X,Y,Z,H)
% ¶Ôx,y,z,h½øÐÐÅÅÐò
p=mod(p,24);
if p==0
    x=X;
    y=Y;
    z=Z;
    h=H;
    
elseif p==1
    x=X;
    y=Z;
    z=H;
    h=Y;
    
elseif p==2
    x=X;
    y=H;
    z=Y;
    h=Z;
    
elseif p==3
    x=X;
    y=Y;
    z=H;
    h=Z;
elseif p==4
    x=X;
    y=H;
    z=Z;
    h=Y;
elseif p==5
    x=X;
    y=Z;
    z=Y;
    h=H;
elseif p==6
    x=Y;
    y=X;
    z=Z;
    h=H;
elseif p==7    
    x=Y;
    y=X;
    z=H;
    h=Z;
elseif p==8
    x=Y;
    y=Z;
    z=X;
    h=H;
elseif p==9   
    x=Y;
    y=Z;
    z=H;
    h=X;
elseif p==10
    x=Y;
    y=H;
    z=X;
    h=Z;
    
elseif p==11   
    x=Y;
    y=H;
    z=Z;
    h=X;
elseif p==12   
    x=Z;
    y=X;
    z=Y;
    h=H;
elseif p==13   
    x=Z;
    y=X;
    z=H;
    h=Y;
elseif p==14  
    x=Z;
    y=Y;
    z=X;
    h=H;
elseif p==15   
    x=Z;
    y=Y;
    z=H;
    h=X;
elseif p==16  
    x=Z;
    y=H;
    z=X;
    h=Y;
elseif p==17  
    x=Z;
    y=H;
    z=Y;
    h=X;
elseif p==18  
    x=H;
    y=X;
    z=Y;
    h=Z;
elseif p==19  
    x=H;
    y=X;
    z=Z;
    h=Y;
elseif p==20
    x=H;
    y=Y;
    z=X;
    h=Z;
elseif p==21 
    x=H;
    y=Y;
    z=Z;
    h=X;
elseif p==22
    x=H;
    y=Z;
    z=X;
    h=Y;
elseif p==23
    x=H;
    y=Z;
    z=Y;
    h=X;
    
end


end