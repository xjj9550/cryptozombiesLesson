pragma ^0.4.19;

import "./zombiefeeding";

contract ZombieHelper is ZombieFeeding {

    // 通过传入的level参数限制僵尸使用某些特殊功能
    modifier aboveLevel(uint _level, uint _zombieId) {
        // 判断当前用户的等级是否大于传入的等级
        require(zombies[_zombieId].level >= _level);
        // 是的话则回滚,条件不成立
        _;
    }

    // 2级以上的僵尸,玩家可以给它们改名
    function changeName(uint _zombieId, string _newName) internal aboveLevel(2,_zombieId) {
        // 判断调用的用户地址是否为拥有僵尸的地址
        require(msg.sender == ZombieToOwner[_zombieId]);
        // 是的话可以更改新的名字,并重新赋值到zombie数组中
        zombies[_zombieId].name = _newName
    }

    // 20级以上的僵尸,玩家能给它们定制DNA
    function changeDna(uint _zombieId, uint _newDna) internal aboveLevel(20,_zombieId) {
        require(msg.sender == ZombieToOwner[_zombieId]);
        zombies[_zombieId].dna = newDna;
    }

    // 返回某个玩家整个僵尸军团
    // 采用external view让玩家不需要花多余的gas费用,玩家只需要查询本地以太坊节点,而不需要在区块链上创建一个事务
    function getZombieByOwner(address _owner) external view returns(uint[]){
        // 采用memory关键字来创建数组,尽在内存中创建,不需要写入外部存储,并且在函数结束后就会散开,与storage相比,也是一个节省gas费不错的选择
        // 使用uint []数组的形式返回某一个用户所拥有的所有僵尸
        uint[] memory result = new uint[](ownerZombieCount[_owner]);

        // for循环,重新整理僵尸军团,避免重复删除调用浪费gas
        uint counter = 0;
        for (i = 0; i < zombies.length; i++) {
            // 判断当前的拥有僵尸的地址(多个) 是否等于当前查询某个玩家的地址
            if (zombieToOwner[i] == _owner) {
                // 是的话则重新排序赋值到result中
                result[counter] = i;
                counter++;
            }
        }
        return result;//返回重新赋值后排序的result数组
    }

}