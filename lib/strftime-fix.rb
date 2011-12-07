require 'date'

class Time
  def _strftime(format)
    if self.gmtime.respond_to?(:strftime_nolocale)
      self.gmtime.strftime_nolocale(format)
    else
      self.gmtime.strftime(format)
    end
  end
end