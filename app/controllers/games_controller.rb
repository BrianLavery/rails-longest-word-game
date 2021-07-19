require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
    session[:letters] = @letters
  end

  def score
    @answer = params[:answer]
    @letters = session[:letters]
    session[:letters] = nil

    url = "https://wagon-dictionary.herokuapp.com/#{@answer}"
    response = URI.open(url).read
    data = JSON.parse(response)

    # Set @result to be that word is not valid unless it is
    @result = "Sorry but #{@answer} does not seem to be a valid English word." unless data["found"]

    # Create a dictionary/ hash with each letter in the grid as a key and count of it in the grid as the value
    letter_count_hash = @letters.uniq.map { |letter| { letter => @letters.count(letter) } }.reduce({}, :merge)

    # Cycle through each letter in answer string and check if in the letters array. And also check if appears mroe time in the answer than in the letters hash
    @answer.upcase.chars.uniq.each do | letter|
      if letter_count_hash[letter].nil? || @answer.upcase.chars.count(letter) > letter_count_hash[letter]
        @result = "Sorry but #{@answer.upcase} can't be built out of #{@letters.join(", ")}" if @result.nil?
      end
    end

    if @result.nil?
      @result = "Congratulations! #{@answer.upcase} is a valid English word!" if @result.nil?
      if session[:score].nil?
        session[:score] = 1
      else
        session[:score] += 1
      end
    end
  end

  def total
    @score = session[:score]
  end
end
