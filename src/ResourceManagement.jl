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
import Base.:+
import Statistics

# exports
export DisciplineLabor



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
    +(x::DisciplineLabor , y::DisciplineLabor)

Adds two labor variables together.

# Arguments
- `x::DisciplineLabor`: The first labor variable to be added
- `y::DisciplineLabor`: The second labor variable to be added
"""
function Base.:+(x::DisciplineLabor , y::DisciplineLabor)
    _TeamBuilder(x , y)
end










end
