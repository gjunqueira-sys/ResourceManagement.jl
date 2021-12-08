using ResourceManagement
using DataFrames
A = DisciplineLabor()
B = DisciplineLabor()


dflabor = ReadLaborTracker("C:\\Users\\junqueg\\Documents\\My Documents\\15. Programming\\Projects\\ResourceManagement.jl\\src\\TEAM_PLANNED_FWD24_NOV.csv"); 
vh, pv = _getEmployeePlannedHours(dflabor, "HIGA ANTHONY", 24)





vh

sum(sum.(vh))

typeof(pv)
for p in pv
    @show p
end

p=unique(pv)
for project in p
    @show project
end

p[1]
p[2]
p[3]
p[4]

Tony = DisciplineLabor("430300", "Higa Anthony",  24);

V1, p1 = fetchAndWritePlannedHours!(dflabor, "HIGA ANTHONY", 24, Tony);

sum(getFwdPlannedHours(Tony, ""))

sum(getFwdPlannedHours(Tony, "153804"))


dfAvail = ReadAvailHours("src\\UTILREPORT_FWD_NOV.csv")


dfRev = ReadAvailHours("C:\\Users\\junqueg\\Documents\\My Documents\\15. Programming\\Projects\\ResourceManagement.jl\\src\\TEAM_ACTUALPLAN_REV18.csv");


Tony = DisciplineLabor("430300", "Higa Anthony",  24);


fetchAndWritePlannedHours!(dfRev, "HIGA ANTHONY", 18, Tony, :plan);






function _getEmployeeHoursFromDf2(df::DataFrame, name::String, m::Int, col::Symbol)

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


d = _getEmployeeHoursFromDf2(dfRev, "HIGA ANTHONY", 18, :plan)


Tony = fetchAndWritePlannedHours!(dfRev, "HIGA ANTHONY", 18, Tony, :rev);
Tony = fetchAndWritePlannedHours!(dflabor, "HIGA ANTHONY", 24, Tony, :fwd);

newT.RevHoursForecast.Project

filter = (newT.RevHoursForecast.Project).=="153804"
sum(newT.RevHoursForecast[filter, :][1, 2:end])








TT = combine(Tony.FwdHoursForecast, months .=>sum)

size(Tony.FwdHoursForecast)[2]

TT = Tony.FwdHoursForecast[:, 2: end]
months= names(Tony.FwdHoursForecast)[2:end]

Vector(TT[1,:])

Vector(TT)

Vector(TT)


combine(Tony.FwdHoursForecast, months .=>sum)


Tony.FwdHoursForecast.Project

filter = Tony.FwdHoursForecast.Project .== "153804"

df = Tony.FwdHoursForecast

v = combine(df[filter, :] , months .=>sum)
v

v = Vector(v[1, :])

sum(getFwdPlannedHours(Tony, "153804"))

Tony