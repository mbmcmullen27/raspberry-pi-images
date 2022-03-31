import sys
import time
import board
import terminalio
import displayio
from adafruit_display_text import label
from adafruit_st7789 import ST7789

def drawColor(rgb, splash):
    color_bitmap = displayio.Bitmap(280, 240, 1)
    color_palette = displayio.Palette(1)
    color_palette[0] = rgb 

    bg_sprite = displayio.TileGrid(color_bitmap, pixel_shader=color_palette, x=0, y=0)
    splash.append(bg_sprite)

def drawText(string, splash, x, y, color):
    text_group = displayio.Group(scale=3, x=x, y=y)
    text_area = label.Label(terminalio.FONT, text=string, color=color)
    text_group.append(text_area)  # Subgroup for text scaling
    splash.append(text_group)

def setupDisplay():
    displayio.release_displays()

    spi = board.SPI()
    tft_cs = board.CE0
    tft_dc = board.D6

    display_bus = displayio.FourWire(
        spi, command=tft_dc, chip_select=tft_cs, reset=board.D5
    )
    return ST7789(display_bus, width=280, height=240, rowstart=20, rotation=90)

if __name__ == "__main__":
    display = setupDisplay()
    splash = displayio.Group()
    display.show(splash)
    drawColor(0x0000FF, splash)
    for i in range(1, len(sys.argv)):
        drawText(sys.argv[i], splash, 40, 30*i, 0xFFFF00)

    time.sleep(1)
    
