#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Test script for Android Bluetooth Security App
This script tests the main components of the app without running the full GUI
"""

import sys
import os

# Add current directory to path
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

print("=== Testing Android Bluetooth Security App ===\n")

# Test 1: Check BLE module imports
print("Test 1: Checking BLE module imports...")
try:
    from ble_module_part1 import DeviceType, SecurityLevel, BLEDevice, BLEExploit, BLEScanner
    from ble_module_part2 import BLESecurityTester, BLEManager, get_ble_manager
    print("✅ BLE modules imported successfully")
    
    # Test 2: Create BLE manager
    print("\nTest 2: Creating BLE manager...")
    ble_manager = get_ble_manager()
    print(f"✅ BLE manager created: {type(ble_manager).__name__}")
    
    # Test 3: Scan for devices
    print("\nTest 3: Scanning for BLE devices...")
    devices = ble_manager.scan_devices()
    print(f"✅ Found {len(devices)} BLE devices")
    
    # Test 4: Check Apple devices
    print("\nTest 4: Checking Apple device detection...")
    apple_devices = [d for d in devices if d.device_type == DeviceType.APPLE]
    print(f"✅ Found {len(apple_devices)} Apple devices")
    
    if apple_devices:
        apple_device = apple_devices[0]
        print(f"  Sample Apple device: {apple_device.name}")
        print(f"  MAC: {apple_device.mac_address}")
        print(f"  Security level: {apple_device.security_level.value}")
    
    # Test 5: Check exploit definitions
    print("\nTest 5: Checking exploit definitions...")
    exploits = ble_manager.get_all_exploits()
    print(f"✅ Found {len(exploits)} exploit definitions")
    
    # Count Apple-specific exploits
    apple_exploits = [e for e in exploits if e.target_device_type == DeviceType.APPLE]
    print(f"  Apple-specific exploits: {len(apple_exploits)}")
    
    # Test 6: Test device indexing
    print("\nTest 6: Testing device indexing...")
    device_index = ble_manager.scan_and_index_devices()
    print(f"✅ Created device index with {len(device_index)} device types")
    
    for device_type, devices_list in device_index.items():
        if devices_list:
            print(f"  {device_type.upper()}: {len(devices_list)} devices")
    
    # Test 7: Test exploit execution (mock)
    print("\nTest 7: Testing exploit execution...")
    if devices:
        test_device = devices[0]
        test_exploits = ble_manager.get_exploits_for_device(test_device)
        
        if test_exploits:
            test_exploit = test_exploits[0]
            result = ble_manager.execute_exploit(test_exploit, test_device)
            print(f"✅ Exploit execution test completed")
            print(f"  Exploit: {test_exploit.name}")
            print(f"  Target: {test_device.name}")
            print(f"  Success: {result.get('success', False)}")
            print(f"  Success rate: {result.get('success_rate', 0)}%")
    
    print("\n=== All tests completed successfully! ===")
    print("\nThe app includes:")
    print(f"  • {len(devices)} BLE devices (mock data)")
    print(f"  • {len(apple_devices)} Apple devices")
    print(f"  • {len(exploits)} exploit definitions")
    print(f"  • {len(apple_exploits)} Apple-specific exploits")
    print("\nApple device exploits include:")
    for exploit in apple_exploits:
        print(f"  • {exploit.name} ({exploit.button_text})")
    
except ImportError as e:
    print(f"❌ Import error: {str(e)}")
    print("Make sure ble_module_part1.py and ble_module_part2.py are in the same directory")
except Exception as e:
    print(f"❌ Test error: {str(e)}")
    import traceback
    traceback.print_exc()

print("\n=== Test Complete ===")