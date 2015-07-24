require 'spec_helper'

describe Api::V1::GroupEventsController, type: :controller do
  context "JSON" do
    context "GET index" do
      context "when errors are not found" do
        before do
          GroupEvent.create(name: "1 - Ruby on Rails Group Event",
                            description: "First group event about Ruby on Rails in New York City.",
                            location: "New York", 
                            start_date: Date.today,
                            end_date: Date.today.next_day(5),
                            duration: 5) 
          get :index, format: 'json'
        end

        let(:group_event) { json['group_events'][0] }

        it { expect(response.status).to eql(200) }
        it { expect(json['group_events'].count).to eql(1) }
        
        %w(name description location duration start_date end_date).each do |key|
          it { expect(group_event).to have_key(key) }
        end

        it { expect(group_event['name']).to eql("1 - Ruby on Rails Group Event") }
        it { expect(group_event['description']).to eql("First group event about Ruby on Rails in New York City.") }
        it { expect(group_event['location']).to eql("New York") }
        it { expect(group_event['start_date']).to eql(Date.today.strftime("%Y-%m-%d")) }
        it { expect(group_event['end_date']).to eql(Date.today.next_day(5).strftime("%Y-%m-%d")) }
        it { expect(group_event['duration']).to eql(5) }
      end

      context "when group event are not found" do
        before do
          get :index, format: 'json'
        end

        let(:group_event) { json['group_events'][0] }

        it { expect(response.status).to eql(200) }
        it { expect(json['group_events'].count).to eql(0) }
      end

      context "when passed filter published=true" do
        before do
          GroupEvent.create(name: "1 - Ruby on Rails Group Event",
                            description: "First group event about Ruby on Rails in New York City.",
                            location: "New York", 
                            start_date: Date.today,
                            end_date: Date.today.next_day(5),
                            duration: 5,
                            published: true)
          GroupEvent.create(name: "1 - Ruby on Rails Group Event",
                            description: "First group event about Ruby on Rails in New York City.",
                            location: "New York", 
                            start_date: Date.today,
                            end_date: Date.today.next_day(5),
                            duration: 5) 
          get :index, format: 'json', published: true
        end

        let(:group_event) { json['group_events'][0] }

        it { expect(response.status).to eql(200) }
        it { expect(json['group_events'].count).to eql(1) }
        
        %w(name description location duration start_date end_date).each do |key|
          it { expect(group_event).to have_key(key) }
        end

        it { expect(group_event['name']).to eql("1 - Ruby on Rails Group Event") }
        it { expect(group_event['description']).to eql("First group event about Ruby on Rails in New York City.") }
        it { expect(group_event['location']).to eql("New York") }
        it { expect(group_event['start_date']).to eql(Date.today.strftime("%Y-%m-%d")) }
        it { expect(group_event['end_date']).to eql(Date.today.next_day(5).strftime("%Y-%m-%d")) }
        it { expect(group_event['duration']).to eql(5) }
        it { expect(group_event['published']).to eql(true) }
      end

      context "when passed filter archived=false" do
        before do
          GroupEvent.create(name: "1 - Ruby on Rails Group Event",
                            description: "First group event about Ruby on Rails in New York City.",
                            location: "New York", 
                            start_date: Date.today,
                            end_date: Date.today.next_day(5),
                            duration: 5,
                            archived: true)
          GroupEvent.create(name: "1 - Ruby on Rails Group Event",
                            description: "First group event about Ruby on Rails in New York City.",
                            location: "New York", 
                            start_date: Date.today,
                            end_date: Date.today.next_day(5),
                            duration: 5,
                            archived: false) 
          get :index, format: 'json', archived: false
        end

        let(:group_event) { json['group_events'][0] }

        it { expect(response.status).to eql(200) }
        it { expect(json['group_events'].count).to eql(1) }
        
        %w(name description location duration start_date end_date).each do |key|
          it { expect(group_event).to have_key(key) }
        end

        it { expect(group_event['name']).to eql("1 - Ruby on Rails Group Event") }
        it { expect(group_event['description']).to eql("First group event about Ruby on Rails in New York City.") }
        it { expect(group_event['location']).to eql("New York") }
        it { expect(group_event['start_date']).to eql(Date.today.strftime("%Y-%m-%d")) }
        it { expect(group_event['end_date']).to eql(Date.today.next_day(5).strftime("%Y-%m-%d")) }
        it { expect(group_event['duration']).to eql(5) }
        it { expect(group_event['archived']).to eql(false) }
      end
    end
  end

  context "POST create" do
    context "when all required attributes are informed" do
      before do
        post :create, format: 'json', group_event: { name: "1 - Ruby on Rails Group Event",
                                                     description: "First group event about Ruby on Rails in New York City.",
                                                     location: "New York", 
                                                     start_date: Date.today,
                                                     end_date: Date.today.next_day(5),
                                                     duration: 5 }
      end

      let(:group_event) { json['group_event'] }

      it { expect(response.status).to eql(201) }
      
      %w(name description location duration start_date end_date).each do |key|
        it { expect(group_event).to have_key(key) }
      end
    end

    context "when all required attributes are not informed" do
      before do
        post :create, format: 'json', group_event: { name: "1 - Ruby on Rails Group Event",
                                                     description: "First group event about Ruby on Rails in New York City.",
                                                     start_date: Date.today,
                                                     end_date: Date.today.next_day(5),
                                                     duration: 5 }
      end

      let(:group_event) { json['group_event'] }

      it { expect(response.status).to eql(201) }
      
      %w(name description location duration start_date end_date).each do |key|
        it { expect(group_event).to have_key(key) }
      end

      it { expect(group_event['name']).to_not be_nil }
      it { expect(group_event['name']).to eql("1 - Ruby on Rails Group Event") }
      it { expect(group_event['location']).to be_nil }
    end
  end

  context "POST publish" do
    context "when errors are not found" do
      before do
        post :publish, format: 'json', group_event: { name: "1 - Ruby on Rails Group Event",
                                                      description: "First group event about Ruby on Rails in New York City.",
                                                      location: "New York", 
                                                      start_date: Date.today,
                                                      end_date: Date.today.next_day(5),
                                                      duration: 5 }
      end

      let(:group_event) { json['group_event'] }

      it { expect(response.status).to eql(201) }
      
      %w(name description location duration start_date end_date).each do |key|
        it { expect(group_event).to have_key(key) }
      end
    end

    context "when errors are found" do
      before do
        post :publish, format: 'json', group_event: { name: "1 - Ruby on Rails Group Event",
                                                      description: "First group event about Ruby on Rails in New York City.",
                                                      start_date: Date.today,
                                                      end_date: Date.today.next_day(5),
                                                      duration: 5 }
      end
      
      let(:group_event) { json['group_event'] }

      it { expect(response.status).to eql(422) }
      it { expect(group_event).to have_key('errors') }
      it { expect(group_event['errors']).to eql(["Location can't be blank"]) }
    end
  end

  context "DELETE destroy" do
    let(:group_event) { GroupEvent.create(name: "1 - Ruby on Rails Group Event",
                                          description: "First group event about Ruby on Rails in New York City.",
                                          location: "New York", 
                                          start_date: Date.today,
                                          end_date: Date.today.next_day(5),
                                          duration: 5)  }

      context "when errors are not found" do
        before do
          post :destroy, format: 'json', id: group_event.id
        end

        it { expect(response.status).to eql(201) }
        it { expect(json).to have_key('group_event') }
      end

      context "when errors are found" do
        before do
          post :destroy, format: 'json', id: 9999
        end

        it { expect(response.status).to eql(422) }
        it { expect(json['group_event']).to have_key('errors') }
        it { expect(json['group_event']['errors']).to eq("Couldn't find GroupEvent with 'id'=9999") }
      end
  end
end