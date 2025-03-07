pragma solidity ^0.4.19;

contract ZombieFactory {
    event NewZombie(uint zombieId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }
    // struct 相当于javascript中的 class类定义
    /*
    class Zombie{
        constructor(name,dna) {
            this.name = name; // 僵尸的名字
            this.dna = dna; // 僵尸的DNA
        }
    }
    */

    // 结构体数组类型
    Zombie[] public zombies;
    // 结构体 公开的 定义的名称

    function _createZombie (string _name, uint _dna) private {
        uint id = zombies.push(Zombie(_name,_dna)) - 1;
        NewZombie(id,_name,_dna);
    }


    //生成随机DNA与随机生成数方法
    function _generateRandomDna(string _str) private view returns(uint) {
        uint rand = uint(keccak256(str));
        return rand % dnaModulus;
    }

    function createRandomZombie(string _name) public {
        // 用来接收僵尸的名称，生成DNA
        uint randDna = _generateRandomDna(_name);
        // 调用创建方法
        _createZombie(_name,ranDna);
    }
}