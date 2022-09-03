from osproc import execProcess
import strutils, os, re

type
    PackageManager* = enum
        # Windows
        choco = (0, "choco.exe")
        # Linux
        dpkg,
        yum,
        rpm,
        pacman,
        dnf,
        apt,
        # MacOSX
        brew

const WindowsPackageManagers* = @[choco]
const LinuxPackageManagers* = @[dpkg, yum, rpm, pacman, dnf, apt]
const MacOSXManagers* = @[brew]

proc runCommand(cmd : string): string = 
    ## Run a command and return result.
    when defined(nimscript): gorge(cmd) else: execProcess(cmd)

proc getPackageList(): string =
    ## Get list of installed package.
    ## The function find what package manager is installed and use it to get the list.
    when defined(windows):
        if findExe($choco) != "":
            result = runCommand($choco & " list --local-only")
    elif defined(linux):
        if findExe($dpkg) != "":
            result = runCommand($dpkg & " --list").replace("ii  ")
        elif findExe($yum) != "":
            result = runCommand($yum & " list installed")
        elif findExe($rpm) != "":
            result = runCommand($rpm & " -qa")
        elif findExe($pacman) != "":
            result = runCommand($pacman & " -Q")
        elif findExe($dnf) != "":
            result = runCommand($dnf & " list installed")   
        elif findExe($apt) != "":
            result = runCommand($apt & " list --installed")
    elif defined(macosx):
        if findExe($brew) != "":
            result = runCommand($brew & " list")

template checkPackTemplate(package, checkFunction: untyped) =
    ## Template to check if a package is installed.
    ## `package` the package name.
    ## `checkFunction` the function to check.
    let packageList = splitLines(getPackageList())
    result = false
    for line in packageList:
        if checkFunction(line, package):
            result = true
            break

template checkPacksTemplate(packages, checkFunction: untyped) =
    ## Template to check if a package is installed.
    ## `packages` the list of package name.
    ## `checkFunction` the function to check.
    var currentPackageFound = false
    let packageList = splitLines(getPackageList())
    result = @[]
    for package in packages:
        currentPackageFound = false
        for line in packageList:
            if checkFunction(line, package):
                currentPackageFound = true
                break

        # Package not found
        if not currentPackageFound:
            result.add(package)

proc checkPack*(packagePattern: Regex): bool =
    ## Returns true if the pattern 'packagePattern' is find in the installed packages list.
    checkPackTemplate(packagePattern, re.contains)

proc checkPack*(packageName: string): bool =
    ## Returns true if the package 'packageName' is installed.
    checkPackTemplate(packageName, strutils.contains)

proc checkPacks*(packageName: seq[string]): seq[string] =
    ## Returns list of missing packages 'packageName' in the install list.
    checkPacksTemplate(packageName, strutils.contains)

proc getAvailablePackageManager*(): seq[PackageManager] =
    ## Returns the list of available managers
    when defined(windows):
        let managers = WindowsPackageManagers
    elif defined(linux):
        let managers = LinuxPackageManagers
    elif defined(macosx):
        let managers = MacOSXManagers
            
    for manager in managers:
        if findExe($manager) != "":
            result.add(manager)