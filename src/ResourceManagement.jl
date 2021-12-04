module ResourceManagement

# Dependancies:
using CSV
using DataFrames
using Plots
using Missings
using Statistics
using StatsBase
using Dates



# Importiong packages that will then be extended.
import Base.+
import Statistics.mean


# Includes

include("types.jl");
using .types: TeamLabor  # Brings Team labor data type into scope.
using .types: DisciplineLabor  # Brings Discipline labor data type into scope.
using .types: LaborVariable # Brings Laborvariable data type into scope.


# exports
export DisciplineLabor, TeamLabor
export +
export Statistics, mean
export ReadLaborTracker, ReadAvailHours, getAvailMonthHours, writeAvailableFwdHours!
export _getEmployeePlannedHours, fetchAndWritePlannedHours!, getFwdPlannedHours
export getUtilization



















"""
    Statistics.mean(x::Float64, y::Float64)

Extends Statistics.mean to return the mean of two numbers.

# Arguments
- `x::Float64`: First number
- `y::Float64`: Second number

# Returns
- `Float64`: Mean of two numbers
"""
function Statistics.mean(x::Float64, y::Float64)
    return (x + y) / 2.0
end



"""
    _TeamBuilder(x::DisciplineLabor, y::DisciplineLabor)

Function to add two DisciplineLabor objects together.

# Arguments
- `x::DisciplineLabor`: First DisciplineLabor object
- `y::DisciplineLabor`: Second DisciplineLabor object to add

# Returns
- `T::TeamLabor`: Team Labor object
"""
function _TeamBuilder(x::DisciplineLabor, y::DisciplineLabor)
    T = TeamLabor()
    push!(T.Team, x)
    push!(T.Team, y)

    # TODO : Implement a more elegant way to add projects. Right now, duplicate projects can be added
    
    # _Projects = Array{String, 1}();

    xlen = count([isassigned(x.Projects, i) for i in 1:length(x.Projects)])
    ylen = count([isassigned(y.Projects, i) for i in 1:length(y.Projects)])

    [push!(T.Projects, x.Projects[i]) for i in 1:xlen if x.Projects[i] ∉ T.Projects];
    [push!(T.Projects, y.Projects[i]) for i in 1:ylen if y.Projects[i] ∉ T.Projects];
    
    

    T.Name = x.Name * " & " * y.Name
    T.Rate = Statistics.mean(x.Rate, y.Rate)
    T.BudgetHours = x.BudgetHours + y.BudgetHours
    T.BudgetDollars = x.BudgetDollars + y.BudgetDollars
    T.TravelBudgetDollars = x.TravelBudgetDollars + y.TravelBudgetDollars

    T.ActualHours = x.ActualHours + y.ActualHours
    T.ActualIncurredCost = x.ActualIncurredCost + y.ActualIncurredCost

    T.FwdHoursAvailable = x.FwdHoursAvailable + y.FwdHoursAvailable
    T.RevHoursAvailable = x.RevHoursAvailable + y.RevHoursAvailable

    T.FwdHoursForecast = x.FwdHoursForecast + y.FwdHoursForecast
    T.RevHoursForecast = x.RevHoursForecast + y.RevHoursForecast
    
    T.FwdCostsForecast = x.FwdCostsForecast + y.FwdCostsForecast
    T.RevCostsForecast = x.RevCostsForecast + y.RevCostsForecast

    T.RevActualHours = x.RevActualHours + y.RevActualHours
    T.RevActualCostHours = x.RevActualCostHours + y.RevActualCostHours


    return T
end




"""
    _TeamBuilder(x::DisciplineLabor, y::DisciplineLabor)

Function to add two DisciplineLabor objects together.

# Arguments
- `x::TeamLabor`: TeamLabor Object to add
- `y::DisciplineLabor`: Second DisciplineLabor object to add

# Returns
- `T::TeamLabor`: Team Labor object
"""
function _TeamBuilder(x::TeamLabor, y::DisciplineLabor)
    T = x
    
    push!(T.Team, y)


    # TODO: Implement add projects from y to x
    
    

    xlen = count([isassigned(x.Projects, i) for i in 1:length(x.Projects)])
    ylen = count([isassigned(y.Projects, i) for i in 1:length(y.Projects)])

    [push!(x.Projects, y.Projects[i]) for i in 1:ylen if y.Projects[i] ∉ x.Projects];

    T.Name = x.Name * " & " * y.Name
    T.Rate = mean(x.Rate, y.Rate)
    T.BudgetHours = x.BudgetHours + y.BudgetHours
    T.BudgetDollars = x.BudgetDollars + y.BudgetDollars
    T.TravelBudgetDollars = x.TravelBudgetDollars + y.TravelBudgetDollars
    T.ActualHours = x.ActualHours + y.ActualHours
    T.ActualIncurredCost = x.ActualIncurredCost + y.ActualIncurredCost

    T.FwdHoursForecast = x.FwdHoursForecast + y.FwdHoursForecast
    T.RevHoursForecast = x.RevHoursForecast + y.RevHoursForecast

    T.FwdCostsForecast = x.FwdCostsForecast + y.FwdCostsForecast
    T.RevCostsForecast = x.RevCostsForecast + y.RevCostsForecast

    T.RevActualHours = x.RevActualHours + y.RevActualHours
    T.RevActualCostHours = x.RevActualCostHours + y.RevActualCostHours
    


    return T
end    










"""
    Base.+(x::DisciplineLabor , y::DisciplineLabor)

Extends Base.+ to add two DisciplineLabor objects together.

# Arguments
- `x::DisciplineLabor`: First DisciplineLabor object to add
- `y::DisciplineLabor`: Second DisciplineLabor object to add


# Returns
- Nothing. Function calls _TeamBuilder to add two DisciplineLabor objects together.
"""
function +(x::DisciplineLabor , y::DisciplineLabor)
    _TeamBuilder(x , y)
end
    


"""
    Base.+(x::TeamLabor , y::DisciplineLabor)

Extends Base.+ to add TeamLabor and DisciplineLabor together.

# Arguments
- `x::TeamLabor`: TeamLabor object to add
- `y::DisciplineLabor`: DisciplineLabor object to add


# Returns
- Nothing. Function calls _TeamBuilder to add the two objects together.
"""
function +(x::TeamLabor , y::DisciplineLabor)
    _TeamBuilder(x , y)
end






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
    _getEmployeePlannedHours(df::DataFrame, name::String, m::Int)

    Function to filter df by Employee name. 

# Arguments
- `df::DataFrame`: dataframe of report (output of ReadLaborTracker)
- `name::String`: name of employee (need to match sap name)
- `m::Int`: number of months

# Returns
- `v::Vector`: Vector with the hours for each month
- `p:: Vector`: Vector with employee's projects

# Example:

```julia
    vh, pv = getEmployeePlannedHours(dflabor, "Doe John", 24)
```

"""
function _getEmployeePlannedHours(df::DataFrame, name::String, m::Int)
    startcol = 9; #column where first planned hours are

    filter = (df."Employee Name").==name
    df = df[filter,:]
    cols = [startcol+3*cols for cols in 0: m-1]
    p = df[:,2]; # vector with employee Projects
    v = [(collect(df[:,cols[i]])) for i in 1: length(cols)]

    return v, p
end




"""
Function to pad vector from the end with zeroes.
Parameters:
    v: vector to pad
    n: number of zeroes to pad
"""
function _pad_zerosEnd(v, n)
    if n > length(v)
        v = [v; zeros(n - length(v),1)]
    end
    return v
end








"""
    fetchAndWritePlannedHours!(df::DataFrame, name::String, m::Int, D::LaborVariable)

Function to fetch planned hours from ACTUAL_PLANNED SAP report 
for a given Employee name and number of months.
Function will then save information to the LaborVariable object.
LaborVariable.FwdHoursForecast[1] will hold the current month.
 
# Arguments
- `df::DataFrame`: df labor DataFrame
- `name::String`: Name of Employee
- `m::Int`: number of months to fetch and save
- `D::LaborVariable`: LaborVariable object to save information to

# Returns
- `vh`: Array of vectors with Planned Hours for each month for projects
- `pv`: Array of vectors with Projects
- `D::LaborVariable` : LaborVariable object with the updated information.

# Throws
- `undefined Projects`: if projects do not match or are not found.
"""
function fetchAndWritePlannedHours!(df::DataFrame, name::String, m::Int, D::LaborVariable)

    vh, pv = _getEmployeePlannedHours(df, name, m)
    l = length(D.FwdHoursForecast); #number of months in the DisciplineLabor object
    pvu = unique(pv);
    
    try
        
        [push!(D.Projects, pvu[i]) for i in 1:length(pvu) if pvu[i] ∉ D.Projects];
    catch
        @warn("undefined Projects")
    end
    
    for m in 1:length(vh)
        for i in enumerate(unique(pv))
            
            D.FwdHoursForecast[m, i[1]] = sum(vh[m][pv .== i[2]])
            # push!(t, sum(V[m][pv .== p]))
        end
    
    end
    
    return vh, unique(pv), D
end





"""
    getFwdPlannedHours(D::LaborVariable, proj::String)

Function to get planned hours for a given project from a LaborVariable object.

# Arguments
- `D::LaborVariable`: LaborVariable object to get information from
- `proj::String`: Project to get information for. If no project is given ("") or found,
    function will return all projects.

# Returns
- `v::Vector`: Vector with planned hours for the project

"""
function getFwdPlannedHours(D::LaborVariable, proj::String, V::Vector)
    v=[]
    if (proj ∉  D.Projects)

        for i in 1:length(V)

            x = sum(V[i])
            push!(v, x)
        end
        
    else
        for i in 1:length(V)
            v = push!(v, V[i][findfirst(x ->x == proj, D.Projects)])
        end

        
    end
    
    return v
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
    _getAvailMonthHours(df::DataFrame,  m::Int)

Function to read Available hours for each month from DataFrame.

# Arguments
- `df::DataFrame`: DataFrame (output of ReadAvailHours)

# Returns
- `v::Vector`: Vector with available hours for each month.  Pos [1] is current month.

# Example:

```julia
    V = getAvailMonthHours("C:\\Users\\james\\Desktop\\UTILREPORT_NOV.csv")
```

"""
function _getAvailMonthHours(df::DataFrame,  m::Int)

    startcol = 6; #column where first planned hours are
    df = df;
    cols = [startcol+3*cols for cols in 0: m-1]
    v = [(collect(df[:,cols[i]])) for i in 1: length(cols)]

    return v
end





"""
    writeAvailableFwdHours!(D::LaborVariable, df::DataFrame, m::Int)

Function will take an Array of Floats containing available monthly hours and 
and a LaborVariable and write the available hours to the LaborVariable FwdHoursAvailable field.
This is a mutable function.

# Arguments
- `D::LaborVariable`: LaborVariable object to write to
- `df::DataFrame`: DataFrame (output of ReadAvailHours)
- `m::Int`: number of months to write to

"""
function writeAvailableFwdHours!(D::LaborVariable, df::DataFrame, m::Int)

    V = _getAvailMonthHours(df, m)

    if length(V) == length(D.FwdHoursAvailable)
        D.FwdHoursAvailable = V
        
    else
        println("""
        Error:
        Vector length does not match LaborVariable length.
        """)
    end
end




"""
    getUtilization(D::LaborVariable, proj::String)

Function to get utilization for a given project from a LaborVariable object.
If  the given project is not found, function will return utilization for all projects.

# Arguments
- `D::LaborVariable`: LaborVariable object to get information from
- `proj::String`: Project to get information for. If no project is given ("") or found,
    function will return all projects.
- TODO: `V::Vector`: Vector with utilization for the project (TOO DEPENDANT ON OTHER FUNCTION)

# Returns
- `v::Vector`: Vector with utilization (percent) for the project

# Example:

```julia
    V = getUtilization(JohnDoe, "")
```
"""
function getUtilization(D::LaborVariable, proj::String, V::Vector)
    v=[];
    Vf = V;
    Vavail = D.FwdHoursAvailable;
    if (proj ∉  D.Projects)
        for i in 1:length(Vf)
            x = sum(Vf[i])/sum(Vavail[i])
            push!(v, x)
        end
        
    else 
        for i in 1: length(V)
            v = push!(v, Vf[i][findfirst(x ->x == proj, D.Projects)] / sum(Vavail[i]))
        end
    end

    return v

end





end
