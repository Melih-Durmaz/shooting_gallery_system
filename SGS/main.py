import sgs
import sys

def main() :
    gui = sgs.GUI(sys.argv)

    gui.tabs.show()

    sys.exit(gui.exec_())


if (__name__ == '__main__') :
    main()