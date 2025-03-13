// 好处
// 1.合约创建,构造函数先行,将owner部署为msg.sender(其部署者)
// 2.为它加上一个修饰符onlyOwner,它会限制陌生人的访问,将访问某些函数的权限锁定在owner上
// 3.允许将合约所有权转让给其他人

// 1.定义了一个名为Ownable的合约
contract Ownable {
    // 2.声明了一个类型为address的状态变量owner，并设置public公开的
    /**
        这意味着合约中保存了一个所有者地址，同时Solidity会自动生成一个getter函数，允许外部查询该地址
     */
    address public owner;

    /**
        事件(Event)：ownershipTransferred用于记录所有权转移的操作
        previousOwner：转移前的所有者地址
        newOwner：转移后的所有者地址

        indexed关键字：允许在事件日志中过滤这两个参数，方便外部监听和查询
     */
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


    /**
        构造函数
        一生唯一一次的执行,就是在合约最初被创建的时候
     */
    function Ownable() public {
        // 初始化为msg.sender，即部署合约时发起交易的地址成为合约所有者
        owner = msg.sender;
    }

    /**
        Modifier（修饰符）:onlyOwner
        修饰符作用：onlyOwner用来限制某些函数只能被合约的所有者调用
     */
    modifier onlyOwner() {
        // require来检查调用者是否等于当前所有者
        require(msg.sender == owner);
        // 如果require不成立，会使及交易回滚，防止非所有者调用受保护的函数。
        _;
    }

    // 转移所有权函数
    /**
        transferOwnership接受一个参数newOwner，类型为address，表示新的所有者地址
        public，意味着外部可以调用，同时加上了onlyOwner修饰符，确保只有当前所有者才能调用该函数
     */
    function transferOwnership(address newOwner) public onlyOwner {
        /**
            检查新所有者地址
            require(newOwner != address(0));确保传入的新所有者地址部署零地址，零地址通常用作默认这，不允许设置为所有者
         */
        require(newOwner != address(0));
        /**
            触发事件
            OwnershipTransferred(owner, newOwner);调用事件，记录所有权转移
         */
        OwnershipTransferred(owner, newOwner);
        /**
            更新所有者
            owner = newOwner；将状态变量owner更新为新的所有者地址，完成所有权转移
         */
        owner = newOwner;
    }
}