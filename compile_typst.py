import sys
import json
import subprocess
import os

if len(sys.argv) > 1:
    if sys.argv[1] == 'supports':
        sys.exit(0)

cwd = os.getcwd()
context, book = json.load(sys.stdin)
def recurse(items):
    for book_item in items:
        chapter = book_item['Chapter']
        content = chapter['content']
        sys.stderr.write(content + '\n')
        typst_run = subprocess.run(
            ['../typst', 'compile', '--features', 'html', '--format', 'html', '--root', cwd, '-', '-'],
            input=content, capture_output=True, text=True
        )
        output: str = typst_run.stdout
        error = typst_run.stderr
        sys.stderr.write(error + '\n')
        # take the content of <body> and remove unnecessary leading whitespace and empty lines
        if '<body>' in output:
            output = output.split('<body>')[1].split('</body>')[0]
        output_lines = [line for line in [line.lstrip() for line in output.splitlines()] if line]
        chapter['content'] = '\n'.join(output_lines)
        recurse(chapter['sub_items'])
recurse(book['sections'])
    
book_dump = json.dumps(book)
sys.stderr.write(book_dump + '\n')
print(book_dump)
