using ResourceManagement
using DataFrames
using Test
using CSV

# dflabor = ReadLaborTracker("src\\TEAM_PLANNED_FWD24.csv"); 
dflabor = ReadLaborTracker("C:\\Users\\junqueg\\OneDrive - dematic.com\\MyDocuments_BackUp\\15. Programming\\Projects\\ResourceManagement.jl\\src\\TEAM_PLANNED_FWD24_NOV.csv"); 
# dfAvail = ReadAvailHours("src\\UTILREPORT_FWD_NOV.csv");
dfAvail = ReadAvailHours("C:\\Users\\junqueg\\OneDrive - dematic.com\\MyDocuments_BackUp\\15. Programming\\Projects\\ResourceManagement.jl\\src\\UTILREPORT_FWD_NOV.csv");
# dfRev = ReadLaborTracker("src\\TEAM_ACTUALPLAN_REV18.csv"); 
dfRev = ReadLaborTracker("C:\\Users\\junqueg\\Documents\\My Documents\\15. Programming\\Projects\\ResourceManagement.jl\\src\\TEAM_ACTUALPLAN_REV18.csv"); 


dfcost = ReadCostTracker("src\\costracker.csv");
## costs
p149529 = Project();
fetchAndWriteProjectFinances!(dfcost, "149529", "430300", p149529)

p150547 = Project();
fetchAndWriteProjectFinances!(dfcost, "150547", "430300", p150547)

p158070 = Project();
fetchAndWriteProjectFinances!(dfcost, "158070", "430300", p158070)


p152242 = Project();
fetchAndWriteProjectFinances!(dfcost, "152242", "430300", p152242)

p152385 = Project();
fetchAndWriteProjectFinances!(dfcost, "152385", "430300", p152385)

p154662 = Project()
fetchAndWriteProjectFinances!(dfcost, "154662", "430300", p154662)

# dfcost2 = CSV.read("src\\costracker.csv", DataFrame)

## Build Program
program = Program();
program = p149529 + p150547
###


A = DisciplineLabor()
B = DisciplineLabor();
C = DisciplineLabor();
A.Budget.Hours = 160.0;
B.Budget.Hours = 200.0;
C.Budget.Hours = 240.0;
T=TeamLabor()
T = A + B + C



Tony = DisciplineLabor("430300", "Higa Anthony");
fetchAndWritePlannedHours!(dflabor, "HIGA ANTHONY", Tony, :fwd);
fetchAndWritePlannedHours!(dfRev, "HIGA ANTHONY", 18, Tony, :rev);
fetchAndWriteRevActualHours!(dfRev, "HIGA ANTHONY", 18, Tony);

Julie = DisciplineLabor("430300", "BRIONES JULITA");
fetchAndWritePlannedHours!(dflabor, "BRIONES JULITA", Julie, :fwd);
fetchAndWritePlannedHours!(dfRev, "BRIONES JULITA", Julie, :rev);
fetchAndWriteRevActualHours!(dfRev, "BRIONES JULITA",Julie);


Brad = DisciplineLabor("430300", "BORDEN BRADLEY")
fetchAndWritePlannedHours!(dflabor, "BORDEN BRADLEY" , Brad, :fwd);
fetchAndWritePlannedHours!(dfRev, "BORDEN BRADLEY", 18, Brad, :rev);
fetchAndWriteRevActualHours!(dfRev, "BORDEN BRADLEY", 18, Brad);




writeAvailableFwdHours!(Tony, dfAvail, 24);
writeAvailableFwdHours!(Julie, dfAvail, 24);
writeAvailableFwdHours!(Brad, dfAvail, 24);



Team1 = Tony + Julie
Team2 = Tony + Julie + Brad






Vp = getFwdPlannedHours(Tony, "");
Vp1 = getFwdPlannedHours(Tony, "153804");
Vp2 = getFwdPlannedHours(Tony, "154558");
Va = Tony.FwdHoursAvailable;
Vpr = getRevPlannedHours(Tony, "");
Vp1r = getRevPlannedHours(Tony, "153804");
Vp2r = getRevPlannedHours(Tony, "154558");
Tactual = getRevActualHours(Tony, "");


TU1 = getFwdUtilization(Tony, "");
TU2 = getFwdUtilization(Tony, "153804");
TU3 = getFwdUtilization(Tony, "154558");

J1 = getFwdPlannedHours(Julie, "");
J1R = getRevPlannedHours(Julie, "");
Jactual = getRevActualHours(Julie, "");


B1 = getFwdPlannedHours(Brad, "");
B1R = getRevPlannedHours(Brad, "");
Bactual = getRevActualHours(Brad, "");

Tcap = getCapacity(Tony);
Jcap = getCapacity(Julie);
Bcap = getCapacity(Brad);

T1cap = getCapacity(Team1);
T2cap = getCapacity(Team2);

TeamDump(Team1)
TeamDump(Team2)

#### Macros
struct MacrosType{T} end 
MacrosType(s::String) = MacrosType{Symbol(s)}();


# macro definition
macro prettyPrint(ex)
    return _prettyPrint(ex);
end




function _prettyPrint(ex)
    args = ex.args;
    if ((ex.head == :->) && (length(args))==2)
        cmd = args[2].args[2];
        cmd = MacrosType("$cmd");
        p = eval(args[1])

        ProcessMacros(p, cmd);

    else println("error")
    end

end


function  ProcessMacros(p::DisciplineLabor , cmd::MacrosType{:All})
   

    println("""
                    Name: $(p.Name)
                 
                    
                    
                    """)
end


function ProcessMacros(::MacrosType{:Sum})
    fwdsum=sum(eval(args[1]).FwdHoursForecast);
    fwdcostsum=sum(eval(args[1]).FwdCostsForecast);
    revsum=sum(eval(args[1]).RevHoursForecast);
    revcostsum=sum(eval(args[1]).RevCostsForecast);

    println("""
                    Name: $(eval(args[1]).Name)
                    Dept: $(eval(args[1]).Dept)
                    Project: $(eval(args[1]).Project)
                    =============================
                    Rate: $(eval(args[1]).Rate)
                    =============================
                    FwdHoursForecast: $fwdsum
                    FwdCostsForecast: $fwdcostsum
                    =============================
                    RevHoursForecast: $revsum
                    RevCostsForecast: $revcostsum
                    =============================
    """)
end


function ProcessMacros(::MacrosType{:Max})
    fwdmax=maximum(eval(args[1]).FwdHoursForecast);
    fwdcostmax=maximum(eval(args[1]).FwdCostsForecast);
    revmax=maximum(eval(args[1]).RevHoursForecast);
    revcostmax=maximum(eval(args[1]).RevCostsForecast);

    println("""
                    Name: $(eval(args[1]).Name)
                    Dept: $(eval(args[1]).Dept)
                    Project: $(eval(args[1]).Project)
                    =============================
                    Rate: $(eval(args[1]).Rate)
                    =============================
                    FwdHoursForecast: $fwdmax
                    FwdCostsForecast: $fwdcostmax
                    =============================
                    RevHoursForecast: $revmax
                    RevCostsForecast: $revcostmax
                    =============================
    """
    )

end


@prettyPrint Tony -> All











@testset "ResourceManagement.jl" begin
    # Write your tests here.

    @test 1 == 1;

    @test Statistics.mean(2.9, 3.1) == 3.0;

    

    # @test A.Budget.Hours == 160.0;
    # @test B.Budget.Hours == 200.0;
    # @test C.Budget.Hours == 240.0;
    
    # @test T.Budget.Hours == 600.0;
    
    
    @test size(dflabor) == (137, 79);
    
    
    @test sum(getFwdPlannedHours(Tony, "")) == 1838;
    @test sum(getFwdPlannedHours(Tony, "153804")) == 240.0
    # @test sum(getRevPlannedHours(Tony, "153804")) == 240.0
    # @test sum(getRevPlannedHours(Tony, "150547")) == 18.0
    @test sum(getFwdPlannedHours(Tony, "154558")) == 200.0
    # @test sum(getRevPlannedHours(Tony, "154558")) == 300.0
    # @test sum(getRevPlannedHours(Tony, "")) == 2233;
    # @test sum(getRevActualHours(Tony, "")) == 2937;



    # @test  sum(Va .*(getFwdUtilization(Tony, "")))== 1446;
    @test sum(Tony.FwdHoursAvailable)[1] == 4016
    @test sum(getFwdAvailableMonthHours(Tony))[1] == 4016
    @test getName(Tony) == "Higa Anthony";
    # @test getProjects(Tony) == ["152242", "153804" , "154558", "154662", "IND-43", "NZ430300"];
    @test sum(getCapacity(Tony)) == 2178;
    @test sum(getCapacity(Tony)) == (sum(getFwdAvailableMonthHours(Tony)) - sum(getFwdPlannedHours(Tony, "")))
   
    





    @test sum(getFwdPlannedHours(Julie, "")) == 3078;
    @test sum(getFwdPlannedHours(Julie, "150547")) == 277;
    @test sum(getFwdPlannedHours(Julie, "156257")) == 137;
    @test sum(getFwdAvailableMonthHours(Julie))== 4016
    # @test getProjects(Julie) == ["150547", "152242", "154662", "156257", "NZ430300"]
    # @test sum(getRevPlannedHours(Julie, "")) == 2802;
    # @test sum(getRevActualHours(Julie, "")) == 3216;



    @test sum(getFwdPlannedHours(Brad, "")) == 3821;
    @test sum(getFwdPlannedHours(Brad, "154644")) == 344;
    # @test getProjects(Brad) == ["154644", "154662", "158070"]
    # @test sum(getRevPlannedHours(Brad, "")) == 2727;
    # @test sum(getRevActualHours(Brad, "")) == 3369;


    @test getFwdPlannedHours(Team1, "") == getFwdPlannedHours(Tony, "") + getFwdPlannedHours(Julie, "");
    # @test getRevPlannedHours(Team1, "") == getRevPlannedHours(Tony, "") + getRevPlannedHours(Julie, "");
    @test getFwdPlannedHours(Team2, "") == getFwdPlannedHours(Tony, "") + getFwdPlannedHours(Julie, "") + getFwdPlannedHours(Brad, "");
    # @test getRevPlannedHours(Team2, "") == getRevPlannedHours(Tony, "") + getRevPlannedHours(Julie, "") + getRevPlannedHours(Brad, "");

    @test getFwdAvailableMonthHours(Team1) == getFwdAvailableMonthHours(Tony) + getFwdAvailableMonthHours(Julie);
    
    # @test getRevActualHours(Team1, "") == getRevActualHours(Tony, "") + getRevActualHours(Julie, "");
    # @test getRevActualHours(Team2, "") == getRevActualHours(Tony, "") + getRevActualHours(Julie, "") + getRevActualHours(Brad, "");


end
