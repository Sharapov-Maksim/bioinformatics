import fileinput
import sys

for line in fileinput.input(files=(sys.argv[1]), encoding="utf-8"):

    if "mapped (" in line:
        spl = line.split("(", 1)
        res = float(spl[1][0:5])
        if res > 90.0:
            print ("OK")
        else:
            print ("not OK")
        break