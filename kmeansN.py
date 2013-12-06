import csv


def parse_csv_to_array(filename):
    array = list(csv.reader(open(r+filename)))

if __name__ == '__main__':

    import re
    import sys

    def usage():
        print("usage: %s k docs..." % sys.argv[0])
        print("    The number of documents must be >= k.")
        sys.exit(1)

    try:
        filename = sys.argv[1]
        data = parse_csv_to_array(filename)
    except ValueError():
        usage()

    print data
