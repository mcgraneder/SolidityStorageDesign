pragma solidity 0.8.4;

contract simpleList {

    //define simple struct
  struct EntityStruct {
    address entityAddress;
    uint entityData;
  }

    //create array to store data of struct instances (Log Array)
  EntityStruct[] entityStructs;
  mapping (address => bool) knownEntity;
  
  //function to check for known entityStructs
  function isEntity(address _entityAddress) public view returns(bool) {
      
      return knownEntity[_entityAddress];
  }

  //create function to create struct instance and push it to the struct log array
  function newEntity(address entityAddress, uint entityData) public returns(EntityStruct memory) {
    //defines a new instance of our entity struct
    if(isEntity(entityAddress)) revert();
    
    EntityStruct memory newEntity;
    
    //defines the attributes of the struct
    newEntity.entityAddress = entityAddress;
    newEntity.entityData    = entityData;
    
    //pushes this new entity instance to our Struct log array
    entityStructs.push(newEntity);
    knownEntity[entityAddress] = true;
    
    
    //returns the new entity (-1 because array indexing starts at 0)
    return entityStructs[entityStructs.length - 1];
  }
  
  //updates entity data
  function updateEnti(uint _id, address _entityAddress, uint _entitydata) public {
      
      if(!isEntity(_entityAddress)) revert();
      if(entityStructs[_id].entityAddress != _entityAddress) revert();
      
     entityStructs[_id].entityData = _entitydata;
      
      
  }
  
  //getter function that returs a certain id that the user inputs

  //function that returns the size of our struct log array
  function getEntityCount() public view returns(uint entityCount) {
    return entityStructs.length;
  }
  
  //function to return our entoty struct log
  function getEntityLog() public view returns (EntityStruct[] memory) {
      
      return entityStructs;
  }
  
  //function to delete entty instance
  function removeEntity(uint _id) public
    {
        //reuire that the entity log array is greater or equal than 1
        require(entityStructs.length >= 1);
        
         //incase we want to remove a user that is not at the end of the simpleList
         //take the id of that entity and push it to the end of the list
         entityStructs[_id] = entityStructs[entityStructs.length - 1];
         address entityAddress = entityStructs[_id].entityAddress;
         knownEntity[entityAddress] = false;
         //then pop that user
         entityStructs.pop();
        //owners;
    }
}