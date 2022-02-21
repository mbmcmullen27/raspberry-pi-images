import os

import board
import sdcardio
import storage

sd = sdcardio.SDCard(board.SPI(), board.CE1)
vfs = storage.VfsFat(sd)
storage.mount(vfs, '/sd')
os.listdir('/sd')