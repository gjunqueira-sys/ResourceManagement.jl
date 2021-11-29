using ResourceManagement
using DataFrames
A = DisciplineLabor()
B = DisciplineLabor()


dflabor = ReadLaborTracker("src\\TEAM_PLANNED_FWD24.csv"); 
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


function _getAvailMonthHours(df::DataFrame,  m::Int)
    startcol = 6; #column where first planned hours are

    
    df = df;
    cols = [startcol+3*cols for cols in 0: m-1]
    
    v = [(collect(df[:,cols[i]])) for i in 1: length(cols)]

    return v
end

VA = _getAvailMonthHours(dfAvail, 24)