// SPDX-License-Identifier: MIT
pragma solidity >0.6.0 <0.9.0;
import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";

contract Rental {
    address creator;
    Item[] public itemList;
    address ownerAccount;
    mapping(string => address) public itemsToOwner;
    AggregatorV3Interface public priceFeed;

    constructor(address _priceFeed) public {
        priceFeed = AggregatorV3Interface(_priceFeed);
        creator = msg.sender;
    }

    modifier onlyCreator() {
        require(msg.sender == creator);
        _;
    }

    struct Item {
        uint256 id;
        string name;
        address ownerAddress;
        uint256 priceUSD;
    }

    function createItem(
        string memory _name,
        address _ownerAddress,
        uint256 _priceUSD
    ) public returns (bool success) {
        uint256 _id = itemList.length + 1;
        itemList.push(
            Item({
                id: _id,
                name: _name,
                ownerAddress: _ownerAddress,
                priceUSD: _priceUSD
            })
        );
        itemsToOwner[_name] = _ownerAddress;
        return true;
    }

    function transferItem(
        uint256 _itemId,
        address payable _prevOwner,
        address _newOwner
    ) public payable returns (uint256) {
        for (uint256 i = 0; i < itemList.length; i++) {
            if (
                itemList[i].id == _itemId &&
                itemList[i].ownerAddress == _prevOwner
            ) {
                itemList[i].ownerAddress = _newOwner;
                itemsToOwner[itemList[i].name] = _newOwner;
                getConversionRate(msg.value);
                _prevOwner.transfer(msg.value);
            }
        }
        return itemList.length;
    }

    function getConversionRate(uint256 ethAmount)
        public
        view
        returns (uint256)
    {
        uint256 ethPrice = getETHPrice();
        return (ethAmount * ethPrice) / 1000000000000000000;
    }

    function getETHPrice() public view returns (uint256) {
        (, int256 result, , , ) = priceFeed.latestRoundData();
        return uint256(result * 10000000000); //2702
    }
}
