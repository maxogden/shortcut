require File.join(File.dirname(__FILE__), '..', 'hotcocoa-0.5.1', 'lib', 'hotcocoa')
require 'shortcut'

class Application

  include HotCocoa

  def start
    @app = application :name => "Shortcut", :delegate => self
    @status = status_item
    set_status_menu
    @app.run
  end
  
  def set_status_menu
    @menu = status_menu
    @status.view = nil
    @status.menu = @menu
    @status.image = image :file => "#{lib_path}/../command.png", :size => [ 17, 17 ]
    @status.alternateImage = image :file => "#{lib_path}/../command-inverted.png", :size => [ 17, 17 ]
    @status.setHighlightMode true
  end

  def status_menu
    menu :delegate => self do |status|
      status.item "Quit", :on_action => proc { @app.terminate self }
    end
  end
  
  def applicationDidFinishLaunching(sender)
    install_shortcut
  end
  
  def install_shortcut
    shortcut = Shortcut.new
    shortcut.delegate = self
    shortcut.addShortcut
  end

  def hotkeyWasPressed(message)  
    puts "You pressed #{message}"
  end

  def lib_path
    File.dirname __FILE__
  end  
end

Application.new.start