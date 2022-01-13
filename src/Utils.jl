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
    ReadCostTracker(fName::String)

Function to read cost tracker report from SAP.
On SAP Report, you would input all project numbers which you may be interested. The report will pull them all.

# Arguments
- `fName::String`: filename of the report

# Returns
- `df::DataFrame`: DataFrame of the report

"""
function ReadCostTracker(fName::String)
    # This function takes report from SAP and saved as CSV file
    # Report from SAP to generate report: Cost Tracker - Sub Product Line



    df = CSV.read(fName, DataFrame)
    df = dropmissing(df, :"Sub - product line");

    sum(occursin.("," , df.Quoted)) > 0 ? df.Quoted = replace.(df.Quoted, "," => "") : ();
    sum(occursin.(",", df.Projected)) > 0 ?  df.Projected = replace.(df.Projected, "," => "") : ();
    sum(occursin.(",", df.Actual)) > 0 ?  df.Actual = replace.(df.Actual, "," => "") : ();
    # df.Actual = replace.(df.Actual, "," => "");
    # df.Var = replace.(df.Var, "," => "");
    # df.:"Antic." = replace.(df."Antic.", "," => "");

    # df.Quoted = parse.(Float64, df.Quoted);
    # df.Projected = parse.(Float64, df.Projected);
    # df.Actual = parse.(Float64, df.Actual);
    # df.Var = parse.(Float64, df.Var);
    # df.:"Antic." = parse.(Float64, df."Antic.");

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
function vec_to_dic(v_keys::Vector, v_vals::Vector)

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
