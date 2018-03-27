var Payroll = artifacts.require("./Payroll.sol");

// Test addEmployee
contract('Payroll', function(accounts) {

  it("Add a new employee with salary equals to 1", function() {
    var payrollInstance;
    return Payroll.deployed().then( instance => {
      payrollInstance = instance;
      return payrollInstance.addEmployee(accounts[1], 1, {from: accounts[0]});
    }).then(() => {
      return payrollInstance.employees(accounts[1]);
    }).then( employee => {
      assert.equal(employee[1].toNumber(), web3.toWei(1, 'ether'), "The salary was not stored!");
    });
  });

  it("Add an existing employee", function() {
    var payrollInstance;
    return Payroll.deployed().then( instance => {
      payrollInstance = instance;
      return payrollInstance.addEmployee(accounts[1], 1, {from: accounts[0]});
    }).then( () => {
      return payrollInstance.addEmployee(accounts[1], 1, {from: accounts[0]})
    }).catch( error => {
      assert.include(error.toString(),"invalid opcode", "Employee already exist!");
    });
  });

  it("Other people want to add employee", function() {
    var payrollInstance;
    return Payroll.deployed().then( instance => {
      payrollInstance = instance;
      return payrollInstance.addEmployee(accounts[1], 1, {from: accounts[2]})
    }).catch( error => {
      assert.include(error.toString(),"revert", "Only onwer can add employee!");
    });
  });

});

//Test RemoveEmployee
contract('Payroll1', function(accounts) {

  it("Remove an existing employee", function() {
    var payrollInstance;
    return Payroll.deployed().then( instance => {
      payrollInstance = instance;
      return payrollInstance.addEmployee(accounts[1], 1, {from: accounts[0]});
    }).then(() => {
      return payrollInstance.employees(accounts[1]);
    }).then( employee => {
      assert.equal(employee[1].toNumber(), web3.toWei(1, 'ether'), "The employee should be added!");
    }).then(() => {
      return payrollInstance.removeEmployee(accounts[1]);
    }).then(() => {
      return payrollInstance.employees(accounts[1]);
    }).then( employee => {
      assert.equal(employee[1].toNumber(), 0, "The employee should be removed!");
    });
  });

  it("Remove a non-existing employee", function() {
    var payrollInstance;
    return Payroll.deployed().then( instance => {
      payrollInstance = instance;
      return payrollInstance.removeEmployee(accounts[1],  {from: accounts[0]});
    }).catch( error => {
      assert.include(error.toString(),"invalid opcode", "Employee did not exist!");
    });
  });

  it("Other people want to remove employee", function() {
    var payrollInstance;
    return Payroll.deployed().then( instance => {
      payrollInstance = instance;
      return payrollInstance.removeEmployee(accounts[1],  {from: accounts[3]});
    }).catch( error => {
      assert.include(error.toString(),"revert", "Employee did not exist!");
    });
  });

});

// Test getPaid()
contract('Payroll2', function(accounts) {

  it("Employee get paid successfully", function(){
      var payroll;
      var lastBalance;
      Payroll.deployed().then(instance => {
          payroll = instance;
          lastBalance = web3.eth.getBalance(accounts[2]).toNumber();
          return payroll.addEmployee(accounts[2],2,{from:accounts[0]});
      }).then( ()=>{
          return payroll.addFund({from:accounts[0],value:web3.toWei('10', 'ether')});
      }).then( () => {
          web3.currentProvider.send({jsonrpc: "2.0", method: "evm_increaseTime", params: [11], id: 0});
          return payroll.getPaid({from:accounts[2]})
      }).then( () =>{
          assert(web3.eth.getBalance(accounts[2]).toNumber()>lastBalance,'balance not added');
      });
  });


  it("Pay a ghost", function(){
      var payroll;
      var lastBalance;
      Payroll.deployed().then(instance => {
          payroll = instance;
          return payroll.addFund({from:accounts[0],value:web3.toWei('1', 'ether')});
      }).then( () => {
          web3.currentProvider.send({jsonrpc: "2.0", method: "evm_increaseTime", params: [11], id: 0});
          return payroll.getPaid({from:accounts[2]})
      }).catch( error => {
      assert.include(error.toString(),"revert", "Employee did not exist!");
    });
  });

  it("Bad bad employee wants to get pay before the duration", function(){
      var payroll;
      var lastBalance;
      Payroll.deployed().then(instance => {
          payroll = instance;
          lastBalance = web3.eth.getBalance(accounts[2]).toNumber();
          return payroll.addEmployee(accounts[2],2,{from:accounts[0]});
      }).then( ()=>{
          return payroll.addFund({from:accounts[0],value:web3.toWei('1', 'ether')});
      }).then( () => {
          web3.currentProvider.send({jsonrpc: "2.0", method: "evm_increaseTime", params: [5], id: 0});
          return payroll.getPaid({from:accounts[2]})
      }).catch( error => {
      assert.include(error.toString(),"invalid opcode", "Can't get pay before the duration");
    });
  });


});