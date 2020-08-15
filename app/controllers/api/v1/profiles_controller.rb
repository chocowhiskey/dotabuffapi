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

        # get the latest matches hero
        @elements = []
        html_doc.search('.r-body a').each do |element|
          @elements.push(element.text)
        end



        render json: {
          status: 'SUCCESS',
          message: 'Loaded',
          data: [@wins,@losses,@abandons, @winRate, @elements]
        }, status: :ok
      end
    end
  end
end



