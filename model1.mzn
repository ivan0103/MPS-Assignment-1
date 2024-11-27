% Use this editor as a MiniZinc scratch bookt
int: trucks = 6;
int: item_size = 10;

enum truck_label = {supplier_code,plant_code,length,width,height,max_load,cost};

array [1..trucks,truck_label] of int: truck_table = 
  [|1, 4, 14500, 2400, 2800, 30000, 1500
   |1, 4, 14940, 2500, 2950, 24000, 1500
   |2, 4, 14940, 2500, 2950, 24000, 1500
   |2, 5, 14940, 2500, 2950, 24000, 1500
   |3, 5, 14940, 2500, 2950, 24000, 1500
   |3, 5, 14940, 2500, 2950, 24000, 1500|];

enum items = {ident_item, supplier_code_item, plant_code_item, number, length_item, width_item, height_item, nestin_height,wheight, max_stackability, stackability_code, inventory_cost };

array [1..item_size, items] of int: item_arr =
      [|1, 1, 4, 5, 200, 200, 200, 0,  100, 4, 4, 3
       |2, 1, 4, 3, 300, 100, 200, 10, 200, 4, 7, 3
       |3, 1, 4, 5, 200, 400, 300, 20, 50 , 3, 4, 3
       |4, 2, 4, 3, 500, 300, 300, 30, 100, 3, 8, 3
       |5, 2, 4, 5, 400, 400, 400, 40, 100, 2, 4, 3
       |6, 2, 5, 3, 300, 500, 400, 50, 100, 2, 6, 3
       |7, 2, 5, 5, 200, 600, 500, 60, 100, 1, 4, 3
       |8, 3, 5, 3, 100, 500, 500, 70, 100, 1, 5, 3
       |9, 3, 5, 5, 200, 400, 600, 80, 100, 2, 3, 3
       |10,3, 5, 3, 300, 300, 600, 90, 100, 2, 4, 3|];

array [1..trucks, 1..item_size] of var int: items_per_truck;

int: n = sum (i in 1..item_size)(item_arr[i,number]);

% [1] -> truck
% [2] -> item
% [3] -> amount
% [4] -> x origin
% [5] -> y origin

array [1..n, 1..5 ] of var int: truck_stack;


% see if wheight is not to much
constraint forall(t in 1..trucks)(
  sum (s in 1..n) (if truck_stack[s,1] != t /\ truck_stack[s,2] != 0 then 0 else truck_stack[s,2] * item_arr[truck_stack[s,1],wheight] endif) <= truck_table[t,max_load]
);
   
   
% check height
constraint forall(t in 1..trucks)(
  sum (s in 1..n) (if truck_stack[s,1] != t /\ truck_stack[s,2] != 0  then 0 else (truck_stack[s,2] * item_arr[truck_stack[s,1],height_item]) - ((truck_stack[s,2] -1) * item_arr[truck_stack[s,1],nestin_height])  endif) <= truck_table[t,height]
);


%%%%%% see if spatial details are satisfied

% No overlap between boxes
constraint forall (s in 1..n) (
  forall (s2 in s..n)(if truck_stack[s,1] == truck_stack[s2,1] 
  then ((truck_stack[s,4] + item_arr[truck_stack[s,2],length_item] < truck_stack[s2,4] \/ %% check x of second box
        truck_stack[s,4] > truck_stack[s2,4] + item_arr[truck_stack[s2,2],length_item]) /\
        (truck_stack[s,5] + item_arr[truck_stack[s,2],width_item] < truck_stack[s2,5] \/ %% check y of second box
        truck_stack[s,5] > truck_stack[s2,5] + item_arr[truck_stack[s2,2],width_item]))
  else (true) endif)
);  
   
% check length of truck
constraint forall (s in 1..n) (
  truck_stack[s,4] + item_arr[truck_stack[s,2],length_item] <=  truck_table[truck_stack[s,2], length]
);

% check with widht
constraint forall (s in 1..n) (
  truck_stack[s,5] + item_arr[truck_stack[s,2],width_item] <=  truck_table[truck_stack[s,2], width]
);

solve satisfy;
