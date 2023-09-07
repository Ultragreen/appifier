# Appifier

Appifier : Applications templating and management tools 


![GitHub](https://img.shields.io/github/license/Ultragreen/appifier)

[![Documentation](https://img.shields.io/badge/docs-rubydoc.info-brightgreen)](https://rubydoc.info/gems/appifier)
![GitHub issues](https://img.shields.io/github/issues/Ultragreen/appifier)
![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/Ultragreen/appifier)
![GitHub top language](https://img.shields.io/github/languages/top/Ultragreen/appifier)
![GitHub milestones](https://img.shields.io/github/milestones/open/Ultragreen/appifier)

![Gem](https://img.shields.io/gem/dt/appifier)
[![Gem Version](https://badge.fury.io/rb/sc4ry.svg)](https://badge.fury.io/rb/appifier)
![Twitter Follow](https://img.shields.io/twitter/follow/Ultragreen?style=social)
![GitHub Org's stars](https://img.shields.io/github/stars/Ultragreen?style=social)
![GitHub watchers](https://img.shields.io/github/watchers/Ultragreen/appifier?style=social)

<noscript><a href="https://liberapay.com/ruydiaz/donate"><img alt="Donate using Liberapay" src="https://liberapay.com/assets/widgets/donate.svg"></a></noscript>


![Sc4ry logo](assets/images/logo_appifier_full_large.png) 
_Applications templating and management tools_

## Installation

    $ gem install appifier

## Usage

Appifier : Manage your applications templates, build, deploy, publish any type of application (CLI, web, etc...) in any languages with any facilities.  


## Process

![Appifier process](assets/images/description_appifier.png) 

## Simple usecase

### Retrieve a template from repository

    $ appifier retrieve https://github.com/AppifierTemplates/sinatra_template_appifier.git

### Collect and generate the application from template

You can build the application wherever you want.
You need to populate your datasets in order to generate the application with good values.

    $ appifier generate sinatra_template_appifier .
    ⚠ Dataset file not found for sinatra_template_appifier
    Do you want to collect dataset interactively ? Yes
    ℹ Beginning interactive Dataset input for sinatra_template_appifier
    Give application name :  (Application)

# Functionalities

## TEMPLATE

### Retrieve a template from repository

    $ appifier retrieve https://github.com/AppifierTemplates/sinatra_template_appifier.git

### Retrieve a template from archive

    $ appifier retrieve -t archive sinatra_template_appifier.tgz

### Collect datasets for a template

    $ appifier collect sinatra_template_appifier
    ℹ Beginning interactive Dataset input for sinatra_template_appifier
    Give application name :  Application
    Give application namespace :  Namespace
    ℹ Dataset recorded for sinatra_template_appifier

### Generate application from template

    $ appifier generate sinatra_template_appifier

### List all templates

    $ appifier templates ls

### Show a template

    $ appifier templates show sinatra_template_appifier

### Delete a template

    $ appifier templates rm sinatra_template_appifier

### Lint a template 

    $ appifier templates lint sinatra_template_appifier

### Display tree view of a template

    $ appifier templates treeview sinatra_template_appifier

## DATASETS

### Show a dataset

    $ appifier datasets show sinatra_template_appifier

### List all datasets

    $ appifier datasets ls

### Edit a dataset

VIM is the default editor.
If you want a specific editor you can export the EDITOR environment variable with the launch command of your editor. 

    $ appifier datasets edit sinatra_template_appifier

### Update a dataset

You can modify the data you want interactively.

    $ appifier datasets update sinatra_template_appifier

### Delete a dataset

    $ appifier datasets rm sinatra_template_appifier

### Delete orphans datasets

    $ appifier datasets prune

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Ultragreen/appifier.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
