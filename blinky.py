import board
import terminalio
import displayio
import RPi.GPIO as GPIO
from adafruit_display_text import label
from adafruit_st7789 import ST7789

def drawColor(rgb, splash):
    color_bitmap = displayio.Bitmap(280, 240, 1)
    color_palette = displayio.Palette(1)
    color_palette[0] = rgb 

    bg_sprite = displayio.TileGrid(color_bitmap, pixel_shader=color_palette, x=0, y=0)
    splash.append(bg_sprite)

def drawText(string, splash, x, color):
    text_group = displayio.Group(scale=3, x=x, y=120)
    text_area = label.Label(terminalio.FONT, text=string, color=color)
    text_group.append(text_area)  # Subgroup for text scaling
    splash.append(text_group)

def drawBlinky(splash):
    drawColor(0x0a0612, splash)

    # Draw a label
    text_group = displayio.Group(scale=2, x=0, y=0)
    text = """           .'|_.-
         .'  '  /_
      .-"    -.   '>
   .- -. -.    '. /    /|_
  .-.--.-.       ' >  /  /
 (o( o( o )       \\_."  <
  '-'-''-'            ) <
(       _.-'-.   ._\\.  _\\
 '----"/--.__.-) _-  \\|
       "V""    "V""
    """
    text_area = label.Label(terminalio.FONT, text=text, color=0xFFFF00)
    text_group.append(text_area)  # Subgroup for text scaling
    splash.append(text_group)

blink = bool(True)
displayio.release_displays()

spi = board.SPI()
tft_cs = board.CE0
tft_dc = board.D21

display_bus = displayio.FourWire(
    spi, command=tft_dc, chip_select=tft_cs, reset=board.D14
)
display = ST7789(display_bus, width=280, height=240, rowstart=20, rotation=90)
def button_callback(channel):
    global blink 
    splash = displayio.Group()
    display.show(splash)

    if blink:
        blink=False
        # drawBlinky(splash)
        drawColor(0x0000FF, splash)
        drawText("BLUE", splash, 40,0xFFFF00)
    else:
        blink=True
        drawColor(0xFF0000, splash)
        drawText("orange", splash, 140, 0x00FFFF)

GPIO.setwarnings(False)
GPIO.setmode(GPIO.BCM)
GPIO.setup(16, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)
GPIO.add_event_detect(16,GPIO.RISING,callback=button_callback)

message = input("Press enter to quit\n\n") # Run until someone presses enter
GPIO.cleanup() # Clean up
