module types

using DataFrames

# Abstract class for all resource modules
abstract type ResourceVariable end

abstract type ProgramVariable end

abstract type ProjectVariable <: ProgramVariable end

abstract type LaborVariable <: ResourceVariable end

abstract type FinanceVariable end 

abstract type BudgetVariable <: FinanceVariable end

abstract type CostVariable <: FinanceVariable end


# -----------------------------------------------

# Concrete Type



"""
    BudgetVariable

# Fields
`Hours::Real` : Stores Budget Hours for the Object
`QuotedDollars::Real` : Stores Budget Dollars for the Object
`Rate::Real` : Stores Budget Rate for the Object (dollars per hour)
`TravelDollars::Real` : Stores Budget Travel Dollars for the Object
"""
mutable struct Budget <: BudgetVariable
    Dept ::String
    Hours::Real                 # Budget in hours
    Rate::Real                  # Rate of dollars per hour
    TravelDollars::Real         # Budget in dollars for travel

    QuotedDollars_ENG::Real         # Budget in dollars used for quoted costs
    Var_ENG :: Real                  # Difference between quoted budget and Projected costs

    QuotedDollars_HDWR::Real         # Budget in dollars used for quoted costs
    Var_HDWR :: Real                  # Difference between quoted budget and Projected costs

    QuotedDollars_RESALE::Real         # Budget in dollars used for quoted costs
    Var_RESALE :: Real                  # Difference between quoted budget and Projected costs

    function Budget()           # Standard Constructor Function

        new("", 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
        
    end

end


mutable struct Cost <: CostVariable

    Dept::String

    ActualHours::Real           # Cost in hours
    ActualTravel::Real          # Cost in dollars for travel

    Actual_ENG::Real                # Cost in dollars used for quoted costs
    Anticipated_ENG:: Real          # Cost in dollars for anticipated costs
    Projected_ENG:: Real            # Cost in dollars for projected costs

    Actual_HDWR::Real                # Cost in dollars used for quoted costs
    Anticipated_HDWR:: Real          # Cost in dollars for anticipated costs
    Projected_HDWR:: Real            # Cost in dollars for projected costs

    Actual_RESALE::Real                # Cost in dollars used for quoted costs
    Anticipated_RESALE:: Real          # Cost in dollars for anticipated costs
    Projected_RESALE:: Real            # Cost in dollars for projected costs


    function Cost() # Standard Constructor Function

        new("", 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
        
    end

end





mutable struct Project <: ProjectVariable 
    Number :: String              # Project Number
    Customer:: String           # Customer Name

    Budget::Array{Budget, 1}              # Budget for the Project
    Cost:: Array{Cost, 1}                  # Cost for the Project

    FwdHoursForecast::DataFrame         # Array holding Hours Forecasted Fwd monthly(future). Element [1] is the first month forecasted.   
    RevHoursForecast::DataFrame          # Array holding Hours Forecasted Rev monthly (in past). Element [1] is the first month forecasted.

    function Project(project::String, customer::String) # Standard Constructor Function

        new(project, customer, Array{Budget, 1}(), Array{Cost, 1}(), DataFrame(Employee=  Array{String,1}(), Month1 = Array{Int64, 1}(), Month2 = Array{Int64, 1}(), Month3 = Array{Int64, 1}(),
        Month4 = Array{Int64, 1}(), Month5 = Array{Int64, 1}(), Month6 = Array{Int64, 1}(), Month7 = Array{Int64, 1}(), Month8 = Array{Int64, 1}(),
        Month9 = Array{Int64, 1}(), Month10 = Array{Int64, 1}(), Month11 = Array{Int64, 1}(), Month12 = Array{Int64, 1}(),
        Month13 = Array{Int64, 1}(), Month14 = Array{Int64, 1}(), Month15 = Array{Int64, 1}(), Month16 = Array{Int64, 1}(), Month17 = Array{Int64, 1}(),
        Month18 = Array{Int64, 1}(), Month19 = Array{Int64, 1}(), Month20 = Array{Int64, 1}(), Month21 = Array{Int64, 1}(), Month22 = Array{Int64, 1}(),
        Month23 = Array{Int64, 1}(), Month24 = Array{Int64, 1}()), DataFrame(Project=  Array{String,1}(), Month1 = Array{Int64, 1}(), Month2 = Array{Int64, 1}(), Month3 = Array{Int64, 1}(),
        Month4 = Array{Int64, 1}(), Month5 = Array{Int64, 1}(), Month6 = Array{Int64, 1}(), Month7 = Array{Int64, 1}(), Month8 = Array{Int64, 1}(),
        Month9 = Array{Int64, 1}(), Month10 = Array{Int64, 1}(), Month11 = Array{Int64, 1}(), Month12 = Array{Int64, 1}(),
        Month13 = Array{Int64, 1}(), Month14 = Array{Int64, 1}(), Month15 = Array{Int64, 1}(), Month16 = Array{Int64, 1}(), Month17 = Array{Int64, 1}(),
        Month18 = Array{Int64, 1}(), Month19 = Array{Int64, 1}(), Month20 = Array{Int64, 1}(), Month21 = Array{Int64, 1}(), Month22 = Array{Int64, 1}(),
        Month23 = Array{Int64, 1}(), Month24 = Array{Int64, 1}()));
        
    end

end



"""
    Program <: ProgramVariable

    # Fields
    `Projects::Array{Project, 1}` : Stores the Projects for the Program
    `Name::String` : Stores the Name of the Program

"""
mutable struct Program <: ProgramVariable
    Name :: String              # Program Name
    Projects :: Array{Project, 1} # Projects in the Program
    function Program() # Standard Constructor Function

        new("", Array{Project, 1}());
        
    end

end




"""
    DisciplineLabor


# Fields
- `Hours::Real <:Budget` : Stores Budget Hours for the Object
- `Dollars::Real <: Budget` : Stores Budget Dollars for the Object
- `Rate::Real <: Budget` : Stores Budget Rate for the Object (dollars per hour)
- `TravelDollars::Real <: Budget` : Stores Budget Travel Dollars for the Object
- `ActualHours::Float64 `: stores actual incurred hours for resource
- `ActualHours::Float64 `: stores actual incurred hours for resource
- `ActualIncurredCost::Float64`: stores actual incurred Costs
- `FwdHoursAvailable::Array`: stores monthly Hours Available from Present going forward
- `FwdHoursForecast::Vector{Vector{Int64}} `: stores Forecast monthly Hours from Present month going forward
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

    FwdHoursAvailable::Array        # Fwd Hours Available on a given month.
    FwdHoursForecast::DataFrame         # Array holding Hours Forecasted Fwd monthly(future). Element [1] is the first month forecasted.   
    RevHoursForecast::DataFrame           # Array holding Hours Forecasted Rev monthly (in past). Element [1] is the first month forecasted. 
    RevHoursAvailable::Array        # Array holding Hours Available Rev monthly (in past). Element [1] is the first month forecasted.     

    FwdCostsForecast::Array          # Array holding costs Forecasted Fwd monthly (future)
    RevCostsForecast::Array         # Array holding costs Forecasted Rev  monthly (past)

    RevActualHours::DataFrame        # Array holding Hours incurred Rev monthly (in past). Element [1] is the first month Actual Hours.
    RevActualCostHours::Array     # Array holding Hours in Dollar Amounts incurred Rev monthly (in past)

    Dept::String                        # Department for Discipline

    Name::String                    # name of resource

    Projects::Array                 # Project for Discipline


    """
        DisciplineLabor() 

    Standard Constructor for Discipline Labor.
    ```
    new(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Array{Float64, 1}(undef, 12), Vector{Vector{Int64}}(), Array{Float64, 1}(undef, 12), Array{Float64, 1}(undef, 12) ,
            Array{Float64, 1}(undef, 12), Array{Float64, 1}(undef, 12), "430300") 
    ```

        DisciplineLabor(Dept, N)
    Detailed Constructor for Discipline Labor. Specifies Dept and number of months to hold forecast and actuals (N)


    # Examples
    ```julia
    CE = DisciplineLabor()

    ```
    """
    function DisciplineLabor()      # standard constructor supplied, all zerors, with 24 months array as default 


        
        new(Array{Float64, 1}(), DataFrame(Project=  Array{String,1}(), Month1 = Array{Int64, 1}(), Month2 = Array{Int64, 1}(), Month3 = Array{Int64, 1}(),
        Month4 = Array{Int64, 1}(), Month5 = Array{Int64, 1}(), Month6 = Array{Int64, 1}(), Month7 = Array{Int64, 1}(), Month8 = Array{Int64, 1}(),
        Month9 = Array{Int64, 1}(), Month10 = Array{Int64, 1}(), Month11 = Array{Int64, 1}(), Month12 = Array{Int64, 1}(),
        Month13 = Array{Int64, 1}(), Month14 = Array{Int64, 1}(), Month15 = Array{Int64, 1}(), Month16 = Array{Int64, 1}(), Month17 = Array{Int64, 1}(),
        Month18 = Array{Int64, 1}(), Month19 = Array{Int64, 1}(), Month20 = Array{Int64, 1}(), Month21 = Array{Int64, 1}(), Month22 = Array{Int64, 1}(),
        Month23 = Array{Int64, 1}(), Month24 = Array{Int64, 1}())
        ,
         DataFrame(Project=  Array{String,1}(), Month1 = Array{Int64, 1}(), Month2 = Array{Int64, 1}(), Month3 = Array{Int64, 1}(),
         Month4 = Array{Int64, 1}(), Month5 = Array{Int64, 1}(), Month6 = Array{Int64, 1}(), Month7 = Array{Int64, 1}(), Month8 = Array{Int64, 1}(),
            Month9 = Array{Int64, 1}(), Month10 = Array{Int64, 1}(), Month11 = Array{Int64, 1}(), Month12 = Array{Int64, 1}(),
            Month13 = Array{Int64, 1}(), Month14 = Array{Int64, 1}(), Month15 = Array{Int64, 1}(), Month16 = Array{Int64, 1}(), Month17 = Array{Int64, 1}(),
            Month18 = Array{Int64, 1}(), Month19 = Array{Int64, 1}(), Month20 = Array{Int64, 1}(), Month21 = Array{Int64, 1}(), Month22 = Array{Int64, 1}(),
            Month23 = Array{Int64, 1}(), Month24 = Array{Int64, 1}())
         , Array{Float64, 2}(undef, 24, 24),  Array{Float64, 2}(undef, 24, 24), Array{Float64, 2}(undef, 24,24) ,
        DataFrame(Project=  Array{String,1}(), Month1 = Array{Int64, 1}(), Month2 = Array{Int64, 1}(), Month3 = Array{Int64, 1}(),
        Month4 = Array{Int64, 1}(), Month5 = Array{Int64, 1}(), Month6 = Array{Int64, 1}(), Month7 = Array{Int64, 1}(), Month8 = Array{Int64, 1}(),
           Month9 = Array{Int64, 1}(), Month10 = Array{Int64, 1}(), Month11 = Array{Int64, 1}(), Month12 = Array{Int64, 1}(),
           Month13 = Array{Int64, 1}(), Month14 = Array{Int64, 1}(), Month15 = Array{Int64, 1}(), Month16 = Array{Int64, 1}(), Month17 = Array{Int64, 1}(),
           Month18 = Array{Int64, 1}(), Month19 = Array{Int64, 1}(), Month20 = Array{Int64, 1}(), Month21 = Array{Int64, 1}(), Month22 = Array{Int64, 1}(),
           Month23 = Array{Int64, 1}(), Month24 = Array{Int64, 1}())
           , Array{Float64, 2}(undef, 24, 24), "430300","", Array{String, 1}())


    end



    """
        DisciplineLabor(Dept,Name) 

    Standard Constructor for Discipline Labor'

        # Parameters
        Dept::String
        Name::String
        N::Int

    ```
    new(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Array{Float64, 1}(undef, 12), Vector{Vector{Int64}}(), Array{Float64, 1}(undef, 12), Array{Float64, 1}(undef, 12) ,
            Array{Float64, 1}(undef, 12), Array{Float64, 1}(undef, 12), "430300") 
    ```

        DisciplineLabor(Dept, N)
    Detailed Constructor for Discipline Labor. Specifies Dept and number of months to hold forecast and actuals (N)


    # Examples
    ```julia
    CE = DisciplineLabor()

    ```
    """
    function DisciplineLabor(Dept::String, Name::String)      # standard constructor supplied, all zerors, with 24 months array as default 


        
        new(Array{Float64, 1}(), DataFrame(Project=  Array{String,1}(), Month1 = Array{Int64, 1}(), Month2 = Array{Int64, 1}(), Month3 = Array{Int64, 1}(),
        Month4 = Array{Int64, 1}(), Month5 = Array{Int64, 1}(), Month6 = Array{Int64, 1}(), Month7 = Array{Int64, 1}(), Month8 = Array{Int64, 1}(),
        Month9 = Array{Int64, 1}(), Month10 = Array{Int64, 1}(), Month11 = Array{Int64, 1}(), Month12 = Array{Int64, 1}(),
        Month13 = Array{Int64, 1}(), Month14 = Array{Int64, 1}(), Month15 = Array{Int64, 1}(), Month16 = Array{Int64, 1}(), Month17 = Array{Int64, 1}(),
        Month18 = Array{Int64, 1}(), Month19 = Array{Int64, 1}(), Month20 = Array{Int64, 1}(), Month21 = Array{Int64, 1}(), Month22 = Array{Int64, 1}(),
        Month23 = Array{Int64, 1}(), Month24 = Array{Int64, 1}())
        ,
         DataFrame(Project=  Array{String,1}(), Month1 = Array{Int64, 1}(), Month2 = Array{Int64, 1}(), Month3 = Array{Int64, 1}(),
         Month4 = Array{Int64, 1}(), Month5 = Array{Int64, 1}(), Month6 = Array{Int64, 1}(), Month7 = Array{Int64, 1}(), Month8 = Array{Int64, 1}(),
            Month9 = Array{Int64, 1}(), Month10 = Array{Int64, 1}(), Month11 = Array{Int64, 1}(), Month12 = Array{Int64, 1}(),
            Month13 = Array{Int64, 1}(), Month14 = Array{Int64, 1}(), Month15 = Array{Int64, 1}(), Month16 = Array{Int64, 1}(), Month17 = Array{Int64, 1}(),
            Month18 = Array{Int64, 1}(), Month19 = Array{Int64, 1}(), Month20 = Array{Int64, 1}(), Month21 = Array{Int64, 1}(), Month22 = Array{Int64, 1}(),
            Month23 = Array{Int64, 1}(), Month24 = Array{Int64, 1}())
         , Array{Float64, 2}(undef, 24, 24),  Array{Float64, 2}(undef, 24, 24), Array{Float64, 2}(undef, 24,24) ,
        DataFrame(Project=  Array{String,1}(), Month1 = Array{Int64, 1}(), Month2 = Array{Int64, 1}(), Month3 = Array{Int64, 1}(),
        Month4 = Array{Int64, 1}(), Month5 = Array{Int64, 1}(), Month6 = Array{Int64, 1}(), Month7 = Array{Int64, 1}(), Month8 = Array{Int64, 1}(),
           Month9 = Array{Int64, 1}(), Month10 = Array{Int64, 1}(), Month11 = Array{Int64, 1}(), Month12 = Array{Int64, 1}(),
           Month13 = Array{Int64, 1}(), Month14 = Array{Int64, 1}(), Month15 = Array{Int64, 1}(), Month16 = Array{Int64, 1}(), Month17 = Array{Int64, 1}(),
           Month18 = Array{Int64, 1}(), Month19 = Array{Int64, 1}(), Month20 = Array{Int64, 1}(), Month21 = Array{Int64, 1}(), Month22 = Array{Int64, 1}(),
           Month23 = Array{Int64, 1}(), Month24 = Array{Int64, 1}())
           , Array{Float64, 2}(undef, 24, 24), Dept,Name, Array{String, 1}())


    end





end





"""
    TeamLabor()

Generates a TeamLabor object.

# Arguments
- `Team::Array`: Array of DisciplineLabor objects
- `Name::String`: Name of the Team
- `Dept::String`: Department of the Team
- `Hours::Real <:Budget` : Stores Budget Hours for the Object
- `Dollars::Real <: Budget` : Stores Budget Dollars for the Object
- `Rate::Real <: Budget` : Stores Budget Rate for the Object (dollars per hour)
- `TravelDollars::Real <: Budget` : Stores Budget Travel Dollars for the Object
- `ActualHours::Float64`: Total Incurred Hours
- `ActualIncurredCost::Float64`: Total Incurred Cost
- `Projects::Array` : Array of Projects for the Team
- `FwdHoursAvailable::Array`: stores Fwd Hours Available on a given month.
- `FwdHoursForecast::Vector{Vector{Int64}} `: stores Forecast monthly Hours from Present month going forward
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
    
    

    
    Projects::Array # project name
    FwdHoursAvailable::Array        # Fwd Hours Available on a given month.
    FwdHoursForecast::DataFrame        # DataFrame holding Hours Forecasted Fwd monthly(future). Element [1] is the first month forecasted.  
    RevHoursForecast::DataFrame        # Array holding Hours Forecasted Rev monthly (in past). Element [1] is the first month forecasted.   
    RevHoursAvailable::Array        # Array holding Hours Available Rev monthly (in past). Element [1] is the first month forecasted.   
    FwdCostsForecast::Array          # Array holding costs Forecasted Fwd monthly (future)
    RevCostsForecast::Array         # Array holding costs Forecasted Rev  monthly (past)
    RevActualHours::DataFrame       # Array holding Hours incurred Rev monthly (in past). Element [1] is the first month Actual Hours.
    RevActualCostHours::Array     # Array holding Hours in Dollar Amounts incurred Rev monthly (in past)
    
    function TeamLabor()
        new(Array{DisciplineLabor, 1}(),  "", "", Array{String, 1}(),
        Array{Float64, 1}(), DataFrame(Project=  Array{String,1}(), Month1 = Array{Int64, 1}(), Month2 = Array{Int64, 1}(), Month3 = Array{Int64, 1}(),
        Month4 = Array{Int64, 1}(), Month5 = Array{Int64, 1}(), Month6 = Array{Int64, 1}(), Month7 = Array{Int64, 1}(), Month8 = Array{Int64, 1}(),
        Month9 = Array{Int64, 1}(), Month10 = Array{Int64, 1}(), Month11 = Array{Int64, 1}(), Month12 = Array{Int64, 1}(),
        Month13 = Array{Int64, 1}(), Month14 = Array{Int64, 1}(), Month15 = Array{Int64, 1}(), Month16 = Array{Int64, 1}(), Month17 = Array{Int64, 1}(),
        Month18 = Array{Int64, 1}(), Month19 = Array{Int64, 1}(), Month20 = Array{Int64, 1}(), Month21 = Array{Int64, 1}(), Month22 = Array{Int64, 1}(),
        Month23 = Array{Int64, 1}(), Month24 = Array{Int64, 1}())
        ,
         DataFrame(Project=  Array{String,1}(), Month1 = Array{Int64, 1}(), Month2 = Array{Int64, 1}(), Month3 = Array{Int64, 1}(),
         Month4 = Array{Int64, 1}(), Month5 = Array{Int64, 1}(), Month6 = Array{Int64, 1}(), Month7 = Array{Int64, 1}(), Month8 = Array{Int64, 1}(),
            Month9 = Array{Int64, 1}(), Month10 = Array{Int64, 1}(), Month11 = Array{Int64, 1}(), Month12 = Array{Int64, 1}(),
            Month13 = Array{Int64, 1}(), Month14 = Array{Int64, 1}(), Month15 = Array{Int64, 1}(), Month16 = Array{Int64, 1}(), Month17 = Array{Int64, 1}(),
            Month18 = Array{Int64, 1}(), Month19 = Array{Int64, 1}(), Month20 = Array{Int64, 1}(), Month21 = Array{Int64, 1}(), Month22 = Array{Int64, 1}(),
            Month23 = Array{Int64, 1}(), Month24 = Array{Int64, 1}())
         , Array{Float64, 2}(undef, 24, 24),  Array{Float64, 2}(undef, 24, 24), Array{Float64, 2}(undef, 24,24) ,
        DataFrame(Project=  Array{String,1}(), Month1 = Array{Int64, 1}(), Month2 = Array{Int64, 1}(), Month3 = Array{Int64, 1}(),
        Month4 = Array{Int64, 1}(), Month5 = Array{Int64, 1}(), Month6 = Array{Int64, 1}(), Month7 = Array{Int64, 1}(), Month8 = Array{Int64, 1}(),
           Month9 = Array{Int64, 1}(), Month10 = Array{Int64, 1}(), Month11 = Array{Int64, 1}(), Month12 = Array{Int64, 1}(),
           Month13 = Array{Int64, 1}(), Month14 = Array{Int64, 1}(), Month15 = Array{Int64, 1}(), Month16 = Array{Int64, 1}(), Month17 = Array{Int64, 1}(),
           Month18 = Array{Int64, 1}(), Month19 = Array{Int64, 1}(), Month20 = Array{Int64, 1}(), Month21 = Array{Int64, 1}(), Month22 = Array{Int64, 1}(),
           Month23 = Array{Int64, 1}(), Month24 = Array{Int64, 1}())
           , Array{Float64, 2}(undef, 24, 24))
    end


end


# Defining how the types show up on Standard IO:
Base.show(io::IO, D::DisciplineLabor) = print(io, "(👨, " , D.Name, ", ", D.Dept, ", Hello: Ready to help!")
Base.show(io::IO, D::TeamLabor) = print(io, "(👨 , 👩  " , D.Name, ", ", D.Dept, ", Alpha Team ready to help!")
Base.show(io::IO, p::Project) = print(io, "(💼, " , p.Number, ", ", p.Customer, ", Make every Project a Success 💪🏻 before it even begins!")
Base.show(io::IO, p::Program) = print(io, "(💼, 💼, " , p.Name,  ", Program launched! 🚀🚀🚀")





end
