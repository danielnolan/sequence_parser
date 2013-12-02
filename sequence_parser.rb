#!/usr/bin/env ruby

begin
  gem "ruby-progressbar"
rescue Gem::LoadError
  puts "Can't find gem ruby-progressbar. Please run 'gem install ruby-progressbar'."
  exit
end

require 'set'
require 'ruby-progressbar'

#create a progressbar to show progress in the console
progressbar = ProgressBar.create(format:'%a %B %p%% %t', total: nil, length: 80)

#create an empty array to hold the lines in the dictionary file
lines = Array.new

File.foreach("dictionary.txt") do |line|
  #add each line in the dictionary to an array
  #strip off any spaces or newline chars
  lines << line.strip
end

# figure out what the longest string is
# this will allow us to know when to stop processing
longest_string = lines.max_by(&:length).length

# this is the start for string slice
# we will increment it each time through the loop
start = 0

#create a new set to hold the unique sequences
sequences = Set.new

while (start + 4) < longest_string do
  lines.each do |line|
    #slice each line down to 4 char length
    sub_line = line[start, 4]

    #check if the sub_line is all alpha chars and 4 chars long
    if sub_line =~ /[[:alpha:]]{4}/
      #add each sequence to the sequences set
      #use the set.add? method so the only unique sequences will be added
      sequences.add? sub_line
    end
  end

  #increment the start for string slice each time through the loop
  #this allows us to find all of the 4 char sequences
  start += 1
end

#set the progress bar total to the length of the sequences set
progressbar.total = sequences.length

File.open("sequences.txt", 'a') do |file|
  sequences.each do |sequence|
    #write each unique 4 letter sequence to a file
    file.puts sequence + "\n"

    #increment the progress bar
    progressbar.increment

    File.open("words.txt", 'a') do |f|
      lines.each do |l|
        #check each line for existance of sequence
        if l.include? sequence
          #if the sequence is found write the word to the words file
          f.puts l
        end
      end
    end
  end
end

