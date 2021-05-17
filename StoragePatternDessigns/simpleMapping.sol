// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

//this storage pattern is different than the array pattern and relies
//on a mapping rather than a lost.
contract mappingWithStruct {

  //again we begin by createing a simple struct
  struct EntityStruct {
    uint entityData;
    bool isEntity;
  }
  
  
  //this time we store our struct instances in a mapping which maps an address
  //to our entity instance
  mapping (address => EntityStruct) public entityStructs;
  
  
  //function that creates an new entity instance it takes the address we want to create an instance
  //with and the attributes of our entity lasttly it takes in a bool set to false
  function newEntity(address entityAddress, uint entityData) public returns(bool success) {
    
    //this first revert statement prevents us from creating duplicate entries so if we enter
    //and arress that we have already made an entity instance for then we revert the transaction
    if(isEntity(entityAddress)) revert(); 
    
    //then we proceed as normal to populate our entty instance by assigning values to the attributes
    //for that given adress
    entityStructs[entityAddress].entityData = entityData;
    //lastly we set our ool to true so that we cannot make duplicates
    entityStructs[entityAddress].isEntity = true;
    
    //return true if we successfully created a new entity instance
    return true;
  }
  
  //function that tells us if we the address that we pass as an input is already an entity instance
  function isEntity(address entityAddress) public view returns(bool isIndeed) {
    
    //if true is returned then we know that the passed in address is an instance
    return entityStructs[entityAddress].isEntity;
  }

  //function that allows us to delete a certain entity instance 
  function deleteEntity(address entityAddress) public returns(bool success) {
    
    //again if we pass in an address that has not been created yet then we cannot delete that
    //account so we revert tje transaction
    if(!isEntity(entityAddress)) revert();
    
    //then we can delete in two ways the first way requires us to set the isEntity boolean to false
    //entityStructs[entityAddress].isEntity = false;
    
    //or we can just use the delete function
    delete entityStructs[entityAddress].isEntity;
    return true;
  }

  //Lastly this function allows us to modify the values of our entity attributes
  function updateEntity(address entityAddress, uint entityData) public returns(bool success) {
    //again check to see if the address we pass in is already an entity
    if(!isEntity(entityAddress)) revert();
    
    //modify the data
    entityStructs[entityAddress].entityData = entityData;
    return true;
  }
}