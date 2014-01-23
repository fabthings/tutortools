## Vars to edit

lab_name = "Beatles Lab"
directory = "output"
default_index = "Add some files here\n"
names_file = "names.csv"

## No need to edit below this line

require "erb"

names = File.readlines(names_file).sort.map{
  |n| n.gsub(/[^ 0-9a-z\-]/i, '').chomp.split(' ').map(&:capitalize).join(' ')
}

people = []

`rm -rf #{directory} index.html`
`mkdir #{directory}`

names.each do |name|
  formatted_name = name.split(' ').reverse.join('.').downcase
  path = [directory,formatted_name].join('/')
  `mkdir -p #{path}`
  `cd #{path} && echo "#{default_index}" >> index.html`
  people << {name: name, formatted_name: formatted_name}
end

people.each do |person|
  `echo '#{person[:name]}' >> index.html`
end

erb = File.read("template.html.erb")
File.open("#{directory}/index.html", 'w') do |f|
  f.write ERB.new(erb).result(binding)
end
