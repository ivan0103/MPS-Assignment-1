include "globals.mzn";

int: n; % the width (and height) of the magic square
set of int: N = 1..n; % the index range for the rows and columns

% Magic[r,c] = the value at row r and column c of the magic square:
array[N,N] of var 1..n*n: Magic;
var int: magicSum; % the sum of each row, column, and major diagonal

% All values in the magic square are different:
constraint alldifferent(array1d(Magic)) :: domain;

% The sum of each row is equal to the magic sum:
constraint forall(r in N)(sum(Magic[r,..]) = magicSum);
% The sum of each column is equal to the magic sum:
constraint forall(c in N)(sum(Magic[..,c]) = magicSum);
% The sum of each major diagonal is equal to the magic sum:
constraint sum([Magic[    i,i] | i in N]) = magicSum;
constraint sum([Magic[n+1-i,i] | i in N]) = magicSum;

% Each row sums up to the magic sum, there are n rows,
% and their sum is equal to the sum of the entire magic square,
% hence the following implied constraint fixes magicSum
% and is useful under all solving technologies:
constraint n * magicSum = sum(1..n*n); % implied constraint

% Break the three rotation symmetries and three of the four
% reflection symmetries by requiring the top-left corner to
% be smaller than the other corners:
constraint symmetry_breaking_constraint(
    Magic[1,1] < Magic[1,n] /\
    Magic[1,1] < Magic[n,1] /\
    Magic[1,1] < Magic[n,n]
);
% Break the down-right-diagonal reflection symmetry by requiring the
% bottom-left corner to be smaller than the top-right corner:
constraint symmetry_breaking_constraint(Magic[n,1] < Magic[1,n]);

solve
% Search first on 4 corners, subject to objective function (below)
% and more constraints (diagonals + symmetry) than the other cells,
% in lower halves of bisections, due to arithmetic and minimisation:
  :: seq_search([
       int_search([Magic[i,j] | i,j in {1,n}],
                                input_order,indomain_split,complete),
       int_search(array1d(Magic),occurrence,indomain_split,complete)])
% Minimise the sum of the 4 corners of the magic square:
  minimize sum([Magic[i,j] | i,j in {1,n}]);

output
  ["Magic sum: ", show(magicSum), "\nMagic square: \n"] ++
  [show(Magic[r,c]) ++ if c=n then "\n" else " " endif | r,c in N]++
  ["CornerSum: ", show(sum([Magic[i,j] | i,j in {1,n}])), "\n"]
  ++ ["Corners: ", show([Magic[i,j] | i,j in {1,n}])];