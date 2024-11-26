% Variables
int: num_items;
int: num_trucks;

array[1..num_items] of string: item_item_ident;
array[1..num_items] of int: item_supplier_code;
array[1..num_items] of int: item_plant_code;
array[1..num_items] of int: item_number_of_items;
array[1..num_items] of int: item_length;
array[1..num_items] of int: item_width;
array[1..num_items] of int: item_height;
array[1..num_items] of float: item_weight;
array[1..num_items] of int: item_nesting_height;
array[1..num_items] of string: item_stackability_code;
array[1..num_items] of int: item_inventory_cost;

array[1..num_trucks] of int: truck_supplier_code;
array[1..num_trucks] of int: truck_plant_code;
array[1..num_trucks] of int: truck_length;
array[1..num_trucks] of int: truck_width;
array[1..num_trucks] of int: truck_height;
array[1..num_trucks] of float: truck_max_weight;
array[1..num_trucks] of int: truck_cost;

float: coefficient_inventory_cost;
float: coefficient_transportation_cost;
float: coefficient_cost_extra_truck;
int: timelimit;

% Decision variables
array[1..num_items] of var 1..num_trucks: item_to_truck; % Assign each item to a truck
array[1..num_items] of var int: item_delivery_time;      % Delivery time for each item

% Auxiliary variables for truck usage
array[1..num_trucks] of var 0..1: truck_used;            % Binary indicator for truck usage
array[1..num_trucks] of var float: truck_weight;         % Total weight in each truck

% Objective
var float: total_transportation_cost =
    sum(t in 1..num_trucks)(truck_used[t] * truck_cost[t]);

var float: total_inventory_cost =
    sum(i in 1..num_items)(
        item_inventory_cost[i] * max(0, item_delivery_time[i] - item_delivery_time[i])
    );

var float: total_cost = coefficient_transportation_cost * total_transportation_cost +
                        coefficient_inventory_cost * total_inventory_cost;

% Constraints
% 1. Ensure all items are assigned to a truck
constraint forall(i in 1..num_items)(
    item_to_truck[i] >= 1 /\ item_to_truck[i] <= num_trucks
);

% 2. Ensure truck capacity is not exceeded
constraint forall(t in 1..num_trucks)(
    truck_weight[t] = sum(i in 1..num_items where item_to_truck[i] = t)(item_weight[i])
    /\
    truck_weight[t] <= truck_max_weight[t]
);

% 3. Ensure items are delivered within their time windows
constraint forall(i in 1..num_items)(
    item_delivery_time[i] >= 0 /\ item_delivery_time[i] <= timelimit
);

% 4. Stackability constraints
constraint forall(i, j in 1..num_items where i != j)(
    item_stackability_code[i] = item_stackability_code[j] ->
    item_to_truck[i] = item_to_truck[j]
);

% 5. Ensure all trucks that have items assigned are marked as used
constraint forall(t in 1..num_trucks)(
    truck_used[t] = bool2int(exists(i in 1..num_items)(item_to_truck[i] = t))
);

% Solve statement
solve minimize total_cost;