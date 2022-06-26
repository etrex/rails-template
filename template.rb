require "byebug"

# reference: https://github.com/mattbrictson/rails-template/blob/main/template.rb#L96-L117
# Add this template directory to source_paths so that Thor actions like
# copy_file and template resolve against our source files. If this file was
# invoked remotely via HTTP, that means the files are not present locally.
# In that case, use `git clone` to download them to a local temporary dir.
def add_template_repository_to_source_path
  if __FILE__ =~ %r{\Ahttps?://}
    require "tmpdir"
    source_paths.unshift(tempdir = Dir.mktmpdir("rails-template-"))
    at_exit { FileUtils.remove_entry(tempdir) }
    git clone: [
      "--quiet",
      "https://github.com/etrex/rails-template.git",
      tempdir
    ].map(&:shellescape).join(" ")

    if (branch = __FILE__[%r{rails-template/(.+)/template.rb}, 1])
      Dir.chdir(tempdir) { git checkout: branch }
    end
  else
    source_paths.unshift(File.dirname(__FILE__))
  end
end

# 新增 gem 到應用程式的 Gemfile
def add_gems
  # code quality
  gem "rollbar"

  gem_group :development do
    gem "annotate"
  end

  gem_group :development, :test do
    gem "rspec-rails"
    gem "rubocop"
    gem "brakeman"
    gem "bundler-audit"
  end

  # features
  gem "dotenv-rails"
  gem "devise"
  gem 'omniauth-line', git: 'git@github.com:etrex/omniauth-line.git'
  gem "kamigo"
  gem "pundit"

  gem "administrate"
  gem "administrate-field-image"
  gem "administrate-field-enum"
  gem "administrate-field-nested_has_many"
  gem "administrate-field-belongs_to_search"
  gem "administrate_exportable"

  gem "omniauth-rails_csrf_protection"
end

# 新增程式到 config/application.rb。
# 若有指定環境 options[:env]，則程式會加到 config/environments 下對應的環境設定檔裡。
def setup_config_application
  # 設定時區
  environment 'config.time_zone = "Taipei"'
end

def install_gems
  generate "devise:install"

  generate "rspec:install"

  generate "pundit:install"

  # kamigo
  generate "kamigo:install"
end

# 建立用戶資料模型
def setup_model
  # 用戶
  generate :devise, :user

  # 第三方登入資料模型
  generate :model, "oauth_provider provider name uid user:references"

  # 建立資料庫
  rake "db:create"
  rake "db:migrate"
end

# 複製檔案
def copy_files
  add_template_repository_to_source_path
  copy_file "env", ".env"
  copy_file "app/controllers/application_controller.rb"
  copy_file "app/controllers/home_controller.rb"
  copy_file "app/controllers/omniauth_callbacks_controller.rb"
  copy_file "app/models/user.rb"
  copy_file "app/views/home/index.html.erb"
  copy_file "app/views/layouts/_nav.html.erb"
  insert_into_file "app/views/layouts/application.html.erb", '<%= render "layouts/nav" %>', after: "<body>\n"
  copy_file "config/initializers/line_login.rb"
  copy_file "config/routes.rb"

end

def setup_admin
  generate "administrate:install"

  # append to app/assets/config/manifest.js
  append_to_file "app/assets/config/manifest.js", "\n//= link administrate-field-nested_has_many/application.js"
  append_to_file "app/assets/config/manifest.js", "\n//= link administrate-field-nested_has_many/application.css"
end

def rails_new
  add_gems
  after_bundle do
    install_gems
    setup_model
    setup_config_application
    copy_files
    setup_admin
  end
end

rails_new