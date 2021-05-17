// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

//the problem with our last mapping is that we could not het a list to sealed
//how many people were in our mapping

contract MappedStructsWithIndex {
  
  //here we begin with the same struct
  struct EntityStruct {
    uint entityData;
    bool isEntity;
  }
  
  //we also keep the same mapping
  mapping(address => EntityStruct) public entityStructs;
  
  //however we now define an array which will keep track of the Entity instances
  //that we have. It will be an arrays of addresses
  address[] public entityList;
  
  //function to create new entity is pretty much the same
  function newEntity(address entityAddress, uint entityData) public returns(uint rowNumber) {
    //revert statment that reverts if the address we pass in is already an instance through
    //the isEntity boolean
    if(isEntity(entityAddress)) revert();
    
    //define struct instace attribute vales
    entityStructs[entityAddress].entityData = entityData;
    //set the isEntity bool to true
    entityStructs[entityAddress].isEntity = true;
    
    entityList.push(entityAddress);
  }

  //att the functions below here are the same
  function updateEntity(address entityAddress, uint entityData) public returns(bool success) {
    if(!isEntity(entityAddress)) revert();
    entityStructs[entityAddress].entityData = entityData;
    return true;
  }

  function isEntity(address entityAddress) public view returns(bool isIndeed) {
      return entityStructs[entityAddress].isEntity;
  }
  
  //here we just return the length of the entity array to see how many instances we have
  function getEntityCount() public view returns(uint entityCount) {
    return entityList.length;
  }
}