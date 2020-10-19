require 'open-uri'
require 'json'


class GamesController < ApplicationController
  def new
    @grid = []
    @grid << ("A".."Z").to_a.sample(1).join until @grid.size == 10
  end

  def score
    @attempt = params['attempt']
    @grid = params[:grid].split(' ')
    grid_string = @grid.join(', ')
    @attempt_array = @attempt.upcase.split('')
    @check = @attempt_array.all? { |letter| @grid.count(letter) >= @attempt_array.count(letter) && @grid.include?(letter) }
    lewagon_dict = open("https://wagon-dictionary.herokuapp.com/#{@attempt}").read
    word = JSON.parse(lewagon_dict)
    if word['found'] == false
      @result = "Sorry but #{@attempt.upcase} does not seem to be a valid English word..."
    elsif @check && word['found']
      @result = "Congratulations! #{@attempt.upcase} is a valid English word!"
    else
      @result = "Sorry but #{@attempt.upcase} can't be built out #{grid_string}"
    end
  end
end
