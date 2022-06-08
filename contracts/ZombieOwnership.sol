// SPDX-License-Identifier: MIT
pragma solidity >=0.7.3;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./ZombieAttack.sol";

/// @title A title that should describe the contract/interface
/// @author The name of the author
/// @notice Explain to an end user what this does
/// @dev Explain to a developer any extra details
abstract contract ZombieOwnership is ZombieAttack, ERC721 {
    using SafeMath for uint256;
    using SafeMath32 for uint32;
    using SafeMath16 for uint16;

    mapping(uint256 => address) zombieApprovals;

    function balanceOf(address _owner)
        public
        view
        virtual
        override
        returns (uint256)
    {
        return ownerZombieCount[_owner];
    }

    function ownerOf(uint256 _tokenId)
        public
        view
        virtual
        override
        returns (address)
    {
        return zombieToOwner[_tokenId];
    }

    function _transfer(
        address _from,
        address _to,
        uint256 _tokenId
    ) internal virtual override {
        ownerZombieCount[_to] = ownerZombieCount[_to].add(1);
        ownerZombieCount[_from] = ownerZombieCount[_from].sub(1);
        zombieToOwner[_tokenId] = _to;
        emit Transfer(_from, _to, _tokenId);
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) public virtual override {
        require(
            zombieToOwner[_tokenId] == msg.sender ||
                zombieApprovals[_tokenId] == _to
        );
        _transfer(_from, _to, _tokenId);
    }

    function approve(address _approved, uint256 _tokenId)
        public
        virtual
        override
        onlyOwnerOf(_tokenId)
    {
        zombieApprovals[_tokenId] = _approved;
        emit Approval(msg.sender, _approved, _tokenId);
    }
}
