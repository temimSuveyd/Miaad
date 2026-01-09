import os
import re

def add_uni_size_to_file(file_path):
    """Add uni_size import and update numeric values in a Dart file"""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Skip if already has uni_size
        if "import 'package:uni_size/uni_size.dart';" in content:
            print(f"Skipping {file_path} - already has uni_size")
            return False
        
        # Skip if no Flutter material import
        if "import 'package:flutter/material.dart';" not in content:
            print(f"Skipping {file_path} - no Flutter material import")
            return False
        
        # Add uni_size import after Flutter material import
        content = content.replace(
            "import 'package:flutter/material.dart';",
            "import 'package:flutter/material.dart';\nimport 'package:uni_size/uni_size.dart';"
        )
        
        # Update SizedBox
        content = re.sub(r'SizedBox\(height:\s*(\d+\.?\d*)\)', r'SizedBox(height: \1.us)', content)
        content = re.sub(r'SizedBox\(width:\s*(\d+\.?\d*)\)', r'SizedBox(width: \1.us)', content)
        content = re.sub(r'const SizedBox\(height:\s*(\d+\.?\d*)\.us\)', r'SizedBox(height: \1.us)', content)
        content = re.sub(r'const SizedBox\(width:\s*(\d+\.?\d*)\.us\)', r'SizedBox(width: \1.us)', content)
        
        # Update EdgeInsets
        content = re.sub(r'const EdgeInsets\.all\((\d+\.?\d*)\)', r'EdgeInsets.all(\1.us)', content)
        content = re.sub(r'EdgeInsets\.all\((\d+\.?\d*)\)', r'EdgeInsets.all(\1.us)', content)
        
        # Update EdgeInsets.symmetric
        content = re.sub(r'const EdgeInsets\.symmetric\(', r'EdgeInsets.symmetric(', content)
        content = re.sub(r'horizontal:\s*(\d+\.?\d*),', r'horizontal: \1.us,', content)
        content = re.sub(r'horizontal:\s*(\d+\.?\d*)\)', r'horizontal: \1.us)', content)
        content = re.sub(r'vertical:\s*(\d+\.?\d*),', r'vertical: \1.us,', content)
        content = re.sub(r'vertical:\s*(\d+\.?\d*)\)', r'vertical: \1.us)', content)
        
        # Update EdgeInsets.only
        content = re.sub(r'const EdgeInsets\.only\(', r'EdgeInsets.only(', content)
        content = re.sub(r'(top|bottom|left|right):\s*(\d+\.?\d*)', r'\1: \2.us', content)
        
        # Update BorderRadius
        content = re.sub(r'BorderRadius\.circular\((\d+\.?\d*)\)', r'BorderRadius.circular(\1.us)', content)
        
        # Update Offset
        content = re.sub(r'const Offset\((\d+\.?\d*),\s*(-?\d+\.?\d*)\)', r'Offset(\1.us, \2.us)', content)
        content = re.sub(r'Offset\((\d+\.?\d*),\s*(-?\d+\.?\d*)\)', r'Offset(\1.us, \2.us)', content)
        
        # Update width and height properties
        content = re.sub(r'width:\s*(\d+\.?\d*),', r'width: \1.us,', content)
        content = re.sub(r'height:\s*(\d+\.?\d*),', r'height: \1.us,', content)
        
        # Update size property
        content = re.sub(r'size:\s*(\d+\.?\d*)[,\)]', r'size: \1.us\2', content)
        
        # Update fontSize
        content = re.sub(r'fontSize:\s*(\d+\.?\d*)', r'fontSize: \1.us', content)
        
        # Update blurRadius
        content = re.sub(r'blurRadius:\s*(\d+\.?\d*)', r'blurRadius: \1.us', content)
        
        # Fix double .us.us
        content = content.replace('.us.us', '.us')
        
        # Fix const with .us
        content = re.sub(r'const\s+(\w+)\([^)]*\.us[^)]*\)', lambda m: m.group(0).replace('const ', ''), content)
        
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(content)
        
        print(f"Updated {file_path}")
        return True
        
    except Exception as e:
        print(f"Error processing {file_path}: {e}")
        return False

def process_directory(directory):
    """Process all Dart files in a directory recursively"""
    updated_count = 0
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith('.dart'):
                file_path = os.path.join(root, file)
                if add_uni_size_to_file(file_path):
                    updated_count += 1
    return updated_count

if __name__ == '__main__':
    lib_dir = 'lib'
    if os.path.exists(lib_dir):
        print(f"Processing {lib_dir} directory...")
        count = process_directory(lib_dir)
        print(f"\nDone! Updated {count} files.")
    else:
        print(f"Directory {lib_dir} not found!")
