pragma solidity ^0.4.19;

// 因为zombiefeeding合约内的setKittyContractAddress是外部,即任何人都可以调用,所以我们需要配置一个所有权
import "./ownable.sol";

// 并让此父级合约继承所有权
contract ZombieFactory is ownable{

    // 创建监听事项
    event NewZombie(uint zombieId, string name, uint dna);


    // 僵尸默认只有16位数的DNA
    uint dnaDigits = 16;
    // 确保新生成的是16位数的DNA
    uint dnaModulus = 10 ** dnaDigits;

    // 创建捕猎行为触发僵尸的默认的冷却时间
    uint cooldownTime = 1 days;

    // 创建僵尸的结构体
    struct Zombie {
        string name;
        uint dna;
        uint32 level; //级别,采用32位是因为uint默认是256,gas费也会提高
        uint32 readyTime; //冷却时间,也是采用32位,存储时间戳
    }

    // 创建数组
    Zombie[] public zombies;
    // 结构数组, 公开的, 利于调用的命名

    // 创建映射
    // 拥有僵尸的地址
    mapping (uint => address) public ZombieToOwner;
    // 某个地址所拥有僵尸的数量
    mapping (address => uint) ownerZombieCount;

    // 创建僵尸的函数方法,只能在合约内调用,关键字internal
    function _createZombie(string _name, uint _dna) internal {
        // 获取到每一次新增僵尸的最新的id编号
        // now返回类型是256,所以必须采用uint32强制转换
        uint id = zombies.push(Zombie(_name,_dna,1,uint32 (now + cooldownTime))) - 1;

        // 获取到当前对应的拥有者地址
        // 要注意映射的键值,uint,所接收的自然是[id]
        zombieToOwner[id] = msg.sender;
        // 地址所拥有的僵尸数量则自增
        ownerZombieCount[msg.sender]++;
        // 发起监听,让前端进行调用
        NewZombie(id,_name,_dna);
    }

    // 生成DNA的随机数方法
    function _generateRandomDna(string _str) private view returns (uint) {
        uint rand = uint(keccak256(_str));
        return rand % dnaModulus;
    }

    // 随机创建僵尸
    function createRandomZombie(string _name) public {
        // 判断拥有者僵尸的数量是不是等于0,是的话则继续,不然用户一直创建僵尸就不好玩了
        require(ownerZombieCount[msg.sender] == 0);
        // 根据用户定义的名称,比如_generateRandomDna('ruin'),_generateRandomDna已经通过uint(keccak256(_str))转换位无符号整数,生成新的DNA数字给到randDna内
        uint randDna = _generateRandomDna(_name);
        // 1234567890123456 % 100 = 56
        // 1234567890123456 - 56 = 1234567890123400
        // 为了预留 DNA 的最后两位给后续的功能（比如喂养或繁殖时可能对这两位进行修改或附加特征）
        randDna = randDna - randDna % 100;
        // 调用创建僵尸的方法,创建新的僵尸
        _createZombie(_name,randDna);


    }


}