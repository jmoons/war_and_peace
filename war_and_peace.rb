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
  PUNCTUATION_REGULAR_EXPRESSION    = /[^a-zA-Z0-9\-\s]/
  SHORT_WORD_CHARACTER_COUNT        = 6

  def initialize(file_to_parse)
    @word_count             = 0
    @short_word_count       = 0
    @longest_word           = {:word => "", :preceding_word_count => 0}
    @unique_word_collection = {}
    @word_statistics        = {}
    @file_to_parse          = File.open(file_to_parse, "r")
  end

  def word_count
    @file_to_parse.each_line do |line|
      candidate_line = line.chomp
      candidate_line = candidate_line.strip
      next if reject_line?(candidate_line)
      filtered_candidate_line = filter_candidate_line(candidate_line)
      iterate_through_line_words(filtered_candidate_line)
    end
    @file_to_parse.close

    calculate_word_statistics

    puts "I Counted This Many Words: #{@word_count}"
    puts "I Counted This Many Short Words: #{@short_word_count}"
    puts "The Longest Word is: #{@longest_word[:word]} and was preceded by: #{@longest_word[:preceding_word_count]} words."

    # TO-DO return self so I can chain print_unique_word_collection temporarily
    self
  end

  def print_unique_word_collection
    puts "The Unique Word Collection is: #{@unique_word_collection.inspect}"
    puts "The Word Statistics Are: #{@word_statistics.inspect}"
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
    array_of_line_words = candidate_line.split(" ")

    update_word_count(array_of_line_words)

    array_of_line_words.each do |word| 
      update_short_word_count(word)
      check_for_longest_word(word)
      update_unique_word_collection_case_insensitive(word)
    end
  end

  def update_word_count(array_of_line_words)
    @word_count += array_of_line_words.length
  end

  def update_short_word_count(word)
    @short_word_count += 1 if word.length < SHORT_WORD_CHARACTER_COUNT
  end

  def check_for_longest_word(word)
    if word.length > @longest_word[:word].length
      @longest_word[:word]                  = word
      @longest_word[:preceding_word_count]  = @word_count - 1
    end
  end

  def update_unique_word_collection_case_insensitive(word)
    word_downcase = word.downcase
    @unique_word_collection.has_key?(word_downcase) ? @unique_word_collection[word_downcase] += 1 : @unique_word_collection[word_downcase] = 1
  end

  def update_unique_word_collection_case_sensitive(word)
    @unique_word_collection.has_key?(word) ? @unique_word_collection[word] += 1 : @unique_word_collection[word] = 1
  end

  def calculate_word_statistics
    sorted_word_lengths = @unique_word_collection.keys.map(&:length).sort
    @word_statistics[:word_length_mean]               = calculate_mean(sorted_word_lengths)
    @word_statistics[:word_length_median]             = calculate_median(sorted_word_lengths)
    @word_statistics[:word_length_mode]               = calculate_mode(sorted_word_lengths)
    # @word_statistics[:word_length_standard_deviation] = calculate_standard_deviation(sorted_word_lengths)
  end

  def calculate_mean(sorted_word_lengths)
    sorted_word_lengths.reduce(:+) / sorted_word_lengths.length
  end

  def calculate_median(sorted_word_lengths)
    middle_index = (sorted_word_lengths.length / 2).floor
    if (sorted_word_lengths.length.odd?)
      return sorted_word_lengths[middle_index]
    else
      return ( sorted_word_lengths[(middle_index - 1)] + sorted_word_lengths[middle_index] ) / 2
    end
  end

  def calculate_mode(sorted_word_lengths)
    mode_hash_keys = sorted_word_lengths.uniq
    # Mode hash will be key/value where key is a word length and value is the number of occurences of that word length
    mode_hash = {}
    mode_hash_keys.each do |mode_hash_key|
      mode_hash[mode_hash_key] = sorted_word_lengths.select{ |sorted_word_length| sorted_word_length == mode_hash_key}.length
    end

    mode_hash.max_by{ |key, value| value}[0]

  end

end

WarAndPeaceWordCounter.new("war_and_peace_text/war_and_peace_stripped_header.txt").word_count.print_unique_word_collection
# WarAndPeaceWordCounter.new("war_and_peace_text/test.txt").word_count
# WarAndPeaceWordCounter.new("war_and_peace_text/short_word_test.txt").word_count
# WarAndPeaceWordCounter.new("war_and_peace_text/punctuation_mix.txt").word_count.print_unique_word_collection
# WarAndPeaceWordCounter.new("war_and_peace_text/unique_word_collection.txt").word_count.print_unique_word_collection