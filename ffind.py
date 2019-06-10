"""Find files in a given folder using a pattern"""

import os, sys, fnmatch

cwd = os.getcwd()
def find(pattern, path, cwd=cwd):
    #print ("{}/{}".format(cwd, path))
    #print ("Finding {} files in {}/{} ...".format(pattern, cwd, path))
    result = []
    for root, dirs, files in os.walk("{}/{}".format(cwd, path)):
        for name in files:
            if fnmatch.fnmatch(name, pattern):
                result.append(os.path.join(root, name))
    return result
