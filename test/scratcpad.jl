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
A = _getAvailMonthHours(dfAvail, 24)

for i in A
    @show i[1]
end

dfRev = ReadAvailHours("C:\\Users\\junqueg\\Documents\\My Documents\\15. Programming\\Projects\\ResourceManagement.jl\\src\\TEAM_ACTUALPLAN_REV18.csv");


Tony = DisciplineLabor("430300", "Higa Anthony",  24);
Julie = DisciplineLabor("430300", "BRIONES JULITA",  24);


fetchAndWritePlannedHours!(dfRev, "HIGA ANTHONY", 18, Tony, :plan);





fetchAndWritePlannedHours!(dfRev, "HIGA ANTHONY", 18, Tony, :rev);
fetchAndWritePlannedHours!(dflabor, "HIGA ANTHONY", 24, Tony, :fwd);
fetchAndWriteRevActualHours!(dfRev, "HIGA ANTHONY", 18, Tony);


Julie = fetchAndWritePlannedHours!(dfRev, "BRIONES JULITA", 18, Julie, :rev);
Julie = fetchAndWritePlannedHours!(dflabor, "BRIONES JULITA", 24, Julie, :fwd);
fetchAndWriteRevActualHours!(dfRev, "BRIONES JULITA", 18, Julie);


writeAvailableFwdHours!(Tony, dfAvail, 24);
writeAvailableFwdHours!(Julie, dfAvail, 24);

Team1 = Tony + Julie



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


TeamDump(Team1, :TotalFwdPlannedHours)
TeamDump(Team1, :TotalRevPlannedHours)
TeamDump(Team1, :TotalRevActualHours)
TeamDump(Team1, :FwdUtilization)

TeamDump(Team1, :FwdUtilization) |> values |> collect |> mean


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

Tony.FwdHoursForecast.Project
Julie.FwdHoursForecast.Project


Tr = DisciplineLabor("430300", "Higa Anthony",  24);

Tr.FwdHoursForecast.Project

Tony.FwdHoursForecast ∪ Julie.FwdHoursForecast
S1 = Set(Julie.FwdHoursForecast.Project)

S2 = Set(Tony.FwdHoursForecast.Project)

Tony.FwdHoursForecast.Project

S1 ∪ S2

Tr.FwdHoursForecast.Project = String.(S1 ∪ S2)

Tr.FwdHoursForecast[!,:Project] = String.(S1 ∪ S2)

String.(S1 ∪ S2)

Tr.FwdHoursForecast

Tony.FwdHoursForecast

names(Tony.FwdHoursForecast)
Tony.FwdHoursForecast[:,2] .+ Julie.FwdHoursForecast[:,2]

Tr.FwdHoursForecast = vcat(Tony.FwdHoursForecast, Julie.FwdHoursForecast)

Tr.FwdHoursForecast.Project

sum(getFwdPlannedHours(Julie))
getFwdPlannedHours(Tony)
dflabor

sum(getFwdPlannedHours(Tr))