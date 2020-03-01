== README

```zsh
cp config/database.yml.sample config/database.yml
cp config/secrets.yml.sample config/secrets.yml

bundle install --without production

rake db:migrate
rake create:system_user
rails s

```