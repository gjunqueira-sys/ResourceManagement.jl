using ResourceManagement
using DataFrames
using Test


A = DisciplineLabor();
B = DisciplineLabor();
C = DisciplineLabor();
A.Budget.Hours = 160.0;
B.Budget.Hours = 200.0;
C.Budget.Hours = 240.0;
T = A + B + C;
dflabor = ReadLaborTracker("src\\TEAM_PLANNED_FWD24.csv"); 
# dflabor = ReadLaborTracker("C:\\Users\\junqueg\\Documents\\My Documents\\15. Programming\\Projects\\ResourceManagement.jl\\src\\TEAM_PLANNED_FWD24_NOV.csv"); 


vh, pv = _getEmployeePlannedHours(dflabor, "HIGA ANTHONY", 24);
Tony = DisciplineLabor("430300", "Higa Anthony",  24);
V1, p1 = fetchAndWritePlannedHours!(dflabor, "HIGA ANTHONY", 24, Tony);

Julie = DisciplineLabor("430300", "BRIONES JULITA",  24);
fetchAndWritePlannedHours!(dflabor, "BRIONES JULITA", 24, Julie);

Brad = DisciplineLabor("430300", "BORDEN BRADLEY",  24);
fetchAndWritePlannedHours!(dflabor, "BORDEN BRADLEY", 24, Brad);

writeAvailableFwdHours!(Tony, dfAvail, 24);
writeAvailableFwdHours!(Julie, dfAvail, 24);
writeAvailableFwdHours!(Brad, dfAvail, 24);

Team1 = Tony + Julie
Team2 = Tony + Julie + Brad

dfAvail = ReadAvailHours("src\\UTILREPORT_FWD_NOV.csv");
# dfAvail = ReadAvailHours("C:\\Users\\junqueg\\Documents\\My Documents\\15. Programming\\Projects\\ResourceManagement.jl\\src\\UTILREPORT_FWD_NOV.csv");



p=unique(pv);




Vp = getFwdPlannedHours(Tony, "");
Vp1 = getFwdPlannedHours(Tony, "153804");
Vp2 = getFwdPlannedHours(Tony, "154558");
Va = Tony.FwdHoursAvailable;

TU1 = getUtilization(Tony, "");
TU2 = getUtilization(Tony, "153804");
TU3 = getUtilization(Tony, "154558");

J1 = getFwdPlannedHours(Julie, "");

B1 = getFwdPlannedHours(Brad, "");

Tcap = getCapacity(Tony);
Jcap = getCapacity(Julie);
Bcap = getCapacity(Brad);

T1cap = getCapacity(Team1);
T2cap = getCapacity(Team2);



@testset "ResourceManagement.jl" begin
    # Write your tests here.

    @test 1 == 1;

    @test Statistics.mean(2.9, 3.1) == 3.0;

    

    @test A.Budget.Hours == 160.0;
    @test B.Budget.Hours == 200.0;
    @test C.Budget.Hours == 240.0;
    
    @test T.Budget.Hours == 600.0;
    
    
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
    @test sum(getFwdAvailableMonthHours(Tony))[1] == 4016
    @test getName(Tony) == "Higa Anthony";
    @test getProjects(Tony) == ["152242", "153804" , "154558", "154662", "IND-43", "NZ430300"];
    @test sum(getCapacity(Tony)) == 2570;
    @test sum(getCapacity(Tony)) == (sum(getFwdAvailableMonthHours(Tony))[1] - sum(getFwdPlannedHours(Tony, "")))

    





    @test sum(getFwdPlannedHours(Julie, "")) == 3038;
    @test sum(getFwdPlannedHours(Julie, "150547")) == 56;
    @test sum(getFwdPlannedHours(Julie, "156257")) == 200;
    @test sum(getFwdAvailableMonthHours(Julie))[1] == 4016
    @test getProjects(Julie) == ["150547", "152242", "154662", "156257", "NZ430300"]



    @test sum(getFwdPlannedHours(Brad, "")) == 3821;
    @test sum(getFwdPlannedHours(Brad, "154644")) == 344;
    @test getProjects(Brad) == ["154644", "154662", "158070"]


    @test getFwdPlannedHours(Team1, "") == getFwdPlannedHours(Tony, "") + getFwdPlannedHours(Julie, "");
    @test getFwdPlannedHours(Team2, "") == getFwdPlannedHours(Tony, "") + getFwdPlannedHours(Julie, "") + getFwdPlannedHours(Brad, "");

    @test getFwdAvailableMonthHours(Team1) == getFwdAvailableMonthHours(Tony) + getFwdAvailableMonthHours(Julie);
    



end
