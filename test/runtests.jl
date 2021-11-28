using ResourceManagement
using Test

@testset "ResourceManagement.jl" begin
    # Write your tests here.

    @test 1 == 1;

    @test Statistics.mean(2.9, 3.1) == 3.0;

    A = DisciplineLabor();
    B = DisciplineLabor();
    C = DisciplineLabor();
    A.BudgetHours = 160.0;
    B.BudgetHours = 200.0;
    C.BudgetHours = 240.0;
    T = A + B + C;

    @test A.BudgetHours == 160.0;
    @test B.BudgetHours == 200.0;
    @test C.BudgetHours == 240.0;
    
    @test T.BudgetHours == 600.0;
    
    dflabor = ReadLaborTracker("src\\TEAM_PLANNED_FWD24.csv"); 
    @test size(dflabor) == (91, 79);


    vh, pv = _getEmployeePlannedHours(dflabor, "HIGA ANTHONY", 24);
    
    @test sum(sum.(vh)) == 1446

    p=unique(pv);
    @test p[1] == "152242";
    @test p[2] == "153804";
    @test p[3] == "154558";
    @test p[4] == "154662";
    @test p[5] == "IND-43";
    @test p[6] == "NZ430300";
    @test length(p) == 6;
    
    


    
end
