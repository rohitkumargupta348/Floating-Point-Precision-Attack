// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract FloatingPointPrecisionAttack{
    // uint constant public tokensPerEth = 10;//1 eth = 10 tokens or 10^18 wei = 10 tokens
    uint constant public tokensPerEth = 10 * 1e18;//1 eth = 10 * 10^18 tokens or 10^18 wei = 10 * 10^18 tokens  //solution2
    uint constant public weiPerEth = 1e18;

    mapping (address => uint) public balances;

    function buyTokens() public payable {
        // uint tokens = (msg.value / weiPerEth)*tokensPerEth;//problem
        uint tokens = msg.value*tokensPerEth / weiPerEth;//solution
        balances[msg.sender] += tokens;
    }
    //for 0.5 ether balance still shows 0
    // msg.value > weiPerEth => msg.value/weiPerEth > 1 but if it is decimal like 1.9 it is converted to 1(float value of 1.9
    // msg.value < weiPerEth => msg.value/weiPerEth < 1 => 0-1 // so solidity makes it 0;
    function sellTokens(uint tokens)public {
        require(balances[msg.sender] >= tokens);
        uint eth = tokens / tokensPerEth;
        balances[msg.sender] -= tokens;
        payable (msg.sender).transfer(eth*weiPerEth);
    }
}

//Conclusion - Numerator should be always in integer and tokens should be also integer in uint tokens = msg.value*tokensPerEth / weiPerEth;
