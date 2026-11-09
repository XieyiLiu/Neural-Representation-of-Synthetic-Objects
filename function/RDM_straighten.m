% Shared figure helper: Vectorize the strict lower triangle of an RDM by column.
function rdm_straighten = RDM_straighten(rdm_matrix)
count = 2;
rdm_straighten = [];
for i =1:length(rdm_matrix)-1
    rdm_straighten = [rdm_straighten;rdm_matrix(count:length(rdm_matrix),i)];
    count = count+1;
end
