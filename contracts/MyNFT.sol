
// SPDX-License-Identifier: MIT

import './IERC721.sol';
import './SafeMath.sol';

pragma solidity >=0.4.22 <0.9.0;

contract MyNFT is IERC721{

    using SafeMath for uint256;

    struct Alltoken{
        uint256 id;
        string name;
        string uri;

    }    
  //  mapping (address => Alltoken[]) internal ownedTokens;
    mapping (uint256 => address) internal tokenOwner;
    mapping (address => uint256) internal ownedTokensCount;
    mapping (uint256 => address) internal _tokenapprove;
    mapping (address => mapping (address => bool)) private _operatorApprovals;


    string private _name;
    string private _symbol;

    constructor(string memory name, string memory symbol) {
        _name=name;
        _symbol=symbol;
    }


    function balanceOf(address _owner) external virtual override view returns(uint256){
        require(_owner!=address(0),"MyNFT:balanceOf Invalid address");
        return ownedTokensCount[_owner];
    }
    function ownerOf(uint256 _tokenId) external virtual override view returns(address){
        return tokenOwner[_tokenId];
    }
    function approve(address _approved, uint _tokenId) external virtual override payable {
        address owner = tokenOwner[_tokenId];
        bool check=true;
        require(_approved!=address(0),"MyNFT:approve Invalid Approval Address !");
        require(msg.sender!=owner || check != _operatorApprovals[owner][msg.sender],"msg.sender is the current NFT owner  or operator !");
        _tokenapprove[_tokenId]=_approved;
        emit Approval(owner, _approved, _tokenId);
    }
    function setApprovalForAll(address _operator, bool _approved) external virtual override{
        require(_operator!=msg.sender, " MyNFT:setApprovalForAll msg.sender is the current NFT owner ");
        _operatorApprovals[msg.sender][_operator]=_approved;
        emit ApprovalForAll(msg.sender, _operator, _approved);
    }
    function getApproved(uint256 _tokenId) external virtual override view returns (address){
        return _tokenapprove[_tokenId];
    }
    function isApprovedForAll(address _owner, address _operator) external override view returns (bool){
        return _operatorApprovals[_owner][_operator];
    }        
    function safeTransferFrom(address _from,address _to, uint256 _tokenId, bytes memory _data) external virtual override payable {
         require(tokenOwner[_tokenId]!=address(0),"MyNFT:safeTransferFrom Not a Valid Token");
        require( _operatorApprovals[msg.sender][_from]==true || 
        msg.sender == _tokenapprove[_tokenId] || 
        msg.sender == tokenOwner[_tokenId],
        "MyNFT:safeTransferFrom transfer caller is not owner nor approved");

        tokenOwner[_tokenId]=address(0);
        ownedTokensCount[_from]=ownedTokensCount[_from].sub(1);
        ownedTokensCount[_to]= ownedTokensCount[_to].add(1);
        tokenOwner[_tokenId]=_to;
        emit Transfer(_from, _to, _tokenId);
     
    }

        function safeTransferFrom(address _from, address _to, uint256 _tokenId) external virtual override payable{
        require(tokenOwner[_tokenId]!=address(0),"MyNFT:safeTransferFrom Not a Valid Token");
        // require( _operatorApprovals[msg.sender][_from]==true || 
        // msg.sender == _tokenapprove[_tokenId] || 
        // msg.sender == tokenOwner[_tokenId],
        // "MyNFT:safeTransferFrom transfer caller is not owner nor approved");

        tokenOwner[_tokenId]=address(0);
        ownedTokensCount[_from]=ownedTokensCount[_from].sub(1);
        ownedTokensCount[_to]= ownedTokensCount[_to].add(1);
        tokenOwner[_tokenId]=_to;
        emit Transfer(_from, _to, _tokenId);
        }

        function transferFrom(address _from, address _to, uint256 _tokenId) external virtual override payable{
        require(tokenOwner[_tokenId]!=address(0),"MyNFT:transferFrom Not a Valid Token");
        require( _operatorApprovals[msg.sender][_from]==true || 
        msg.sender == _tokenapprove[_tokenId] || 
        msg.sender == tokenOwner[_tokenId],
        "MyNFT:transferFrom caller is not owner nor approved");

        tokenOwner[_tokenId]=address(0);
        ownedTokensCount[_from]=ownedTokensCount[_from].sub(1);
        ownedTokensCount[_to]= ownedTokensCount[_to].add(1);
        tokenOwner[_tokenId]=_to;
        emit Transfer(_from, _to, _tokenId);
        }


    function _mint(address to, uint256 tokenId) external {
        require(tokenOwner[tokenId]==address(0),"MyNFT:mint Not a Valid Token");
        require(to!=address(0), "MyNFT:mint Invalid Address");
        require(tokenOwner[tokenId]==address(0),"MyNFT:mint Already exists..");
        tokenOwner[tokenId]=to;
        ownedTokensCount[to]=ownedTokensCount[to].add(1);
        emit Transfer(address(0), to, tokenId);
    }
    
}

  
