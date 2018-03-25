
var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function(accounts) {

  it("...payroll.", function() {
    return Payroll.deployed().then(function(instance) {
      payrollInstance = instance;

      return payrollInstance.addFund({from: accounts[0], value: 100}); 
    }).then(function() {
      
      return payrollInstance.addEmployee(accounts[1], 1);
    }).then(function() {
      
      return payrollInstance.employees.call(accounts[1]);
    }).then(function(employee) {
      //console.log(employee);
      assert.equal(employee[0], accounts[1], "add employee not work");
      return payrollInstance.removeEmployee(accounts[1]);
    }).then(function() {
      
      return payrollInstance.employees.call(accounts[1]);
    }).then(function(employee) {

      assert.equal(employee[0], 0x0, "delete employee not work");
    });


  });

});
