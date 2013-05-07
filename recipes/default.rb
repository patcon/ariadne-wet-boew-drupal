repo = node['ariadne']['project']
site_url = "#{repo}.dev"
branch = node['ariadne']['branch']
node['php']['directives']['memory_limit'] = "292M"

web_app site_url do
  cookbook "ariadne"
  template "drupal-site.conf.erb"
  server_name site_url
  server_aliases [ "*.#{site_url}" ]
  docroot "/mnt/www/html/#{repo}"
  port node['apache']['listen_ports'].to_a[0]
end

if node['ariadne']['clean']
  execute "chmod -R 777 /mnt/www/html/#{repo}"
  %W{
    /vagrant/data/profiles/#{repo}
    /mnt/www/html/#{repo}
  }.each do |dir|
    directory dir do
      recursive true
      action :delete
    end
  end
end

git "/vagrant/data/profiles/#{repo}" do
  user "vagrant"
  repository "https://github.com/wet-boew/#{repo}.git"
  reference branch
  enable_submodules true
  action :sync
end

bash "Installing site..." do
  action :nothing
  user "vagrant"
  group "vagrant"
  code <<-"EOH"
    drush site-install wetkit wetkit_theme_form.theme=wetkit_adaptivetheme \
      --root=/mnt/www/html/#{repo} \
      --db-url=mysql://root:root@localhost/wetkit \
      --account-pass=S4mpleP^ssword \
      --site-name=#{repo} \
      --yes
  EOH
  environment({
    'HOME' => '/home/vagrant',
  })
end

bash "Building site..." do
  user "vagrant"
  group "vagrant"
  cwd "/vagrant/data/profiles/#{repo}"
  code <<-"EOH"
    drush make build-wetkit.make /mnt/www/html/#{repo} \
      --working-copy \
      --prepare-install \
      --no-gitinfofile \
      --yes
  EOH
  not_if "test -d /mnt/www/html/#{repo}"
  environment({
    'HOME' => '/home/vagrant',
  })
  notifies :run, "bash[Installing site...]", :immediately
  notifies :reload, "service[apache2]"
  notifies :restart, "service[varnish]"
end
