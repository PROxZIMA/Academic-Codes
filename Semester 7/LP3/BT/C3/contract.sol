// SPDX-License-Identifier: MIT
pragma solidity  >=0.4.22;

contract banking{
    mapping(address=>uint) public userAccount;
    mapping(address=>bool) public userExists;

    constructor() public payable {
        require(msg.value >= 30 ether, "At least 30 ether initial funding required");
    }

    function createAcc() public payable returns(address){
        require(userExists[msg.sender] == false, 'Account already created');
        if(msg.value == 0){
            userAccount[msg.sender] = 0;
            userExists[msg.sender] = true;
            return msg.sender;
        }
        require(userExists[msg.sender] == false, 'Account already created');
        userAccount[msg.sender] = msg.value;
        userExists[msg.sender] = true;
        return msg.sender;
    }

    function deposit() public payable returns(string memory){
        require(userExists[msg.sender] == true, 'Account is not created');
        require(msg.value > 0, 'Value for deposit is Zero');
        userAccount[msg.sender] = userAccount[msg.sender] + msg.value;
        return 'Deposited succesfully';
    }

    function withdraw(uint amount) public payable returns(string memory){
        require(userAccount[msg.sender] > amount, 'Insufficeint balance in Bank account');
        require(userExists[msg.sender] == true, 'Account is not created');
        require(amount > 0, 'Enter non-zero value for withdrawal');
        userAccount[msg.sender] = userAccount[msg.sender] - amount;
        payable(msg.sender).transfer(amount);
        return 'Withdrawal succesful';
    }

    function TransferAmount(address payable userAddress, uint amount) public returns(string memory){
        require(userAccount[msg.sender] > amount, 'Insufficeint balance in Bank account');
        require(userExists[msg.sender] == true, 'Account is not created');
        require(userExists[userAddress] == true, 'to Transfer account does not exists in bank accounts ');
        require(amount > 0, 'Enter non-zero value for sending');
        userAccount[msg.sender] = userAccount[msg.sender] - amount;
        userAccount[userAddress] = userAccount[userAddress] + amount;
        return 'Transfer succesfully';
    }

    function sendAmount(address payable toAddress , uint256 amount) public payable returns(string memory){
        require(amount > 0, 'Enter non-zero value for withdrawal');
        require(userExists[msg.sender] == true, 'Account is not created');
        require(userAccount[msg.sender] > amount, 'Insufficeint balance in Bank account');
        userAccount[msg.sender] = userAccount[msg.sender] - amount;
        payable(toAddress).transfer(amount);
        return 'Transfer success';
    }

    function userAccountBalance() public view returns(uint){
        return userAccount[msg.sender];
    }

    function accountExist() public view returns(bool){
        return userExists[msg.sender];
    }
}
