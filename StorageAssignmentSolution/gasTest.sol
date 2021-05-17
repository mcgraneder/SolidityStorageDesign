// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

contract GasTest {
    
    //STATE VARIABLE
    uint n = 10;
    //below we have two functions that are the exact same only one is public
    //and the other is external
    
    //external contratcs are much cheaper than public contratcs. Note that external
    //contratcs use the calldata memory call which is cheaper than memory storage
    
    //with external functions we use the calldata data location for our input arguments.
    //calldata does not write our arguments to memory. They are only read from the function
    //call. However this also means that we can not modify our input as its read only
    //COST = 562 gas
    
    //if our function does not write or read or modify a state variable (a var declared outside function)
    //then we can have it as a pure function. Pure functions do not cost anything so should be used when nessecary
    function testExternal(uint[10] calldata numbers) external pure returns(uint){
        return numbers[0];
    }
    
    //public contratcs cost much more expensive because public contratcs require
    //us to have our input arguments in memory which is more expensive that
    //calldata
    //COST = 3314 GAS
    
    //writing data to memoty is still expensive but not as expensive as storage
    //view functions are functions that do not modify a state variable they only read it
    //haveing functions as view or pure are in a lot of cases free to execute. They can be run without
    //making a transaction on the blockchain
    function testPublicl(uint[10] memory numbers) public view returns(uint){
        return numbers[0];
    }
    
    //the diference between public and external functions is that we can calld public functions from anywhere in our contartcs
    //both internally and externally. However external contratcs can only becalled from outside our contarcst
    
    function test() public{
        
        //can be called (commented to prevent error)
        //testPublicl();
        //can not be called (commented to prevent error)
        //testExternal();
    }
    
    //Note inherited contratcs are called externally so perhaps should be left public
}