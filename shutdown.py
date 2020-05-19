#!/usr/bin/env python3

#Script Name: shutdown.py
#Script Location: /home
#Author: That Dead Guy
#Editor: n/a
#Version: 0.3
	#version 0.3 changed the flash function to use a for loop to shrink code
	#version 0.2 broke out the flash routine to reduce code size, added LED control logic inversion
	#version 0.1 initial creation
#Release Date: Dec 6, 2019

#This script creates three status LEDs Red=Shutting down; 
#Yellow=Rebooting, Green=Up and Running. It also creates reboot and 
#shutdown buttons for terminal-less control preventing card corrpution

# import all important libraries
from gpiozero import Button
from signal import pause
import RPi.GPIO as GPIO
GPIO.setmode(GPIO.BCM)
import os, sys
import time

normalLogic = 1		#allows us to switch the on/off command for lights
On = 1				#default on= 1 for normal logic
Off = 0				#default off=0 for normal logic
red = 19			#red LED control pin on GPIO 19/board pin 35
yellow = 16			#yellow LED control pin on GPIO 16/board pin 36
green = 26			#green LED control pin on GPIO 26/board pin 37
btnShutdown = 21	#Shut down button input pin on GPIO 21/board pin 40
btnReboot = 20		#Reboot button input pin on GPIO 20/board pin 38

if normalLogic == 0:	#If we need to use reverse logic for the LEDs
	On = 0			#reverse the on and off state numbers
	Off = 1
	
#print('pin setup')	#simplistic terminal debug
GPIO.setup(red, GPIO.OUT)
GPIO.output(red,Off)
GPIO.setup(yellow, GPIO.OUT)
GPIO.output(yellow,Off)
GPIO.setup(green, GPIO.OUT)
GPIO.output(green,On)

holdTime = int(3) #hold button for 3 seconds

#Flash function will flicker a certain LED while turning off the green
#LED. This requires the variable name of the LED control pin to be 
#passed in to the function (light=red, yellow or green)
def flash(light):
	#print('Flash:', light) #simplistic terminal debug
	GPIO.output(green, Off)
	for x in range(1, 10):
		GPIO.output(light, On)
		time.sleep(0.1)
		GPIO.output(light, Off)
		time.sleep(0.1)


#reboot will call Flash(yellow) then clear out the GPIO stack and issue
#the reboot command	
def reboot():
	flash(light=yellow);
	#print('reboot') #simplistic terminal debug
	GPIO.cleanup()
	os.system("sudo reboot")

#shutdown will call Flash(red) then clear out the GPIO stack and issue
#the shutdown command	
def shutdown():
	flash(light=red)
	#print('shutdown') #simplistic terminal debug
	GPIO.cleanup()
	os.system("sudo poweroff")
	
	
#the script
#print('script') #simplistic terminal debug
pwroff = Button(btnShutdown, hold_time=holdTime)
#print('script power off') #simplistic terminal debug
rst = Button(btnReboot, hold_time=holdTime)
#print('script reboot') #simplistic terminal debug
pwroff.when_held = shutdown
rst.when_held = reboot
#print('script end') #simplistic terminal debug
pause()
