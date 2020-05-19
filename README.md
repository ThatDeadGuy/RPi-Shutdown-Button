# RPi-Shutdown-Button
Author: ThatDeadGuy

Based on work by:

    Tony L Hansen: https://github.com/TonyLHansen/raspberry-pi-safe-off-switch
    
    chuck-finley : https://www.instructables.com/id/Raspberry-Pi-Hardware-Reset-and-Shutdown-Buttons/



Shutdown and restart buttons with indicator lights for use on Raspberry Pi boards.

The python script can be modified as desired. Currently it provides support for both positive and negative logic for the output of the lights. 

NOTE: The shell script needs to be run as root or with sudo rights
The bash shell script will automatically generate the python script in the /home folder and make the necessary system file changes to register it as a service and enable it to run at boot up.

The buttons short to ground. LEDs can have either common annode or cathode based on the positive or negative logic needed.

TODO:

    Better Documentation 
    
         Circuit Diagram
         
         Shell Notes
