//SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "./Ownable.sol";
import "./Item.sol";

contract ItemManager is Ownable{

    enum SupplyChainState{Created, Paid, Delivered} // we dont use a ; after enum


    struct S_Item {
        Item _item;
        string _identifier;
        uint _itemPrice;
        ItemManager.SupplyChainState _state;
    }

   


    mapping(uint => S_Item) public items;
    uint itemIndex;
    event SupplyChainStep(uint _itemIndex,uint _step, address _itemAddress);

    function createItem(string memory _identifier, uint _itemPrice) public onlyOwner{
        Item item = new Item(this,_itemPrice, itemIndex);
        items[itemIndex]._item = item;
        items[itemIndex]._identifier = _identifier;
        items[itemIndex]._itemPrice = _itemPrice;
        items[itemIndex]._state = SupplyChainState.Created;
        emit SupplyChainStep(itemIndex,uint(items[itemIndex]._state), address(item));// basically converted the Created , Paid, Delivered  to 0 ,1, 2;
        itemIndex++;
        
    }

    function triggerPayment(uint _itemIndex) public payable {

        require(items[_itemIndex]._itemPrice == msg.value, "Make Sure Full Payment is Done");
        require(items[_itemIndex]._state == SupplyChainState.Created,"Item is further in chain");
        items[_itemIndex]._state = SupplyChainState.Paid;

        emit SupplyChainStep(_itemIndex,uint(items[_itemIndex]._state), address(items[_itemIndex]._item));// basically converted the Created , Paid, Delivered  to 0 ,1, 2;



    }
    
    function triggerDelivery(uint _itemIndex) public onlyOwner{
        require(items[_itemIndex]._state == SupplyChainState.Paid,"Item is further in chain");
        items[_itemIndex]._state = SupplyChainState.Delivered;

        emit SupplyChainStep(_itemIndex,uint(items[_itemIndex]._state), address(items[_itemIndex]._item));// basically converted the Created , Paid, Delivered  to 0 ,1, 2;

    }
}