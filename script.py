import os
import random
import time

try:
    import pyautogui
except ImportError:
    os.system("pip install pyautogui")
    import pyautogui

# Récupérer la résolution de l'écran
screenWidth, screenHeight = pyautogui.size()

while True:
    # Obtenir la position actuelle de la souris
    currentMouseX, currentMouseY = pyautogui.position()
    
    # Calculer les nouveaux offsets tout en s'assurant que la souris reste à l'intérieur des limites de l'écran
    x_offset = random.randint(-250, 250)
    y_offset = random.randint(-250, 250)
    
    new_x = min(max(currentMouseX + x_offset, 0), screenWidth - 1)
    new_y = min(max(currentMouseY + y_offset, 0), screenHeight - 1)
    
    # Déplacer la souris
    pyautogui.moveTo(new_x, new_y, duration=0.01)
    #time.sleep(0.10)  # Délai de 1 seconde
