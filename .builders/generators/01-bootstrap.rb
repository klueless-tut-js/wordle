KManager.action :bootstrap do
  def on_action
    application_name = :wordle

    director = KDirector::Dsls::BasicDsl
      .init(k_builder,
        on_exist:                   :skip,                      # %i[skip write compare]
        on_action:                  :queue                      # %i[queue execute]
      )
      .data(
        application:                application_name,
        application_description:    'JS Tutorial - Wordle is a daily word game you can find online here. It is fun, simple and, like a crossword, can only be played once a day',
        author:                     'David Cruwys',
        author_email:               'david@ideasmen.com.au',
        main_story:                 'As a Developer, I want practice my JS/HTML skills, so that I keep up to date',
        copyright_date:             '2022'
      )
      .github(
        active: false,
        repo_name: application_name,
        organization: 'klueless-tut-js'
      ) do
        create_repository
        # delete_repository
        # list_repositories
        open_repository
      end
      .blueprint(
        active: false,
        name: :bin_hook,
        description: 'initialize repository',
        on_exist: :write) do

        cd(:app)

        run_command('git init')
        add('.gitignore')
        run_template_script('.git-setup.sh', dom: dom)

        run_command("git add .; git commit -m 'chore: #{self.options.description.downcase}'; git push")
        run_command("gh repo edit -d \"#{dom[:application_description]}\"")
      end
      .package_json(
        active: false,
        name: :package_json,
        description: 'Set up the package.json file for semantic versioning'
      ) do
        self
          .add('package.json', dom: dom)
          .play_actions

        # self
        #   .add_script('xxx', 'xxx')
        #   .sort
        #   .development
        #   .npm_add_group('xxx')

        # run_command("git add .; git commit -m 'chore: #{self.options.description.downcase}'; git push")
      end
      .blueprint(
        active: false,
        name: :opinionated,
        description: 'opinionated files',
        on_exist: :write) do

        cd(:app)

        # add('something.txt', dom: dom)

        # run_command("git add .; git commit -m 'chore: #{self.options.description.downcase}'; git push")
      end

    director.play_actions
  end
end

KManager.opts.app_name                    = 'wordle'
KManager.opts.sleep                       = 2
KManager.opts.reboot_on_kill              = 0
KManager.opts.reboot_sleep                = 4
KManager.opts.exception_style             = :short
KManager.opts.show.time_taken             = true
KManager.opts.show.finished               = true
KManager.opts.show.finished_message       = 'FINISHED :)'
