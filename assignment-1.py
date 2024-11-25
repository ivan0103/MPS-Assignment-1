import pandas as pd
import os

dir = os.path.dirname(os.path.abspath(__file__))

input_items = pd.read_csv(dir+r"\assignment 1\data\instances\BU\input_items.csv", sep=';')
input_parameters = pd.read_csv(dir+r"\assignment 1\data\instances\BU\input_parameters.csv", sep=';')
input_trucks = pd.read_csv(dir+r"\assignment 1\data\instances\BU\input_trucks.csv", sep=';')

input_items.drop(['Supplier dock', 'Plant dock', 'Product code', 'Package code', 'Forced orientation', 'Earliest arrival time', 'Latest arrival time', 'Max stackability'], axis=1, inplace=True)
input_trucks.drop(['Supplier loading order', 'Supplier dock', 'Supplier dock loading order', 'Plant dock', 'Plant dock loading order', 'Product code', 'Arrival time', 'Id truck', 'Stack with multiple docks', 'Max density', 'Max weight on the bottom item in stacks', 'EMmm', 'EMmr', 'CM', 'CJfm', 'CJfc', 'CJfh', 'EM', 'EJhr', 'EJcr', 'EJeh'], axis=1, inplace=True)

with open(dir+r"\assignment 1\input_items.dzn", 'w') as file:
    for col in input_items.columns:
        values = ', '.join(map(str, input_items[col]))
        file.write(f"{col} = [{values}];\n")

with open(dir+r"\assignment 1\input_parameters.dzn", 'w') as file:
    for col in input_parameters.columns:
        values = ', '.join(map(str, input_parameters[col]))
        file.write(f"{col} = [{values}];\n")

with open(dir+r"\assignment 1\input_trucks.dzn", 'w') as file:
    for col in input_trucks.columns:
        values = ', '.join(map(str, input_trucks[col]))
        file.write(f"{col} = [{values}];\n")