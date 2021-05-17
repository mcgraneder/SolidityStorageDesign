// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;
//'EvansToken', 'EMT', 15, 2000000000000000000
contract Token {
    
    
    //struct to atore Approvee, their allowance, and approver for referance
    struct Approvee {
        address _approvee_address;
        address _approver_address;
        uint _allowance;
    }
  
  Approvee[] public approvers;
  
 
  //create a mapping that maps an address to a approver id
  mapping (address => uint) approver_id;
  
  //token name
  string internal tokenName;

  //token symbol
  string internal tokenSymbol;

  //number of decimals
  uint8 internal tokenDecimals;

 //total supply of tokens
  uint256 internal tokenTotalSupply;

  //balance mapping 
  mapping (address => uint256) internal balances;

  //token allowance mppinh   
  mapping (address => mapping (address => uint256)) internal allowed;

  // event triggers when transfer func is called
  event Transfer(address indexed _from,address indexed _to,uint256 _value);

  //trigger event when approve function call returns success
  event Approval(address indexed _owner,address indexed _spender,uint256 _value);
  
  constructor(string memory _name, string memory _symbol, uint8 _decimals, uint _initialOwnerBalance) {
      tokenName = _name;
      tokenSymbol = _symbol;
      tokenDecimals = _decimals;
      tokenTotalSupply = _initialOwnerBalance;
      balances[msg.sender] = _initialOwnerBalance;
  }

  //return the name of the token
  function name() external view returns (string memory _name){
    _name = tokenName;
  }

  //return token symbol
  function symbol() external view returns (string memory _symbol){
    _symbol = tokenSymbol;
  }

  //returns num decimals token uses
  function decimals() external view returns (uint8 _decimals){
    _decimals = tokenDecimals;
  }

  //return total token supply
  function totalSupply()external view returns (uint256 _totalSupply){
    _totalSupply = tokenTotalSupply;
  }

  
 
  function balanceOf(address _owner) external view returns (uint256 _balance){
    _balance = balances[_owner];
  }

 
  function transfer(address payable _to, uint256 _value) public returns (bool _success){
     
     //require sufficent balance
     require(balances[msg.sender] >= _value);
     //requie owner not recipient
     require(msg.sender != _to);
     
     //update balances accordingly
     balances[msg.sender] -= _value;
     balances[_to] += _value;
     
     //emmit transfer to log
     emit Transfer(msg.sender, _to,  _value);
     
     return _success;
  }

  
  function approve(address _spender,uint256 _value) public returns (bool _success) {
      
      //initialise aprrovee instamce
      Approvee memory newApprovee;
      
      //define approver id
      bool isApprovee = false;
      uint _id = 0;
      
      //require that the owner is not the recipient or approvee
      require(msg.sender != _spender);
      
      //if the current approver and approvee already have a relationship
      //then set isAprovve to true
      for (uint i = 0; i < approvers.length; i++) {
          if(approvers[_id]._approver_address == msg.sender && approvers[_id]._approvee_address == _spender) {
              isApprovee = true;
          }
      }
      
      //if is approvee is true then overwrite the allowance
      if (isApprovee) {
          approvers[_id]._allowance += _value;
          allowed[msg.sender][_spender] += _value;
          
       //else make new approvee
      }else {
          
          //set the allowance
          allowed[msg.sender][_spender] = _value;
          
          
          
          //push the approvers id into the approver id array
          approver_id[_spender] = _id;
          
          //increment approver id for the next approver
          _id = _id + 1;
          
          //creates new approver instance and adds it to getApprover array
          //handy to keep track of what accoutns are approvers or not
          newApprovee._approver_address = msg.sender;
          newApprovee._approvee_address = _spender;
          newApprovee._allowance = _value;
          
          approvers.push(newApprovee);
      
          
      }
      
      return _success;
  }

 
  function allowance(address _owner,address _spender) external view returns (uint256 _remaining){
    _remaining = allowed[_owner][_spender];
  }

  
  function transferFrom(address _from,address _to,uint256 _value) public returns (bool _success){
      
     
     //require the allowance is greater than the transfer amounallowed
     require(allowed[_from][msg.sender] >= _value);
     //require that the from address is not the to address
     require(_from != _to);
     //likewise with the owner
     require(msg.sender != _to);
     //require sufficent balance
     require(balances[_from] >= _value);
     
     //if(allowed[_from][msg.sender] )
     
     //call function that gets approver ID
     uint _id = getApproverID(msg.sender);
     
     //after transfer subtratc value from allowance
     allowed[_from][msg.sender] -= _value;
     //update the approoes allowance balance
     approvers[_id]._allowance -= _value;
     

     //update balances of both parties 
     balances[_from] -= _value;
     balances[_to] += _value;
     
     //emmit the transfer to log
     emit Transfer(_from, _to,  _value);
     
     return _success;

  }
  
  function getApprovers() public view returns(Approvee[] memory){
      
      return approvers;
  }
  
  function getApproverID(address _approver) public view returns(uint) {
      
      return approver_id[_approver];
  }

}

