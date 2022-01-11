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

include("Utils.jl");
using .Utils: ReadLaborTracker
using .Utils: ReadAvailHours
using .Utils: dic_to_vec
using .Utils: vec_to_dic
using .Utils: ReadCostTracker


# exports
export DisciplineLabor, TeamLabor
export +
export Statistics, mean
export ReadLaborTracker, ReadAvailHours, getAvailMonthHours, writeAvailableFwdHours!
export _getEmployeeHoursFromDf, fetchAndWritePlannedHours!, getFwdPlannedHours, getRevPlannedHours
export getFwdUtilization
export getFwdAvailableMonthHours
export getName
export getProjects
export getDept
export getRate
export getCapacity
export _getAvailMonthHours
export fetchAndWriteRevActualHours!
export getRevActualHours
export dic_to_vec, vec_to_dic
export TeamDump
export ReadCostTracker





## Function Implementations for LaborVariable Data Type:
## getters
# function fetchAndWritePlannedHours!(df::DataFrame, name::String, m::Int, D::LaborVariable) end
# function fetchAndWriteRevActualHours!(df::DataFrame, name::String, m::Int, D::LaborVariable)
# function getFwdPlannedHours(D::LaborVariable, proj::String) end
# function getRevPlannedHours(D::LaborVariable, proj::String) end
# function writeAvailableFwdHours!(D::LaborVariable, df::DataFrame, m::Int) end
# function getFwdUtilization(D::LaborVariable, proj::String) end
# function getCapacity(D::LaborVariable) end
getFwdAvailableMonthHours(D::LaborVariable) = D.FwdHoursAvailable #one line function definition
getName(D::LaborVariable) = D.Name #one line function definition
getProjects(D::LaborVariable) = D.Projects #one line function definition
getDept(D::LaborVariable) = D.Dept #one line function definition to get Department name/number
getRate(D::LaborVariable) = D.Budget.Rate #one line function definition to get rate /budget
























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

    [push!(T.Projects, x.Projects[i]) for i in 1:length(x.Projects) if x.Projects[i] ∉ T.Projects];
    [push!(T.Projects, y.Projects[i]) for i in 1:length(y.Projects) if y.Projects[i] ∉ T.Projects];

    T.Name = x.Name * " & " * y.Name
    T.Budget.Rate = Statistics.mean(x.Budget.Rate, y.Budget.Rate)
    T.Budget.Hours = x.Budget.Hours + y.Budget.Hours
    T.Budget.Dollars = x.Budget.Dollars + y.Budget.Dollars
    T.Budget.TravelDollars = x.Budget.TravelDollars + y.Budget.TravelDollars

    T.ActualHours = x.ActualHours + y.ActualHours
    T.ActualIncurredCost = x.ActualIncurredCost + y.ActualIncurredCost

    T.FwdHoursAvailable = x.FwdHoursAvailable + y.FwdHoursAvailable
    T.RevHoursAvailable = x.RevHoursAvailable + y.RevHoursAvailable

    T.FwdHoursForecast = vcat(x.FwdHoursForecast, y.FwdHoursForecast) 
    T.RevHoursForecast = vcat(x.RevHoursForecast, y.RevHoursForecast) 
    
    T.FwdCostsForecast = x.FwdCostsForecast + y.FwdCostsForecast
    T.RevCostsForecast = x.RevCostsForecast + y.RevCostsForecast

    T.RevActualHours = vcat(x.RevActualHours, y.RevActualHours) 
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

    [push!(x.Projects, y.Projects[i]) for i in 1:length(y.Projects) if y.Projects[i] ∉ x.Projects];

    T.Name = x.Name * " & " * y.Name
    T.Budget.Rate = mean(x.Budget.Rate, y.Budget.Rate)
    T.Budget.Hours = x.Budget.Hours + y.Budget.Hours
    T.Budget.Dollars = x.Budget.Dollars + y.Budget.Dollars
    T.Budget.TravelDollars = x.Budget.TravelDollars + y.Budget.TravelDollars
    T.ActualHours = x.ActualHours + y.ActualHours
    T.ActualIncurredCost = x.ActualIncurredCost + y.ActualIncurredCost

    T.FwdHoursForecast = vcat(x.FwdHoursForecast, y.FwdHoursForecast)
    T.RevHoursForecast = vcat(x.RevHoursForecast, y.RevHoursForecast)

    T.FwdCostsForecast = x.FwdCostsForecast + y.FwdCostsForecast
    T.RevCostsForecast = x.RevCostsForecast + y.RevCostsForecast

    T.RevActualHours = vcat(x.RevActualHours, y.RevActualHours)
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
Function to transform df into a vector of vectors
rows of this vector will represent each month (18 months as default for rev report)
then each row will have a vector of hours for each project. Hours are summed for each project.

    function _getEmployeeHoursFromDf2(df::DataFrame, name::String, m::Int, col::Symbol)

# Parameters
# df: DataFrame
# name: String
# m: Int
# col: Symbol

# Returns
# v: Vector of vectors

"""
function _getEmployeeHoursFromDf(df::DataFrame, name::String, m::Int, col::Symbol)

    if col == :plan
        startcol = 9 #this matchs for both Fwd and Rev Sap Report
    elseif col == :actual
        startcol = 8
    else 
        startcol = 9 #defaults to plan
    end
    


    filter = (df."Employee Name").==name
    df = df[filter,:]
    cols = [startcol+3*cols for cols in 0: m-1]
    numbercols = [numbercols for numbercols in 2:m ]

    dfg = groupby(df, :"Project");
    

    dfg_hours_per_month_per_name = combine(dfg, cols .=>sum)

    return dfg_hours_per_month_per_name
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






function fetchAndWritePlannedHours!(df::DataFrame, name::String, m::Int, D::LaborVariable, target::Symbol)

    df2 = _getEmployeeHoursFromDf(df, name, m, :plan)
    
    try
        
        [push!(D.Projects, p) for p in df2.Project if p ∉ D.Projects];
    catch
        @warn("undefined Projects")
    end

    if target == :fwd
        D.FwdHoursForecast = copy(df2)
    elseif target == :rev
        D.RevHoursForecast = copy(df2)
    end
    
   
    
    return D
end





function fetchAndWriteRevActualHours!(df::DataFrame, name::String, m::Int, D::LaborVariable)

    df2 = _getEmployeeHoursFromDf(df, name, m, :actual)
    
    try
        
        [push!(D.Projects, p) for p in df2.Project if p ∉ D.Projects];
    catch
        @warn("undefined Projects")
    end

    
    D.RevActualHours = copy(df2)
    
    return D
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
function getFwdPlannedHours(D::LaborVariable, proj::String = "")
    v=[]
    months = names(D.FwdHoursForecast)[2:end] #get only month columns

    if (proj ∉  D.FwdHoursForecast.Project)

        
        v = combine(D.FwdHoursForecast, months .=>sum) #get combine hours per month
        v = Vector(v[1,:]) #vector of hours per month
        
        
    else
        filter = D.FwdHoursForecast.Project .== proj
        v = combine(D.FwdHoursForecast[filter, :], months .=>sum)
        v = Vector(v[1,:]) #vector of hours per month for the selected project


        
    end
    
    return v
end





"""
    getRevPlannedHours(D::LaborVariable, proj::String)

Function to get planned hours for a given project from a LaborVariable object.

# Arguments
- `D::LaborVariable`: LaborVariable object to get information from
- `proj::String`: Project to get information for. If no project is given ("") or found,
    function will return all projects.

# Returns
- `v::Vector`: Vector with planned hours for the project

"""
function getRevPlannedHours(D::LaborVariable, proj::String = "")
    v=[]
    months = names(D.RevHoursForecast)[2:end] #get only month columns

    if (proj ∉  D.RevHoursForecast.Project)

        
        v = combine(D.RevHoursForecast, months .=>sum) #get combine hours per month
        v = Vector(v[1,:]) #vector of hours per month
        
        
    else
        filter = D.RevHoursForecast.Project .== proj
        v = combine(D.RevHoursForecast[filter, :], months .=>sum)
        v = Vector(v[1,:]) #vector of hours per month for the selected project


        
    end
    
    return v
end






"""
    getRevActualHours(D::LaborVariable, proj::String)

Function to get planned hours for a given project from a LaborVariable object.

# Arguments
- `D::LaborVariable`: LaborVariable object to get information from
- `proj::String`: Project to get information for. If no project is given ("") or found,
    function will return all projects.

# Returns
- `v::Vector`: Vector with planned hours for the project

"""
function getRevActualHours(D::LaborVariable, proj::String = "")
    v=[]
    months = names(D.RevActualHours)[2:end] #get only month columns

    if (proj ∉  D.RevActualHours.Project)

        
        v = combine(D.RevActualHours, months .=>sum) #get combine hours per month
        v = Vector(v[1,:]) #vector of hours per month
        
        
    else
        filter = D.RevActualHours.Project .== proj
        v = combine(D.RevActualHours[filter, :], months .=>sum)
        v = Vector(v[1,:]) #vector of hours per month for the selected project


        
    end
    
    return v
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

    for i in V
        push!(D.FwdHoursAvailable, i[1])
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
function getFwdUtilization(D::LaborVariable, proj::String = "")
    v=[];
    if (proj ∈  D.Projects)
        v = (getFwdPlannedHours(D, proj)) ./ (D.FwdHoursAvailable)

    else 
        v = (getFwdPlannedHours(D)) ./ (D.FwdHoursAvailable)
        
    end

    return v

end




"""
    getCapacity(D::LaborVariable)

Get Capacity of Resource from LaborVariable object.
Capacity is defined as the Difference between the sum of Available Hours for a given month and the sum of Planned Hours for a given month.

# Arguments
- `D::LaborVariable`: LaborVariable object to get information from

# Returns
- `v::Vector`: Vector with capacity for each month

"""
function getCapacity(D::LaborVariable)
    v = []
    v = D.FwdHoursAvailable - getFwdPlannedHours(D)
    
    return v
end




### TEAM LEVEL FUNCTIONS (THAT RETURN ALL MEMBERS OF THE TEAM ON DICTIONARY FORM)


"""
    function TeamDump(Team::TeamLabor, target::Symbol)

Function to iterate over all Team Resources and output `target` field as Dict pairs

# Arguments
`Team::TeamLabor`: TeamLabor object
`target::Symbol`: Symbol of field to dump
        targets:
            :TotalFwdPlannedHours (monthly FwdPlannedHours vector for all projects)


# Returns
`Dict`: Dict of Team Resources with `target` field
        Keys are Employee names
        Values are Dict of `target` field
"""
function TeamDump(Team::TeamLabor, target::Symbol)
    dict = Dict()
    v_nam=[] #vector of names
    v_vals=[] #vector of values

    for i in 1:length(Team.Team)
        push!(v_nam, Team.Team[i].Name)
    end

    if target == :TotalFwdPlannedHours

        for i in 1:length(Team.Team)
            push!(v_vals, getFwdPlannedHours(Team.Team[i], "") )
        end

    elseif target == :TotalRevPlannedHours
            
            for i in 1:length(Team.Team)
                push!(v_vals, getRevPlannedHours(Team.Team[i], "") )
            end

        elseif target == :TotalRevActualHours
            
            for i in 1:length(Team.Team)
                push!(v_vals, getRevActualHours(Team.Team[i], "") )
            end

        elseif target == :FwdUtilization
            
            for i in 1:length(Team.Team)
                push!(v_vals, getFwdUtilization(Team.Team[i]) )
            end
    end

    dict = vec_to_dic(v_nam, v_vals)

    return dict
    
end




### cost tracker

function _getCostTrackerFromDf(df::DataFrame, Pnumber::Int, Dept::String)

    if Dept == "430300"
        strC = "CONT"
    elseif Dept == "430400"
        strM = "MECH"
    end

    filter = (df."Project Definition").==Pnumber & (df."Sub - product line").==Dept
    df = df[filter,:]
    

    return df
end




function fetchAndWriteProject!(df::DataFrame, p::Project)

    df2 = _CostTrackerFromDf(df, p.Number)
    
    
    
   
    
    return D
end




end

    




    











