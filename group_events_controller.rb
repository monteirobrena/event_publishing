module Api
  module V1
    class GroupEventsController < BaseController
      skip_before_filter :verify_authenticity_token

      def index
        begin
          group_events = GroupEvent.where(nil)

          filtering_params(params).each do |key, value|
            group_events = group_events.public_send(key, value)
          end
          render json: group_events, status: 200
        rescue => e
          render json: { group_events: { errors: e } }, status: 422
        end
      end

      def create
        begin
          group_event = GroupEvent.new(group_event_params)
          
          if group_event.save(validate: false)
            render json: group_event, status: 201
          else
            render json: { group_event: { errors: group_event.errors.full_messages } }, status: 422
          end
        rescue => e
          render json: { group_event: { errors: e } }, status: 422
        end
      end

      def publish
        begin
          group_event = GroupEvent.new(group_event_params)
          group_event.published = true

          if group_event.save
            render json: group_event, status: 201
          else
            render json: { group_event: { errors: group_event.errors.full_messages } }, status: 422
          end
        rescue => e
          render json: { group_event: { errors: e } }, status: 422
        end
      end

      def destroy
        begin
          group_event = GroupEvent.find(params[:id])
          group_event.archive

          render json: group_event, status: 201
        rescue => e
          render json: { group_event: { errors: e.message } }, status: 422
        end
      end

      private

      def group_event_params
        params.require(:group_event).permit!
      end

      def filtering_params(params)
        params.slice(:archived, :published)
      end
    end
  end
end