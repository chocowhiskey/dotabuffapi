module Api
  module v1
    class HomesController < ApplicationController
      def index
        @profile
        render json: {
          status: 'SUCCESS',
          message: 'Loaded',
          data: @profile
        }
      end
    end
  end
end


