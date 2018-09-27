%% partition connectivity matrices into modules 

load('all_mats.mat')
all_mats(isnan(all_mats)) = 0;     % Connectivity matrices are stored in a 3D matrix of size M x M x N x 2 
                                   % (M is the number of nodes, N is the number of subjects, 2 is pre-training & post-training)

pre = all_mats(:,:,:,1);

for d = 15:60

premean = mean(pre,3);   

% proportional thresholds
n=size(premean,1);                                %number of nodes

if max(max(abs(premean-premean.'))) < 1e-10             
    premean=triu(premean);                              
    ud=2;                                   
else
    ud=1;
end

ind=find(premean);                                
E=sortrows([ind premean(ind)], -2);               
en=round((n^2-n)*(d/100)/ud);                     

premean(E(en+1:end,1))=0;                         

if ud==2                                    
    premean=premean+premean.';                                
end

MD(:,d-14) = community_louvain(premean,[],[],'modularity');   % Louvain algorithm from Brain Connectivity Toolbox 

end