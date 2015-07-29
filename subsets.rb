$dictionary = 'wordsEn.txt'

def subsets(set)
  return [[]] if set.empty?
  previous = subsets(set.take(set.count - 1))
  previous + previous.map { |element| element + [set.last] }
end

def substrings(word)
  letters = word.split('')
  subsets(letters).map { |array| array.join('') }
end

def factorial(n)
  return 1 if n <= 1

  n * factorial(n - 1)
end

def hash_interpretor(word, numbers)
  interpretor = Hash.new
  word.split('').each_with_index { |char, id| interpretor[id] = char }

  word = ''
  numbers.each { |id| word += interpretor[id] }

  word
end

def anagrams(word)
  all_words = File.readlines($dictionary).map {|word| word.chomp}
  coded_word = []
  word.split('').each_with_index { |char, id| coded_word << id }

  coded_strings = []
  until coded_strings.size == factorial(word.length)
    coded_string = coded_word.shuffle
    coded_strings << coded_string  if !coded_strings.include?(coded_string)
  end

  scrambled = []
  coded_strings.uniq.each { |code| scrambled << hash_interpretor(word, code)}

  scrambled.delete_if { |string| !all_words.include?(string) }
end

def subanagrams(word)
  sub_strings = substrings(word)
  subs = []

  sub_strings.each do |string|
    mixes = anagrams(string)
    mixes.each do |sub_anagram|
      subs << sub_anagram if !subs.include?(sub_anagram)
    end
  end

  subs.flatten.sort
end

def subanagram_any?(word)
  sub_strings = substrings(word)

  sub_strings.each do |string|
    mixes = anagrams(string)
    return true if mixes.size > 1
  end

  false
end

def preener
  testing_words = File.readlines($dictionary).map {|word| word.chomp}
  testing_words.delete_if { |word| word.include?('a') || word.include?('i') || word.length <= 6 }

  small_words = testing_words.select { |word| word.length <= 5 }

  small_words.each do |small_word|
    testing_words.delete_if { |tester| tester.include?(small_word) }
  end

  testing_words
end

# test if 'queue' is longest word without sub-anagram
def longest_non_sub_anagram
  testing_words = preener
  longest_word = 'queue'

  until testing_words.empty?
    testing_words.each do |word|
      if !subanagram_any?(word) && word.length >= longest_word.length
        longest_word = word
        testing_words.delete_if { |tester| tester.length < longest_word.length }
      else
        testing_words.delete_if { |tester| tester.include?(word) }
      end
    end
  end

  longest_word
end

puts subanagrams("bermuda")
# puts "Based on the dictionary given, the longest word without an anagram is: #{longest_non_sub_anagram.upcase}"
