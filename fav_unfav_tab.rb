# -*- coding: utf-8 -*-

miquire :addon, 'addon'
miquire :mui, 'skin'
miquire :mui, 'timeline'

=begin
libnotifyの通知を有効にするには
$sudo apt-get install libnotify-bin
を実行してlibnotifyをインストールしてください。
=end

Module.new do
  main = Gtk::TimeLine.new()
  image = Gtk::Image.new(Gdk::Pixbuf.new(MUI::Skin.get("fav.png"), 24,24))
  is_notify_favorited = true
  is_notify_unfavorited = true
  
  plugin = Plugin::create(:fav_unfav_tab)
  plugin.add_event(:boot){ |service|
    Plugin.call(:mui_tab_regist, main, 'Fav/Unfav', image)
  }
  plugin.add_event(:favorite){ |service, fav_by, messages|
    main.add(messages)
    main.favorite(fav_by, messages)
    if command_exist? "notify-send" || is_notify_favorited then
      SerialThread.new {
        #userでは無くgetでfav_byの人のアイコンを取得
        bg_system("notify-send","fav_by:#{fav_by}",
				  "#{messages.user.idname}:#{messages}","-i",
				  Gtk::WebIcon.local_path(fav_by.get(:profile_image_url,-1)))
	  }
    end
  }
  plugin.add_event(:unfavorite){ |service, unfav_by, messages|
    main.add(messages)
    main.unfavorite(unfav_by,messages)
    if command_exist? "notify-send" || is_notify_unfavorited then
      SerialThread.new {
        #userでは無くgetでunfav_byの人のアイコンを取得
        bg_system("notify-send","unfav_by:#{unfav_by}",
				  "#{messages.user.idname}:#{messages}","-i",
				  Gtk::WebIcon.local_path(unfav_by.get(:profile_image_url,-1)))
	  }
    end
  }
  
end
