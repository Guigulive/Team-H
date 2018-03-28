var Payroll = artifacts.require("./Payroll.sol");
//add
contract('Payroll', function(accounts) {

    it("salary equals to 1", function() {
        var testpay;
        return Payroll.deployed().then( instance => {
          testpay = instance;
          return testpay.addEmployee(accounts[1], 1, {from: accounts[0]});
        }).then(() => {
          return testpay.employees(accounts[1]);
        }).then( employee => {
          assert.equal(employee[1].toNumber(), web3.toWei(1, 'ether'), "The salary was not stored!");
        });
      });

      it("have existed", function() {
        var testpay;
        return Payroll.deployed().then( instance => {
          testpay = instance;
          return testpay.addEmployee(accounts[1], 1, {from: accounts[0]});
        }).then( () => {
          return testpay.addEmployee(accounts[1], 1, {from: accounts[0]})
        }).catch( error => {
          assert.include(error.toString(),"invalid opcode", "Employee already exist!");
        });
      });
  
  });

//remove
  contract('Payroll1', function(accounts) {

    it("Remove  employee", function() {
      var testpay;
      return Payroll.deployed().then( instance => {
        testpay = instance;
        return testpay.addEmployee(accounts[1], 1, {from: accounts[0]});
      }).then(() => {
        return testpay.employees(accounts[1]);
      }).then( employee => {
        assert.equal(employee[1].toNumber(), web3.toWei(1, 'ether'), "Not added!");
      }).then(() => {
        return testpay.removeEmployee(accounts[1]);
      }).then(() => {
        return testpay.employees(accounts[1]);
      }).then( employee => {
        assert.equal(employee[1].toNumber(), 0, "Still not removed!");
      });
    });
  
    it("employee not existed", function() {
      var testpay;
      return Payroll.deployed().then( instance => {
        testpay = instance;
        return testpay.removeEmployee(accounts[1],  {from: accounts[0]});
      }).catch( error => {
        assert.include(error.toString(),"invalid opcode", "Employee not exist!");
      });
    });
});