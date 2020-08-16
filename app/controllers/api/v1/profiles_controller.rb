require 'open-uri'
require 'nokogiri'

module Api
  module V1
    class ProfilesController < ApplicationController
      def index
        userID = '199188713' #die ID muesste am Anfang der App eingegeben werden
        url = "https://www.dotabuff.com/players/#{userID}"

        html_file = open(url).read
        html_doc = Nokogiri::HTML(html_file)

        # get the username
        @username = html_doc.search('.header-content-title').text.gsub("Overview", "")

        # get the wins
        html_doc.search('.wins').each do |element|
          @wins = element.text.strip
        end
        # get the losses
        html_doc.search('.losses').each do |element|
          @losses = element.text.strip
        end
        # get the abandons
        html_doc.search('.abandons').each do |element|
          @abandons = element.text.strip
        end

        # get the win-rate
        html_doc.search('dd').each do |element|
          @winRate = element.text.strip
        end

        # get the latest matches hero + get if latest matches won or lost
        @elements = []
        html_doc.search('.r-body a').each do |element|
          @elements.push(element.text)
        end
        # filter empty elements from array
        @elements = @elements.reject { |c| c.empty? }
        # Delete not-hero names from the array
        @herosAndMore = []
        @elements.each do |element|
          # returns false if element contains numbers
          if !/\d/.match?(element)
            @herosAndMore.push(element)
          end
          @heros = @herosAndMore.reject {|c| c === 'Lost Match' || c === 'Won Match' }
        end
        @winOrLoseLastPlayedMatches = []
        @herosAndMore.each do |element|
          if element === 'Lost Match' || element === 'Won Match' 
            @winOrLoseLastPlayedMatches.push(element)
          end
        end
        # filtering the heros depending on latest matches or most played heros
        @mostPlayedHeros = @heros.first(10)
        @latestMatchesHeros = @heros.last(15)

        # find the duration of the last matches
        @durationsLastMatches = []
        html_doc.search('.r-duration').each do |durationContainer|
          @durationsLastMatches.push(durationContainer.text.gsub("Duration", ""))
        end

        # get the KDA of last matches
        @kdaLastMatches = []
        html_doc.search('.kda-record').each do |kda|
          @kdaLastMatches.push(kda.text)
        end

        render json: {
          status: 'SUCCESS',
          message: 'Loaded',
          data: [@username, @wins,@losses,@abandons, @winRate, @mostPlayedHeros, @latestMatchesHeros, @winOrLoseLastPlayedMatches,@durationsLastMatches, @kdaLastMatches]
        }, status: :ok
      end
    end
  end
end



