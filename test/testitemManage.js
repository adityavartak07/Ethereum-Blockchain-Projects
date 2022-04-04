var assert = require('assert');

const ItemManager = artifacts.require("./ItemManager.sol");

contract("ItemManager", accounts => {
    it("...should be able to add an item", async function(){
        const ItemManagerInstance = await ItemManager.deployed();
        const itemName ="test1";
        const itemPrice=500;

        const result = await ItemManagerInstance.createItem(itemName,itemPrice,{from:accounts[0]});
        assert.equal(result.logs[0].args._itemIndex,0 , "its not the first item");
        const item = await ItemManagerInstance.items(0);
        console.log(item);

        assert.equal(item._identifier,itemName, " _identifier of item is diff than itemName, error occured");
    })

})