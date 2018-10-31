test_iso = "#{Chef::Config[:file_cache_path]}/test.iso"

remote_file 'test.iso' do
  path test_iso
  source 'https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-9.5.0-amd64-netinst.iso'
  action :create
end

if platform?('windows')
  windows_mount_iso 'Z:' do
    device test_iso
    action :mount
  end
else
  mount '/mnt' do
    device test_iso
    options 'loop'
    action :mount
  end
end
