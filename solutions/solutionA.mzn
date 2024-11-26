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
