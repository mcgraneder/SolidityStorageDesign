// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

//import "DataStructured.sol";

contract ArrayStorageSimple {
    
    
     struct Entity {
        uint data;
        address _address;
    }
    
    Entity[] public newEntity;
  
    function addEntity(uint _data) public {
        
        Entity memory newentity; 
        newentity.data = _data;
        newentity._address = msg.sender;
        newEntity.push(newentity);
    }
    
    function updateEntity(uint _id, uint data) public{
    
        newEntity[_id].data = data;
    }
}


contract ArrayStorage {
    
    
     struct Entity {
        uint data;
        address _address;
    }
    
    Entity[] public newEntity;
    address[] public addressArray;
    
    
    function addEntity(uint _data) public {
        
        for (uint i = 0; i < addressArray.length; i++) {
            require(addressArray[i] != msg.sender);
        }
        addressArray.push(msg.sender);
        
        Entity memory newentity; 
        newentity.data = _data;
        newentity._address = msg.sender;
    
        newEntity.push(newentity);
    }
    
    function updateEntity(address _address, uint data) public{
        
        if (_address != msg.sender) revert();
        uint id = 0;
        
        while (newEntity[id]._address != msg.sender) {
            id++;
            
        }
        newEntity[id].data = data;
    }
}


contract MappingStorage {
    
    
     struct Entity {
        uint data;
        address _address;
    }
    
    mapping (address => Entity) public newEntity;
    address[] public entitylist;
    
    function addEntity(address _address, uint _data) public {
        
        require(_address == msg.sender);
        newEntity[_address].data = _data;
        newEntity[_address]._address = msg.sender;
        
    
        
    }
    
    
    
    //function getEntities() public view returns()
}



contract MappingStorageBetter {
    
    
     struct Entity {
        uint data;
        address _address;
        bool isKnown;
    }
    
    mapping (address => Entity) public newEntity;
    
    
    function addEntity(address _address, uint _data) public {
        require(!newEntity[_address].isKnown);
        require(_address == msg.sender);
        newEntity[_address].data = _data;
        newEntity[_address]._address = msg.sender;
        newEntity[_address].isKnown = true;
    
        
    }
    
    function updateEntit( uint _data) public{
        
        
        require(newEntity[msg.sender]._address == msg.sender);
        
        //uint id = 0;
        
        newEntity[msg.sender].data = _data;
        
        
    }
}