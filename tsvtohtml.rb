
def main
  ARGV.each do | file |
    data = read_tsv(file)
    html = write_table(data)
    puts html
  end
end

def read_tsv(file)
  f = File.open(file, 'r')
  tsv_lines = f.readlines
  f.close

  lines = []
  tsv_lines.each do | tsv_line |
    lines += [ tsv_line.split("\t") ]
  end

  return lines
end

def write_table(lines)
  html = "<table border=\"1px solid\">"
  lines.each do | fields |
    html += "<tr>"
    fields.each do | field |
      html += "<td width=400>#{field}</td>"
    end
    html += "</tr>\n"
  end
  html += "</table>"
end

if __FILE__ == $PROGRAM_NAME
  main
end

