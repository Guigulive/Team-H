var Ownable = artifacts.require("./Ownable.sol");
var SafeMath = artifacts.require("./SafeMath.sol");
var PullPayment= artifacts.require("./Pullpayment.sol");
var Payroll = artifacts.require("./Payroll.sol");

module.exports = function(deployer) {
  deployer.deploy(Ownable);
  deployer.deploy(SafeMath);

  deployer.link(Ownable, PullPayment);
  deployer.link(SafeMath, PullPayment);
  deployer.deploy(PullPayment);

  deployer.link(Ownable, Payroll);
  deployer.link(SafeMath, Payroll);
  deployer.link(PullPayment, Payroll);
  deployer.deploy(Payroll);
};
