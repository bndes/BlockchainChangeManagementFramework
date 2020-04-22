pragma solidity ^0.5.0;

import "../../changeManagementFramework/core/Upgrader.sol";
import "../../changeManagementFramework/core/ChangeManagement.sol";
import "../../changeManagementFramework/core/Storage.sol";
import "../../changeManagementFramework/core/Resolver.sol";

import {Upgrader1 as LastUpgrader} from './Upgrader1.sol';
import "../LegalEntityMapping.sol";
import "../BNDESRegistry.sol";


contract Upgrader2 is Upgrader {

    LastUpgrader lastUpgrader;
    
    ChangeManagement public changeManagementInstance;
    Resolver public resolverInstance;
    Storage public storageContractInstance;
    LegalEntityMapping public legalEntityMappingInstance;
    BNDESRegistry public bndesRegistryInstance;

    constructor (address lastUpgraderAddr) public {
       
        lastUpgrader = LastUpgrader(lastUpgraderAddr);
        changeManagementInstance = ChangeManagement(lastUpgrader.getChangeManagementAddr());
        resolverInstance = Resolver(lastUpgrader.getResolverAddr());
        storageContractInstance = Storage(lastUpgrader.getStorageContractAddr());
        legalEntityMappingInstance = LegalEntityMapping(lastUpgrader.getLegalEntityMappingAddr());
        bndesRegistryInstance = BNDESRegistry(lastUpgrader.getBNDESRegistryAddr());
    }

    modifier onlyChangeManagement() {
        require(msg.sender==getChangeManagementAddr(), "Upgrader 2 - This function can only be executed by the ChangeManagement");
        _;
    }

    function upgrade () external onlyChangeManagement {

        //Change data in storage
        address ownerOfCMAddr = changeManagementInstance.owner();

        legalEntityMappingInstance.addHandler(address(this));

        legalEntityMappingInstance.setId(ownerOfCMAddr, 777);

        legalEntityMappingInstance.removeHandler(address(this));
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