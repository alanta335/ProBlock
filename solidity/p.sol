pragma solidity ^0.8.0;
// SPDX-License-Identifier: GPL-3.0

pragma experimental ABIEncoderV2;
contract Array{
    uint index = 0;
    address owner;
    uint latest_ctr = 1;
    uint owner_controller = 0;
    constructor()  {
        owner = msg.sender;
    }
    modifier ownerCheck()
    {
        require (msg.sender == owner);
        _;
    }
    string[][][] public values = [  
        [ [ "0001" , "alan" ]  ]  
        ];

    function getValue(uint serialNo, uint ownerId, uint owdet) public view returns(string memory){
        string  memory k = values[serialNo][ownerId][owdet];
        return k;
    }

    function insertOwner(uint serialNo, string memory ownerid ,string memory ownerName) public ownerCheck returns(uint ){
        string[][] storage  kd = values[serialNo];
        kd.push( [ ownerid , ownerName] );
        owner_controller  = owner_controller+1;
        return kd.length;
    }

    function createProduct( string memory ownerid ,string memory ownerName) public ownerCheck returns(uint ){
        string[][][] storage  kd = values;
        kd.push( [ [ ownerid, ownerName ] ] );
        latest_ctr = latest_ctr+1;

        return latest_ctr;
    }
    
    function ownerNoRetrieve(uint product_id) public view returns (uint){
        string[][]  storage k = values[product_id];
        return k.length;
    }
    function ProNoRetrieve() public view returns (uint){
       
        return latest_ctr-1;
    }
    function returnarr() public view returns(string[][][] memory)
    {
        string[][][] memory temp = values;
        return temp;
    }
}