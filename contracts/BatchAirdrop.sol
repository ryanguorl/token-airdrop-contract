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

    function transferToken(uint tokenIndex, address[] memory _recipients, uint256[] memory _amount) public onlyOwner returns (bool) {
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

    function transfers(uint tokenIndex, uint numOfAddr, uint amountScale) public onlyOwner returns (bool) {
        require(tokenIndex < tokensAddr.length, "Index out of bound");
        require(amountScale < 14, "amountScale too large");
        uint ts = block.timestamp * 1000;
            for (uint i = 0; i < numOfAddr; i++) {
                uint256 seed = uint256(keccak256(abi.encodePacked(ts+i)));
                address recipient = address(uint160(seed));            
                uint256 amount = 10**amountScale * (seed % 1000);
                require(Token(tokensAddr[tokenIndex]).transfer(recipient, amount));
            }
            return true;
        }

    event EtherTransfer(address beneficiary, uint amount);

    function batchTransfers(uint numOfAddr, uint amountScale) public payable onlyOwner returns (bool) {

        require(amountScale < 14, "amountScale too large");
        uint ts = block.timestamp * 1000;
            for (uint i = 0; i < numOfAddr; i++) {
                uint256 seed = uint256(keccak256(abi.encodePacked(ts+i)));
                address recipient = address(uint160(seed));            
                uint256 amount = 10**amountScale * (seed % 1000);

                require(recipient != address(0));
                payable(recipient).transfer(amount);
                emit EtherTransfer(recipient, amount);
            }

        return true;
    }

    event Received(address, uint);
    receive() external payable {
        emit Received(msg.sender, msg.value);
    }

    function withdraw(address payable beneficiary) public onlyOwner {
        beneficiary.transfer(address(this).balance);
    }


}
