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
using .types: Budget
using .types: Cost
using .types: Project
using .types: Program

include("Utils.jl");
using .Utils: ReadLaborTracker
using .Utils: ReadAvailHours
using .Utils: dic_to_vec
using .Utils: vec_to_dic
using .Utils: ReadCostTracker



# exports
export DisciplineLabor, TeamLabor, Cost, Budget, Project, Program
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
export fetchAndWriteProjectFinances!
export fetchAndWritePlannedProjHours!
export getProjectCostItem
export _tranfProjToDisciplineDf


# export Macros
# export @prettyPrint



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

    T.Name = x.Name * " & " * y.Name;
    

    

    T.FwdHoursForecast = vcat(x.FwdHoursForecast, y.FwdHoursForecast);
    T.RevHoursForecast = vcat(x.RevHoursForecast, y.RevHoursForecast);

    T.FwdCostsForecast = x.FwdCostsForecast + y.FwdCostsForecast;
    T.RevCostsForecast = x.RevCostsForecast + y.RevCostsForecast;

    T.RevActualHours = vcat(x.RevActualHours, y.RevActualHours);
    T.RevActualCostHours = x.RevActualCostHours + y.RevActualCostHours;
    


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
    Base.+(p1::Project , p2::Project)
Extends Base.+ to add two Project objects together.

# Arguments
- `p1::Project`: First Project object to add
- `p2::Project`: Second Project object to add

# Returns
- Nothing. Function calls _ProgramBuilder to add two Project objects together.

"""
function +(p1::Project , p2::Project)
    _ProgramBuilder(p1 , p2)
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
function _getEmployeeHoursFromDf(df::DataFrame, name::String, col::Symbol, m::Int=24)

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


function fetchAndWritePlannedHours!(df::DataFrame, name::String, D::DisciplineLabor, target::Symbol, m::Int=24)

    df2 = _getEmployeeHoursFromDf(df, name, :plan, m)
    rename!(df2, names(df2) .=> names(D.FwdHoursForecast))
    
    try
        
        [push!(D.Projects, p) for p in df2.Project if p ∉ D.Projects];
    catch
        @warn("undefined Projects")
    end

    if target == :fwd
        append!(D.FwdHoursForecast, df2, cols = :intersect);
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
function TeamDump(Team::TeamLabor, target::Symbol = :TotalFwdPlannedHours)
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

"""
    _getCostTrackerFromDf(df::DataFrame, Pnumber::Int, Dept::String)

Function to return  cost data relative to a given project number and department.

# Arguments
- `df::DataFrame`: DataFrame (output of ReadCostTracker)
- `Pnumber::Int`: Project number to get cost data for
- `Dept::String`: Department to get cost data for

# Returns
- `df:: DataFrame`: DataFrame with cost data for the given project and department


"""
function _getCostTrackerFromDf(df::DataFrame, Pnumber::String, Dept::String)

    if Dept == "430300"
        strC = "CONT"
    elseif Dept == "430400" # need to be verified
        strM = "MECH"
    end

    filter = ((df."Project Definition").== Pnumber) .& (occursin.(strC, df."Sub - product line"))
    df = df[filter,:]
    

    return df
end




function fetchAndWriteProjectFinances!(df::DataFrame, Pnumber::String, Dept::String, p::Project)

    df2 = _getCostTrackerFromDf(df, Pnumber, Dept); #get cost data for project relative to department and project number

    # create budget to push
    b = Budget(); #constructor for budget object

    b.Dept = Dept;
    b.QuotedDollars_HDWR =  df2.Quoted[1]; #HDWR is always position 1
    b.QuotedDollars_ENG = df2.Quoted[2]; #ENG is always position 2
    b.QuotedDollars_RESALE = df2.Quoted[3]; #RESALE is always position 3

    b.Var_HDWR = df2.Var[1] ; #HDWR is always position 1
    b.Var_ENG = df2.Var[2] ; #ENG is always position 2
    b.Var_RESALE = df2.Var[3] ; #RESALE is always position 3

    # create cost to push
    c = Cost(); #constructor for cost object

    c.Dept = Dept;

    c.Actual_HDWR = df2.Actual[1] ; #HDWR is always position 1
    c.Actual_ENG = df2.Actual[2]; #ENG is always position 2
    c.Actual_RESALE = df2.Actual[3]; #RESALE is always position 3

    c.Anticipated_HDWR = df2."Antic."[1]; #HDWR is always position 1
    c.Anticipated_ENG = df2."Antic."[2]; #ENG is always position 2
    c.Anticipated_RESALE = df2."Antic."[3]; #RESALE is always position 3

    c.Projected_HDWR = df2.Projected[1]; #HDWR is always position 1
    c.Projected_ENG = df2.Projected[2]; #eng is always position 2
    c.Projected_RESALE = df2.Projected[3]; #RESALE is always position 3


    # write to p object
    p.Number = df2."Project Definition"[1]; #project number
    p.Customer = df2."Project Description"[1]; #customer
    push!(p.Budget, b); #push budget to project
    push!(p.Cost, c); #push cost to project

    return p
    
end


function fetchAndWritePlannedProjHours!(df::DataFrame, p::Project, target::Symbol)

    
    
    dfp = df[:, 7:end] #select columns
    s =map(s -> occursin("Forecast", s), names(dfp)) #select columns containing "forecast" to be eliminated
    columns = map(v -> !v , s) #invert select to NOT select forecast columns
    dfp = dfp[:, columns] #select columns
    rename!(dfp, names(dfp) .=> names(p.FwdHoursForecast))
    
    

    if target == :fwd
        append!(p.FwdHoursForecast, dfp, cols = :intersect);
    elseif target == :rev
        p.RevHoursForecast = copy(df)
    end
    
   
    
    return p
end




function _tranfProjToDisciplineDf(p::Project, d::DisciplineLabor , name::String)

    df = filter(:Employee  => x  -> x  == name, p.FwdHoursForecast)

    dfw = df[:, 2:end] #subset  months FwdHoursForecast

    dfn = DataFrame(:Project => [p.Number]) #prepare dataframe with project number to insert into dfw

    dff = hcat(dfn, dfw) #concatenate project number and FwdHoursForecast

    _updateDisciplineProjNumber(p, d) #update project lists


    return append!(d.FwdHoursForecast, dff)


end


function _updateDisciplineProjNumber(p::Project, d::DisciplineLabor)

    if (p.Number ∉  d.Projects)
        push!(d.Projects, p.Number)
    end
    
    
end





function getProjectCostItem(p::Project, item::Symbol)

    if item == :Actual_ENG
        return p.Cost[1].Actual_ENG

    elseif item == :Anticipated_ENG
        return p.Cost[1].Anticipated_ENG
        
    elseif item == :Projected_ENG
        return p.Cost[1].Projected_ENG

    elseif item == :Actual_RESALE
        return p.Cost[1].Actual_RESALE

    elseif item == :Anticipated_RESALE
        return p.Cost[1].Anticipated_RESALE

    elseif item == :Projected_RESALE
        return p.Cost[1].Projected_RESALE

    elseif item == :Actual_HDWR
        return p.Cost[1].Actual_HDWR

    elseif item == :Anticipated_HDWR
        return p.Cost[1].Anticipated_HDWR

    elseif item == :Projected_HDWR
        return p.Cost[1].Projected_HDWR

    else 
        return println("Invalid Cost Item")
    end

    
end




"""
    getProjectNumbers(D::DisciplineLabor)

Functin that returns Project Numbers for a given Discipline. 
    This is multiple-dispatch function

Arguments:
- `D::DisciplineLabor`: DisciplineLabor object

Returns:
- Array of Strings with Project Numbers

"""
function getProjectNumbers(D::DisciplineLabor)

    return D.Projects #return array of strings with project numbers


end

"""
    getProjectNumbers(D::DisciplineLabor)

Functin that returns Project Numbers for a given Discipline. 
    This is multiple-dispatch function

Arguments:
- `p::Project`: Project object

Returns:
- Array of Strings with Project Numbers

"""
function getProjectNumbers(p::Project)

    projects = []; 
    push!(projects, p.Number);
    return projects;

end

"""
    getProjectNumbers(D::DisciplineLabor)

Functin that returns Project Numbers for a given Discipline. 
    This is multiple-dispatch function

Arguments:
- `t::TeamLabor `: TeamLabor object

Returns:
- Array of Strings with Project Numbers

"""
function getProjectNumbers(t::TeamLabor)

    return t.Projects

end





"""
    _ProgramBuilder(p1::Project, p2::Project)

Function to build a Program object from two Project objects. A Program is a collection of Projects.

# Arguments
- `p1::Project`: Project object to build Program from
- `p2::Project`: Project object to build Program from

# Returns
- `p::Program`: Program object built from p1 and p2

"""
function _ProgramBuilder(p1::Project, p2::Project)
    p = Program(); #constructor for program object

    push!(p.Projects, p1);
    push!(p.Projects, p2);

    return p
end















end

    




    











