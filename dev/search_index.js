var documenterSearchIndex = {"docs":
[{"location":"","page":"Home","title":"Home","text":"CurrentModule = ResourceManagement\nDocTestSetup = quote\n    using ResourceManagement\nend\n","category":"page"},{"location":"#ResourceManagement","page":"Home","title":"ResourceManagement","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Documentation for ResourceManagement.","category":"page"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"","page":"Home","title":"Home","text":"Modules = [ResourceManagement]","category":"page"},{"location":"#Base.:+-Tuple{DisciplineLabor, DisciplineLabor}","page":"Home","title":"Base.:+","text":"Base.+(x::DisciplineLabor , y::DisciplineLabor)\n\nExtends Base.+ to add two DisciplineLabor objects together.\n\nArguments\n\nx::DisciplineLabor: First DisciplineLabor object to add\ny::DisciplineLabor: Second DisciplineLabor object to add\n\nReturns\n\nNothing. Function calls _TeamBuilder to add two DisciplineLabor objects together.\n\n\n\n\n\n","category":"method"},{"location":"#Base.:+-Tuple{TeamLabor, DisciplineLabor}","page":"Home","title":"Base.:+","text":"Base.+(x::TeamLabor , y::DisciplineLabor)\n\nExtends Base.+ to add TeamLabor and DisciplineLabor together.\n\nArguments\n\nx::TeamLabor: TeamLabor object to add\ny::DisciplineLabor: DisciplineLabor object to add\n\nReturns\n\nNothing. Function calls _TeamBuilder to add the two objects together.\n\n\n\n\n\n","category":"method"},{"location":"#ResourceManagement._TeamBuilder-Tuple{DisciplineLabor, DisciplineLabor}","page":"Home","title":"ResourceManagement._TeamBuilder","text":"_TeamBuilder(x::DisciplineLabor, y::DisciplineLabor)\n\nFunction to add two DisciplineLabor objects together.\n\nArguments\n\nx::DisciplineLabor: First DisciplineLabor object\ny::DisciplineLabor: Second DisciplineLabor object to add\n\nReturns\n\nT::TeamLabor: Team Labor object\n\n\n\n\n\n","category":"method"},{"location":"#ResourceManagement._TeamBuilder-Tuple{TeamLabor, DisciplineLabor}","page":"Home","title":"ResourceManagement._TeamBuilder","text":"_TeamBuilder(x::DisciplineLabor, y::DisciplineLabor)\n\nFunction to add two DisciplineLabor objects together.\n\nArguments\n\nx::TeamLabor: TeamLabor Object to add\ny::DisciplineLabor: Second DisciplineLabor object to add\n\nReturns\n\nT::TeamLabor: Team Labor object\n\n\n\n\n\n","category":"method"},{"location":"#ResourceManagement._getAvailMonthHours-Tuple{DataFrames.DataFrame, Int64}","page":"Home","title":"ResourceManagement._getAvailMonthHours","text":"_getAvailMonthHours(df::DataFrame,  m::Int)\n\nFunction to read Available hours for each month from DataFrame.\n\nArguments\n\ndf::DataFrame: DataFrame (output of ReadAvailHours)\n\nReturns\n\nv::Vector: Vector with available hours for each month.  Pos [1] is current month.\n\nExample:\n\n    V = getAvailMonthHours(\"C:\\Users\\james\\Desktop\\UTILREPORT_NOV.csv\")\n\n\n\n\n\n","category":"method"},{"location":"#ResourceManagement._getEmployeeHoursFromDf-Tuple{DataFrames.DataFrame, String, Int64, Symbol}","page":"Home","title":"ResourceManagement._getEmployeeHoursFromDf","text":"Function to transform df into a vector of vectors rows of this vector will represent each month (18 months as default for rev report) then each row will have a vector of hours for each project. Hours are summed for each project.\n\nfunction _getEmployeeHoursFromDf2(df::DataFrame, name::String, m::Int, col::Symbol)\n\nParameters\n\ndf: DataFrame\n\nname: String\n\nm: Int\n\ncol: Symbol\n\nReturns\n\nv: Vector of vectors\n\n\n\n\n\n","category":"method"},{"location":"#ResourceManagement._pad_zerosEnd-Tuple{Any, Any}","page":"Home","title":"ResourceManagement._pad_zerosEnd","text":"Function to pad vector from the end with zeroes. Parameters:     v: vector to pad     n: number of zeroes to pad\n\n\n\n\n\n","category":"method"},{"location":"#ResourceManagement.getCapacity-Tuple{ResourceManagement.types.LaborVariable}","page":"Home","title":"ResourceManagement.getCapacity","text":"getCapacity(D::LaborVariable)\n\nGet Capacity of Resource from LaborVariable object. Capacity is defined as the Difference between the sum of Available Hours for a given month and the sum of Planned Hours for a given month.\n\nArguments\n\nD::LaborVariable: LaborVariable object to get information from\n\nReturns\n\nv::Vector: Vector with capacity for each month\n\n\n\n\n\n","category":"method"},{"location":"#ResourceManagement.getFwdPlannedHours","page":"Home","title":"ResourceManagement.getFwdPlannedHours","text":"getFwdPlannedHours(D::LaborVariable, proj::String)\n\nFunction to get planned hours for a given project from a LaborVariable object.\n\nArguments\n\nD::LaborVariable: LaborVariable object to get information from\nproj::String: Project to get information for. If no project is given (\"\") or found,   function will return all projects.\n\nReturns\n\nv::Vector: Vector with planned hours for the project\n\n\n\n\n\n","category":"function"},{"location":"#ResourceManagement.getFwdUtilization-Tuple{ResourceManagement.types.LaborVariable, String}","page":"Home","title":"ResourceManagement.getFwdUtilization","text":"getUtilization(D::LaborVariable, proj::String)\n\nFunction to get utilization for a given project from a LaborVariable object. If  the given project is not found, function will return utilization for all projects.\n\nArguments\n\nD::LaborVariable: LaborVariable object to get information from\nproj::String: Project to get information for. If no project is given (\"\") or found,   function will return all projects.\nTODO: V::Vector: Vector with utilization for the project (TOO DEPENDANT ON OTHER FUNCTION)\n\nReturns\n\nv::Vector: Vector with utilization (percent) for the project\n\nExample:\n\n    V = getUtilization(JohnDoe, \"\")\n\n\n\n\n\n","category":"method"},{"location":"#ResourceManagement.getRevPlannedHours","page":"Home","title":"ResourceManagement.getRevPlannedHours","text":"getRevPlannedHours(D::LaborVariable, proj::String)\n\nFunction to get planned hours for a given project from a LaborVariable object.\n\nArguments\n\nD::LaborVariable: LaborVariable object to get information from\nproj::String: Project to get information for. If no project is given (\"\") or found,   function will return all projects.\n\nReturns\n\nv::Vector: Vector with planned hours for the project\n\n\n\n\n\n","category":"function"},{"location":"#ResourceManagement.writeAvailableFwdHours!-Tuple{ResourceManagement.types.LaborVariable, DataFrames.DataFrame, Int64}","page":"Home","title":"ResourceManagement.writeAvailableFwdHours!","text":"writeAvailableFwdHours!(D::LaborVariable, df::DataFrame, m::Int)\n\nFunction will take an Array of Floats containing available monthly hours and  and a LaborVariable and write the available hours to the LaborVariable FwdHoursAvailable field. This is a mutable function.\n\nArguments\n\nD::LaborVariable: LaborVariable object to write to\ndf::DataFrame: DataFrame (output of ReadAvailHours)\nm::Int: number of months to write to\n\n\n\n\n\n","category":"method"},{"location":"#Statistics.mean-Tuple{Float64, Float64}","page":"Home","title":"Statistics.mean","text":"Statistics.mean(x::Float64, y::Float64)\n\nExtends Statistics.mean to return the mean of two numbers.\n\nArguments\n\nx::Float64: First number\ny::Float64: Second number\n\nReturns\n\nFloat64: Mean of two numbers\n\n\n\n\n\n","category":"method"}]
}
