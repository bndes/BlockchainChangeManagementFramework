pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/lifecycle/Pausable.sol";

import "../changeManagementFramework/core/Updatable.sol";

import "./LegalEntityMapping.sol";

contract BNDESRegistry is Updatable {


    LegalEntityMapping public legalEntityMapping;

//    event AccountRegistration(address addr, uint cnpj, uint idFinancialSupportAgreement, string idProofHash);
//   event AccountChange(address oldAddr, address newAddr, uint cnpj, uint64 idFinancialSupportAgreement, string idProofHash);
 
    constructor (address upgraderInfo, address legalEntityMappingAddr) Updatable (upgraderInfo) public {
        legalEntityMapping = LegalEntityMapping(legalEntityMappingAddr);
    }

    function setLegalEntityMapping (address newAddr) public onlyAllowedUpgrader {
        legalEntityMapping = LegalEntityMapping(newAddr);
    }

    function registryLegalEntity(uint64 id) public {
        legalEntityMapping.setId(msg.sender, id);
    }
    function getId(address addr) external view returns (uint) {
        return legalEntityMapping.getId(addr);
    }
    
    
    function getIdFake() external pure returns (uint) {
        return 12345;
    }


    function kill() external onlyAllowedUpgrader {
        selfdestruct(address(0));
    }
    


}