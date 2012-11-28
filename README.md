Bored of waiting on `rails server` or `rake routes`? No more! This gem provides two commands, `waiting-on-rails` and `waiting-on-rake`. They are meant as replacements to `rails` and `rake`, respectively, so you can call them like this:

    waiting-on-rails server
    waiting-on-rake db:migrate

What's the difference? Aside from running the required task, they also play some relaxing elevator music, so you'll never get bored of waiting again. Problem solved!

<div>
  <object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" height="300" width="200" align="middle">
    <param name="allowScriptAccess" value="always">
    <param name="wmode" value="transparent">
    <param name="movie" value="http://widgets.jamendo.com/en/track/?track_id=839030&amp;playertype=2008&amp;refuid=1011928">
    <param name="quality" value="high">
    <param name="bgcolor" value="#FFFFFF">
    <embed src="http://widgets.jamendo.com/en/track/?track_id=839030&amp;playertype=2008&amp;refuid=1011928" quality="high" wmode="transparent" bgcolor="#FFFFFF" allowscriptaccess="always" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" height="300" width="200" align="middle">&nbsp;&nbsp;
  </object>
  <a href="http://pro.jamendo.com/" style="display:block;font-size:8px !important;">Royalty-free music for professional licensing</a>
</div>

## Gotchas

Okay, so `waiting-on-rails` only plays music for the `server` task, not for the similarly long-loading `console` cousin, but I have no idea how to run the console in a child process and control its IO. Pull requests welcome. And `waiting-on-rake` only plays music for long-running tasks (see `slow_tasks` method in [this file](https://github.com/AndrewRadev/waiting-on-rails/blob/master/lib/waiting_on_rails/rake.rb)), but that's intentional.

## Installation and Usage Details

The first thing you need to do is install the gem:

    gem install waiting-on-rails

The gem requires `mplayer` to play its music. On a Mac, you can install mplayer with homebrew:

    brew install mplayer

On Linux, you should use your distribution's package manager. For Arch Linux, the command would be:

    pacman -S mplayer

You could run `waiting-on-rails` without using `bundle exec` (unless it's run by a bundle-exec-ed script, like with a Procfile), but you probably won't be able to with `waiting-on-rake`. So if you're serious about battling boring loading times, you're going to have to add it to your Gemfile with a `:require => false`. If you just want a quick laugh, install the gem globally and start your project with `waiting-on-rails s`. Preferably in front of your unsuspecting coworkers. Amusement not guaranteed, but very likely.

## TODO

  - Implement `waiting-on-spork`?
  - Implement continuing from a point. Could save a temporary file somewhere with the time at which the music was stopped.
  - Implement simple configuration, controlling what song to play, or even something different to do (like show a notification). Warning: might make the project actually useful, consider carefully.

## Music sources

Both music sources are CC-licensed and can be found at the following urls:

  - Elevator music: http://www.jamendo.com/en/list/a98147/echoes-from-the-past
  - Elevator ding: http://soundbible.com/1441-Elevator-Ding.html
