pragma solidity >=0.7.0;
import "./Ownable.sol";
import "./SafeMath.sol";
import "./Token.sol";


contract Airdrop is Ownable {
    using SafeMath for uint;

    address public tokenAddr;

    event EtherTransfer(address beneficiary, uint amount);

    constructor(address _tokenAddr) public {
        tokenAddr = _tokenAddr;
    }

    function airdropTokens(address[] memory _recipients, uint256[] memory _amount) public onlyOwner returns (bool) {
       
        for (uint i = 0; i < _recipients.length; i++) {
            require(_recipients[i] != address(0));
            require(Token(tokenAddr).transfer(_recipients[i], _amount[i]));
        }

        return true;
    }


    function updateTokenAddress(address newTokenAddr) public onlyOwner {
        tokenAddr = newTokenAddr;
    }

}
