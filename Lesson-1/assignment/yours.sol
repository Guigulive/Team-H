/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;
contract Payroll {
    uint salary= 1 ether;
    address user=0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    uint constant payDuration=10 seconds;
    uint lastPayday=now;
    
    function addFund() payable returns (uint){
        return this.balance;
    }
    
    function calculateRunway() returns (uint){
        return this.balance / salary;
    }
    
    function hasEnoughFund() returns (bool){
        return calculateRunway()>0;
    }
    
    function getPaid() {
        if (msg.sender!=user){
            revert();
        }
        uint nextPayday=lastPayday+payDuration;
        if (nextPayday >now){
            revert();
        }
        lastPayday=nextPayday;
        user.transfer(salary);
       
    }
    
    function changeAddress(address temp) returns (address) {
        user=temp;
    }
    
    function changeSalary(uint temp2) returns (uint){
        salary=temp2;
        salary*=1 ether;
    }
    

}


