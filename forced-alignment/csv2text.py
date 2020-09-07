import csv 
import sys

csv_file = sys.argv[2] + sys.argv[1]
out_file = sys.argv[3] + sys.argv[1]
out_file = out_file.replace(".csv", ".txt")

with open( csv_file ) as fp:
    reader = csv.reader(fp, delimiter=",")
    next(reader, None)
    data_read = [row[9] for row in reader]

with open(out_file, 'w') as filetowrite:
	for line in data_read:
		filetowrite.write(line + '\n')

print('txt',sys.argv[1])
