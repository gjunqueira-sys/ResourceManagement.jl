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

# exports
export DisciplineLabor
export TeamLabor
export mean
export +
export Statistics



# Abstract class for all resource modules
abstract type ResourceVariable end

abstract type LaborVariable <: ResourceVariable end






"""
    DisciplineLabor


# Fields
- `Rate::Float64 `: stores the rate for the labor variable
- `BudgetHours::Float64`: stores budget for the resource in hours
- `BudgetDollars::Float64`: stores budget for the resource in Dollars
- `TravelBudgetDollars::Float64`: stores budget for Travel in Dollars
- `ActualHours::Float64 `: stores actual incurred hours for resource
- `ActualHours::Float64 `: stores actual incurred hours for resource
- `ActualIncurredCost::Float64`: stores actual incurred Costs
- `FwdHoursAvailable::Array`: stores monthly Hours Available from Present going forward
- `FwdHoursForecast::Array`: stores Forecast monthly Hours from Present month going forward
- `RevHoursForecast::Array`: stores Forecast monthly Hours from Present month going backwards (reverse)
- `RevHoursAvailable::Array`: stores Forecast monthly Hours from Present month going backwards (reverse)
- `FwdCostsForecast::Array`: stores forecasted monthly Labor cost  from Present going forward
- `RevCostsForecast::Array`: stores forecasted monthly Labor cost  from Present going backwards (reverse)
- `RevActualCostHours::Array `: stores monthly actual labor costs  from Present going backwards (reverse)
- `Dept::String`: stores Dept name
- `Name::String`: stores name of the resource
- `Projects::Array`: stores projects for the resource
"""
mutable struct  DisciplineLabor <:LaborVariable 

    Rate::Float64                   # engineering labor rate for project
    BudgetHours::Float64          # Labor budget in LaborBudgetHours
    BudgetDollars::Float64          # Labor Budget in Dollars
    TravelBudgetDollars::Float64    # travel Budget in Dollars
    ActualHours::Float64           # Total Incurred Hours
    ActualIncurredCost::Float64     # Total Incurred Cost


    FwdHoursAvailable::Array        # Fwd Hours Available on a given month.
    FwdHoursForecast::Array         # Array holding Hours Forecasted Fwd monthly(future). Element [1] is the first month forecasted.   
    RevHoursForecast::Array         # Array holding Hours Forecasted Rev monthly (in past). Element [1] is the first month forecasted. 
    RevHoursAvailable::Array        # Array holding Hours Available Rev monthly (in past). Element [1] is the first month forecasted.     

    FwdCostsForecast::Array          # Array holding costs Forecasted Fwd monthly (future)
    RevCostsForecast::Array         # Array holding costs Forecasted Rev  monthly (past)

    RevActualHours::Array        # Array holding Hours incurred Rev monthly (in past). Element [1] is the first month Actual Hours.
    RevActualCostHours::Array     # Array holding Hours in Dollar Amounts incurred Rev monthly (in past)

    Dept::String                        # Department for Discipline

    Name::String                    # name of resource

    Projects::Array                 # Project for Discipline


    """
        DisciplineLabor() 

    Standard Constructor for Discipline Labor.
    ```
    new(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Array{Float64, 1}(undef, 12), Array{Float64, 1}(undef, 12), Array{Float64, 1}(undef, 12), Array{Float64, 1}(undef, 12) ,
            Array{Float64, 1}(undef, 12), Array{Float64, 1}(undef, 12), "430300") 
    ```

        DisciplineLabor(Dept, N)
    Detailed Constructor for Discipline Labor. Specifies Dept and number of months to hold forecast and actuals (N)


    # Examples
    ```julia
    CE = DisciplineLabor()

    ```
    """
    function DisciplineLabor()      # standard constructor supplied, all zerors, with 12 months array as default 
 
        new(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Array{Float64, 1}(undef, 12), Array{Float64, 2}(undef, 12, 12),Array{Float64, 2}(undef, 12, 12), Array{Float64, 2}(undef, 12, 12),  Array{Float64, 2}(undef, 12, 12), Array{Float64, 2}(undef, 12,12) ,
        Array{Float64, 2}(undef, 12, 12), Array{Float64, 2}(undef, 12, 12), "430300","", Array{String, 1}())


    end


    """
        DisciplineLabor(Dept,Name, N) 

    Standard Constructor for Discipline Labor'

        # Parameters
        Dept::String
        Name::String
        N::Int

    ```
    new(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Array{Float64, 1}(undef, 12), Array{Float64, 1}(undef, 12), Array{Float64, 1}(undef, 12), Array{Float64, 1}(undef, 12) ,
            Array{Float64, 1}(undef, 12), Array{Float64, 1}(undef, 12), "430300") 
    ```

        DisciplineLabor(Dept, N)
    Detailed Constructor for Discipline Labor. Specifies Dept and number of months to hold forecast and actuals (N)


    # Examples
    ```julia
    CE = DisciplineLabor()

    ```
    """
    function DisciplineLabor(Dept::String, Name::String, N::Int)     # Constructor that can specify number of months for Fwd and Rev Forecasts and also Dept
        new(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Array{Float64, 1}(undef, N),  Array{Float64, 2}(undef, N,N),  Array{Float64, 2}(undef, N,N),  Array{Float64, 2}(undef, N, N), Array{Float64, 2}(undef, N,N), Array{Float64, 2}(undef, N,N),
        Array{Float64, 2}(undef, N,N), Array{Float64, 2}(undef, N,N), Dept, Name, Array{String, 1}())
    end


end





"""
    TeamLabor()

Generates a TeamLabor object.

# Arguments
- `Team::Array`: Array of DisciplineLabor objects
- `Name::String`: Name of the Team
- `Dept::String`: Department of the Team
- `Rate::Float64`: Engineering Labor Rate for the Team
- `BudgetHours::Float64`: Labor Budget in LaborBudgetHours
- `BudgetDollars::Float64`: Labor Budget in Dollars
- `TravelBudgetDollars::Float64`: travel Budget in Dollars
- `ActualHours::Float64`: Total Incurred Hours
- `ActualIncurredCost::Float64`: Total Incurred Cost
- `Projects::Array` : Array of Projects for the Team
- `FwdHoursAvailable::Array`: stores Fwd Hours Available on a given month.
- `FwdHoursForecast::Array`: stores Forecast monthly Hours from Present month going forward
- `RevHoursForecast::Array`: stores Forecast monthly Hours from Present month going backwards (reverse)
- `RevHoursAvailable::Array`: stores Available monthly Hours from Present month going backwards (reverse)
- `FwdCostsForecast::Array`: stores Forecasted monthly Labor cost  from Present going forward
- `RevCostsForecast::Array`: stores Forecasted monthly Labor cost  from Present going backwards (reverse)
- `RevActualHours::Array`: stores Actual monthly Hours from Present month going backwards (reverse)
- `RevActualCostHours::Array`: stores Actual monthly Labor cost  from Present going backwards (reverse)

# Returns
- `TeamLabor`: TeamLabor object
"""
mutable struct  TeamLabor <:LaborVariable

    Team::Array{DisciplineLabor, 1}
    Name::String # name of team
    Dept::String                        # Department for Discipline
    Rate::Float64                   #  labor rate for team
    BudgetHours::Float64           # Labor budget in LaborBudgetHours
    BudgetDollars::Float64          # Labor Budget in Dollars
    TravelBudgetDollars::Float64    # travel Budget in Dollars
    ActualHours::Float64            # Total Incurred Hours
    ActualIncurredCost::Float64     # Total Incurred Cost
    Projects::Array # project name
    FwdHoursAvailable::Array        # Fwd Hours Available on a given month.
    FwdHoursForecast::Array         # Array holding Hours Forecasted Fwd monthly(future). Element [1] is the first month forecasted.  
    RevHoursForecast::Array         # Array holding Hours Forecasted Rev monthly (in past). Element [1] is the first month forecasted.   
    RevHoursAvailable::Array        # Array holding Hours Available Rev monthly (in past). Element [1] is the first month forecasted.   
    FwdCostsForecast::Array          # Array holding costs Forecasted Fwd monthly (future)
    RevCostsForecast::Array         # Array holding costs Forecasted Rev  monthly (past)
    RevActualHours::Array        # Array holding Hours incurred Rev monthly (in past). Element [1] is the first month Actual Hours.
    RevActualCostHours::Array     # Array holding Hours in Dollar Amounts incurred Rev monthly (in past)
    
    function TeamLabor()
        new(Array{DisciplineLabor, 1}(),  "", "",0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Array{String, 1}(),Array{Float64, 1}(undef, 24), Array{Float64, 2}(undef, 24, 24),
        Array{Float64, 2}(undef, 24 ,24), Array{Float64, 2}(undef, 24, 24), Array{Float64, 2}(undef, 24, 24), Array{Float64, 2}(undef, 24, 24))
    end


end





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





end
