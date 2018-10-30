resource_name :windows_mount_iso

description "Use the mount_iso resource to mount an ISO on Windows."

default_action :mount
allowed_actions :mount, :umount #, :unmount, :remount, :enable, :disable

property :mount_point, String, name_property: true,
         description: "The directory (or path) in which the device is to be mounted. Defaults to the name of the resource block if not provided."

property :device, String, identity: true,
         description: "Required for :umount and :remount actions (for the purpose of checking the mount command output for presence). The special block device or remote node, a label, or a uuid to be mounted."

action :mount do
  powershell_script 'Mount ISO' do
    code <<-EOH
    Mount-DiskImage '#{new_resource.device}' -ErrorAction 'Stop'
    EOH
    not_if <<-EOH
    (Get-DiskImage '#{new_resource.device}').Attached
    EOH
  end

  powershell_script 'Set ISO drive letter' do
    code <<-EOH
    gwmi win32_volume -Filter "Label = '$((Get-DiskImage -ImagePath '#{new_resource.device}' | Get-Volume).FileSystemLabel)'" | swmi -Arguments @{DriveLetter="#{new_resource.mount_point}"}
    EOH
    not_if <<-EOH
    ((Get-DiskImage '#{new_resource.device}' | Get-Volume).DriveLetter + ':' -ieq '#{new_resource.mount_point}')
    EOH
  end
end

action :umount do
end
