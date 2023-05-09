// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Sohi is ERC20, Ownable {
    uint256 private _maxSupply = 1000000000000 * 10 ** decimals();
    uint256 private _sellTax = 50;

    address private _taxReceiver = 0xfBE8aAd2b4fc0c60619bf8B46eB171cCe3628C04; // 设置默认交易税收益接收者地址

    constructor() ERC20("Sohi", "Sohi") {
        _mint(msg.sender, _maxSupply);
    }

    function setDivi(uint256 newTax) public onlyOwner {
        require(newTax >= 0 && newTax <= 100, "Invalid tax value");
        _sellTax = newTax;
    }

    function _applySellTax(address sender, uint256 amount) internal view returns (uint256) {
        return amount * _sellTax / 100;
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        uint256 taxAmount = _applySellTax(_msgSender(), amount);
        super.transfer(_taxReceiver, taxAmount); // 将交易税发送给 _taxReceiver
        return super.transfer(recipient, amount - taxAmount);
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        uint256 taxAmount = _applySellTax(sender, amount);
        super.transferFrom(sender, _taxReceiver, taxAmount); // 将交易税发送给 _taxReceiver
        return super.transferFrom(sender, recipient, amount - taxAmount);
    }
}



