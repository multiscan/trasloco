# Trasloco
As minimal application for moving to new house.
It helps keeping track of all the boxes by 

## Build with
- Ruby on Rails
- Bootstrap with Webpack
- Github OAuth

## Get Started
### Requirements
- Ruby 2.6
- Rails 6
- Foreman gem

### Clone
```bash
git clone https://github.com/multiscan/trasloco.git
cd trasloco
```
### Install and migrate db

```bash
bundle install
yarn install --check-files
rails db:migrate
```
### Start Server
To start rails server
```bash
rails server

```
To start webpack server (rails 6 default is to use webpack)
```bash
gem install foreman
foreman start -f Procfile.dev
```

## Useful links
- [Rails6 + Devise template]: https://github.com/imhta/rails_6_devise_example
- [Ruby on Rails]: https://rubyonrails.org/
- [bootstrap]: https://getbootstrap.com/
- [Devise]: http://devise.plataformatec.com.br/Devise
- [Simple Form]: http://simple-form.plataformatec.com.br/
- [Simple form and bootstrap]: http://simple-form-bootstrap.plataformatec.com.br/


## Note
This is a very old project of mine that I had to quickly resurrect. Do not expect anything of good quelity.
