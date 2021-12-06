module Utils

# Dependancies:
using CSV
using DataFrames




"""
    ReadLaborTracker(fName::String)

Function to read ACTUAL_PLANNED hours from SAP.
Report should be saved in CSV format.
Rows with missing names of resources are ignored.

# Arguments
- `fName::String`: filename of the report

# Returns
- `df::DataFrame`: DataFrame of the report

# Example:

```julia
    df = ReadLaborTracker("C:\\Users\\james\\Desktop\\labor_tracker.csv")
```

"""
function ReadLaborTracker(fName::String)
    
    df = CSV.read(fName, DataFrame)
    df = dropmissing(df, :"Employee Name");

    
    return df;
end




"""
    ReadAvailHours(fName::String)

Function to read Available hours on a given month from SAP.
Report should be saved in CSV format.
YLF_UTIL_DEPT is used to pull available hours from.
Since SAP report only goes fwd 12 months, spreadhsheet can be 
edited to include avail hours beyond 12 months.

# Arguments
- `fName::String`: filename of the report

# Returns
- `df::DataFrame`: DataFrame of the report

# Example:

```julia
    df = ReadAvailHours("C:\\Users\\james\\Desktop\\labor_tracker.csv")
```

"""
function ReadAvailHours(fName::String)
    
    df = CSV.read(fName, DataFrame)
        
    return df;
end







end
