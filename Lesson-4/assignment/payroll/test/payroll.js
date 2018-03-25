var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function(accounts) {
    it("add employee",function(){
        return Payroll.deployed().then(function(ins){
            payroll = ins;
            payroll.addFund({from:accounts[0],value:10});
            payroll.addEmployee(accounts[1],1);
            return payroll.employees(accounts[1]);
        }).then(function(employee){
            assert.equal(employee[0],accounts[1],"failed");
        })
    });

    it("remove employee",function(){
        return Payroll.deployed().then(function(ins){
            payroll = ins;           
            payroll.removeEmployee(accounts[1]);
            return payroll.employees(accounts[1]);
        }).then(function(employee){
            assert.equal(employee[0],0x0,"failed");
        })
    });
});    