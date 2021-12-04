using ResourceManagement
using DataFrames
using Test


A = ResourceManagement.types.DisciplineLabor();
B = ResourceManagement.types.DisciplineLabor();
C = ResourceManagement.types.DisciplineLabor();
A.BudgetHours = 160.0;
B.BudgetHours = 200.0;
C.BudgetHours = 240.0;
T = A + B + C;
dflabor = ReadLaborTracker("src\\TEAM_PLANNED_FWD24.csv"); 
# dflabor = ReadLaborTracker("C:\\Users\\junqueg\\Documents\\My Documents\\15. Programming\\Projects\\ResourceManagement.jl\\src\\TEAM_PLANNED_FWD24_NOV.csv"); 


vh, pv = _getEmployeePlannedHours(dflabor, "HIGA ANTHONY", 24);
Tony = ResourceManagement.types.DisciplineLabor("430300", "Higa Anthony",  24);
V1, p1 = fetchAndWritePlannedHours!(dflabor, "HIGA ANTHONY", 24, Tony);

dfAvail = ReadAvailHours("src\\UTILREPORT_FWD_NOV.csv");
# dfAvail = ReadAvailHours("C:\\Users\\junqueg\\Documents\\My Documents\\15. Programming\\Projects\\ResourceManagement.jl\\src\\UTILREPORT_FWD_NOV.csv");



p=unique(pv);

writeAvailableFwdHours!(Tony, dfAvail, 24);


Vp = getFwdPlannedHours(Tony, "");
Vp1 = getFwdPlannedHours(Tony, "153804");
Vp2 = getFwdPlannedHours(Tony, "154558");
Va = Tony.FwdHoursAvailable;

TU1 = getUtilization(Tony, "");
TU2 = getUtilization(Tony, "153804");
TU3 = getUtilization(Tony, "154558");


@testset "ResourceManagement.jl" begin
    # Write your tests here.

    @test 1 == 1;

    @test Statistics.mean(2.9, 3.1) == 3.0;

    

    @test A.BudgetHours == 160.0;
    @test B.BudgetHours == 200.0;
    @test C.BudgetHours == 240.0;
    
    @test T.BudgetHours == 600.0;
    
    
    @test size(dflabor) == (91, 79);


    
    
    @test sum(sum.(vh)) == 1446

    
    @test p[1] == "152242";
    @test p[2] == "153804";
    @test p[3] == "154558";
    @test p[4] == "154662";
    @test p[5] == "IND-43";
    @test p[6] == "NZ430300";
    @test length(p) == 6;

    
    
    @test sum(getFwdPlannedHours(Tony, "")) == 1446;
    @test sum(getFwdPlannedHours(Tony, "153804")) == 240.0
    @test sum(getFwdPlannedHours(Tony, "154558")) == 200.0

    @test  sum(Va .*(getUtilization(Tony, "")))[1] == 1446;

    
    
    @test sum(Tony.FwdHoursAvailable)[1] == 4016



    


    
end
