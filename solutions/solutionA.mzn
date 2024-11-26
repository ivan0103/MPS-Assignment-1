int: num_items = {num_items};
int: num_trucks = {num_trucks};

array[1..num_items] of int: item_length = {item_lengths};
array[1..num_items] of int: item_width = {item_widths};
array[1..num_items] of int: item_height = {item_heights};
array[1..num_items] of float: item_weight = {item_weights};
array[1..num_items] of int: item_stackability_code = {item_stackability_codes};
array[1..num_items] of int: item_max_stackability = {item_max_stackability};

array[1..num_trucks] of int: truck_length = {truck_lengths};
array[1..num_trucks] of int: truck_width = {truck_widths};
array[1..num_trucks] of int: truck_height = {truck_heights};
array[1..num_trucks] of float: truck_max_weight = {truck_max_weights};

% Cost coefficients
float: inventory_cost_coeff = {inventory_cost_coeff};
float: transport_cost_coeff = {transport_cost_coeff};
float: extra_truck_cost_coeff = {extra_truck_cost_coeff};

% Variables
array[1..num_items] of var 1..num_trucks: item_truck; % Truck assignment for each item
array[1..num_items] of var 1..num_items: item_stack;  % Stack assignment for each item

% Constraints
% 1. Ensure all items are assigned to a valid truck
constraint forall(i in 1..num_items) (
    item_truck[i] > 0 /\ item_truck[i] <= num_trucks
);

% 2. Stackability: Items in a stack must have the same stackability code
constraint forall(s in 1..num_items) (
    let {set of int: stack_items = {i | i in 1..num_items where item_stack[i] = s}} in
    (card(stack_items) > 0 -> forall(i, j in stack_items where i != j) (
        item_stackability_code[i] = item_stackability_code[j]
    ))
);

% 3. Max stack height per truck
constraint forall(t in 1..num_trucks) (
    let {set of int: truck_items = {i | i in 1..num_items where item_truck[i] = t}} in
    sum(i in truck_items) (item_height[i]) <= truck_height[t]
);

% 4. Max truck weight
constraint forall(t in 1..num_trucks) (
    let {set of int: truck_items = {i | i in 1..num_items where item_truck[i] = t}} in
    sum(i in truck_items) (item_weight[i]) <= truck_max_weight[t]
);

% 5. Area of stacks and trucks
constraint forall(t in 1..num_trucks) (
    let {set of int: truck_stacks = {s | s in 1..num_items where item_truck[s] = t}} in
    sum(s in truck_stacks) (item_length[s] * item_width[s]) <= truck_length[t] * truck_width[t]
);

% % 6: Number of items in a stack must not exceed the smallest max stackability of the items in the stack
% constraint forall(s in 1..num_items) (
%     let {set of int: stack_items = {i | i in 1..num_items where item_stack[i] = s},
%         int: min_stackability = if card(stack_items) > 0 then min([item_max_stackability[i] | i in stack_items]) else 0}
%     in card(stack_items) <= min_stackability
% );

% Objective: Minimize total transportation and inventory costs
var float: total_cost = sum(t in 1..num_trucks) (
    (transport_cost_coeff + extra_truck_cost_coeff) * card({i | i in 1..num_items where item_truck[i] = t})
) + sum(i in 1..num_items) (
    inventory_cost_coeff * item_weight[i]
);
solve minimize total_cost;

% Output
output [
    "Total cost: ", show(total_cost), "\n",
    "Truck assignments: ", show(item_truck), "\n",
    "Stack assignments: ", show(item_stack), "\n"
];
