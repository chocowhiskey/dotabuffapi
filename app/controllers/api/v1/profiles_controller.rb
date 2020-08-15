module Api
  module V1
    class ProfilesController < ApplicationController
      def index
        @profile
        render json: {
          status: 'SUCCESS',
          message: 'Loaded',
          data: @profile
        }, status: :ok
      end
    end
  end
end


