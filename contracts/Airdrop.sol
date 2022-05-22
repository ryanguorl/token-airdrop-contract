pragma solidity >=0.7.0;
pragma abicoder v2;
import "./Ownable.sol";
import "./SafeMath.sol";
import "./Token.sol";


contract BatchAirdrop is Ownable {
    using SafeMath for uint;

    address [] public tokensAddr;
    string [] public tokenSymbols;

    constructor(address _tokenAddr) public {
        tokensAddr.push(_tokenAddr);
        tokenSymbols.push(Token(_tokenAddr).symbol());
    }

    function airdropTokens(uint tokenIndex, address[] memory _recipients, uint256[] memory _amount) public onlyOwner returns (bool) {
       require(tokenIndex < tokensAddr.length, "Index out of bound");
        for (uint i = 0; i < _recipients.length; i++) {
            require(_recipients[i] != address(0));
            require(Token(tokensAddr[tokenIndex]).transfer(_recipients[i], _amount[i]));
        }
        return true;
    }

    function addTokenAddr(address[] memory newTokenAddr) public onlyOwner {
        for (uint i=0; i < newTokenAddr.length; i++) {
            tokensAddr.push(newTokenAddr[i]);
            tokenSymbols.push(Token(newTokenAddr[i]).symbol());
        }
    }

    function withdrawTokens(uint tokenIndex, address beneficiary) public onlyOwner {
        require(tokenIndex < tokensAddr.length, "Index out of bound");
        require(Token(tokensAddr[tokenIndex]).transfer(beneficiary, Token(tokensAddr[tokenIndex]).balanceOf(address(this))));
    }

    function balanceOfToken(uint tokenIndex) public onlyOwner returns (uint256){
        require(tokenIndex < tokensAddr.length, "Index out of bound");
        return Token(tokensAddr[tokenIndex]).balanceOf(address(this));
    }

}
