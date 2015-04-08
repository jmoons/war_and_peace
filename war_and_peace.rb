class WarAndPeaceWordCounter
  ILLEGAL_LINES               = ["WAR AND PEACE", "By Leo Tolstoy/Tolstoi", "CONTENTS"]
  BOOK_REGULAR_EXPRESSION     = /^BOOK [A-Z]*:/
  CHAPTER_REGULAR_EXPRESSION  = /^CHAPTER [A-Z]*/

  def initialize(file_to_parse)
    @word_count     = 0
    @file_to_parse  = File.open(file_to_parse, "r")
  end

  def word_count
    @file_to_parse.each_line do |line|
      candidate_line = line.chomp
      candidate_line = candidate_line.strip
      update_word_count(candidate_line) unless ( candidate_line.length == 0 || ILLEGAL_LINES.include?(candidate_line) )
    end
    @file_to_parse.close
    puts "I Counted This Many Words: #{@word_count}"
  end

  private

  def update_word_count(candidate_line)
    if (candidate_line !~ BOOK_REGULAR_EXPRESSION) && (candidate_line !~ CHAPTER_REGULAR_EXPRESSION)
      @word_count += candidate_line.split(" ").length
    end
  end

end

WarAndPeaceWordCounter.new("war_and_peace_text/war_and_peace_stripped_header.txt").word_count
# WarAndPeaceWordCounter.new("war_and_peace_text/test.txt").word_count
