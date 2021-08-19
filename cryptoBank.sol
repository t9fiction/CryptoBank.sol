//"SPDX-License-Identifier:UNLICENSED"

pragma solidity ^0.8.0;

// ==================================================================
contract Bank{
    event elog(address);
    event elog2(string);
    event elog3(uint);
    
    string bank_name;
    address payable bank_owner;
    mapping(address => uint256) accountsList;
    address bankAddress;
    uint256 initialCapital;
    uint256 currentCapital;
    
    // Task 1) The owner can start the bank with initial deposit/capital in ether (min 50 eths)
 constructor() payable{
    require(msg.value >= 50 ether, "====> Min 50 Ether required for Bank Start <====");
    bank_name = "PIAIC-SWAP";
    bank_owner = payable(msg.sender);
    bankAddress = payable(address(this));
    initialCapital = msg.value;
    emit elog2("Bank Started");
    }
    
// Task 2) Only the owner can close the bank. Upon closing the balance should return to the Owner
 
  modifier closeBank {
      require( msg.sender == bank_owner);
      _;
  }
 
    function BankClosed() public payable closeBank {
          emit elog2("Bank Closed");
          selfdestruct(bank_owner);
    } 
    
// Task 3) Anyone can open an account in the bank for Account opening they need to deposit ether with address

  modifier acct_Open() {
      
      require( msg.value > 0 , "Deposit some Ether please" );
      _;
  }

  function accountOpen() public payable acct_Open(){
      accountsList[msg.sender] = accountsList[msg.sender] + msg.value;
      
      emit elog2("Acount opened");
   }
   
   // Task  4) Bank will maintain balances of accounts
   // Task  8) Account holder can inquiry balance
   
      function checkbalance(address _address ) public view returns (uint){
        
        return accountsList[_address]; 
        }
   
   // Task 5) Anyone can deposit in the bank but in valid accounts
        function addFunds(address _account, uint _amount) payable public {
        require(_account == msg.sender, "Only deposit in valid account");
        accountsList[msg.sender]=accountsList[msg.sender] - _amount;
        payable(msg.sender).transfer(_amount);
        emit elog2("withdraw successful");
    }
    
   // Task 6) Only valid account holders can withdraw
        function withdraw(uint _amount) payable public {
        require(accountsList[msg.sender] >= _amount , "Balance is short");
        accountsList[msg.sender]=accountsList[msg.sender] - _amount;
        payable(msg.sender).transfer(_amount);
        emit elog2("withdraw successful");
    }
    
    // Task 9) The depositor can request for closing an account
 
  
    function accountClose(address _address) public payable {
        require( _address == msg.sender);
          payable(msg.sender).transfer(accountsList[_address]);
          emit elog2("Account Closed");
          selfdestruct(payable(_address));
    } 
    
//     //____________For Testing________________________
    
//     function view_Vars() public {
//       emit elog(bank_owner);
//       emit elog(bankAddress);
//       emit elog2(bank_name);  
//       emit elog3(initialCapital);
//       emit elog3(currentCapital);
//     }

//  // -------------------------------------------
    
    function updateCash() public payable {
        currentCapital = address(this).balance;
    }
    
    // -------------------------------------------
    // ____________ Fallback function
    fallback() external payable{
    }
    // _________ Receive function
    receive() external payable{
    }
    

    
// ==================================================================

    function sendEther(address _to, uint256 _value) public payable{
        payable(_to).transfer(_value);
    }
    
}

