// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

//this is the best solution for storage as it uses a mpaiing with duplicate prevention
//and delete functionalities

contract mappedWithUnorderedIndexAndDelete {

  //we begin with the same stuct
  struct EntityStruct {
    uint entityData;
    //more data
    uint listPointer; //0
  }
  
  //here we define an address to struct mapping which maps an address to
  //and entity instance
  mapping(address => EntityStruct) public entityStructs;
  
  //here we define an array which will store all the address of our entity instamnces
  address[] public entityList;

  
  //this function prevents duplicat entities by checking
  function isEntity(address entityAddress) public view returns(bool isIndeed) {
    if(entityList.length == 0) return false;
    
    //returns a bool of the inex of our entity list array which takes in the id of
    //our entity struct ID
    return (entityList[entityStructs[entityAddress].listPointer] == entityAddress);
  }

  //this function gets the length of our entity array
  function getEntityCount() public view returns(uint entityCount) {
    return entityList.length;
  }


  //this function creates an entity instance
  function newEntity(address entityAddress, uint entityData) public returns(bool success) {
    
    //we begin by checking if the entity we are creating already exits and revert if so
    if(isEntity(entityAddress)) revert();
    
    //..then we just set the enity instance attribute values
    entityStructs[entityAddress].entityData = entityData;
    
    //and we push the address of the entity instance to our entity list
    entityList.push(entityAddress);
    
    //we also set the id of our new entity
    entityStructs[entityAddress].listPointer = entityList.length - 1;
    return true;
  }

  //this function allows us to update the values of our entity instance attributes
  function updateEntity(address entityAddress, uint entityData) public returns(bool success) {
     
    //if the entity does not exist revert
    if(!isEntity(entityAddress)) revert();
    entityStructs[entityAddress].entityData = entityData;
    return true;
  }
  
  //[ADRESS1, ADDRESS4, ADDRESS3]
  
  //this function allows us to delete entities
  function deleteEntity(address entityAddress) public returns(bool success) {
    if(!isEntity(entityAddress)) revert();
    uint rowToDelete = entityStructs[entityAddress].listPointer; // = 1
    address keyToMove   = entityList[entityList.length-1]; //save address4
    entityList[rowToDelete] = keyToMove;
    entityStructs[keyToMove].listPointer = rowToDelete; //= 2
    entityList.pop();
    delete entityStructs[entityAddress];
    return true;
  }
  
  function removeEntity(address _entityAddress) public
    {
        //require that the entity we wish to delet exists
        if (!isEntity(_entityAddress)) revert();
        uint entity_ID = entityStructs[_entityAddress].listPointer;
        entityList[entity_ID] = entityList[entityList.length - 1];
        
        entityList.pop();
        delete entityStructs[_entityAddress];
        
    }

}