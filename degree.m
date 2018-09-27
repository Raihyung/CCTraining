%% calculate the mean degree of each of four networks (FPN, CON, DMN, CBN) before and after training 

load('all_mats.mat')
all_mats(isnan(all_mats)) = 0;     % Connectivity matrices are stored in a 3D matrix of size M x M x N x 2 
                                   % (M is the number of nodes, N is the number of subjects, 2 is pre-training & post-training)
pre = all_mats(:,:,:,1);
post = all_mats(:,:,:,2);

pre = abs(pre);   % take the absolute value of all negative weights
post = abs(post);

for d = 15:60     % network density
    
    for n = 1:51     % subject
     
    mat = pre(:,:,n);    % individual connectivity matrices before training
    
    % proportional thresholds    
    n=size(mat,1);                                

    if max(max(abs(mat-mat.'))) < 1e-10            
    mat=triu(mat);                              
    ud=2;                                  
    else
     ud=1;
    end

    ind=find(mat);                               
    E=sortrows([ind mat(ind)], -2);               
    en=round((n^2-n)*(d/100)/ud);                    

    mat(E(en+1:end,1))=0;                         

    if ud==2                                    
        mat=mat+mat.';                               
    end
 
       mat = double(mat~=0);   % calculate degree 
    
    deg_pre(n,:,d-14) = sum(mat);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    mat = post(:,:,n);    % individual connectivity matrices after training
    
    % proportional thresholds 
    n=size(mat,1);                                

    if max(max(abs(mat-mat.'))) < 1e-10            
    mat=triu(mat);                              
    ud=2;                                  
    else
     ud=1;
    end

    ind=find(mat);                               
    E=sortrows([ind mat(ind)], -2);               
    en=round((n^2-n)*(d/100)/ud);                    

    mat(E(en+1:end,1))=0;                         

    if ud==2                                    
        mat=mat+mat.';                               
    end

   mat = double(mat~=0);   % calculate degree 
    
    deg_post(n,:,d-14) = sum(mat);
   
    end
  
    % calculate the mean degree of each network
    fpnpre(:,d-14) = mean(deg_pre(:,1:11,d-14),2);
    fpnpost(:,d-14) = mean(deg_post(:,1:11,d-14),2);
    conpre(:,d-14) = mean(deg_pre(:,12:18,d-14),2);
    conpost(:,d-14) = mean(deg_post(:,12:18,d-14),2);
    dmnpre(:,d-14) = mean(deg_pre(:,19:30,d-14),2);
    dmnpost(:,d-14) = mean(deg_post(:,19:30,d-14),2);
    cbnpre(:,d-14) = mean(deg_pre(:,31:34,d-14),2);
    cbnpost(:,d-14) = mean(deg_post(:,31:34,d-14),2);
        
end

FM = [fpnpre,fpnpost,conpre,conpost,dmnpre,dmnpost,cbnpre,cbnpost];

csvwrite('Degree.csv', FM)

