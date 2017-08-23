pragma solidity ^0.4.0;

contract vault {

    address creator;
    uint userCount;

    struct Info {
        uint value;
        uint endTime;
    }

    mapping(address => Info) users;

    function vault() {
        creator = msg.sender;
    }

    function newUser(uint time) payable {
        if (users[msg.sender].value == 0) {
            users[msg.sender] = Info(msg.value, time + now);
            userCount++;
        }
    }

    function canWithdraw(address user) constant returns(bool){
        if (users[user].value > 0) {
            if (users[user].endTime < now) {
                return true;
            }
        }
    }

    function remaining(address user) constant returns(uint){
        uint timeLeft;
        timeLeft = users[user].endTime - now;
        if (timeLeft < 0) {
            timeLeft = 0;
        }
        return timeLeft;
    }

    function withdraw() {
        require(canWithdraw(msg.sender));
        msg.sender.transfer(users[msg.sender].value);
    }

    function kill() {
        selfdestruct(creator);
    }
}
