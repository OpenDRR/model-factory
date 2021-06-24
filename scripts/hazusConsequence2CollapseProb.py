import pandas as pd
import openpyxl


def main():
    df = pd.read_excel('Hazus_Consequence_Parameters.xlsx',
                       engine='openpyxl',  # Necessary for .xlsx
                       sheet_name='Collapse Rates',
                       skiprows=2, header=None,  # Drop the first 2 rows,
                       names=['eqbldgtype', 'collapse_pc'])  # Add column names

    # Convert percentages to decimal
    df['collapse_pc'] /= 100

    # Add typology column and copy over eqbldgtype values
    df.loc[:, 'typology'] = df['eqbldgtype']

    # Convert to .csv and add quotes around all entries
    df.to_csv('collapse_probability.csv', index=False,
              quoting=1)


if __name__ == '__main__':
    main()
