using ResourceManagement
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