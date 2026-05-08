import re
import argparse

count,info_count,warning_count = 0,0,0
first_entry = ""
most_recent_warn_entries = []
TIMESTAMP_PATTERN = r'\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}'

parser = argparse.ArgumentParser()
parser.add_argument("--file", help="Enter name of log file") # it tells the parser that this program accepts --file argument from the command line.
parser.add_argument('--warnings-only', action='store_true', help='Show only warning entries')
args = parser.parse_args()

with open(args.file, 'r') as f:
    lines = f.readlines()

    for x in lines:
        if not x.strip() or x.startswith('---'):
            continue
        count +=1
        if re.search(r'\[INFO\]', x):
            info_count +=1
        if re.search(r'\[WARNING\]',x):
            warning_count +=1
            most_recent_warn_entries.append(x)
    if lines:
        first_entry = re.search(TIMESTAMP_PATTERN,lines[0]).group()
        last_entry = re.search(TIMESTAMP_PATTERN,lines[-1]).group()
        

# Output section
if args.warnings_only:
    for entry in most_recent_warn_entries:
        print(entry, end='')
else:
    # your existing output section
    print(f"Total Entries:  {count}")    
    print(f"INFO Entries:  {info_count}")    
    print(f"WARNING Entries:  {warning_count}")    
    print("First entry at:", first_entry)
    print("Last entry at:", last_entry)
    print("Most recent warn entries:")
    for recent_entry in most_recent_warn_entries[-3:]:
        print('\t',recent_entry)
