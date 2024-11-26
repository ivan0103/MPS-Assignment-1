import pandas as pd
import os

instance_type = input("Enter instance type (instances/instance_small): ")
instance_name = input("Enter instance name (AS, 1_1, ...): ")

dir = os.path.dirname(os.path.abspath(__file__))

input_items = pd.read_csv(dir+f"/data/{instance_type}/{instance_name}/input_items.csv", sep=';')
input_parameters = pd.read_csv(dir+f"/data/{instance_type}/{instance_name}/input_parameters.csv", sep=';')
input_trucks = pd.read_csv(dir+f"/data/{instance_type}/{instance_name}/input_trucks.csv", sep=';')

input_items.drop(['Supplier dock', 'Plant dock', 'Product code', 'Package code', 'Forced orientation', 'Earliest arrival time', 'Latest arrival time', 'Max stackability'], axis=1, inplace=True)
input_trucks.drop(['Supplier loading order', 'Supplier dock', 'Supplier dock loading order', 'Plant dock', 'Plant dock loading order', 'Product code', 'Arrival time', 'Id truck', 'Stack with multiple docks', 'Max density', 'Max weight on the bottom item in stacks', 'EMmm', 'EMmr', 'CM', 'CJfm', 'CJfc', 'CJfh', 'EM', 'EJhr', 'EJcr', 'EJeh'], axis=1, inplace=True)

with open(dir+r"/input_items.dzn", 'w') as file:
    for col in input_items.columns:
        values = ', '.join(map(str, input_items[col]))
        file.write(f"{col} = [{values}];\n")

with open(dir+r"/input_parameters.dzn", 'w') as file:
    for col in input_parameters.columns:
        values = ', '.join(map(str, input_parameters[col]))
        file.write(f"{col} = [{values}];\n")

with open(dir+r"/input_trucks.dzn", 'w') as file:
    for col in input_trucks.columns:
        values = ', '.join(map(str, input_trucks[col]))
        file.write(f"{col} = [{values}];\n")