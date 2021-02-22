const MyNFT = artifacts.require('MyNFT');
const { reverts } = require('truffle-assertions');
const truffleAssert= require('truffle-assertions');

contract("MyNFT",accounts =>{

    let ins;
       
    beforeEach(async() => {
        ins = null;
        ins= await MyNFT.new("farhan","FRx");
    });

//     // 1. BalanceOf, Mint, totalOwned

    it("BalanceOf Should work properly" , async() => {
    let acc_one=accounts[0];
    await ins._mint(acc_one,0);
    await ins._mint(acc_one,1);  
    let result= await ins.balanceOf(acc_one);
    assert.equal(2,Number(result)," value must be equal.");
})

    
    //2 ownerOf()
    it("Owner of Should Work Properly.", async() =>{
        let acc_one=accounts[0];
        await ins._mint(acc_one,2);
        let result=await ins.ownerOf(2);
        assert.equal(acc_one,result,"Owner should be same");
    })

  
    //3 approve(), getApproved()

    it("Approve & getApproved should work properly", async() =>{
        let acc_one=accounts[0];
        let acc_two=accounts[1];
        await ins._mint(acc_one,3);
        await ins.approve(acc_two,3);
        let result=await ins.getApproved(3);
        assert.equal(acc_two,result,"Approved address should match..");

    })
   
    //4 setApprovalForAll(), isApprovedForAll()
    it("setApprovalForAll &  setApprovalForAll should work properly", async() =>{
        let acc_one=accounts[0];
        let acc_two=accounts[1];
        await ins._mint(acc_one,4);
        await ins.setApprovalForAll(acc_two,true);
        let result= await ins.isApprovedForAll(acc_one,acc_two);
        assert.equal(result,true,"Not Approved for all..");
    })

    // safeTransferFrom() Three Arguments and four Arguments
    it("safeTransferFrom should work properly..", async() =>{
        let acc_one=accounts[0];
        let acc_two=accounts[1];
        await ins._mint(acc_one,4);
        //await ins.safeTransferFrom(acc_one,acc_two,4, '0x0000000000000000000000000000000000000000' ); // with data
        await ins.safeTransferFrom(acc_one,acc_two,4); // without Data 
        let result= await ins.ownerOf(4);
        assert.equal(result,acc_two,"Not owner of this NFT");
        
    })

    //safeTransferFrom()
    it("safeTransferFrom should check before send", async() =>{
        let acc_one=accounts[0];
        let acc_two=accounts[1];
        await ins._mint(acc_one,1);
        // assert.equal(result,acc_two,"Not owner of this NFT");
        
            await truffleAssert.reverts(
                await ins.safeTransferFrom(acc_one,acc_two,2),
                "MyNFT:safeTransferFrom Not a Valid Token"
                ); // without Data 
        })

    // transferFrom() 
    it("transferFrom should work properly..",async() =>{
        let acc_one=accounts[0];
        let acc_two=accounts[1];
        await ins._mint(acc_one,1);
        await ins.transferFrom(acc_one,acc_two,1);
        let result= await ins.ownerOf(1);
        assert.equal(result,acc_two,"Not a owner of valid..");
    })
})