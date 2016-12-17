import gui
import sys
import db

def main() :
    g = gui.GUI(sys.argv)

    g.tabs.show()

    sys.exit(g.exec_())


if (__name__ == '__main__') :
    main()