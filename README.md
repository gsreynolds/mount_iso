# mount_iso

Example cookbook for mounting ISOs plus a custom resource to support mounting ISOs on Windows using Chef.

On *nix mounting ISOs can be done using just the `mount` resource but that doesn't support mounting ISOs on Windows.

Mounting an ISO on Windows with a specific drive letter is a two stage process as the `Mount-DiskImage` cmdlet doesn't support specifying a drive letter to mount as. The `windows_mount_iso` custom resource contained in this cookbook uses `Mount-DiskImage`, `Get-CimInstance` and `Set-CimInstance` with appropriate guards to converge to the desired state.

## Example
```ruby
if platform?('windows')
  windows_mount_iso 'Z:' do
    device 'test.iso'
    action :mount
  end
else
  mount '/mnt' do
    device 'test.iso'
    options 'loop'
    action :mount
  end
end
```
