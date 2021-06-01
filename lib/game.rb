# frozen_string_literal: true

require 'json'

# handles game logic
class Game
  def initialize(answer: nil,
                 turns: 5,
                 wordlist: './lib/wordlist.txt',
                 guesses: [])
    @answer = answer
    @answer ||= JSON.parse(File.read(wordlist)).keys.sample
    @turns = turns
    @wordlist = wordlist
    @guesses = guesses
    turn_logic
  end

  def turn_logic
    while @turns.positive?
      puts "Answer: #{hide_answer}  \
Tries: #{@turns}
Guesses: #{@guesses.join ', '}
Please input your guess (:h for help)"
      @turns -= 1 unless @answer.include? parse_guess
      game_over if @turns.zero?
      game_over winner: true if hide_answer == @answer
    end
  end

  def game_over(winner: nil)
    puts "Answer was: #{@answer}"
    if winner
      puts 'You win!'
    else
      puts 'You hanged.'
    end
    abort
  end

  def hide_answer
    key = []
    (0..@answer.length - 1).each do |i|
      if @guesses.include? @answer[i]
        key.append @answer[i]
      else
        key.append '_'
      end
    end
    key.join ''
  end

  def parse_guess(guess: gets.chomp)
    if guess.split('')[0] == ':'
      return parse_guess unless handle_command guess
    elsif guess == @answer
      game_over winner: true
    elsif ![*('A'..'Z'), *('a'..'z')].include?(guess) || @guesses.include?(guess)
      puts 'Bad input, try again.'
      return parse_guess
    end
    @guesses.append guess
    guess
  end

  def handle_command(command)
    case command
    when ':h'
      puts ":q  quit game\n:h  print this message"
    when ':q'
      game_over
    else
      puts 'Unrecognized command.'
    end
  end
end
