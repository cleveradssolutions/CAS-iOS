import os
import sys
import json
from datetime import date

def toUniqueLine(line):
    line = line.strip()
    if not line or not line.startswith('<string>'):
        return ""
    line = line.lower()
    return line[line.find('<string>')+len('<string>'):line.rfind('</string>')]

rootDir = os.path.dirname(os.path.abspath(__file__))
uniqueSet = set()
duplicate = 0

forceGenerate = "--force" in sys.argv

if not os.path.exists(rootDir + "/TempUpdate.txt"):
    open(rootDir + "/TempUpdate.txt", 'w').close()
    print("File created: " + rootDir + "/TempUpdate.txt")
    exit()

with open(rootDir + "/SKAdNetworkItems.xml", 'r') as sourceFile:
    for line in sourceFile:
        line = toUniqueLine(line)
        if not line:
            continue
        if line in uniqueSet:
            duplicate += 1
            print("Duplicate in source: " + line[:-1])
        elif not forceGenerate:
            uniqueSet.add(line)

sourcesCount = len(uniqueSet)
with open(rootDir + "/TempUpdate.txt", 'r') as updateFile:
    updateCount = 0
    for line in updateFile:
        line = toUniqueLine(line)
        if not line:
            continue
        updateCount += 1
        if line not in uniqueSet:
            if not forceGenerate:
                print("New identifier:\n" + line)
            uniqueSet.add(line)

if sourcesCount < len(uniqueSet) or duplicate > 0:
    userSelect = 'y' if forceGenerate else raw_input("Write Y when you want update sources or N to exit: ")

    if userSelect.lower() == 'y':
        with open(rootDir + "/SKAdNetworkItems.xml", 'w') as sourceFile:
            sourceFile.write('<plist version="1.0">\n')
            sourceFile.write('    <key>SKAdNetworkItems</key>\n')
            sourceFile.write('    <array>\n')
            for line in uniqueSet:
                sourceFile.write('        <dict>\n')
                sourceFile.write('            <key>SKAdNetworkIdentifier</key>\n')
                sourceFile.write('            <string>')
                sourceFile.write(line)
                sourceFile.write('</string>\n')
                sourceFile.write('        </dict>\n')
            sourceFile.write('    </array>\n')
            sourceFile.write('</plist>\n')
        currentDate = date.today().strftime("%b %d, %Y")
        print("Updated total " + str(len(uniqueSet)) + " identifiers at " + currentDate)
        shiledInfo = {
            "schemaVersion": 1,
            "label": "SKAdNetworks",
            "message": currentDate,
            "color": "green"
        }

        with open(rootDir + "/SKAdNetowrksShield.json", "w") as shiledFile:
            json.dump(shiledInfo, shiledFile)
    else:
        print("No new identifiers found. ")





