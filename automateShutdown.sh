#!/bin/bash

echo "#!/usr/bin/env python3" >> /home/shutdown.py
echo " " >> /home/shutdown.py
echo "#Script Name: shutdown.py" >> /home/shutdown.py
echo "#Script Location: /home" >> /home/shutdown.py
echo "#Author: That Dead Guy" >> /home/shutdown.py
echo "#Editor: n/a" >> /home/shutdown.py
echo "#Version: 0.3" >> /home/shutdown.py
echo "		#version 0.3 changed the flash function to use a for loop to shrink code" >> /home/shutdown.py
echo "		#version 0.2 broke out the flash routine to reduce code size, added LED control logic inversion" >> /home/shutdown.py
echo "		#version 0.1 initial creation" >> /home/shutdown.py
echo "#Release Date: Dec 6, 2019" >> /home/shutdown.py
echo " " >> /home/shutdown.py
echo "#This script creates three status LEDs Red=Shutting down; " >> /home/shutdown.py
echo "#Yellow=Rebooting, Green=Up and Running. It also creates reboot and " >> /home/shutdown.py
echo "#shutdown buttons for terminal-less control preventing card corrpution" >> /home/shutdown.py
echo "" >> /home/shutdown.py
echo "# import all important libraries" >> /home/shutdown.py
echo "from gpiozero import Button" >> /home/shutdown.py
echo "from signal import pause" >> /home/shutdown.py
echo "import RPi.GPIO as GPIO" >> /home/shutdown.py
echo "GPIO.setmode(GPIO.BCM)" >> /home/shutdown.py
echo "import os, sys" >> /home/shutdown.py
echo "import time" >> /home/shutdown.py
echo "" >> /home/shutdown.py
echo "normalLogic = 1	#allows us to switch the on/off command for lights" >> /home/shutdown.py
echo "On = 1				#default on= 1 for normal logic" >> /home/shutdown.py
echo "Off = 0				#default off=0 for normal logic" >> /home/shutdown.py
echo "red = 19			#red LED control pin on GPIO 19/board pin 35" >> /home/shutdown.py
echo "yellow = 16		#yellow LED control pin on GPIO 16/board pin 36" >> /home/shutdown.py
echo "green = 26		#green LED control pin on GPIO 26/board pin 37" >> /home/shutdown.py
echo "btnShutdown = 21	#Shut down button input pin on GPIO 21/board pin 40" >> /home/shutdown.py
echo "btnReboot = 20	#Reboot button input pin on GPIO 20/board pin 38" >> /home/shutdown.py
echo "" >> /home/shutdown.py
echo "flashTime = 0.5" >> /home/shutdown.py
echo "if normalLogic == 0:	#If we need to use reverse logic for the LEDs" >> /home/shutdown.py
echo "	On = 0			#reverse the on and off state numbers" >> /home/shutdown.py
echo "	Off = 1" >> /home/shutdown.py
echo "" >> /home/shutdown.py
echo "#print('pin setup')	#simplistic terminal debug" >> /home/shutdown.py
echo "GPIO.setup(red, GPIO.OUT)" >> /home/shutdown.py
echo "GPIO.output(red,Off)" >> /home/shutdown.py
echo "GPIO.setup(yellow, GPIO.OUT)" >> /home/shutdown.py
echo "GPIO.output(yellow,Off)" >> /home/shutdown.py
echo "GPIO.setup(green, GPIO.OUT)" >> /home/shutdown.py
echo "GPIO.output(green,On)" >> /home/shutdown.py
echo "" >> /home/shutdown.py
echo "holdTime = int(3) #hold button for 3 seconds" >> /home/shutdown.py
echo "" >> /home/shutdown.py
echo "#Flash function will flicker a certain LED while turning off the green" >> /home/shutdown.py
echo "#LED. This requires the variable name of the LED control pin to be " >> /home/shutdown.py
echo "#passed in to the function (light=red, yellow or green)" >> /home/shutdown.py
echo "def flash(light):" >> /home/shutdown.py
echo "	#print('Flash:', light) #simplistic terminal debug" >> /home/shutdown.py
echo "	GPIO.output(green, Off)" >> /home/shutdown.py
echo "	for x in range(1, 10):" >> /home/shutdown.py
echo "		GPIO.output(light, On)" >> /home/shutdown.py
echo "		time.sleep(flashTime)" >> /home/shutdown.py
echo "		GPIO.output(light, Off)" >> /home/shutdown.py
echo "		time.sleep(flashTime)" >> /home/shutdown.py
echo "		flashTime = flashTime - 0.05" >> /home/shutdown.py
echo "" >> /home/shutdown.py
echo "#reboot will call Flash(yellow) then clear out the GPIO stack and issue" >> /home/shutdown.py
echo "#the reboot command	" >> /home/shutdown.py
echo "def reboot():" >> /home/shutdown.py
echo "	flash(light=yellow);" >> /home/shutdown.py
echo "	#print('reboot') #simplistic terminal debug" >> /home/shutdown.py
echo "	GPIO.cleanup()" >> /home/shutdown.py
echo '	os.system("sudo reboot")' >> /home/shutdown.py
echo "" >> /home/shutdown.py
echo "#shutdown will call Flash(red) then clear out the GPIO stack and issue" >> /home/shutdown.py
echo "#the shutdown command	" >> /home/shutdown.py
echo "def shutdown():" >> /home/shutdown.py
echo "	flash(light=red)" >> /home/shutdown.py
echo "	#print('shutdown') #simplistic terminal debug" >> /home/shutdown.py
echo "	GPIO.cleanup()" >> /home/shutdown.py
echo '	os.system("sudo poweroff")' >> /home/shutdown.py
echo "" >> /home/shutdown.py
echo "#the script" >> /home/shutdown.py
echo "#print('script') #simplistic terminal debug" >> /home/shutdown.py
echo "pwroff = Button(btnShutdown, hold_time=holdTime)" >> /home/shutdown.py
echo "#print('script power off') #simplistic terminal debug" >> /home/shutdown.py
echo "rst = Button(btnReboot, hold_time=holdTime)" >> /home/shutdown.py
echo "#print('script reboot') #simplistic terminal debug" >> /home/shutdown.py
echo "pwroff.when_held = shutdown" >> /home/shutdown.py
echo "rst.when_held = reboot" >> /home/shutdown.py
echo "#print('script end') #simplistic terminal debug" >> /home/shutdown.py
echo "pause()" >> /home/shutdown.py

chmod +x /home/shutdown.py

echo "[Unit]" >> /lib/systemd/system/shutdown.service
echo "Description=Off Program" >> /lib/systemd/system/shutdown.service
echo " " >> /lib/systemd/system/shutdown.service
echo "[Service]" >> /lib/systemd/system/shutdown.service
echo "ExecStart=/home/shutdown.py StandardOutput=null" >> /lib/systemd/system/shutdown.service
echo " " >> /lib/systemd/system/shutdown.service
echo "[Install]" >> /lib/systemd/system/shutdown.service
echo "WantedBy=multi-user.target Alias=shutdown.service" >> /lib/systemd/system/shutdown.service

systemctl start shutdown.service
systemctl enable shutdown.service
systemctl is-enabled shutdown.service
