pragma solidity  solidity ^0.4.19;

import "./zombiefactory.sol";

// 调用kitty猫咪合约
contract KittyInterface {
    function getKitty(uint256 _id) external view returns (
        bool isGestating,
        bool isReady,
        uint256 cooldownIndex,
        uint256 nextActionAt,
        uint256 stringWithId,
        uint256 birthTime,
        uint256 matronId,
        uint256 sireId,
        uint256 generation,
        uint256 genes
    );
}

// 继承父级合约文件 利于调用父级合约内容
contract ZombieFeeding is ZombieFactory {

    // 声明变量,变量类型是kittyInterface(猫咪合约)
    KittyInterface kittyContract;

    // 避免对方的智能合约出现问题,所以采用新的方法函数去配置,因为智能合约一旦部署上线是不可能更改的,这个方法也便于后期修改,*external方法方便外部合约调用
    // 这里配置了onlyOwner,是限制这个方法只能被合约的所有者调用
    function setKittyContractAddress(address _address) external onlyOwner{
        // 1.kittyContract就是存储的朋友号码
        // 2.KittyInterface(_address)把电话号码转换位一个可以通话的对象,可以按照约定给它打电话
        kittyContract = KittyInterface(_address);
    }

    // 重新触发僵尸的冷静周期
    // storage为永久存储在区块链中的变量,所以采用Zombie storage 命名模块调用结构体的定义的变量数据readyTime
    function _triggerCooldown(Zombie storage _zombie) internal {
        // 首先获取到当前下时间+冷静周期赋值到结构体内32位数
        _zombie.readyTime = uint32(now + cooldownTime);
    }

    // 僵尸在这段时间结束前不可再捕猎小猫
    // view为只能读取数据,不能更改数据
    function _isReady(Zombie storage _zombie) internal view returns(bool) {
        // 限制的时间不可以小于冷却的时间,如果成立则为true,不成立则为false,不能再捕猎
        return (_zombie.readyTime <= now);
    }

    function feedAndMultiply(uint _zombieId, uint _targetDna, string species) public {
        // 判断是否是当前对应的调用者地址
        require(msg.sender == zombieToOwner[_zombieId]);

        // 判断当前对应的id值的用户信息,存储到myZombie(命名)的storage的区块链变量中
        Zombie storage myZombie = zombies[_zombieId];

        // 判断该用户是否再冷却时间内,这样,用户就必须等到冷静周期后才可调用这个方法
        require(_isReady(myZombie));

        // 确保生成的DNA保持在16位数
        _targetDna = _targetDna % dnaModulus;

        // 取出新的DNA的平均值
        uint newDna = (myZombie.dna + _targetDna) / 2;

        // 如果species的值等于kitty,则让dna的后两位尾数为99
        if (keccak256(species) == keccak256("kitty)) {
            newDna = newDna - newDna % 100 + 99;
        }

        // 调用生成僵尸的代码,生成新的小猫的僵尸
        _createZombie("NoName", newDna);

        // 重新触发僵尸新的生命周期
        _triggerCooldown(myZombie);
    }

    function feedOnKitty(uint _zombieId, uint _kittyId) public {
        // 先声明一个无符号整数变量
        uint kittyDna;
        // 获取到kitty合约中的genes基因
        (,,,,,,,,,KittyDna) = kittyContract.getKitty(_kittyId);
        // 调用feedAndMultiply函数,让它进行分析
        feedAndMultiply(_zombieId,kittyDna,"kitty");
    }
}