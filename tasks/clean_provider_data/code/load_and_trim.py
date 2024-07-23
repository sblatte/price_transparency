# Load in the big CSVs and save them as smaller dtas. Python much faster

import pandas as pd 
import sys

print("Command-line arguments:", sys.argv)
year = sys.argv[1]
year_int = int(year)
assert (2013 <= year_int <= 2022), "Year is in 2013-2022"


def load_and_trim(year):
    raw = pd.read_csv("../input/physician_procedure_raw_" + str(year) + ".csv", engine = "pyarrow", encoding='latin-1')
    trimmed_raw = raw[['Rndrng_NPI', 'Rndrng_Prvdr_State_FIPS', 'Rndrng_Prvdr_Zip5', 'HCPCS_Cd', 'Place_Of_Srvc', 'Tot_Srvcs', 'Avg_Sbmtd_Chrg', 'Avg_Mdcr_Stdzd_Amt', 'Avg_Mdcr_Alowd_Amt']]
    outfile = f"../output/trimmed_provider_data_{year}.dta"
    trimmed_raw.to_stata(outfile, write_index=False)

load_and_trim(year)
