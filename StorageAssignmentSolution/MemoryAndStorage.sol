// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

contract memoryAndStorage {
    
    //we can assign data in two ways
    //assign by copyof
    //assign by data
    
    //storage -> memory = COPY;
    //memory -> storage = COPY;
    
    //memory -> memory = REFERENCE
    //storage -> local storage = REFERENCE
    
    uint[] storageArray; //[1, 2, 3]
    
    function f(uint[] memory memoryArray) public { //[1, 2, 3,, 4]
        
        storageArray = memoryArray; //this copys memory array to storage array
        storageArray.push(4);
        
        uint[] storage pointerArray = storageArray; //pointerArray => storageArray
        
        pointerArray.push(7);
        
        uint[] memory memoryArray2 = memoryArray;  // memoryArray2 -> memoryArray
        
        //THIS COPIES
        memoryArray = pointerArray;
        
        //return storageArray;
    }
    
}