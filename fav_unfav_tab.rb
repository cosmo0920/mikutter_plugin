# -*- coding: utf-8 -*-

miquire :addon, 'addon'
miquire :mui, 'skin'
miquire :mui, 'timeline'

Module.new do
  main = Gtk::TimeLine.new()
  image = Gtk::Image.new(Gdk::Pixbuf.new(MUI::Skin.get("fav.png"), 24,24))

  plugin = Plugin::create(:fav_unfav_tab)
  plugin.add_event(:boot){ |service|
    Plugin.call(:mui_tab_regist, main, 'Fav/Unfav', image)
    # Gtk::TimeLine.addwidgetrule(/@([a-zA-Z0-9_]+)/){ |text|
    #   user = User.findbyidname(text[1, text.size])
    #   Gtk::WebIcon.new(user[:profile_image_url], 12, 12) if user }
  }
  plugin.add_event(:favorite){ |service, fav_by, messages|
      main.add(messages)
      main.favorite(fav_by, messages)
 }
  plugin.add_event(:unfavorite){ |service, unfav_by, messages|
	  main.add(messages)
	  main.unfavorite(unfav_by,messages)
  }

end
