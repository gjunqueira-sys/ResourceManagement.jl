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



"""
    vec_to_dic(v_vals::Vector, v_keys::Vector)

Function to convert vector pair to Dictionary format

# Arguments
- `v_vals::Vector`: vector of values
- `v_keys::Vector`: vector of keys

# Returns
- `dic::Dictionary`: Dictionary

"""
function vec_to_dic(v_vals::Vector, v_keys::Vector)

    @assert length(v_vals) == length(v_keys) "Vector lengths must match!"

    dic = Dict();
    for i = 1:length(v_vals)
        dic[v_keys[i]] = v_vals[i];
    end

    return dic;
end




"""
    dic_to_vec(dic::Dict)
Function to return Dictionary key:value pair  as two vectors: keys and values

# Arguments
- `dic::Dict`: Dictionary

# Returns
- `v_keys::Vector`: vector of keys
- `v_vals::Vector`: vector of values
"""
function dic_to_vec(dic::Dict)

    v_keys = [];
    v_vals = [];
    for k in keys(dic), v in values(dic)
        push!(v_keys, k);
        push!(v_vals, v);
    end

    return v_keys, v_vals;
end





end
