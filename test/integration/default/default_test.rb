# # encoding: utf-8

# Inspec test for recipe mount_iso::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

if os.windows?
  describe file('Z:\md5sum.txt') do
    it { should exist }
  end
else
  describe file('/mnt/md5sum.txt') do
    it { should exist }
  end
end
