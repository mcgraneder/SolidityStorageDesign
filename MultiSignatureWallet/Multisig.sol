//SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

//we need this for the get transferRequests() function
//abicode allows us to print structs
pragma abicoder v2;


//TO DO -- make withdrawal struct

// so the way this wallet works is its a multisig wallet which means in order
// //to transfer funds or withdraw tou need to have consesnus. So if the wallet has 
// three owners then in order to send funds we need 2 approvals out of threeto transfer or send funds.

//to use you first need to deploy and you first need to create wallet owners buy copying address in from
//the accounts tab and putting them into the addUsers function on the side bar. You cant add the same user twice and the 
//user array needs to be greater than 2 in length to create transfer requests. You can delete and add addUsers

//after you create users you can deposit into an account. You can only deposit into one of the owners addresses 
//so make sure you in one of the owners accounts

//after you deposit you can create a withdrawal request or a transfer request. they both take in the amount
//and the address its going to. Once you create the transfer/withdrawal you ned to approve it buy pasting in 
//at least len of users array -1 approvals. you can only approve with the wallet owners

//after you approve you can finally withdraw/transfer

contract Wallet {

    //address array to store owners
    address[] owners;
    //conensus limit for approvals
    uint public limit;
    
    //set up data structures. each trasnfer has diff properties
    //like amount, the reviever, how many approvals it has, the state of the
    //transfer etc
    struct Transfer{
        uint amount;
        address payable receiver;
        uint approvals;
        bool hasBeenSent;
        uint id;
    }
    
    //same for withdrawals
    struct Withdraw{
        uint amount;
        address payable receiver;
        uint approvals;
        bool hasBeenSent;
        uint id;
    }
    
    
    //here we create instances of our structs so we can keep logs
    Transfer[] transferRequests;
    Withdraw[] withdrawalRequests;
    
    //double mpping which maps an address and the transaction id to an approval boolean
    //false if not approved true if so
    mapping(address => mapping(uint => bool)) approvals;
    //balance mapping which maps user address ot their account balance
    mapping(address => uint)balance;
    
    //modifier which we can lace in function definitions to restrict access of that 
    //function to the wallet owners
    modifier onlyOwners(){
        bool owner = false;
        for(uint i=0; i<owners.length;i++){
            if(owners[i] == msg.sender){
                owner = true;
            }
        }
        require(owner == true);
        _;
    }
    
    //evets
    event TransferRequestCreated(uint _id, uint _amount, address _initiator, address _receiver);
    event ApprovalReceived(uint _id, uint _approvals, address _approver);
    event TransferApproved(uint _id);
    
    
    //add user function. require owner is not already in the wallet array
    function addUsers(address _owners) public
    {
        for (uint user = 0; user < owners.length; user++)
        {
            require(owners[user] != _owners, "Already registered");
        }
        owners.push(_owners);
        
        //from the current array calculate the value of minimum consensus
        limit = owners.length - 1;
    }
    
    //remove user require the address we pass in is the address were removing
    function removeUser(address _user) public
    {
        uint user_index;
        for(uint user = 0; user < owners.length; user++)
        {
            if (owners[user] == _user)
            {   
                user_index = user;
                require(owners[user] == _user);
            }
        }
        
        owners[user_index] = owners[owners.length - 1];
        owners.pop();
        //owners;
    }
    
    
    //gets wallet users
    function getUsers() public view returns(address[] memory)
    {
        return owners;
    }
    
    function getApprovalLimit() public view returns (uint)
    {
        return (limit);
    }
    
    
    //deposit function. require deposit amount i sgreater than 0 and withdrawalRequests//the wallet oweners array is greater than 1
    function deposit() public payable onlyOwners
    {
        require(msg.value >= 0);
        require(owners.length > 1, "need to have more than one signer");
    
        balance[msg.sender] += msg.value;
    }
    
    
    //next we want to make a get balance function
    function getAccountBalance() public view returns(uint)
    {
        return balance[msg.sender];
    }
    
    //get contratc balance
    function getContractBalance() public view returns(uint)
    {
        return address(this).balance;
    }
    
    
    //next we want to make q function to return the address of the wallet owner
    function getOwner() public view returns(address)
    {
        return msg.sender;
    }
    
    
    //Create an instance of the Transfer struct and add it to the transferRequests array
    function createTransfer(uint _amount, address payable _receiver) public onlyOwners {
        require(owners.length > 1, "need to have more than one signer");
        //require(msg.sender != _receiver);
        for (uint i = 0; i < owners.length; i++)
        {
            require(owners[i] != _receiver);
        //   if  (owners[i] == _receiver)
        //   {
        //       revert();
        //   }
        }
        emit TransferRequestCreated(transferRequests.length, _amount, msg.sender, _receiver);
        transferRequests.push(
            Transfer(_amount, _receiver, 0, false, transferRequests.length)
        );
        
    }
    
     function createWithdrawal(uint _amount, address payable _receiver) public onlyOwners {
        require(owners.length > 1, "need to have more than one signer");
        //require(msg.sender != _receiver);
        for (uint i = 0; i < owners.length; i++)
        {
            require(owners[i] != _receiver);
        //   if  (owners[i] == _receiver)
        //   {
        //       revert();
        //   }
        }
        //emit TransferRequestCreated(transferRequests.length, _amount, msg.sender, _receiver);
        withdrawalRequests.push(
            Withdraw(_amount, _receiver, 0, false, withdrawalRequests.length)
        );
        
    }
    
    
    
    function Transferapprove(uint _id) public onlyOwners {
        require(owners.length > 1, "need to have more than one signer");
        require(approvals[msg.sender][_id] == false, "transaction alrady approved");
        require(transferRequests[_id].hasBeenSent == false);
        
        // if ( transferRequests[_id].approvals => limit){
        //     approvals[msg.sender][_id] = true;
        // }
        approvals[msg.sender][_id] = true;
        transferRequests[_id].approvals++;
        
        emit ApprovalReceived(_id, transferRequests[_id].approvals, msg.sender);
    
        
    }
    
    function Withdrawalapprove(uint _id) public onlyOwners {
        require(owners.length > 1, "need to have more than one signer");
        require(approvals[msg.sender][_id] == false, "transaction alrady approved");
        require(withdrawalRequests[_id].hasBeenSent == false);
        
        // if ( transferRequests[_id].approvals => limit){
        //     approvals[msg.sender][_id] = true;
        // }
        approvals[msg.sender][_id] = true;
        withdrawalRequests[_id].approvals++;
        
        //emit ApprovalReceived(_id, transferRequests[_id].approvals, msg.sender);
    
        
    }
    
    
     //now we need to create a function to actually transfer the funds after the
    //transfer has been recieved
    function TransferFunds(uint _id) public returns(uint)
    {
        require(owners.length > 1, "need to have more than one signer");
        require(transferRequests[_id].approvals >= limit);
        
        if(transferRequests[_id].approvals >= limit)
        {
            transferRequests[_id].hasBeenSent = true;
            balance[msg.sender] -= transferRequests[_id].amount;
            balance[transferRequests[_id].receiver] += transferRequests[_id].amount;
            
        }
        return balance[msg.sender];
    }
    
    //after transfer is called our balance i < transaction amount thus we cannot withfraw
    //update amount after transfer function.
    function withdraw(uint _id, uint _amount) public onlyOwners returns (uint)
    {
        //take in amount and update struct 
        require(owners.length > 1, "need to have more than one signer");
        require(withdrawalRequests[_id].approvals >= limit);
        require(balance[msg.sender] >= _amount);
        
        if(withdrawalRequests[_id].approvals >= limit)
        {
            withdrawalRequests[_id].hasBeenSent = true;
            withdrawalRequests[_id].receiver.transfer(_amount);
            //emit TransferApproved(_id);
        }
        
        return balance[msg.sender];
        
    }
    
    
    function getApprovalState(uint _id) public view returns(uint)
    {
        return transferRequests[_id].approvals;
    }
    
    
    //Should return all transfer requests
    function getTransferRequests() public view returns (Transfer[] memory){
       
        return transferRequests;
    }
}