# start docker service
docker_service 'default' do
  action [:create, :start]
end


# create directory for docker images
node.default['docker_images_path'] = '/root/docker_images/'
directory node.default['docker_images_path'] do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end
node.default['docker_files_array'].each do |file|
  # download tarballs with Dockerfiles for build
  remote_file "#{node.default['docker_images_path']}/#{file}" do
    source   "#{node.default['docker_files_links']}/#{file}"
    backup   false
  end
  # extract Dockerfiles from tarballs
  bash 'extract_module' do
    cwd ::File.dirname("#{node.default['docker_images_path']}/#{file}")
    code <<-EOH
      tar xzf #{file} -C #{node.default['docker_images_path']}
      EOH
    not_if { ::File.exists?("#{node.default['docker_images_path']}/#{file.gsub(".tar.gz", "")}/Dockerfile") }
  end
end


# build an image for DB
docker_image 'mysql' do
  tag '5.6'
  source "#{node.default['docker_images_path']}/db/Dockerfile"
  path "#{node.default['docker_images_path']}/db/"
  action :build_if_missing
  cmd_timeout 1000
end
# # run DB container
bash 'run_db' do
  code <<-EOH
    docker run -d --name db mysql:5.6
    EOH
end
# docker_container 'mysql:5.6' do
#   detach true
#   hostname 'mysql_srv'
# end

# build an image for FreeRADIUS
docker_image 'freeradius' do
  tag '3.0.5'
  source "#{node.default['docker_images_path']}/freeradius/Dockerfile"
  path "#{node.default['docker_images_path']}/freeradius"
  action :build_if_missing
  cmd_timeout 1000
end
# # run FreeRADIUS container
bash 'run_freeradius' do
  code <<-EOH
    docker run -p 1812:1812/udp -p 1813:1813/udp -d --link db:mysql_srv freeradius:3.0.5
    EOH
end
# docker_container 'freeradius' do
#   detach true
#   init_type false
#   # hostname 'freeradius'
#   # link 'mysql_srv'
# end

# build an image for Apache Tomcat
docker_image 'tomcat' do
  tag '6'
  source "#{node.default['docker_images_path']}/web/Dockerfile"
  path "#{node.default['docker_images_path']}/web"
  action :build_if_missing
  cmd_timeout 1000
end
# run Tomcat container
execute 'run_tomcat' do
  # user 'root'
  command "docker run -p 80:8080 -d --link db:mysql_srv tomcat:6"
  # returns [0, 2, nil]
  # not_if { ::File.exists?("#{node.default['app']['app_path']}/releases")}
end
# docker_container 'tomcat' do
#   detach true
#   hostname 'tomcat'
#   link 'mysql_srv'
# end

