pragma solidity ^0.5.0;

import "../../changeManagementFramework/core/Upgrader.sol";
import "../../changeManagementFramework/core/ChangeManagement.sol";
import "../../changeManagementFramework/core/Storage.sol";
import "../../changeManagementFramework/core/Resolver.sol";

import {Upgrader2 as LastUpgrader} from './Upgrader2.sol';
import "../LegalEntityMapping.sol";
import "../BNDESRegistry.sol";


contract Upgrader3 is Upgrader {

    LastUpgrader lastUpgrader;
    
    ChangeManagement public changeManagementInstance;
    Resolver public resolverInstance;
    Storage public storageContractInstance;
    LegalEntityMapping public legalEntityMappingInstance;
    address bndesRegistryOldAddr;
    BNDESRegistry public bndesRegistryInstance;

    constructor (address lastUpgraderAddr, address newBndesRegistryAddr) public {
       
        lastUpgrader = LastUpgrader(lastUpgraderAddr);
        changeManagementInstance = ChangeManagement(lastUpgrader.getChangeManagementAddr());
        resolverInstance = Resolver(lastUpgrader.getResolverAddr());
        storageContractInstance = Storage(lastUpgrader.getStorageContractAddr());
        legalEntityMappingInstance = LegalEntityMapping(lastUpgrader.getLegalEntityMappingAddr());
        bndesRegistryOldAddr = lastUpgrader.getBNDESRegistryAddr();
        bndesRegistryInstance = BNDESRegistry(newBndesRegistryAddr);
    }

    modifier onlyChangeManagement() {
        require(msg.sender==getChangeManagementAddr(), "Upgrader 3 - This function can only be executed by the ChangeManagement");
        _;
    }

    function upgrade () external onlyChangeManagement {

        legalEntityMappingInstance.removeHandler(bndesRegistryOldAddr);
        legalEntityMappingInstance.addHandler(address(bndesRegistryInstance));
        resolverInstance.changeContract("BNDESRegistry", address(bndesRegistryInstance));

    }


    function getChangeManagementAddr() public view returns (address) {
        return address(changeManagementInstance);
    }

    function getResolverAddr() public view returns (address) {
        return address(resolverInstance);
    }

    function getStorageContractAddr() public view returns (address) {
        return address(storageContractInstance);
    }

    function getLegalEntityMappingAddr() public view returns (address) {
        return address(legalEntityMappingInstance);
    }

    function getBNDESRegistryAddr() public view returns (address) {
        return address(bndesRegistryInstance);
    }

}