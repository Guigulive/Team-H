pragma solidity ^0.4.2;

import "../contracts/PayRoll.sol";

contract TestPayRoll is PayRoll {

  function test() public {
    
    addEmployee(0x1ae8107d1f06eb66489a0d584c7c4c0ab023990c, 10);

    removeEmployee(0x1ae8107d1f06eb66489a0d584c7c4c0ab023990c);

  }

}