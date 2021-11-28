var documenterSearchIndex = {"docs":
[{"location":"","page":"Home","title":"Home","text":"CurrentModule = ResourceManagement\nDocTestSetup = quote\n    using ResourceManagement\nend\n","category":"page"},{"location":"#ResourceManagement","page":"Home","title":"ResourceManagement","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Documentation for ResourceManagement.","category":"page"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"","page":"Home","title":"Home","text":"Modules = [ResourceManagement]","category":"page"},{"location":"#ResourceManagement.DisciplineLabor","page":"Home","title":"ResourceManagement.DisciplineLabor","text":"DisciplineLabor\n\nFields\n\nRate::Float64: stores the rate for the labor variable\nBudgetHours::Float64: stores budget for the resource in hours\nBudgetDollars::Float64: stores budget for the resource in Dollars\nTravelBudgetDollars::Float64: stores budget for Travel in Dollars\nActualHours::Float64: stores actual incurred hours for resource\nActualHours::Float64: stores actual incurred hours for resource\nActualIncurredCost::Float64: stores actual incurred Costs\nFwdHoursAvailable::Array: stores monthly Hours Available from Present going forward\nFwdHoursForecast::Array: stores Forecast monthly Hours from Present month going forward\nRevHoursForecast::Array: stores Forecast monthly Hours from Present month going backwards (reverse)\nRevHoursAvailable::Array: stores Forecast monthly Hours from Present month going backwards (reverse)\nFwdCostsForecast::Array: stores forecasted monthly Labor cost  from Present going forward\nRevCostsForecast::Array: stores forecasted monthly Labor cost  from Present going backwards (reverse)\nRevActualCostHours::Array: stores monthly actual labor costs  from Present going backwards (reverse)\nDept::String: stores Dept name\nName::String: stores name of the resource\nProjects::Array: stores projects for the resource\n\n\n\n\n\n","category":"type"},{"location":"#ResourceManagement.TeamLabor","page":"Home","title":"ResourceManagement.TeamLabor","text":"TeamLabor()\n\nGenerates a TeamLabor object.\n\nArguments\n\nTeam::Array: Array of DisciplineLabor objects\nName::String: Name of the Team\nDept::String: Department of the Team\nRate::Float64: Engineering Labor Rate for the Team\nBudgetHours::Float64: Labor Budget in LaborBudgetHours\nBudgetDollars::Float64: Labor Budget in Dollars\nTravelBudgetDollars::Float64: travel Budget in Dollars\nActualHours::Float64: Total Incurred Hours\nActualIncurredCost::Float64: Total Incurred Cost\nProjects::Array : Array of Projects for the Team\nFwdHoursAvailable::Array: stores Fwd Hours Available on a given month.\nFwdHoursForecast::Array: stores Forecast monthly Hours from Present month going forward\nRevHoursForecast::Array: stores Forecast monthly Hours from Present month going backwards (reverse)\nRevHoursAvailable::Array: stores Available monthly Hours from Present month going backwards (reverse)\nFwdCostsForecast::Array: stores Forecasted monthly Labor cost  from Present going forward\nRevCostsForecast::Array: stores Forecasted monthly Labor cost  from Present going backwards (reverse)\nRevActualHours::Array: stores Actual monthly Hours from Present month going backwards (reverse)\nRevActualCostHours::Array: stores Actual monthly Labor cost  from Present going backwards (reverse)\n\nReturns\n\nTeamLabor: TeamLabor object\n\n\n\n\n\n","category":"type"},{"location":"#Base.:+-Tuple{DisciplineLabor, DisciplineLabor}","page":"Home","title":"Base.:+","text":"Base.+(x::DisciplineLabor , y::DisciplineLabor)\n\nExtends Base.+ to add two DisciplineLabor objects together.\n\nArguments\n\nx::DisciplineLabor: First DisciplineLabor object to add\ny::DisciplineLabor: Second DisciplineLabor object to add\n\nReturns\n\nNothing. Function calls _TeamBuilder to add two DisciplineLabor objects together.\n\n\n\n\n\n","category":"method"},{"location":"#Base.:+-Tuple{TeamLabor, DisciplineLabor}","page":"Home","title":"Base.:+","text":"Base.+(x::TeamLabor , y::DisciplineLabor)\n\nExtends Base.+ to add TeamLabor and DisciplineLabor together.\n\nArguments\n\nx::TeamLabor: TeamLabor object to add\ny::DisciplineLabor: DisciplineLabor object to add\n\nReturns\n\nNothing. Function calls _TeamBuilder to add the two objects together.\n\n\n\n\n\n","category":"method"},{"location":"#ResourceManagement.ReadLaborTracker-Tuple{String}","page":"Home","title":"ResourceManagement.ReadLaborTracker","text":"ReadLaborTracker(fName::String)\n\nFunction to read ACTUAL_PLANNED hours from SAP. Report should be saved in CSV format. Rows with missing names of resources are ignored.\n\nArguments\n\nfName::String: filename of the report\n\nReturns\n\ndf::DataFrame: DataFrame of the report\n\nExample:\n\n    df = ReadLaborTracker(\"C:\\Users\\james\\Desktop\\labor_tracker.csv\")\n\n\n\n\n\n","category":"method"},{"location":"#ResourceManagement._TeamBuilder-Tuple{DisciplineLabor, DisciplineLabor}","page":"Home","title":"ResourceManagement._TeamBuilder","text":"_TeamBuilder(x::DisciplineLabor, y::DisciplineLabor)\n\nFunction to add two DisciplineLabor objects together.\n\nArguments\n\nx::DisciplineLabor: First DisciplineLabor object\ny::DisciplineLabor: Second DisciplineLabor object to add\n\nReturns\n\nT::TeamLabor: Team Labor object\n\n\n\n\n\n","category":"method"},{"location":"#ResourceManagement._TeamBuilder-Tuple{TeamLabor, DisciplineLabor}","page":"Home","title":"ResourceManagement._TeamBuilder","text":"_TeamBuilder(x::DisciplineLabor, y::DisciplineLabor)\n\nFunction to add two DisciplineLabor objects together.\n\nArguments\n\nx::TeamLabor: TeamLabor Object to add\ny::DisciplineLabor: Second DisciplineLabor object to add\n\nReturns\n\nT::TeamLabor: Team Labor object\n\n\n\n\n\n","category":"method"},{"location":"#ResourceManagement._getEmployeePlannedHours-Tuple{DataFrames.DataFrame, String, Int64}","page":"Home","title":"ResourceManagement._getEmployeePlannedHours","text":"_getEmployeePlannedHours(df::DataFrame, name::String, m::Int)\n\nFunction to filter df by Employee name.\n\nArguments\n\ndf::DataFrame: dataframe of report (output of ReadLaborTracker)\nname::String: name of employee (need to match sap name)\nm::Int: number of months\n\nReturns\n\nv::Vector: Vector with the hours for each month\np:: Vector: Vector with employee's projects\n\nExample:\n\n    vh, pv = getEmployeePlannedHours(dflabor, \"Doe John\", 24)\n\n\n\n\n\n","category":"method"},{"location":"#Statistics.mean-Tuple{Float64, Float64}","page":"Home","title":"Statistics.mean","text":"Statistics.mean(x::Float64, y::Float64)\n\nExtends Statistics.mean to return the mean of two numbers.\n\nArguments\n\nx::Float64: First number\ny::Float64: Second number\n\nReturns\n\nFloat64: Mean of two numbers\n\n\n\n\n\n","category":"method"}]
}
