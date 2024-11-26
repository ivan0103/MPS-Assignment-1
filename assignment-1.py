import pandas as pd
import os

instance_type = input("Enter instance type (instances/instances_small): ")
instance_name = input("Enter instance name (AS, 1_1, ...): ")

dir = os.path.dirname(os.path.abspath(__file__))

input_items = pd.read_csv(dir+f"/data/{instance_type}/{instance_name}/input_items.csv", sep=';')
input_parameters = pd.read_csv(dir+f"/data/{instance_type}/{instance_name}/input_parameters.csv", sep=';')
input_trucks = pd.read_csv(dir+f"/data/{instance_type}/{instance_name}/input_trucks.csv", sep=';')

input_items.drop(['Supplier dock', 'Plant dock', 'Product code', 'Package code', 'Forced orientation', 'Earliest arrival time', 'Latest arrival time', 'Max stackability'], axis=1, inplace=True)
input_trucks.drop(['Supplier loading order', 'Supplier dock', 'Supplier dock loading order', 'Plant dock', 'Plant dock loading order', 'Product code', 'Arrival time', 'Id truck', 'Stack with multiple docks', 'Max density', 'Max weight on the bottom item in stacks', 'EMmm', 'EMmr', 'CM', 'CJfm', 'CJfc', 'CJfh', 'EM', 'EJhr', 'EJcr', 'EJeh'], axis=1, inplace=True)

with open(dir+r"/input_items.dzn", 'w') as file:
    for col in input_items.columns:
        c = 'item_' + col.lower().replace(' ', '_')
        values = ', '.join(
            str(float(value.replace(',', '.'))) if isinstance(value, str) and value.replace(',', '.').replace('.', '', 1).isdigit()
            else (str(value).replace('.', ',') if isinstance(value, (float, int))
                  else f'"{value}"')
            for value in input_items[col]
        )
        file.write(f"{c} = [{values}];\n")
    file.write(f"num_items = {len(input_items)};\n")

with open(dir+r"/input_parameters.dzn", 'w') as file:
    for col in input_parameters.columns:
        c = col.lower().replace(' ', '_').replace('_(sec)', '')
        values = ', '.join(
            str(float(value.replace(',', '.'))) if isinstance(value, str) and value.replace(',', '.').replace('.', '', 1).isdigit()
            else str(value).replace('.', ',')
            for value in input_parameters[col]
        )
        file.write(f"{c} = {values};\n")

with open(dir+r"/input_trucks.dzn", 'w') as file:
    for col in input_trucks.columns:
        c = 'truck_' + col.lower().replace(' ', '_')
        values = ', '.join(
            str(float(value.replace(',', '.'))) if isinstance(value, str) and value.replace(',', '.').replace('.', '', 1).isdigit() 
            else (str(value).replace('.', ',') if isinstance(value, (float, int)) 
                  else f'"{value}"') 
            for value in input_trucks[col]
        )
        file.write(f"{c} = [{values}];\n")
    file.write(f"num_trucks = {len(input_trucks)};\n")