pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/access/Ownable.sol";

contract IoTDeviceController {
    address private owner;
    mapping (address => IoTDevice) public devices;

    struct IoTDevice {
        string name;
        string deviceType;
        uint256 deviceId;
        bool isActive;
    }

    event DeviceAdded(address indexed owner, uint256 deviceId, string name, string deviceType);
    event DeviceRemoved(address indexed owner, uint256 deviceId);
    event DeviceActivated(address indexed owner, uint256 deviceId);
    event DeviceDeactivated(address indexed owner, uint256 deviceId);

    constructor() {
        owner = msg.sender;
    }

    function addDevice(string memory _name, string memory _deviceType, uint256 _deviceId) public onlyOwner {
        devices[owner].push(IoTDevice(_name, _deviceType, _deviceId, false));
        emit DeviceAdded(owner, _deviceId, _name, _deviceType);
    }

    function removeDevice(uint256 _deviceId) public onlyOwner {
        for (uint256 i = 0; i < devices[owner].length; i++) {
            if (devices[owner][i].deviceId == _deviceId) {
                delete devices[owner][i];
                emit DeviceRemoved(owner, _deviceId);
                return;
            }
        }
    }

    function activateDevice(uint256 _deviceId) public onlyOwner {
        for (uint256 i = 0; i < devices[owner].length; i++) {
            if (devices[owner][i].deviceId == _deviceId) {
                devices[owner][i].isActive = true;
                emit DeviceActivated(owner, _deviceId);
                return;
            }
        }
    }

    function deactivateDevice(uint256 _deviceId) public onlyOwner {
        for (uint256 i = 0; i < devices[owner].length; i++) {
            if (devices[owner][i].deviceId == _deviceId) {
                devices[owner][i].isActive = false;
                emit DeviceDeactivated(owner, _deviceId);
                return;
            }
        }
    }

    function getDevice(uint256 _deviceId) public view returns (string memory, string memory, bool) {
        for (uint256 i = 0; i < devices[owner].length; i++) {
            if (devices[owner][i].deviceId == _deviceId) {
                return (devices[owner][i].name, devices[owner][i].deviceType, devices[owner][i].isActive);
            }
        }
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }
}