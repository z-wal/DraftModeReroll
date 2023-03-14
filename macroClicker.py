import pyautogui
import time

constantDelay = 1.00


def main():
    pyautogui.FAILSAFE = True

    pyautogui.press("1")

    time.sleep(3)

    main()

if __name__ == "__main__":
    print("Starting")
    for i in range(0, 5):
        print("Starting in: " + str(5-i))
        time.sleep(1)
    print("rolling")

    main()