#!/bin/bash
cd /home/ubuntu/webapps/snpe
#Setea las variables globales del PATH y de las gemas
export PATH=/home/ubuntu/.rvm/gems/ruby-2.0.0-p451@snpe/bin:/home/ubuntu/.rvm/gems/ruby-2.0.0-p451@global/bin:/home/ubuntu/.rvm/rubies/ruby-2.0.0-p451/bin:/home/ubuntu/.rvm/bin:/home/ubuntu/.virtualenvs/snpe/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/bin/X11:/usr/games
export GEM_HOME=/home/ubuntu/.rvm/gems/ruby-2.0.0-p451@snpe
export GEM_PATH=/home/ubuntu/.rvm/gems/ruby-2.0.0-p451@snpe:/home/ubuntu/.rvm/gems/ruby-2.0.0-p451@global
#Corre la aplicacion con unicorn, el primer exec es para devolverle el pid a supervisor
exec bundle exec unicorn -c config/unicorn.rb -E production
