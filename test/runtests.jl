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
    



    
end
