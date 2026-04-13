"""
BLE Module Part 3: Windows Exploits, Mock Device Creation, and Debugging Logging
This module adds Windows device exploits, mock Bluetooth/BLE device creation with GATT services,
and a comprehensive debugging logging system.
"""

import time
import uuid
import json
from datetime import datetime
from enum import Enum
from dataclasses import dataclass, field
from typing import List, Dict, Optional, Any, Callable
import random

# Import from existing modules
from ble_module_part1 import DeviceType, BLEDevice, BLEExploit
from ble_module_part2 import BLESecurityTester, BLEManager


class DebugLogLevel(Enum):
    """Debug logging levels"""
    DEBUG = "DEBUG"
    INFO = "INFO"
    WARNING = "WARNING"
    ERROR = "ERROR"
    CRITICAL = "CRITICAL"


@dataclass
class DebugLogEntry:
    """Debug log entry with timestamp and metadata"""
    timestamp: float
    level: DebugLogLevel
    module: str
    message: str
    data: Optional[Dict] = None
    
    def to_dict(self) -> Dict:
        """Convert to dictionary for UI display"""
        return {
            "timestamp": datetime.fromtimestamp(self.timestamp).strftime("%H:%M:%S.%f")[:-3],
            "level": self.level.value,
            "module": self.module,
            "message": self.message,
            "data": json.dumps(self.data) if self.data else ""
        }
    
    def __str__(self) -> str:
        return f"[{datetime.fromtimestamp(self.timestamp).strftime('%H:%M:%S.%f')[:-3]}] {self.level.value}: {self.module} - {self.message}"


class DebugLogger:
    """Comprehensive debugging logger with filtering and UI integration"""
    
    def __init__(self, max_entries: int = 1000):
        self.logs: List[DebugLogEntry] = []
        self.max_entries = max_entries
        self.callbacks: List[Callable[[DebugLogEntry], None]] = []
    
    def log(self, level: DebugLogLevel, module: str, message: str, data: Optional[Dict] = None):
        """Add a log entry"""
        entry = DebugLogEntry(
            timestamp=time.time(),
            level=level,
            module=module,
            message=message,
            data=data
        )
        self.logs.append(entry)
        
        # Trim if exceeds max entries
        if len(self.logs) > self.max_entries:
            self.logs = self.logs[-self.max_entries:]
        
        # Notify callbacks
        for callback in self.callbacks:
            try:
                callback(entry)
            except:
                pass
        
        return entry
    
    def debug(self, module: str, message: str, data: Optional[Dict] = None):
        """Log at DEBUG level"""
        return self.log(DebugLogLevel.DEBUG, module, message, data)
    
    def info(self, module: str, message: str, data: Optional[Dict] = None):
        """Log at INFO level"""
        return self.log(DebugLogLevel.INFO, module, message, data)
    
    def warning(self, module: str, message: str, data: Optional[Dict] = None):
        """Log at WARNING level"""
        return self.log(DebugLogLevel.WARNING, module, message, data)
    
    def error(self, module: str, message: str, data: Optional[Dict] = None):
        """Log at ERROR level"""
        return self.log(DebugLogLevel.ERROR, module, message, data)
    
    def critical(self, module: str, message: str, data: Optional[Dict] = None):
        """Log at CRITICAL level"""
        return self.log(DebugLogLevel.CRITICAL, module, message, data)
    
    def get_logs(self, level_filter: Optional[DebugLogLevel] = None, 
                 module_filter: Optional[str] = None, 
                 limit: int = 100) -> List[DebugLogEntry]:
        """Get filtered logs"""
        filtered = self.logs
        
        if level_filter:
            filtered = [log for log in filtered if log.level == level_filter]
        
        if module_filter:
            filtered = [log for log in filtered if module_filter in log.module]
        
        return filtered[-limit:] if limit else filtered
    
    def clear(self):
        """Clear all logs"""
        self.logs.clear()
    
    def add_callback(self, callback: Callable[[DebugLogEntry], None]):
        """Add callback for new log entries"""
        self.callbacks.append(callback)
    
    def remove_callback(self, callback: Callable[[DebugLogEntry], None]):
        """Remove callback"""
        if callback in self.callbacks:
            self.callbacks.remove(callback)


@dataclass
class GATTCharacteristic:
    """GATT characteristic definition"""
    uuid: str
    name: str
    properties: List[str]  # e.g., ["read", "write", "notify"]
    value: bytes = b""
    description: str = ""
    
    def to_dict(self) -> Dict:
        """Convert to dictionary"""
        return {
            "uuid": self.uuid,
            "name": self.name,
            "properties": self.properties,
            "value": self.value.hex() if self.value else "",
            "description": self.description
        }


@dataclass
class GATTService:
    """GATT service definition"""
    uuid: str
    name: str
    characteristics: List[GATTCharacteristic] = field(default_factory=list)
    primary: bool = True
    
    def add_characteristic(self, uuid: str, name: str, properties: List[str], 
                          value: bytes = b"", description: str = ""):
        """Add a characteristic to this service"""
        char = GATTCharacteristic(
            uuid=uuid,
            name=name,
            properties=properties,
            value=value,
            description=description
        )
        self.characteristics.append(char)
        return char
    
    def to_dict(self) -> Dict:
        """Convert to dictionary"""
        return {
            "uuid": self.uuid,
            "name": self.name,
            "characteristics": [char.to_dict() for char in self.characteristics],
            "primary": self.primary
        }


class MockBLEDevice:
    """Mock Bluetooth/BLE device with GATT services"""
    
    def __init__(self, name: str, address: str, device_type: DeviceType, 
                 rssi: int = -60, services: Optional[List[GATTService]] = None):
        self.name = name
        self.address = address
        self.device_type = device_type
        self.rssi = rssi
        self.services = services or []
        self.connected = False
        self.advertising = False
        self.created_at = time.time()
        
        # Add default services based on device type
        self._add_default_services()
    
    def _add_default_services(self):
        """Add default GATT services based on device type"""
        # Generic Access Service (required by BLE spec)
        generic_access = GATTService(
            uuid="00001800-0000-1000-8000-00805f9b34fb",
            name="Generic Access",
            primary=True
        )
        generic_access.add_characteristic(
            uuid="00002a00-0000-1000-8000-00805f9b34fb",
            name="Device Name",
            properties=["read"],
            value=self.name.encode('utf-8'),
            description="Device name"
        )
        generic_access.add_characteristic(
            uuid="00002a01-0000-1000-8000-00805f9b34fb",
            name="Appearance",
            properties=["read"],
            value=b"\x00\x00",  # Generic computer
            description="Device appearance"
        )
        self.services.append(generic_access)
        
        # Generic Attribute Service (required by BLE spec)
        generic_attribute = GATTService(
            uuid="00001801-0000-1000-8000-00805f9b34fb",
            name="Generic Attribute",
            primary=True
        )
        self.services.append(generic_attribute)
        
        # Device-specific services
        if self.device_type == DeviceType.WINDOWS:
            self._add_windows_services()
        elif self.device_type == DeviceType.APPLE:
            self._add_apple_services()
        elif self.device_type == DeviceType.ANDROID:
            self._add_android_services()
        elif self.device_type == DeviceType.WEARABLE:
            self._add_wearable_services()
        elif self.device_type == DeviceType.IOT:
            self._add_iot_services()
        elif self.device_type == DeviceType.MEDICAL:
            self._add_medical_services()
        elif self.device_type == DeviceType.AUDIO:
            self._add_audio_services()
    
    def _add_windows_services(self):
        """Add Windows-specific GATT services"""
        # Windows Bluetooth Service
        windows_service = GATTService(
            uuid="0000fe57-0000-1000-8000-00805f9b34fb",
            name="Windows Bluetooth",
            primary=True
        )
        windows_service.add_characteristic(
            uuid="0000fe58-0000-1000-8000-00805f9b34fb",
            name="Windows Version",
            properties=["read"],
            value=b"Windows 11 23H2",
            description="Windows version information"
        )
        windows_service.add_characteristic(
            uuid="0000fe59-0000-1000-8000-00805f9b34fb",
            name="Device Model",
            properties=["read"],
            value=b"Surface Pro 9",
            description="Device model information"
        )
        self.services.append(windows_service)
        
        # Windows Hello Service
        windows_hello = GATTService(
            uuid="0000fe5a-0000-1000-8000-00805f9b34fb",
            name="Windows Hello",
            primary=True
        )
        windows_hello.add_characteristic(
            uuid="0000fe5b-0000-1000-8000-00805f9b34fb",
            name="Biometric Status",
            properties=["read", "notify"],
            value=b"\x01",  # Enabled
            description="Windows Hello biometric status"
        )
        self.services.append(windows_hello)
        
        # Windows Nearby Sharing Service
        nearby_sharing = GATTService(
            uuid="0000fe5c-0000-1000-8000-00805f9b34fb",
            name="Nearby Sharing",
            primary=True
        )
        nearby_sharing.add_characteristic(
            uuid="0000fe5d-0000-1000-8000-00805f9b34fb",
            name="Sharing Status",
            properties=["read", "write"],
            value=b"\x01",  # Enabled
            description="Nearby sharing status"
        )
        self.services.append(nearby_sharing)
    
    def _add_apple_services(self):
        """Add Apple-specific GATT services"""
        # Apple Continuity Service
        continuity = GATTService(
            uuid="0000fe00-0000-1000-8000-00805f9b34fb",
            name="Apple Continuity",
            primary=True
        )
        continuity.add_characteristic(
            uuid="0000fe01-0000-1000-8000-00805f9b34fb",
            name="Handoff Status",
            properties=["read", "notify"],
            value=b"\x01",
            description="Handoff enabled status"
        )
        self.services.append(continuity)
        
        # Find My Service
        find_my = GATTService(
            uuid="0000fe02-0000-1000-8000-00805f9b34fb",
            name="Find My",
            primary=True
        )
        find_my.add_characteristic(
            uuid="0000fe03-0000-1000-8000-00805f9b34fb",
            name="Location Data",
            properties=["read"],
            value=b"\x00\x00\x00\x00\x00\x00",  # Mock location
            description="Location data"
        )
        self.services.append(find_my)
    
    def _add_android_services(self):
        """Add Android-specific GATT services"""
        # Fast Pair Service
        fast_pair = GATTService(
            uuid="0000fe2c-0000-1000-8000-00805f9b34fb",
            name="Fast Pair",
            primary=True
        )
        fast_pair.add_characteristic(
            uuid="0000fe2d-0000-1000-8000-00805f9b34fb",
            name="Pairing Key",
            properties=["read", "write"],
            value=b"\x00\x11\x22\x33\x44\x55",
            description="Fast pairing key"
        )
        self.services.append(fast_pair)
    
    def _add_wearable_services(self):
        """Add wearable-specific GATT services"""
        # Heart Rate Service
        heart_rate = GATTService(
            uuid="0000180d-0000-1000-8000-00805f9b34fb",
            name="Heart Rate",
            primary=True
        )
        heart_rate.add_characteristic(
            uuid="00002a37-0000-1000-8000-00805f9b34fb",
            name="Heart Rate Measurement",
            properties=["read", "notify"],
            value=b"\x00\x48",  # 72 BPM
            description="Heart rate measurement"
        )
        self.services.append(heart_rate)
    
    def _add_iot_services(self):
        """Add IoT-specific GATT services"""
        # Environmental Sensing Service
        env_sensing = GATTService(
            uuid="0000181a-0000-1000-8000-00805f9b34fb",
            name="Environmental Sensing",
            primary=True
        )
        env_sensing.add_characteristic(
            uuid="00002a6e-0000-1000-8000-00805f9b34fb",
            name="Temperature",
            properties=["read", "notify"],
            value=b"\x15\x00",  # 21°C
            description="Temperature measurement"
        )
        self.services.append(env_sensing)
    
    def _add_medical_services(self):
        """Add medical-specific GATT services"""
        # Blood Pressure Service
        blood_pressure = GATTService(
            uuid="00001810-0000-1000-8000-00805f9b34fb",
            name="Blood Pressure",
            primary=True
        )
        blood_pressure.add_characteristic(
            uuid="00002a35-0000-1000-8000-00805f9b34fb",
            name="Blood Pressure Measurement",
            properties=["read", "notify"],
            value=b"\x78\x00\x50\x00",  # 120/80 mmHg
            description="Blood pressure measurement"
        )
        self.services.append(blood_pressure)
    
    def _add_audio_services(self):
        """Add audio-specific GATT services"""
        # Audio Service
        audio = GATTService(
            uuid="0000185f-0000-1000-8000-00805f9b34fb",
            name="Audio",
            primary=True
        )
        audio.add_characteristic(
            uuid="00002b91-0000-1000-8000-00805f9b34fb",
            name="Volume Level",
            properties=["read", "write"],
            value=b"\x50",  # 80% volume
            description="Volume level"
        )
        self.services.append(audio)
    
    def connect(self):
        """Simulate device connection"""
        self.connected = True
        return True
    
    def disconnect(self):
        """Simulate device disconnection"""
        self.connected = False
        return True
    
    def start_advertising(self):
        """Start advertising the device"""
        self.advertising = True
        return True
    
    def stop_advertising(self):
        """Stop advertising the device"""
        self.advertising = False
        return True
    
    def read_characteristic(self, service_uuid: str, char_uuid: str) -> Optional[bytes]:
        """Read a characteristic value"""
        for service in self.services:
            if service.uuid.lower() == service_uuid.lower():
                for char in service.characteristics:
                    if char.uuid.lower() == char_uuid.lower():
                        return char.value
        return None
    
    def write_characteristic(self, service_uuid: str, char_uuid: str, value: bytes) -> bool:
        """Write to a characteristic"""
        for service in self.services:
            if service.uuid.lower() == service_uuid.lower():
                for char in service.characteristics:
                    if char.uuid.lower() == char_uuid.lower():
                        if "write" in char.properties:
                            char.value = value
                            return True
        return False
    
    def to_bledevice(self) -> BLEDevice:
        """Convert to BLEDevice for compatibility with existing system"""
        return BLEDevice(
            name=self.name,
            address=self.address,
            device_type=self.device_type,
            rssi=self.rssi,
            services=[service.to_dict() for service in self.services],
            connected=self.connected
        )
    
    def to_dict(self) -> Dict:
        """Convert to dictionary"""
        return {
            "name": self.name,
            "address": self.address,
            "device_type": self.device_type.value,
            "rssi": self.rssi,
            "services": [service.to_dict() for service in self.services],
            "connected": self.connected,
            "advertising": self.advertising,
            "created_at": datetime.fromtimestamp(self.created_at).strftime("%Y-%m-%d %H:%M:%S")
        }