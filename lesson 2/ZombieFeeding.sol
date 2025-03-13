pragma solidity ^0.4.19;

// *一定要双引号
import "./zombiefactory.sol";

// 调用CryptoKitties合约
contract KittyInterface {
    function getKitty(uint256 id) external view returns(
        bool isGestating,
        bool isReady,
        uint256 cooldownIndex,
        uint256 nextActionAt,
        uint256 siringWithId,
        uint256 birthTime,
        uint256 matronId,
        uint256 sireId,
        uint256 generation,
        uint256 genes
    );//要以分号结束
}

/**
    为僵尸实现各种功能,让它可以猎食和繁殖
 */
contract ZombieFeeding is ZombieFactory {
    
    // CryptoKitties合约地址
    address ckAddress = "0x06012c8cf97BEaD5deAe237070F9587f8E7A266d";
    // 调用合约地址接口
    KittyInterface kittyContract = KittyInterface(ckAddress);


    /**
     * 当一个僵尸猎食其他生物体时,它自身的DNA将于猎物生物的DNA结合在一起形成一个新的僵尸DNA
     */
     function feeAndMultiply(uint _zombieId, uint _targetDna,string _species) public {
        // 检查调用者(msg.sender)是否与存储再zombieToOwner映射中的僵尸_zombieId对应的所有者地址一致
        require(msg.sender == zombieToOwner[_zombieId]);
        // 从zombies数组中获取对应id的僵尸,并把它的存储引用赋值给局部变量myZombie
        // myZombie一般用于更新它的属性等操作,比如myZombie.name或myZombie.dna
        Zombie storage myZombie = zombies[_zombieId];
        // 确保不长于16位,还是跟之前一样操作
        _targetDna = _targetDna % dnaModulus;
        // 取平均值
        uint newDna = (myZombie.dna + _targetDna) / 2;

        // 如果这个僵尸是一只猫变来的
        if (keccak256(_species) == "kitty") {
            // 把猫咪僵尸DNA的最后两个数字设定为99
            newDna = newDna - newDna % 100 + 99;
        }

        
        // 计算出新的DNA,生成新的僵尸
        _createZombie("NoName",newDna);
     }

     /**
        与CryptoKitties合约交互,获取它的基因
        * _kittyId参数代表想要让僵尸"吃"那只kitty唯一的标识符,传入Kittyid后,合约就要确定查询哪只kitty的数据
      */
      function feedOnkitty(uint _zombieId,uint _kittyId) public {
        // 先定义一个无符号整数变量
        uint kittyDna;
        // 前面的逗号代表不需要的部分,我们只需要获取cryptokitties中的genus基因数据
        (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
        // 调用上述方法,把获取到的基因数据让它重新形成一个新的僵尸DNA
        feeAndMultiply(_zombieId,kittyDna,"kitty");
      }
}