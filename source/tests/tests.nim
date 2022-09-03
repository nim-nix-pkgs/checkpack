import unittest

import checkpack, re

test "Check git":
    check checkPack("git") == true

test "Check lol":
    check checkPack("lol") == false

test """Check re"^git.*""":
    check checkPack(re"^git.*") == true

test """Check re"^lol.*""":
    check checkPack(re"^lol.*") == false

test "Check list with git and lol":
    check checkPacks(@["lol", "git"]) == @["lol"]

test "Check list available package manager":
    when defined(windows):
        check getAvailablePackageManager() == @[choco]
    elif defined(linux):
        check getAvailablePackageManager() == @[dpkg, apt]
    elif defined(macosx):
        check getAvailablePackageManager() == @[brew]