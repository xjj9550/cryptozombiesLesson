pragma solidity ^0.4.19;

contract ZombieFactory {

    // 监听事件创建
    event NewZombie(uint zombieId, string name, uint dna);

    uint dnaDigits = 16; // 僵尸默认DNA为16位数
    uint dnaModulus = 10 ** dnaDigits; // 确保生成的数字位16位数

    // 创建僵尸军团的结构体
    struct Zombie {
        string name;
        uint dna;
    }

    // 公开的僵尸数组,利于合约内进行数组调用
    Zombie[] public zombies;

    // 在这里定义映射
    mapping (uint => address) public zombieToOwner;//僵尸拥有者的地址

    mapping (address => uint) ownerZombieCount;//记录某个地址所拥有的僵尸数量

    // 私有的创建僵尸函数方法
    function _createZombie(string _name, uint _dna) private {
        // 确保每次创建僵尸能够获取到最新僵尸的id
        uint id = zombies.push(Zombie(_name, _dna)) - 1;

        zombieToOwner[id] = msg.sender;

        ownerZombieCount[msg.sender]++;

        // 返回监听事件,通知外部有新的僵尸创建
        NewZombie(id, _name, _dna);
    }

    // 生成僵尸随机DNA方法,调用的时候会返回16位不同数字的变量
    function _generateRandomDna(string _str) private view returns (uint) {
        uint rand = uint(keccak256(_str));
        return rand % dnaModulus;
    }

    // 公开的创建僵尸方法
    function createRandomZombie(string _name) public {
        // 调用生成僵尸随机DNA方法,由前端createRandomZombie("zombieA")调用
        uint randDna = _generateRandomDna(_name);
        // 调用私有的创建僵尸函数方法,传入了姓名以及随机DNA
        _createZombie(_name, randDna);
    }

}
