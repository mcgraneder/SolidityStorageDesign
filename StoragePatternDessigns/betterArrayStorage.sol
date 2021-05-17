// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;


//this contratc provides a slightly better solution for our array storage method
//because it  can handle for duplicat entries unlike our last method
contract arrayWithUniqueIds {

  //we begin with the same struct
  struct EntityStruct {
    address entityAddress;
    uint entityData;
  }

  //and the same initialise instance method
  EntityStruct[] public entityStructs;
  
  //however we now introduce a mapping which maps an address introduce
  //a boolean which maps the address to true if the address ahs already
  //been added into the entiry log array.
  mapping(address => bool) knownEntity;

  //so we start out with our create entity function
  function newEntity(address entityAddress, uint entityData) public returns(uint rowNumber) {
      
    //this is the line that handles the duplicates. So if have an if statment
    //which passes the address that we want to make a new entity for into a isEntity
    //function. This function returns the KnownEntity boolean and if its true we revert
    //preventing us from making duplicates
    if(isEntity(entityAddress)) revert();
    
    //then we continue as normal
    EntityStruct memory newEntity;
    newEntity.entityAddress = entityAddress;
    newEntity.entityData = entityData;
    
    //befre we leave the function we set our known entity mappy to true for this new entityAddress
    //to prevent us creating duplicates in future
    knownEntity[entityAddress] = true;
    entityStructs.push(newEntity);
  }

  //this function allows us to change the values of the values of our our entity instance's attributes
  function updateEntity(uint rowNumber, address entityAddress, uint entityData) public returns(bool success) {
    //here we check to make sure that we are actually modifing an instance that exits ortherwise revert
    if(!isEntity(entityAddress)) revert();
    
    //this statment checks that the address we are trying to modify is actually the struct id we provide
    if(entityStructs[rowNumber].entityAddress != entityAddress) revert();
    
    //modify the data
    entityStructs[rowNumber].entityData    = entityData;
    return true;
  }

  //these functions are the same as normmal
  function isEntity(address entityAddress) public view returns(bool isIndeed) {
    return knownEntity[entityAddress];
  }

  function getEntityCount() public view returns(uint entityCount) {
    return entityStructs.length;
  }
}

