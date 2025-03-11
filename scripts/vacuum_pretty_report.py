import json
import glob
import os

def format_vacuum(data):
    results = data["resultSet"]["results"]
    columns = ["severity", "line", "ruleId", "message"]
    categorized = {"error": [], "warn": [], "info": [], "other": []}

    for result in results:
        severity = result["ruleSeverity"]
        entry = {
            "message": result["message"],
            "ruleId": result["ruleId"],
            "line": result["range"]["start"]["line"],
            "severity": severity
        }
        categorized.get(severity, categorized["other"]).append(entry)

    all_entries = sum(categorized.values(), [])
    max_lengths = {col: max(len(col), max(len(str(entry[col])) for entry in all_entries)) for col in columns}

    def format_entry(entry):
        return " | ".join(f"{str(entry[col]).ljust(max_lengths[col])}" for col in columns)

    header = " | ".join(col.ljust(max_lengths[col]) for col in columns)
    separator = "-+-".join('-' * max_lengths[col] for col in columns)

    output_file = os.path.join(os.getcwd(), 'vacuum_pretty_report_output.txt')
    with open(output_file, 'w') as f:
        f.write(header + '\n')
        f.write(separator + '\n')
        for entry in all_entries:
            f.write(format_entry(entry) + '\n')
    print(f"Report exported to {output_file}")

def main():
    file_pattern = os.path.join(os.getcwd(), 'vacuum-report*.json')
    file_list = glob.glob(file_pattern)

    if file_list:
        with open(file_list[0], 'r') as file:
            data = json.load(file)
        format_vacuum(data)
    else:
        print("No file starting with 'vacuum-report' found.")

if __name__ == '__main__':
    main()
