require 'rubygems'
require 'hotcocoa'
require "shortcut"

class Application

  include HotCocoa

  def start
    application :name => "Shortcut" do |app|
      app.delegate = self
      window :frame => [100, 100, 500, 500], :title => "Shortcut" do |win|
        win << label(:text => "Hello from HotCocoa", :layout => {:start => false})
        win << label(:text => "Press Control+Option+Space to pop-up a window", :layout => {:start => false})
        win.will_close { exit }
      end
    end
  end
  
  def applicationDidFinishLaunching(sender)
    install_shortcut
  end
    
  def install_shortcut
    @shortcut = Shortcut.new
    @shortcut.delegate = self
    @shortcut.addShortcut
  end
  
  def hotkeyWasPressed
    window :size => [250, 50] do |win|
      my_label = label(:text => "You pressed Control+Option+Space", :layout => {:expand => :width, :start => false})
      win << my_label
    end
  end 

end

Application.new.start