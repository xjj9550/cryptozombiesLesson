pragma solidity ^0.4.19;

contract ZombieFactory {
	// 13.定义一个事件叫NewZombie
	event NewZombie(uint zombieId, string name, uint dna);

	// 1.我们的僵尸DNA将由一个十六位数字组成
	uint dnaDigits = 16
	// 2.为了保证我们的僵尸DNA只含有16个字符，我们先造一个uint数据，让它等于10^16，这样一来我们可以用模运算符%把一个整数变成16位
	uint dnaModulus = 10 ** dnaDigits;
	// 3.在我们的程序中，我们将创建一些僵尸，每个僵尸将拥有多个属性，所以这是一个展示结构体的完美例子
	struct Zombie {
		string name;
		uint dna;
	}
	// 4.为了把一个僵尸部队保存在我们的APP里，并且能够让其他APP看到这些僵尸，我们需要一个公共数组
	Zombie[] public zombies;
	// 5.在我们的应用里，我们要能创建一些僵尸，
	// 7.变更为私有函数
	function _createZombie (string _name, uint _dna) private {
		// 6.在函数体里新创建一个Zombie，然后把它加入zombies数组中，新创建的僵尸name和dna，来自函数的参数
        // zombies.push(Zombie(_name,_dna));
        // 14.定义僵尸id，array.push()返回数组的长度类型是uint，因为数组的第一个元素的索引是0，所以定义的时候，array.push() - 1
        uint id = zombies.push(Zombie(_name,_dna)) - 1;
        // 15.生成事件NewZombie，进行监听
        NewZombie(id,_name,_dna);
	}
	
	// 8.建议一个帮助函数，根据一个字符串随机生成一个DNA数据
	function _generateRandomDna(string _str) private view returns (uint) {
		// 9.第一行代码取_str的keccak256散列值生成一个伪随机十六进制数，类型转换为uint，最后保存在类型为uint名为rand的变量中
		uint rand = uint(keccak256(_str))
		// 9.1.返回我们的DNA长度为16的dnaModulus，数值配对上方变量取余计算
		return rand % dnaModulus;
    }
    
    // 10.创建一个 public 函数，命名为 createRandomZombie. 它将被传入一个变量 _name (数据类型是 string)。 (注: 定义公共函数 public 和定义一个私有 private 函数的做法一样)。
	function createRandomZombie(string _name) public {
		// 11.函数的第一行应该调用 _generateRandomDna 函数，传入 _name 参数, 结果保存在一个类型为 uint 的变量里，命名为 randDna。
		uint randDna = _generateRandomDna(_name);
		// 12.第二行调用 _createZombie 函数， 传入参数： _name 和 randDna。
		_createZombie(_name,ranDna);
	}
}