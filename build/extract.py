import re
import sys

enc = 0.0
q = 0.0
tr = 0.0
infile = sys.argv[1]
with open(infile) as f:
    content = f.readlines()
    temp = content[-1].strip('\n')
    for line in content:
        if line != None:
            list = line.strip('\n').split(':')
            if list[0].startswith("Encoding Time"):
                enc = re.findall("\d+\.\d+", list[1])
            elif list[0].startswith("Query Time"):
                q = re.findall("\d+\.\d+", list[1])
            elif list[0].startswith("Training Time"):
                tr = re.findall("\d+\.\d+", list[1])
print(f"{infile},{str(tr[0])},{str(enc[0])},{str(q[0])},{temp}")
# print（"{},{},{},{},{}".format(infile,tr[0],enc[0],q[0],temp)）
