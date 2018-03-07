# README

Thanks for looking this over :)

### Built using Ruby 2.4.2 and Rails 5.1.5 running on SQLite3

### Setting up ruby environment (Skip This Section if you already have Ruby set up on your machine)

1. Install Ruby package manager https://rvm.io/rvm/basics https://www.ruby-lang.org/en/documentation/installation/
```
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB

\curl -sSL https://get.rvm.io | bash -s stable
```

2. Install and use Ruby version
```
rvm install 2.4.2

rvm use 2.4.2
```

3. Install Rails
```
gem install rails --version 5.1.5
```

4. Make sure everything you need is being loaded in your PATH in `~/.bash_profile`
Add to path
```
source ~/.bash_profile
```

5. Install bundler to manage gem dependencies http://bundler.io/
```
gem install bundler
```

---

### To Run
1. Install dependencies
```
bundle
```
2. Create and migrate database
```
rake db:setup
```
4. Run server locally
```
rails s
```

---

### To Test
1. Run test suite
```
rspec
```
2. Run linter/ static code analyzer
```
rubocop
```

---
### Info
- the urls are shortned based on converting id of url to base 36. I do it this way because:
1. insures that shortened url is unique because ids will always be unique
2. saves us the application level check for uniqueness which does not guard from race conditions and slows down the inserts
3. hashing algorithms sometimes result in clashes as well

- `ExceptionHandler` handles errors by rescuing ActiveRecord exceptions

---

### Criticisms
#### Tests
- did not have time to refactor properly or add headers for JSON content-type in request specs
- hardcoding expectations in some places

#### Scalability
These are the things I could do for scalability which I didn't have time to do:
- don't use Rails
- using postgreSQL would be preferred to SQLite3
- add indexes to database for short_urls `short_address` since I am doing a uniqueness application-level (At a larger scale this check might not makes sense since it serves no functional purpose)
- add caching
- separate out short_url and url into their own controllers

---

##### Resources
- http://edgeguides.rubyonrails.org/api_app.html
