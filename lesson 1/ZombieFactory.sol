pragma solidity ^0.4.19;

contract ZombieFactory {

    // 定义监听事项
    event NewZombie(uint zombieId, string name, uint dna);

    uint dnaDigits = 16; // 定义僵尸DNA，初始化是16位数组成

    uint dnaModulus = 10 ** dnaDigits; // 确保僵尸的DNA只含有16个字符，10^16
    /**
     * 10 ^ 16 = 10,000,000,000,000,000,000,1后面跟了16个0
     */

    // 创建一些僵尸，每个僵尸拥有多个属性
    struct Zombie {
        string name; // 名字
        uint dna; // DNA
    }

    // 为了把僵尸部队保存在DApp里，并且能够让其他App看到这些僵尸，我们需要一个公共数组
    Zombie[] public zombies;
    //调用结构体，公开的，存储所有创建的僵尸（便于外部调用）

    // 创建僵尸
    function _createZombie (string _name, uint _dna) private {
        // zombies.push(Zombie(_name,dna));
        // 定义僵尸id,array.push()返回数组的长度类型是uint,因为数组的第一个元素的索引是0,所以定义的时候,array.push()-1,每次新生成一个僵尸,比如为1减去1等于0,为2减去1,等于1,都能获取最新的僵尸id
        uint id = zombies.push(Zombie(_name,_dna)) - 1;


        NewZombie(id,_name,_dna); //生成事件,进行监听,通知外部有僵尸生成
    }

    // 根据一个字符串随机生成一个DNA数据
    function _generateRandomDna (string _str) private view returns (uint) {
        // 取keccak256散列值生成一个伪随机十六进制数，类型转换位uint，最后保存在类型为uint名为rand的变量中
        uint rand = uint(keccak256(_str));
        // 返回我们的DNA长度为16的dnaModulus，数值配对rand变量取余计算
        return rand % dnaModulus;
    }

    // 随机创建僵尸
    // 对外公开创建僵尸的函数
    function createRandomZombie (string _name) public {
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name,randDna);
    }
}