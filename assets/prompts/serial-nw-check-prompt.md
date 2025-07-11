Your task is to check the FortiOS version on a Fortinet device connected via a serial interface. Specifically, you must:

- Connect to the device using serial communication,  
  following the target device’s default serial settings (e.g., baud rate),  
  but you may ask the user for settings like baud rate if necessary.

- Retrieve the current FortiOS version installed,  
- Obtain the latest FortiOS version from the official Fortinet website (https://www.fortinet.com/products/fortigate/fortios),  
- Compare the device's version with the latest available version,  
- Report whether the device's FortiOS is up to date or requires an update.

You must interact with the user step-by-step, requesting any necessary information **only when needed**, not all at once.

---

## Available Tools

- **#serial-open**  
- **#serial-message**  
- **#serial-close**  

