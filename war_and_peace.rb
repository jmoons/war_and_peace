# Download the text of: http://www.gutenberg.org/cache/epub/2600/pg2600.txt and place it in a file

# Write a Ruby program that reads the file and outputs the following:

#     A count of the total words (if you have any questions/issues with what comprises a "word" we can discuss/debate) in the main text (e.g. excluding the preamble and the epilogue -- extra credit to exclude chapter separators)
#     A list of all the unique words
#     A list of all the unique words and their frequency
#     A count of all the instances of short words (where a word is less than six characters)
#     The longest word in the book
#     The count of how many words appeared in the book before the longest word appears
#     The sum of all of the four digit numbers in the book

# Extra credit:

#     The mean, median, mode and standard deviation of word length of all of the words in the book


class WarAndPeaceWordCounter
  ILLEGAL_LINES                     = ["WAR AND PEACE", "By Leo Tolstoy/Tolstoi", "CONTENTS"]
  BOOK_REGULAR_EXPRESSION           = /^BOOK [A-Z]*:/
  CHAPTER_REGULAR_EXPRESSION        = /^CHAPTER [A-Z]*/
  DOUBLE_HYPHEN_REGULAR_EXPRESSION  = /--/
  PUNCTUATION_REGULAR_EXPRESSION    = /[^a-zA-Z0-9\s]/
  SHORT_WORD_CHARACTER_COUNT        = 6

  def initialize(file_to_parse)
    @word_count       = 0
    @short_word_count = 0
    @longest_word     = {:word => "", :preceding_word_count => 0}
    @file_to_parse    = File.open(file_to_parse, "r")
  end

  def word_count
    @file_to_parse.each_line do |line|
      candidate_line = line.chomp
      candidate_line = candidate_line.strip
      next if reject_line?(candidate_line)
      filtered_candidate_line = filter_candidate_line(candidate_line)
      update_word_count(filtered_candidate_line)
      iterate_through_line_words(filtered_candidate_line)
    end
    @file_to_parse.close
    puts "I Counted This Many Words: #{@word_count}"
    puts "I Counted This Many Short Words: #{@short_word_count}"
    puts "The Longest Word is: #{@longest_word[:word]} and was preceded by: #{@longest_word[:preceding_word_count]} words."
  end

  private

  def reject_line?(candidate_line)
    candidate_line.length == 0 ||
    ILLEGAL_LINES.include?(candidate_line) ||
    candidate_line =~ BOOK_REGULAR_EXPRESSION ||
    candidate_line =~ CHAPTER_REGULAR_EXPRESSION
  end

  def filter_candidate_line(candidate_line)
    # First replace double-hyphens with a space, then remove all punctuation in place
    candidate_line.gsub(DOUBLE_HYPHEN_REGULAR_EXPRESSION, " ").gsub(PUNCTUATION_REGULAR_EXPRESSION, '')
  end

  def iterate_through_line_words(candidate_line)
    candidate_line.split(" ").each do |word| 
      @short_word_count += 1    if word.length < SHORT_WORD_CHARACTER_COUNT
      if word.length > @longest_word[:word].length
        @longest_word[:word]                  = word
        @longest_word[:preceding_word_count]  = @word_count - 1
      end
    end
  end

  def update_word_count(candidate_line)
    @word_count += candidate_line.split(" ").length
  end

  def update_short_word_count(candidate_line)
    candidate_line.split(" ").each{ |word| @short_word_count += 1 if word.length < SHORT_WORD_CHARACTER_COUNT}
  end

end

WarAndPeaceWordCounter.new("war_and_peace_text/war_and_peace_stripped_header.txt").word_count
# WarAndPeaceWordCounter.new("war_and_peace_text/test.txt").word_count
# WarAndPeaceWordCounter.new("war_and_peace_text/short_word_test.txt").word_count
