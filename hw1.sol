pragma solidity ^0.8.1; 

/** 
 * Author: fupeiyu 
 * email: 420839500#qq.com 
 * Date: 2021/5/14 13:47  
 * 设立一个彩票池子，任何使用者可通过向彩票池子注入定额资金。 
 * 如果一个人注入资金后一段时间没有其他人注入资金，则所有资金自动转给最后注入资金者。 
 * 如果有其他用户注入资金，则游戏继续滚动执行。 
 */ 
 
 contract HW1{ 
    //The administrator responsible for creating the lottery pool 
    address public owner; 
    address payable public winner; 
     
    struct LotteryPool { 
        uint uuid; 
        uint amount; 
        uint timer; 
        bool ended;
        bool gotten;
    }  
     
    LotteryPool public lotteryPool; 
     
    constructor() {
        owner = msg.sender; 
        winner = payable(address(0)); 
        lotteryPool = LotteryPool({ 
            uuid : block.timestamp, 
            amount : 0, timer : 
            block.timestamp, 
            ended : false,
            gotten : false
        });
    } 
     
     function placeBet() public payable returns (bool) { 
        // 未结束，检查是否超时
        require(
            !lotteryPool.ended,
            "The lottery had been ended." 
        ); 
         
         //  超时，结束彩票 
        if(block.timestamp > (lotteryPool.timer + 3 minutes)){ 
            lotteryPool.ended = true; 
            return false;
            
        } else if(msg.value == 0){ 
            return false; 
            
        } else{ 
            winner = payable (msg.sender); 
            lotteryPool.amount += msg.value; 
            lotteryPool.timer = block.timestamp; 
            return true;
            
        } } 
         
        function endByOwner() public returns (bool){ 
            require( 
                msg.sender == owner, 
                "Only owner can end lottery."
            ); 
            
            require(
                !lotteryPool.ended, 
                "The lottery had been ended." 
            ); 
            
            require( 
                block.timestamp > (lotteryPool.timer + 3 minutes), 
                "It's not time" 
            ); 
            
            lotteryPool.ended = true; 
            return true; 
            
        } 
        
        function getReward() public payable{ 
            require( 
                lotteryPool.ended, 
                "The lottery had not been ended." 
            ); 
            
            require( 
                msg.sender == winner, 
                "Only winner can get reward." 
            );
            
            require( 
                !lotteryPool.gotten, 
                "It has been gotten." 
            ); 
            
            uint amount = lotteryPool.amount; 
            
            if (amount > 0) { 
                lotteryPool.amount = 0; 
                winner.transfer(amount);
                lotteryPool.gotten = true;
            } 
        } 
 }
