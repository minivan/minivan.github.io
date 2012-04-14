#googlerese to english
mapping = { "a" => "y", "b" => "h", "c" => "e", "d" => "s", "e" => "o",
	        "f" => "c", "g" => "v", "h" => "x", "i" => "d", "j" => "u",
	        "k" => "i", "l" => "g", "m" => "l", "n" => "b", "o" => "k",
	        "p" => "r", "q" => "z", "r" => "t", "s" => "n", "t" => "w",
	        "u" => "j", "v" => "p", "w" => "f", "x" => "m", "y" => "a",
	        "z" => "q"}

file = File.new("input", "r")
max = file.gets
counter = 1

while (line = file.gets)
  translatedLine = String.new
  line.split("").each do |i|

    if (i == " ")
      translatedLine << " "
    else
      translatedLine << mapping[i].to_s
    end
  end
  
  puts "Case ##{counter}: #{translatedLine}"
  counter = counter + 1
end
file.close
