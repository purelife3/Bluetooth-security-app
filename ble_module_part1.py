#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
BLE Security Module with Apple Device Exploits - Part 1
A comprehensive Bluetooth Low Energy security testing module with Apple-specific vulnerabilities
"""

import asyncio
import json
import random
from dataclasses import dataclass, field
from typing import List, Dict, Optional, Tuple, Any
from enum import Enum
import time

class DeviceType(Enum):
    """Device type classification"""
    APPLE = "Apple"
    ANDROID = "Android"
    WEARABLE = "Wearable"
    IOT = "IoT"
    MEDICAL = "Medical"
    AUDIO = "Audio"
    UNKNOWN = "Unknown"

class SecurityLevel(Enum):
    """Security level classification"""
    NONE = "None"
    LOW = "Low"
    MEDIUM = "Medium"
    HIGH = "High"
    CRITICAL = "Critical"

@dataclass
class BLEDevice:
    """BLE Device information"""
    name: str
    mac_address: str
    device_type: DeviceType
    manufacturer: str = "Unknown"
    rssi: int = -60
    services: List[str] = field(default_factory=list)
    security_level: SecurityLevel = SecurityLevel.LOW
    vulnerabilities: List[str] = field(default_factory=list)
    is_connected: bool = False
    is_paired: bool = False
    
    def to_dict(self) -> Dict:
        """Convert to dictionary for UI display"""
        return {
            "name": self.name,
            "address": self.mac_address,
            "type": self.device_type.value,
            "manufacturer": self.manufacturer,
            "rssi": self.rssi,
            "services": self.services,
            "security": self.security_level.value,
            "vulnerabilities": self.vulnerabilities,
            "connected": self.is_connected,
            "paired": self.is_paired
        }

@dataclass
class BLEExploit:
    """BLE Exploit definition with UI button text"""
    name: str
    description: str
    button_text: str  # Text for UI button
    severity: SecurityLevel
    target_devices: List[DeviceType]  # Which device types this exploit targets
    requires_connection: bool = False
    cve_id: Optional[str] = None
    year_discovered: Optional[int] = None
    
    def to_dict(self) -> Dict:
        """Convert to dictionary for UI display"""
        return {
            "name": self.name,
            "description": self.description,
            "button_text": self.button_text,
            "severity": self.severity.value,
            "target_devices": [d.value for d in self.target_devices],
            "requires_connection": self.requires_connection,
            "cve_id": self.cve_id,
            "year": self.year_discovered
        }

class BLEScanner:
    """BLE Device Scanner with Apple device detection"""
    
    def __init__(self):
        self.devices: List[BLEDevice] = []
        self.scanning = False
        
        # Apple device manufacturer IDs
        self.apple_manufacturer_ids = {
            "Apple Inc.": ["iPhone", "iPad", "Mac", "Apple Watch", "AirPods", "HomePod"],
            "Apple Computer, Inc.": ["MacBook", "iMac", "Mac Pro"]
        }
    
    def scan_devices(self, duration: int = 10) -> List[BLEDevice]:
        """
        Scan for BLE devices (mock implementation)
        In real implementation, this would use bleak or pybluez
        """
        print(f"Scanning for BLE devices for {duration} seconds...")
        self.scanning = True
        
        # Generate mock devices including Apple devices
        self.devices = self._generate_mock_devices()
        
        # Simulate scanning delay
        time.sleep(2)
        
        self.scanning = False
        print(f"Scan complete: Found {len(self.devices)} devices")
        return self.devices
    
    def _generate_mock_devices(self) -> List[BLEDevice]:
        """Generate mock BLE devices including Apple devices"""
        devices = []
        
        # Apple devices
        apple_devices = [
            BLEDevice(
                name="iPhone 15 Pro",
                mac_address="AA:BB:CC:11:22:33",
                device_type=DeviceType.APPLE,
                manufacturer="Apple Inc.",
                rssi=-45,
                services=["Battery", "Device Information", "Apple Continuity", "Find My"],
                security_level=SecurityLevel.MEDIUM,
                vulnerabilities=["CVE-2019-8641", "CVE-2021-30858"]
            ),
            BLEDevice(
                name="AirPods Pro",
                mac_address="DD:EE:FF:44:55:66",
                device_type=DeviceType.APPLE,
                manufacturer="Apple Inc.",
                rssi=-55,
                services=["Audio", "Battery", "Device Information"],
                security_level=SecurityLevel.LOW,
                vulnerabilities=["CVE-2020-9770"]
            ),
            BLEDevice(
                name="Apple Watch Series 9",
                mac_address="11:22:33:AA:BB:CC",
                device_type=DeviceType.APPLE,
                manufacturer="Apple Inc.",
                rssi=-50,
                services=["Heart Rate", "Battery", "Device Information", "Apple Unlock"],
                security_level=SecurityLevel.HIGH,
                vulnerabilities=["CVE-2023-42824"]
            ),
            BLEDevice(
                name="iPad Pro",
                mac_address="44:55:66:DD:EE:FF",
                device_type=DeviceType.APPLE,
                manufacturer="Apple Inc.",
                rssi=-60,
                services=["Battery", "Device Information", "Apple Continuity", "AirDrop"],
                security_level=SecurityLevel.MEDIUM,
                vulnerabilities=["CVE-2021-30858"]
            ),
            BLEDevice(
                name="MacBook Pro",
                mac_address="77:88:99:00:11:22",
                device_type=DeviceType.APPLE,
                manufacturer="Apple Computer, Inc.",
                rssi=-65,
                services=["Battery", "Device Information", "Apple Continuity", "Handoff"],
                security_level=SecurityLevel.MEDIUM,
                vulnerabilities=["CVE-2019-8641"]
            ),
        ]
        
        # Android devices
        android_devices = [
            BLEDevice(
                name="Samsung Galaxy S24",
                mac_address="33:44:55:66:77:88",
                device_type=DeviceType.ANDROID,
                manufacturer="Samsung Electronics",
                rssi=-50,
                services=["Battery", "Device Information", "Fast Pair"],
                security_level=SecurityLevel.MEDIUM,
                vulnerabilities=["BlueBorne", "KNOX bypass"]
            ),
            BLEDevice(
                name="Google Pixel 8",
                mac_address="99:00:11:22:33:44",
                device_type=DeviceType.ANDROID,
                manufacturer="Google LLC",
                rssi=-55,
                services=["Battery", "Device Information", "Fast Pair"],
                security_level=SecurityLevel.HIGH,
                vulnerabilities=[]
            ),
        ]
        
        # Other devices
        other_devices = [
            BLEDevice(
                name="Fitbit Charge 6",
                mac_address="55:66:77:88:99:00",
                device_type=DeviceType.WEARABLE,
                manufacturer="Fitbit Inc.",
                rssi=-70,
                services=["Heart Rate", "Battery", "Device Information"],
                security_level=SecurityLevel.LOW,
                vulnerabilities=["BLE Spoofing"]
            ),
            BLEDevice(
                name="Smart Lock",
                mac_address="22:33:44:55:66:77",
                device_type=DeviceType.IOT,
                manufacturer="August Home",
                rssi=-75,
                services=["Lock Control", "Battery", "Device Information"],
                security_level=SecurityLevel.CRITICAL,
                vulnerabilities=["BLE Replay Attack"]
            ),
        ]
        
        devices.extend(apple_devices)
        devices.extend(android_devices)
        devices.extend(other_devices)
        
        # Randomize order
        random.shuffle(devices)
        
        return devices
    
    def get_device_by_type(self, device_type: DeviceType) -> List[BLEDevice]:
        """Get devices filtered by type"""
        return [device for device in self.devices if device.device_type == device_type]
    
    def get_apple_devices(self) -> List[BLEDevice]:
        """Get all Apple devices"""
        return self.get_device_by_type(DeviceType.APPLE)
    
    def get_device_by_mac(self, mac_address: str) -> Optional[BLEDevice]:
        """Get device by MAC address"""
        for device in self.devices:
            if device.mac_address.lower() == mac_address.lower():
                return device
        return None