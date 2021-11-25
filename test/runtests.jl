using ResourceManagement
using Test

@testset "ResourceManagement.jl" begin
    # Write your tests here.

    @test 1 == 1;

    @test Statistics.mean(2.9, 3.1) == 3.0;

    A = DisciplineLabor();
    B = DisciplineLabor();
    A.BudgetHours = 160.0;
    B.BudgetHours = 200.0;
    T = A + B;

    @test A.BudgetHours == 160.0;
    @test B.BudgetHours == 200.0;
    
    @test T.BudgetHours == 360.0;
    



    
end
