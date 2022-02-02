import RPi.GPIO as GPIO # Import Raspberry Pi GPIO library

def button_callback(channel):
    print("Button was pushed!")

GPIO.setwarnings(False)
GPIO.setmode(GPIO.BCM)
GPIO.setup(16, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)

GPIO.add_event_detect(16,GPIO.RISING,callback=button_callback)

message = input("Press enter to quit\n\n") # Run until someone presses enter
GPIO.cleanup() # Clean up

# while True: # Run forever
#     if GPIO.input(16) == GPIO.HIGH:
#         print("Button was pushed!")