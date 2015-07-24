require 'spec_helper'

describe GroupEvent do
  context "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :location }
    it { should validate_presence_of :duration }
    it { should validate_presence_of :start_date }
    it { should validate_presence_of :end_date }

    it { should_not allow_value(Date.yesterday).for(:start_date) }
    it { should_not allow_value(Date.yesterday).for(:end_date) }
  end

  context "scopes" do
    describe ".published" do
      before do
        create(:group_event, name: "1 - Ruby on Rails Group Event",
                             description: "First group event about Ruby on Rails in New York City.",
                             location: "New York", 
                             start_date: Date.today,
                             end_date: Date.today.next_day(1),
                             published: true)
      end

      it { expect(GroupEvent.published(true).count).to eql(1) }
      it { expect(GroupEvent.published(false).count).to eql(0) }
    end

    describe ".archived" do
      let(:group_event) { create(:group_event, name: "1 - Ruby on Rails Group Event",
                                               description: "First group event about Ruby on Rails in New York City.",
                                               location: "New York", 
                                               start_date: Date.today,
                                               end_date: Date.today.next_day(1)) }

      before do
        group_event.archive
      end

      it { expect(GroupEvent.archived(true).count).to eql(1) }
      it { expect(GroupEvent.archived(true).first).to eql(group_event) }
      it { expect(GroupEvent.archived(false).count).to eql(0) }
    end
  end

  describe ".formatting_description" do
    let(:group_event) { build(:group_event, name: "1 - Ruby on Rails Group Event",
                                            description: "I <b>love</b> Ruby on Rails",
                                            location: "New York", 
                                            start_date: Date.today,
                                            end_date: Date.today.next_day(1)) }

    let(:group_event_formatted) { build(:group_event, name: "1 - Ruby on Rails Group Event",
                                                      description: "I <strong>love</strong> Ruby on Rails",
                                                      location: "New York", 
                                                      start_date: Date.today,
                                                      end_date: Date.today.next_day(1)) }
    
    before do
      group_event.formatting_description
      group_event_formatted.formatting_description
    end

    it { expect(group_event.description).to eql("I <b>love</b> Ruby on Rails") }
    it { expect(group_event_formatted.description).to eql("I love Ruby on Rails") }
  end

  context "when duration is omitted" do
    let(:group_event) { build(:group_event, name: "1 - Ruby on Rails Group Event",
                                            description: "First group event about Ruby on Rails in New York City.",
                                            location: "New York", 
                                            start_date: Date.today,
                                            end_date: Date.today.next_day(1)) }

    it { expect(group_event.set_duration).to eql(1) }
  end

  context "when start date is omitted" do
    let(:group_event) { build(:group_event, name: "1 - Ruby on Rails Group Event",
                                            description: "First group event about Ruby on Rails in New York City.",
                                            location: "New York", 
                                            duration: 5,
                                            end_date: Date.tomorrow) }

    it { expect(group_event.set_start_date).to eql(group_event.end_date - group_event.duration) }
  end

  context "when end date is omitted" do
    let(:group_event) { build(:group_event, name: "1 - Ruby on Rails Group Event",
                                            description: "First group event about Ruby on Rails in New York City.",
                                            location: "New York", 
                                            start_date: Date.today,
                                            duration: 5) }

    it { expect(group_event.set_end_date).to eql(group_event.start_date + group_event.duration) }
  end

  context "before validations" do
    context "when duration is empty" do
      let(:group_event) { GroupEvent.new(name: "1 - Ruby on Rails Group Event",
                                         description: "First group event about Ruby on Rails in New York City.",
                                         location: "New York", 
                                         start_date: Date.today,
                                         end_date: Date.today.next_day(3)) }

      before do
        group_event.valid?
      end

      it { expect(group_event.duration).to eql((group_event.end_date - group_event.start_date).to_i)  }
    end

    context "when start date is empty" do
      let(:group_event) { GroupEvent.new(name: "1 - Ruby on Rails Group Event",
                                         description: "First group event about Ruby on Rails in New York City.",
                                         location: "New York", 
                                         duration: 5,
                                         end_date: Date.tomorrow) }
      before do
        group_event.valid?
      end

      it { expect(group_event.start_date).to eql(group_event.end_date.prev_day(group_event.duration))  }
    end

    context "when end date is empty" do
      let(:group_event) { GroupEvent.new(name: "1 - Ruby on Rails Group Event",
                                         description: "First group event about Ruby on Rails in New York City.",
                                         location: "New York", 
                                         duration: 5,
                                         start_date: Date.tomorrow) }
      before do
        group_event.valid?
      end

      it { expect(group_event.end_date).to eql(group_event.start_date.next_day(group_event.duration))  }
    end
  end
end