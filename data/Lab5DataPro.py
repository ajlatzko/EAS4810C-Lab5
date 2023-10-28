import os
import pandas as pd
import numpy as np

# Define the directory where your data files are located
data_directory = 'raw data'  # Replace with your actual data directory path

# Define the specific alpha and port values
alpha_values = [-13, -12, -11, -10, -9, -8, -7, -5, -3, 0, 3, 5, 7, 8, 9, 10, 11, 12, 13]
port_values = list(range(2, 10))

# Create a dictionary to store the pressure data DataFrames for each alpha
pressure_data = {}

# Iterate over alpha values and create a DataFrame for each
for alpha in alpha_values:
    alpha_data = pd.DataFrame()
    for port in port_values:
        file_name = f'a{alpha}_p{port}.txt'
        file_path = os.path.join(data_directory, file_name)
        try:
            data = pd.read_csv(file_path, header=None, names=[f'Port {port}'])
            #data = (data * 252.7) + (767.7 * 133.322368) # Convert to Pa and add atmospheric pressure to get static pressure
            alpha_data = pd.concat([alpha_data, data], axis=1)
        except FileNotFoundError:
            print(f"File not found: {file_path}")
        except Exception as e:
            print(f"Error reading file {file_path}: {str(e)}")
    pressure_data[alpha] = alpha_data

# Read the static pressure data into a separate DataFrame
static_file_path = os.path.join(data_directory, 'static.txt')
try:
    static_data = pd.read_csv(static_file_path, header=None, names=['Static'])
except FileNotFoundError:
    print(f"File not found: {static_file_path}")
    static_data = pd.DataFrame(columns=['static_pressure'])
except Exception as e:
    print(f"Error reading file {static_file_path}: {str(e)}")

# Calculate the mean and standard deviation for each port at each alpha
data = {} # Means
std_devs_dict = {}
uncertainties_dict = {}

for alpha in alpha_values:
    alpha_data = pressure_data[alpha]
    means = alpha_data.mean().tolist()
    std_devs = alpha_data.std().tolist()
    uncertainties = []
    for port in port_values:
        count = len(alpha_data[f'Port {port}'].dropna())
        uncertainty = 1.96 * (std_devs[port - 2] / (count**0.5))
        uncertainties.append(uncertainty)
    
    data[alpha] = means
    std_devs_dict[alpha] = std_devs
    uncertainties_dict[alpha] = uncertainties