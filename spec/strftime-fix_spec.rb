require "spec_helper"

describe Time do
  context "when in a translated environment" do
    it "uses original strftime" do
      Time.utc(1970,"nov",05)._strftime("%a").should == "Thu"
    end

    it "uses strftime_nolocale" do

      # Sample implementation of localized strftime - in Portuguese
      class Time
        Date::PORTUGUESE_ABBR_DAYNAMES = %w(Dom Seg Ter Qua Qui Sex Sab)
        alias :strftime_nolocale :strftime
        def strftime(format)
          format = format.dup
          format.gsub!(/%a/, Date::PORTUGUESE_ABBR_DAYNAMES[self.wday])
          self.strftime_nolocale(format)
        end
      end
      
      Time.utc(1970,"nov",05).strftime("%a").should == "Qui"
      Time.utc(1970,"nov",05)._strftime("%a").should == "Thu"
    end
  end
end