#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
Android Bluetooth Security App with Apple Device Exploits
A Bluetooth management and security testing application for Android built with Kivy
Includes Apple device exploits with easy-to-tap buttons and full device indexing
"""

import kivy
kivy.require('2.3.0')

from kivy.app import App
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.button import Button
from kivy.uix.label import Label
from kivy.uix.scrollview import ScrollView
from kivy.uix.gridlayout import GridLayout
from kivy.uix.tabbedpanel import TabbedPanel, TabbedPanelItem
from kivy.uix.popup import Popup
from kivy.uix.textinput import TextInput
from kivy.clock import Clock
from kivy.properties import StringProperty, ListProperty, BooleanProperty, NumericProperty, ObjectProperty
from kivy.lang import Builder

# Try to import Bluetooth modules
try:
    from plyer import bluetooth
    BLUETOOTH_AVAILABLE = True
except ImportError:
    BLUETOOTH_AVAILABLE = False
    print("Warning: plyer.bluetooth not available. Using mock data.")

# Import BLE Security Module
try:
    from ble_module_part1 import DeviceType, SecurityLevel, BLEDevice, BLEExploit, BLEScanner
    from ble_module_part2 import BLESecurityTester, BLEManager, get_ble_manager
    from ble_module_part3 import DebugLogger, MockBLEDevice, GATTService, GATTCharacteristic, DebugLogLevel
    BLE_MODULE_AVAILABLE = True
    print("BLE Security Module loaded successfully")
except ImportError as e:
    BLE_MODULE_AVAILABLE = False
    print(f"Warning: BLE Security Module not available: {str(e)}")

# Load Kivy language file
Builder.load_file('bluetooth.kv')

class BluetoothDeviceItem(BoxLayout):
    """Widget for displaying a Bluetooth device - matches bluetooth.kv definition"""
    device_name = StringProperty("Unknown Device")
    mac_address = StringProperty("00:00:00:00:00:00")
    is_connected = BooleanProperty(False)
    is_paired = BooleanProperty(False)
    device_type = StringProperty("Unknown")
    
    def __init__(self, device_info=None, **kwargs):
        super().__init__(**kwargs)
        if device_info:
            self.device_name = device_info.get('name', 'Unknown Device')
            self.mac_address = device_info.get('address', '00:00:00:00:00:00')
            self.device_type = device_info.get('type', 'Unknown')
            self.is_paired = device_info.get('paired', False)
            self.is_connected = device_info.get('connected', False)
    
    def on_touch_down(self, touch):
        """Handle touch events on device item - connect/disconnect on tap"""
        if self.collide_point(*touch.pos):
            print(f"Selected device: {self.device_name} ({self.mac_address})")
            
            # Toggle connection status on tap
            if self.is_connected:
                # If already connected, disconnect
                app = App.get_running_app()
                if app and hasattr(app.root, 'disconnect_device'):
                    app.root.disconnect_device(self)
            else:
                # If not connected, connect
                app = App.get_running_app()
                if app and hasattr(app.root, 'connect_to_device'):
                    app.root.connect_to_device(self)
            
            return True
        return super().on_touch_down(touch)

class BLEDeviceItem(BoxLayout):
    """Widget for displaying a BLE device - matches bluetooth.kv definition"""
    device_name = StringProperty("Unknown BLE Device")
    mac_address = StringProperty("00:00:00:00:00:00")
    device_type = StringProperty("Unknown")
    security_level = StringProperty("UNKNOWN")
    ble_device = ObjectProperty(None, allownone=True)
    
    def __init__(self, ble_device=None, **kwargs):
        super().__init__(**kwargs)
        if ble_device:
            self.ble_device = ble_device
            self.device_name = ble_device.name
            self.mac_address = ble_device.mac_address
            self.device_type = ble_device.device_type.value
            self.security_level = ble_device.security_level.value
    
    def show_exploits(self):
        """Show available exploits for this device"""
        if self.ble_device and BLE_MODULE_AVAILABLE:
            app = App.get_running_app()
            if app and hasattr(app.root, 'show_exploits_for_device'):
                app.root.show_exploits_for_device(self.ble_device)

class ExploitButton(BoxLayout):
    """Widget for displaying an exploit button - matches bluetooth.kv definition"""
    exploit_name = StringProperty("Unknown Exploit")
    severity = StringProperty("MEDIUM")
    target_device = StringProperty("General")
    button_text = StringProperty("Run Exploit")
    exploit = ObjectProperty(None, allownone=True)
    device_mac = StringProperty("")
    
    def __init__(self, exploit=None, device_mac="", **kwargs):
        super().__init__(**kwargs)
        if exploit:
            self.exploit = exploit
            self.exploit_name = exploit.name
            self.severity = exploit.severity.value
            self.target_device = exploit.target_device_type.value
            self.button_text = exploit.button_text
            self.device_mac = device_mac
    
    def run_exploit(self):
        """Run this exploit"""
        if self.exploit and BLE_MODULE_AVAILABLE:
            app = App.get_running_app()
            if app and hasattr(app.root, 'run_exploit_for_device'):
                app.root.run_exploit_for_device(self.exploit, self.device_mac)

class ExploitPopup(Popup):
    """Popup for displaying available exploits"""
    device_name = StringProperty("Unknown Device")
    device_mac = StringProperty("")
    ble_device = ObjectProperty(None, allownone=True)
    
    def __init__(self, ble_device=None, **kwargs):
        super().__init__(**kwargs)
        if ble_device:
            self.ble_device = ble_device
            self.device_name = ble_device.name
            self.device_mac = ble_device.mac_address
            self.load_exploits()
    
    def load_exploits(self):
        """Load exploit buttons for this device"""
        if self.ble_device and BLE_MODULE_AVAILABLE and hasattr(self, 'ids'):
            # Clear existing buttons
            if 'exploit_buttons_grid' in self.ids:
                self.ids.exploit_buttons_grid.clear_widgets()
            
            # Get BLE manager
            app = App.get_running_app()
            if app and hasattr(app.root, 'ble_manager'):
                ble_manager = app.root.ble_manager
                if ble_manager:
                    # Get available exploits for this device
                    exploits = ble_manager.get_exploits_for_device(self.ble_device)
                    
                    # Create exploit buttons
                    for exploit in exploits:
                        exploit_button = ExploitButton(exploit=exploit, device_mac=self.device_mac)
                        self.ids.exploit_buttons_grid.add_widget(exploit_button)
    
    def run_all_exploits(self):
        """Run all exploits for this device"""
        if self.ble_device and BLE_MODULE_AVAILABLE:
            app = App.get_running_app()
            if app and hasattr(app.root, 'run_all_exploits_for_device'):
                app.root.run_all_exploits_for_device(self.ble_device)
                self.dismiss()

class BluetoothAppLayout(BoxLayout):
    """Main application layout - matches bluetooth.kv definition"""
    status_text = StringProperty("Bluetooth Manager Started")
    devices = ListProperty([])
    is_scanning = BooleanProperty(False)
    bluetooth_enabled = BooleanProperty(False)
    selected_device = None
    ble_devices = ListProperty([])
    ble_manager = ObjectProperty(None, allownone=True)
    debug_logger = ObjectProperty(None, allownone=True)
    mock_devices = ListProperty([])
    
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        # Initialize Bluetooth if available
        if BLUETOOTH_AVAILABLE:
            self.init_bluetooth()
        else:
            print("Warning: Bluetooth API not available. Using mock data.")
            self.add_mock_devices()
        
        # Initialize BLE Manager if available
        if BLE_MODULE_AVAILABLE:
            try:
                self.ble_manager = get_ble_manager()
                print("BLE Manager initialized successfully")
                self.ble_log("BLE Security Module Ready")
                
                # Initialize debug logger
                self.debug_logger = DebugLogger()
                self.debug_logger.set_callback(self.on_debug_log_update)
                self.debug_logger.info("main", "Debug logger initialized")
                
            except Exception as e:
                print(f"Error initializing BLE Manager: {str(e)}")
                self.ble_manager = None
        else:
            print("Warning: BLE Security Module not available")
    
    def init_bluetooth(self):
        """Initialize Bluetooth functionality"""
        try:
            # Check if Bluetooth is available on the device
            self.bluetooth_enabled = True  # This would be checked via plyer
            print("Bluetooth initialized")
        except Exception as e:
            print(f"Error initializing Bluetooth: {str(e)}")
            self.bluetooth_enabled = False
    
    def log(self, message):
        """Add message to status log - updates the status_log label in kv file"""
        print(f"LOG: {message}")
        # Update the status_log label in the kv file
        if hasattr(self, 'ids') and 'status_log' in self.ids:
            current_text = self.ids.status_log.text
            self.ids.status_log.text = f"{current_text}\n{message}"
    
    def ble_log(self, message):
        """Add message to BLE security log"""
        print(f"BLE LOG: {message}")
        # Update the ble_security_log label in the kv file
        if hasattr(self, 'ids') and 'ble_security_log' in self.ids:
            current_text = self.ids.ble_security_log.text
            self.ids.ble_security_log.text = f"{current_text}\n{message}"
    
    def clear_log(self):
        """Clear the status log"""
        if hasattr(self, 'ids') and 'status_log' in self.ids:
            self.ids.status_log.text = "Log cleared\n"
        print("Log cleared")
    
    def clear_ble_log(self):
        """Clear the BLE security log"""
        if hasattr(self, 'ids') and 'ble_security_log' in self.ids:
            self.ids.ble_security_log.text = "BLE Log cleared\n"
        print("BLE Log cleared")
    
    def add_mock_devices(self):
        """Add mock Bluetooth devices for testing and display them in UI"""
        mock_devices = [
            {"name": "Wireless Headphones", "address": "AA:BB:CC:11:22:33", "type": "Audio", "paired": True, "connected": True},
            {"name": "Smart Watch", "address": "DD:EE:FF:44:55:66", "type": "Wearable", "paired": True, "connected": False},
            {"name": "Car Audio", "address": "11:22:33:AA:BB:CC", "type": "Audio", "paired": False, "connected": False},
            {"name": "Keyboard", "address": "44:55:66:DD:EE:FF", "type": "HID", "paired": True, "connected": True},
            {"name": "Fitness Tracker", "address": "77:88:99:00:11:22", "type": "Wearable", "paired": False, "connected": False},
        ]
        
        for device_info in mock_devices:
            # Create device item widget
            device_item = BluetoothDeviceItem(device_info=device_info)
            
            # Add to devices list
            self.devices.append(device_info)
            
            # Add to UI if device_list exists
            if hasattr(self, 'ids') and 'device_list' in self.ids:
                self.ids.device_list.add_widget(device_item)
        
        self.log(f"Added {len(mock_devices)} mock devices to UI")
    
    def scan_devices(self):
        """Scan for nearby Bluetooth devices - called from kv file button"""
        self.log("Scanning for Bluetooth devices...")
        
        if BLUETOOTH_AVAILABLE:
            try:
                # Clear existing devices from the device_list GridLayout
                if hasattr(self, 'ids') and 'device_list' in self.ids:
                    self.ids.device_list.clear_widgets()
                
                # Clear devices list
                self.devices = []
                
                # Start scanning (this would use actual Bluetooth API)
                self.log("Bluetooth scanning started")
                # In a real app, you would use: bluetooth.start_scan()
                
                # Simulate finding devices
                Clock.schedule_once(self.simulate_scan_results, 2)
                
            except Exception as e:
                self.log(f"Error scanning: {str(e)}")
                self.add_mock_devices()
        else:
            self.log("Bluetooth not available - showing mock devices")
            self.add_mock_devices()
    
    def simulate_scan_results(self, dt):
        """Simulate finding Bluetooth devices"""
        self.log("Scan complete: Found 5 devices")
        
        # Add mock devices to the UI
        self.add_mock_devices()
    
    def connect_to_device(self, device_item):
        """Connect to selected device"""
        if device_item:
            self.log(f"Connecting to {device_item.device_name}...")
            device_item.is_connected = True
            self.selected_device = device_item
    
    def disconnect_device(self, device_item):
        """Disconnect from current device"""
        if device_item:
            self.log(f"Disconnecting from {device_item.device_name}...")
            device_item.is_connected = False
            if self.selected_device == device_item:
                self.selected_device = None
    
    def toggle_bluetooth(self):
        """Toggle Bluetooth on/off - called from kv file button"""
        self.log("Toggling Bluetooth...")
        self.bluetooth_enabled = not self.bluetooth_enabled
        
        if self.bluetooth_enabled:
            self.log("Bluetooth turned ON")
            # Initialize Bluetooth when turned on
            if BLUETOOTH_AVAILABLE:
                self.init_bluetooth()
        else:
            self.log("Bluetooth turned OFF")
            # Clear devices when Bluetooth is off
            if hasattr(self, 'ids') and 'device_list' in self.ids:
                self.ids.device_list.clear_widgets()
            self.devices = []
    
    def scan_ble_devices(self):
        """Scan for BLE devices - called from BLE Security Testing tab"""
        if not BLE_MODULE_AVAILABLE or not self.ble_manager:
            self.ble_log("BLE Security Module not available")
            return
        
        self.ble_log("Scanning for BLE devices...")
        
        # Clear existing BLE devices from UI
        if hasattr(self, 'ids') and 'ble_device_list' in self.ids:
            self.ids.ble_device_list.clear_widgets()
        
        # Clear BLE devices list
        self.ble_devices = []
        
        try:
            # Use BLE manager to scan for devices
            devices = self.ble_manager.scan_devices()
            
            # Add devices to UI
            for ble_device in devices:
                # Add to internal list
                self.ble_devices.append(ble_device)
                
                # Create UI widget
                device_item = BLEDeviceItem(ble_device=ble_device)
                
                # Add to UI
                if hasattr(self, 'ids') and 'ble_device_list' in self.ids:
                    self.ids.ble_device_list.add_widget(device_item)
            
            self.ble_log(f"Found {len(devices)} BLE devices")
            
            # Log device types
            apple_count = sum(1 for d in devices if d.device_type.value == "APPLE")
            android_count = sum(1 for d in devices if d.device_type.value == "ANDROID")
            self.ble_log(f"Apple devices: {apple_count}, Android devices: {android_count}")
            
        except Exception as e:
            self.ble_log(f"Error scanning BLE devices: {str(e)}")
    
    def index_ble_devices(self):
        """Index BLE devices by type - called from BLE Security Testing tab"""
        if not BLE_MODULE_AVAILABLE or not self.ble_manager:
            self.ble_log("BLE Security Module not available")
            return
        
        self.ble_log("Indexing BLE devices by type...")
        
        try:
            # Get device index from BLE manager
            device_index = self.ble_manager.scan_and_index_devices()
            
            # Clear existing index display
            if hasattr(self, 'ids') and 'device_index_display' in self.ids:
                self.ids.device_index_display.text = ""
            
            # Display device index
            index_text = "=== BLE DEVICE INDEX ===\n\n"
            
            for device_type, devices in device_index.items():
                if devices:
                    index_text += f"📱 {device_type.upper()} DEVICES ({len(devices)}):\n"
                    for device in devices:
                        exploits_count = len(device.get('exploits_available', []))
                        index_text += f"  • {device['name']} ({device['mac_address']})\n"
                        index_text += f"    Security: {device['security_level']} | Exploits: {exploits_count}\n"
                    index_text += "\n"
            
            # Update UI
            if hasattr(self, 'ids') and 'device_index_display' in self.ids:
                self.ids.device_index_display.text = index_text
            
            self.ble_log(f"Device index created with {len(device_index)} device types")
            
        except Exception as e:
            self.ble_log(f"Error indexing devices: {str(e)}")
    
    def show_exploits_for_device(self, ble_device):
        """Show available exploits for a BLE device"""
        if not BLE_MODULE_AVAILABLE or not self.ble_manager:
            self.ble_log("BLE Security Module not available")
            return
        
        try:
            # Create and show exploit popup
            exploit_popup = ExploitPopup(ble_device=ble_device)
            exploit_popup.open()
            
            self.ble_log(f"Showing exploits for {ble_device.name}")
            
        except Exception as e:
            self.ble_log(f"Error showing exploits: {str(e)}")
    
    def run_exploit_for_device(self, exploit, device_mac):
        """Run a specific exploit against a device"""
        if not BLE_MODULE_AVAILABLE or not self.ble_manager:
            self.ble_log("BLE Security Module not available")
            return
        
        try:
            # Find the device by MAC address
            target_device = None
            for device in self.ble_devices:
                if device.mac_address == device_mac:
                    target_device = device
                    break
            
            if not target_device:
                self.ble_log(f"Device with MAC {device_mac} not found")
                return
            
            self.ble_log(f"Running exploit: {exploit.name}")
            self.ble_log(f"Target: {target_device.name} ({target_device.mac_address})")
            self.ble_log(f"Severity: {exploit.severity.value}")
            
            # Execute the exploit
            result = self.ble_manager.execute_exploit(exploit, target_device)
            
            # Log the result
            if result.get('success', False):
                success_rate = result.get('success_rate', 0)
                self.ble_log(f"✅ Exploit successful! Success rate: {success_rate}%")
                self.ble_log(f"   Details: {result.get('message', 'No details')}")
            else:
                self.ble_log(f"❌ Exploit failed: {result.get('message', 'Unknown error')}")
            
        except Exception as e:
            self.ble_log(f"Error running exploit: {str(e)}")
    
    def run_all_exploits_for_device(self, ble_device):
        """Run all available exploits against a device"""
        if not BLE_MODULE_AVAILABLE or not self.ble_manager:
            self.ble_log("BLE Security Module not available")
            return
        
        try:
            self.ble_log(f"Running ALL exploits against {ble_device.name}...")
            
            # Get all exploits for this device
            exploits = self.ble_manager.get_exploits_for_device(ble_device)
            
            if not exploits:
                self.ble_log("No exploits available for this device")
                return
            
            self.ble_log(f"Found {len(exploits)} exploits to run")
            
            # Run each exploit
            successful = 0
            failed = 0
            
            for exploit in exploits:
                self.ble_log(f"Running: {exploit.name}...")
                
                result = self.ble_manager.execute_exploit(exploit, ble_device)
                
                if result.get('success', False):
                    successful += 1
                    success_rate = result.get('success_rate', 0)
                    self.ble_log(f"  ✅ Success ({success_rate}%): {exploit.name}")
                else:
                    failed += 1
                    self.ble_log(f"  ❌ Failed: {exploit.name}")
            
            # Summary
            self.ble_log(f"=== EXPLOIT SUMMARY ===")
            self.ble_log(f"Total exploits: {len(exploits)}")
            self.ble_log(f"Successful: {successful}")
            self.ble_log(f"Failed: {failed}")
            self.ble_log(f"Success rate: {(successful/len(exploits)*100):.1f}%")
            
        except Exception as e:
            self.ble_log(f"Error running all exploits: {str(e)}")
    
    def load_windows_exploits(self):
        """Load and display Windows-specific exploits in UI"""
        if not BLE_MODULE_AVAILABLE or not self.ble_manager:
            self.ble_log("BLE Security Module not available")
            return
        
        try:
            # Clear existing exploit buttons
            if hasattr(self, 'ids') and 'windows_exploits_grid' in self.ids:
                self.ids.windows_exploits_grid.clear_widgets()
            
            # Get Windows exploits from BLE manager
            windows_exploits = self.ble_manager.get_windows_device_exploits()
            self.debug_logger.info("main", f"Retrieved {len(windows_exploits)} Windows exploits")
            
            # Create exploit buttons for UI
            for exploit in windows_exploits:
                exploit_button = Button(
                    text=exploit.get('button_text', exploit.get('name', 'Unknown Exploit')),
                    size_hint_y=None,
                    height=60,
                    background_color=(0.8, 0.2, 0.2, 1) if exploit.get('severity') == 'CRITICAL' else 
                                    (0.8, 0.5, 0.2, 1) if exploit.get('severity') == 'HIGH' else 
                                    (0.8, 0.8, 0.2, 1) if exploit.get('severity') == 'MEDIUM' else 
                                    (0.2, 0.6, 0.8, 1),
                    font_size='14sp',
                    bold=True
                )
                
                # Bind button to run exploit
                exploit_name = exploit.get('name')
                exploit_button.bind(on_press=lambda btn, e_name=exploit_name: self.run_windows_exploit_ui(e_name))
                
                # Add to grid
                if hasattr(self, 'ids') and 'windows_exploits_grid' in self.ids:
                    self.ids.windows_exploits_grid.add_widget(exploit_button)
            
            # Update log
            log_text = f"Loaded {len(windows_exploits)} Windows exploits\n"
            for exploit in windows_exploits:
                log_text += f"• {exploit.get('name')} ({exploit.get('severity')})\n"
            
            if hasattr(self, 'ids') and 'windows_exploit_log' in self.ids:
                self.ids.windows_exploit_log.text = log_text
            
            self.ble_log(f"Loaded {len(windows_exploits)} Windows exploits")
            
        except Exception as e:
            self.debug_logger.error("main", f"Error loading Windows exploits: {str(e)}")
            if hasattr(self, 'ids') and 'windows_exploit_log' in self.ids:
                self.ids.windows_exploit_log.text = f"Error loading Windows exploits: {str(e)}"
    
    def clear_windows_exploits(self):
        """Clear Windows exploit display"""
        try:
            # Clear exploit buttons
            if hasattr(self, 'ids') and 'windows_exploits_grid' in self.ids:
                self.ids.windows_exploits_grid.clear_widgets()
            
            # Clear log
            if hasattr(self, 'ids') and 'windows_exploit_log' in self.ids:
                self.ids.windows_exploit_log.text = "Windows exploits cleared.\nClick 'Load Windows Exploits' to reload."
            
            self.debug_logger.info("main", "Cleared Windows exploits display")
            self.ble_log("Cleared Windows exploits display")
            
        except Exception as e:
            self.debug_logger.error("main", f"Error clearing Windows exploits: {str(e)}")
    
    def run_windows_exploit_ui(self, exploit_name):
        """Run Windows exploit from UI button"""
        # For now, we'll use a dummy MAC address since we need a target device
        # In a real implementation, you would select a Windows device first
        dummy_mac = "00:11:22:33:44:55"
        
        result = self.run_windows_exploit(exploit_name, dummy_mac)
        
        # Update log with result
        if result and result.get('success', False):
            log_msg = f"✅ {exploit_name}: Success\n"
        else:
            log_msg = f"❌ {exploit_name}: Failed\n"
        
        if hasattr(self, 'ids') and 'windows_exploit_log' in self.ids:
            current_log = self.ids.windows_exploit_log.text
            self.ids.windows_exploit_log.text = current_log + log_msg
    
    def get_windows_exploits(self):
        """Get Windows-specific exploits for UI display"""
        if not BLE_MODULE_AVAILABLE or not self.ble_manager:
            self.ble_log("BLE Security Module not available")
            return []
        
        try:
            # Get Windows exploits from BLE manager
            windows_exploits = self.ble_manager.get_windows_device_exploits()
            self.debug_logger.info("main", f"Retrieved {len(windows_exploits)} Windows exploits")
            return windows_exploits
        except Exception as e:
            self.debug_logger.error("main", f"Error getting Windows exploits: {str(e)}")
            return []
    
    def create_mock_device(self, device_type_str, device_name="Mock Device"):
        """Create a mock Bluetooth/BLE device with GATT services"""
        if not BLE_MODULE_AVAILABLE:
            self.ble_log("BLE Security Module not available")
            return None
        
        try:
            # Convert string to DeviceType enum
            device_type = None
            for dt in DeviceType:
                if dt.value.upper() == device_type_str.upper():
                    device_type = dt
                    break
            
            if not device_type:
                self.debug_logger.error("main", f"Invalid device type: {device_type_str}")
                return None
            
            # Create mock device
            mock_device = MockBLEDevice(
                name=device_name,
                device_type=device_type,
                mac_address=self._generate_mock_mac()
            )
            
            # Add to mock devices list
            self.mock_devices.append(mock_device)
            
            # Log creation
            self.debug_logger.info("main", f"Created mock {device_type.value} device: {device_name}")
            self.ble_log(f"Created mock {device_type.value} device: {device_name}")
            
            # Add to UI if available
            if hasattr(self, 'ids') and 'mock_device_list' in self.ids:
                # Create UI widget for mock device
                from kivy.uix.label import Label
                device_label = Label(
                    text=f"{device_name} ({device_type.value}) - {mock_device.mac_address}",
                    size_hint_y=None,
                    height=40
                )
                self.ids.mock_device_list.add_widget(device_label)
            
            return mock_device
            
        except Exception as e:
            self.debug_logger.error("main", f"Error creating mock device: {str(e)}")
            return None
    
    def _generate_mock_mac(self):
        """Generate a random MAC address for mock devices"""
        import random
        mac_parts = []
        for i in range(6):
            mac_parts.append(f"{random.randint(0, 255):02x}")
        return ":".join(mac_parts).upper()
    
    def connect_to_mock_device(self, mock_device):
        """Connect to a mock BLE device"""
        if not mock_device:
            return False
        
        try:
            # Connect to mock device
            mock_device.connect()
            self.debug_logger.info("main", f"Connected to mock device: {mock_device.name}")
            self.ble_log(f"Connected to mock device: {mock_device.name}")
            
            # Log GATT services
            services = mock_device.get_services()
            self.debug_logger.debug("main", f"Device has {len(services)} GATT services")
            
            return True
        except Exception as e:
            self.debug_logger.error("main", f"Error connecting to mock device: {str(e)}")
            return False
    
    def disconnect_from_mock_device(self, mock_device):
        """Disconnect from a mock BLE device"""
        if not mock_device:
            return False
        
        try:
            mock_device.disconnect()
            self.debug_logger.info("main", f"Disconnected from mock device: {mock_device.name}")
            self.ble_log(f"Disconnected from mock device: {mock_device.name}")
            return True
        except Exception as e:
            self.debug_logger.error("main", f"Error disconnecting from mock device: {str(e)}")
            return False
    
    def get_mock_device_services(self, mock_device):
        """Get GATT services from a mock device"""
        if not mock_device:
            return []
        
        try:
            services = mock_device.get_services()
            service_list = []
            
            for service in services:
                service_dict = {
                    "uuid": service.uuid,
                    "name": service.name,
                    "characteristics": []
                }
                
                for char in service.characteristics:
                    char_dict = {
                        "uuid": char.uuid,
                        "name": char.name,
                        "properties": char.properties,
                        "value": char.value
                    }
                    service_dict["characteristics"].append(char_dict)
                
                service_list.append(service_dict)
            
            return service_list
        except Exception as e:
            self.debug_logger.error("main", f"Error getting device services: {str(e)}")
            return []
    
    def on_debug_log_update(self, log_entry):
        """Callback for debug logger updates - updates UI"""
        if hasattr(self, 'ids') and 'debug_log_display' in self.ids:
            # Format log entry for display
            log_text = f"[{log_entry.timestamp}] {log_entry.level}: {log_entry.module} - {log_entry.message}"
            
            # Add to debug log display
            current_text = self.ids.debug_log_display.text
            self.ids.debug_log_display.text = f"{current_text}\n{log_text}"
            
            # Auto-scroll to bottom
            if hasattr(self.ids.debug_log_display, 'scroll_y'):
                self.ids.debug_log_display.scroll_y = 0
    
    def clear_debug_log(self):
        """Clear the debug log display"""
        if hasattr(self, 'ids') and 'debug_log_display' in self.ids:
            self.ids.debug_log_display.text = "Debug Log:\n"
            self.debug_logger.info("main", "Debug log cleared")
    
    def set_debug_log_level(self, level_str):
        """Set debug log level filter"""
        if not self.debug_logger:
            return
        
        try:
            level = DebugLogLevel[level_str.upper()]
            self.debug_logger.set_level_filter(level)
            self.debug_logger.info("main", f"Debug log level set to: {level_str}")
            self.ble_log(f"Debug log level set to: {level_str}")
        except KeyError:
            self.debug_logger.error("main", f"Invalid debug log level: {level_str}")
    
    def run_windows_exploit(self, exploit_name, device_mac):
        """Run a Windows-specific exploit"""
        if not BLE_MODULE_AVAILABLE or not self.ble_manager:
            self.ble_log("BLE Security Module not available")
            return None
        
        try:
            # Find the device by MAC address
            target_device = None
            for device in self.ble_devices:
                if device.mac_address == device_mac and device.device_type == DeviceType.WINDOWS:
                    target_device = device
                    break
            
            if not target_device:
                self.ble_log(f"Windows device with MAC {device_mac} not found")
                return None
            
            # Get Windows exploits
            windows_exploits = self.ble_manager.get_windows_device_exploits()
            exploit = next((e for e in windows_exploits if e['name'] == exploit_name), None)
            
            if not exploit:
                self.ble_log(f"Windows exploit {exploit_name} not found")
                return None
            
            # Run the exploit
            self.debug_logger.info("main", f"Running Windows exploit: {exploit_name}")
            result = self.ble_manager.run_exploit_on_device(exploit_name, device_mac)
            
            # Log result
            if result.get('success', False):
                self.debug_logger.info("main", f"Windows exploit successful: {exploit_name}")
                self.ble_log(f"✅ Windows exploit successful: {exploit_name}")
            else:
                self.debug_logger.warning("main", f"Windows exploit failed: {exploit_name}")
                self.ble_log(f"❌ Windows exploit failed: {exploit_name}")
            
            return result
            
        except Exception as e:
            self.debug_logger.error("main", f"Error running Windows exploit: {str(e)}")
            return None
    
    def clear_mock_devices(self):
        """Clear mock devices display"""
        try:
            # Clear mock devices list
            self.mock_devices.clear()
            
            # Clear UI display
            if hasattr(self, 'ids') and 'mock_devices_grid' in self.ids:
                self.ids.mock_devices_grid.clear_widgets()
            
            # Clear log
            if hasattr(self, 'ids') and 'mock_device_log' in self.ids:
                self.ids.mock_device_log.text = "Mock devices cleared.\nUse 'Create Mock Device' to add new devices."
            
            self.debug_logger.info("main", "Cleared mock devices")
            self.ble_log("Cleared mock devices")
            
        except Exception as e:
            self.debug_logger.error("main", f"Error clearing mock devices: {str(e)}")
    
    def refresh_debug_log(self):
        """Refresh debug log display"""
        if not self.debug_logger:
            self.ble_log("Debug logger not available")
            return
        
        try:
            # Get all log entries
            log_entries = self.debug_logger.get_log_entries()
            
            # Clear existing display
            if hasattr(self, 'ids') and 'debug_log_grid' in self.ids:
                self.ids.debug_log_grid.clear_widgets()
            
            # Add log entries to UI
            for entry in log_entries:
                # Create log entry widget
                from kivy.uix.label import Label
                
                # Color code based on log level
                color = (0.7, 0.7, 0.7, 1)  # Default gray for DEBUG
                if entry.level == DebugLogLevel.INFO:
                    color = (0.2, 0.6, 0.8, 1)  # Blue
                elif entry.level == DebugLogLevel.WARNING:
                    color = (0.8, 0.8, 0.2, 1)  # Yellow
                elif entry.level == DebugLogLevel.ERROR:
                    color = (0.8, 0.5, 0.2, 1)  # Orange
                elif entry.level == DebugLogLevel.CRITICAL:
                    color = (0.8, 0.2, 0.2, 1)  # Red
                
                log_label = Label(
                    text=f"[{entry.timestamp}] {entry.level.name}: {entry.module} - {entry.message}",
                    size_hint_y=None,
                    height=30,
                    color=color,
                    font_size='12sp',
                    halign='left',
                    text_size=(800, None)
                )
                
                # Add to grid
                if hasattr(self, 'ids') and 'debug_log_grid' in self.ids:
                    self.ids.debug_log_grid.add_widget(log_label)
            
            # Update status
            if hasattr(self, 'ids') and 'debug_log_status' in self.ids:
                self.ids.debug_log_status.text = f"Log refreshed: {len(log_entries)} entries"
            
            self.debug_logger.info("main", f"Debug log refreshed: {len(log_entries)} entries")
            
        except Exception as e:
            self.debug_logger.error("main", f"Error refreshing debug log: {str(e)}")
            if hasattr(self, 'ids') and 'debug_log_status' in self.ids:
                self.ids.debug_log_status.text = f"Error: {str(e)}"
    
    def export_debug_log(self):
        """Export debug log to file"""
        if not self.debug_logger:
            self.ble_log("Debug logger not available")
            return
        
        try:
            # Get all log entries
            log_entries = self.debug_logger.get_log_entries()
            
            if not log_entries:
                self.ble_log("No log entries to export")
                return
            
            # Create export filename with timestamp
            import datetime
            timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
            filename = f"/sdcard/Download/debug_log_{timestamp}.txt"
            
            # Write log entries to file
            with open(filename, 'w') as f:
                f.write("=== DEBUG LOG EXPORT ===\n")
                f.write(f"Export time: {datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")
                f.write(f"Total entries: {len(log_entries)}\n")
                f.write("=" * 40 + "\n\n")
                
                for entry in log_entries:
                    f.write(f"[{entry.timestamp}] {entry.level.name}: {entry.module} - {entry.message}\n")
                    if entry.data:
                        f.write(f"    Data: {entry.data}\n")
            
            # Update UI
            if hasattr(self, 'ids') and 'debug_log_status' in self.ids:
                self.ids.debug_log_status.text = f"Log exported to: {filename}"
            
            self.debug_logger.info("main", f"Debug log exported to: {filename}")
            self.ble_log(f"✅ Debug log exported to: {filename}")
            
        except Exception as e:
            self.debug_logger.error("main", f"Error exporting debug log: {str(e)}")
            if hasattr(self, 'ids') and 'debug_log_status' in self.ids:
                self.ids.debug_log_status.text = f"Export error: {str(e)}"

class BluetoothApp(App):
    """Main application class"""
    def build(self):
        self.title = "Android Bluetooth Manager"
        return BluetoothAppLayout()
    
    def on_start(self):
        """Called when the app starts"""
        print("Bluetooth App started")
        # Add initial mock devices when app starts
        if self.root:
            self.root.add_mock_devices()
    
    def on_stop(self):
        """Called when the app stops"""
        print("Bluetooth App stopped")
        # Clean up Bluetooth resources if needed
        if BLUETOOTH_AVAILABLE:
            print("Cleaning up Bluetooth resources...")

if __name__ == "__main__":
    print("Starting Android Bluetooth App...")
    print(f"Bluetooth available: {BLUETOOTH_AVAILABLE}")
    
    # Check Android permissions
    if BLUETOOTH_AVAILABLE:
        print("Note: On Android, you need to request Bluetooth permissions")
        print("Add these to your AndroidManifest.xml:")
        print("  <uses-permission android:name=\"android.permission.BLUETOOTH\" />")
        print("  <uses-permission android:name=\"android.permission.BLUETOOTH_ADMIN\" />")
        print("  <uses-permission android:name=\"android.permission.ACCESS_FINE_LOCATION\" />")
    
    BluetoothApp().run()
