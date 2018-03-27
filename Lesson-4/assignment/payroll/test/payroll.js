var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', accounts => {

  it("... Owner adds an employee with 2-ether salary", () => {
    return Payroll.deployed().then( instance => {
      payrollInstance = instance;
      return payrollInstance.addEmployee(accounts[1], 2, {from: accounts[0]});
    }).then( () => {
      return payrollInstance.employees(accounts[1]);
    }).then( employee => { 
      expected_salary = web3.toWei(2, 'ether') 
      assert.equal(employee[0], accounts[1], "the employee id added is wrong.");
      assert.equal(employee[1].toNumber(), expected_salary, "the salary added is wrong.")
    })
  })

  it("... Owner adds an existing employee with 1-ether salary", () => {
    return Payroll.deployed().then( ( instance => {
      payrollInstance = instance;
      return payrollInstance.addEmployee(accounts[1], 1, {from: accounts[0]});
    })).then( () => {
      return payrollInstance.employees(accounts[1]);
    }).catch( error => {
      assert.include(error.toString(),"Error", 'Employee already existed.');
    })
  })

  it("... Non-owner adds an non-existing employee with 2-ether salary", () => {
    return Payroll.deployed().then( instance => {
      payrollInstance = instance;
      return payrollInstance.addEmployee(accounts[3], 2, {from: accounts[2]});
    }).then( () => {
      return payrollInstance.employees(accounts[3]);
    }).catch( error => {
      assert.include(error.toString(), "Error", "Action not authorized.")
    })
  })

  it("... Non-owner removes a non-existing employee", () => {
    return Payroll.deployed().then( instance => {
      payrollInstance = instance;
      return payrollInstance.removeEmployee(accounts[1], {from: accounts[3]});
    }).then( () => {
      return payrollInstance.employees(accounts[1]);
    }).catch( error => {
      assert.include(error.toString(), "Error", "Action not authorized!")
    })
  })

  it("... Owner removes an existing employee", () => {
    return Payroll.deployed().then( instance => {
      payrollInstance = instance;
      return payrollInstance.removeEmployee(accounts[1], {from: accounts[0]});
    }).then( () => {
      return payrollInstance.employees(accounts[1]);
    }).then( employee => {
      expected_id = "0x0000000000000000000000000000000000000000"
      expected_salary = 0;
      assert.equal(employee[0], expected_id, "The employee id wasn't removed.")
      assert.equal(employee[1].toNumber(), expected_salary, "employee's salary isn't zero.")
    })
  })

  it("... Owner removes a non-existing employee", () => {
    return Payroll.deployed().then( instance => {
      payrollInstance = instance;
      return payrollInstance.removeEmployee(accounts[2], {from: accounts[0]});
    }).then( () => {
      return payrollInstance.employees(accounts[2]);
    }).catch( error => {
      assert.include(error.toString(), "Error", "Can't remove a non-existing employee!")
    })
  })

})

// contract('Payroll_2', accounts => {
  
//   it("... Employee gets paid", () => {
//     var payrollInstance;
//     return Payroll.deployed().then( instance => {
//       payrollInstance = instance;
//       payrollInstance.addFund({from: accounts[0], value: 100})
//       return payrollInstance.addEmployee(accounts[1], 2, {from: accounts[0]});
//     }).then( () => {
//       web3.currentProvider.send({
//         jsonrpc: "2.0", 
//         method: "evm_increaseTime", 
//         params: [11], id: 0
//       });
//     }).then( () => {
//       balance = web3.eth.getBalance(accounts[1]).toNumber();
//       payrollInstance.getPaid({from:accounts[1]});
//     }).then( () => {
//       assert(web3.eth.getBalance(accounts[1]).toNumber()>balance, "Getting paid failed!")
//     })
//   })

// })