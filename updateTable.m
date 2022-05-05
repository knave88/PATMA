function myTable = updateTable(objects)

nRow = max(vertcat(objects.row));
nCol = max(vertcat(objects.col));

if isempty(nRow) || nRow == 0
    nRow = 1;
end

if isempty(nCol) || nCol == 0
    nCol = 1;
end

myTable = zeros(nRow, nCol);

for i = 1 : length(objects)
    myTable(objects(i).row,objects(i).col) = i;
end