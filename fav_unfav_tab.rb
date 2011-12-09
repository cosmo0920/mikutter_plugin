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
  #M-xで出てくるコンソールで通知するかしないか変更できるよ
  UserConfig[:is_notify_favorited] = true
  UserConfig[:is_notify_unfavorited] = true
  
  plugin = Plugin::create(:fav_unfav_tab)
  plugin.add_event(:boot){ |service|
    Plugin.call(:mui_tab_regist, main, 'Fav/Unfav', image)
  }
  plugin.add_event(:favorite){ |service, fav_by, messages|
    main.add(messages)
    main.favorite(fav_by, messages)
    if command_exist? "notify-send" || UserConfig[:is_notify_favorited] then
      SerialThread.new {
        #自分(Post.primary_service.user)がふぁぼした時には通知しないよ
        if !(fav_by.to_s == Post.primary_service.user.to_s) then
          #userでは無くgetでfav_byの人のアイコンを取得
          bg_system("notify-send","fav_by:#{fav_by}",
                    "#{messages.user.idname}:#{messages}","-i",
                    Gtk::WebIcon.local_path(fav_by.get(:profile_image_url,-1)))
        end
      }
    end
  }
  plugin.add_event(:unfavorite){ |service, unfav_by, messages|
    main.add(messages)
    main.unfavorite(unfav_by,messages)
    if command_exist? "notify-send" || UserConfig[:is_notify_unfavorited] then
      SerialThread.new {
        #自分(Post.primary_service.user)があんふぁぼした時には通知しないよ
        if !(unfav_by.to_s == Post.primary_service.user.to_s) then
          #userでは無くgetでunfav_byの人のアイコンを取得
          bg_system("notify-send","unfav_by:#{unfav_by}",
                    "#{messages.user.idname}:#{messages}","-i",
                    Gtk::WebIcon.local_path(unfav_by.get(:profile_image_url,-1)))
        end
      }
    end
  }
  
end
