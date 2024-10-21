/**
 *Submitted for verification at Etherscan.io on 2024-10-20
 */

// SPDX-License-Identifier: MIT
pragma solidity >=0.4.16 <0.9.0;

/**
 * @title GravatarRegistry
 * @dev Gravatar registry contract
 * @author https://github.com/jobsimi
 */
contract GravatarRegistry {
    event GravatarCreated(
        uint id,
        address indexed owner,
        string name,
        string url
    );
    event GravatarUpdated(
        uint id,
        address indexed owner,
        string name,
        string url
    );
    event GravatarNameUpdated(uint id, address indexed owner, string name);
    event GravatarURLUpdated(uint id, address indexed owner, string url);

    /**
     * @notice Gravatar struct
     * @param owner Gravatar owner
     * @param name Gravatar name
     * @param url Gravatar URL
     */
    struct Gravatar {
        address owner;
        string name;
        string url;
    }

    constructor() {
        {
            contractCreator = msg.sender;
            contractOwner = msg.sender;
        }

        // Create a default Gravatar
        createGravatar(
            "jobsimi",
            "https://avatars.githubusercontent.com/u/108779259"
        );
    }

    // Metadata
    string public version = "0.1.0";
    address public contractCreator;
    address public contractOwner;

    Gravatar[] public gravatars;

    mapping(address => uint) public ownerToGravatar;
    mapping(uint => address) public gravatarToOwner;

    function createGravatar(string memory name, string memory url) public {
        address owner = msg.sender;

        require(ownerToGravatar[owner] == 0, "Gravatar already exists");

        Gravatar memory gravatar = Gravatar(owner, name, url);
        gravatars.push(gravatar);
        uint id = gravatars.length - 1;

        ownerToGravatar[owner] = id;
        gravatarToOwner[id] = owner;

        emit GravatarCreated(id, owner, name, url);
    }

    function readGravatar(
        address owner
    ) public view returns (string memory, string memory) {
        uint id = ownerToGravatar[owner];

        require(id != 0, "Gravatar does not exist");

        Gravatar memory gravatar = gravatars[id];

        return (gravatar.name, gravatar.url);
    }

    function updateGravatar(string memory name, string memory url) public {
        address owner = msg.sender;
        uint id = ownerToGravatar[owner];

        require(id != 0, "Gravatar does not exist");

        Gravatar storage gravatar = gravatars[id];

        require(owner == gravatar.owner, "Only owner can update");

        gravatar.name = name;
        gravatar.url = url;

        emit GravatarUpdated(id, owner, name, url);
    }
    function updateGravatarName(string memory name) public {
        address owner = msg.sender;
        uint id = ownerToGravatar[owner];

        require(id != 0, "Gravatar does not exist");

        Gravatar storage gravatar = gravatars[id];

        require(owner == gravatar.owner, "Only owner can update");

        gravatar.name = name;

        emit GravatarNameUpdated(id, owner, name);
    }
    function updateGravatarURL(string memory url) public {
        address owner = msg.sender;
        uint id = ownerToGravatar[owner];

        require(id != 0, "Gravatar does not exist");

        Gravatar storage gravatar = gravatars[id];

        require(owner == gravatar.owner, "Only owner can update");

        gravatar.url = url;

        emit GravatarURLUpdated(id, owner, url);
    }

    // Balance management
    function withdraw(uint amount) public payable {
        require(
            msg.sender == contractOwner,
            "Only the constract owner can call this function"
        );
        require(address(this).balance > 0, "No balance to transfer");
        require(amount <= address(this).balance, "Amount exceeds balance");
        require(amount > 0, "Amount must be greater than 0");

        payable(msg.sender).transfer(amount);
    }
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
    function transferOwnership(address newOwner) public {
        require(
            msg.sender == contractOwner,
            "Only the contract owner can call this function"
        );
        contractOwner = newOwner;
    }
}
