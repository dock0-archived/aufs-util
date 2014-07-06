#!/usr/bin/env ruby

require 'yaml'
require 'fileutils'

kernel = YAML.load(File.read('host_config/config.yaml'))['kernel']['version']
version, revision = kernel.split '_'

system "roller.py -v \
  -k #{version} \
  -c #{version} \
  -r #{revision} \
  -b /opt/build \
  -d kernels/configs \
  -p #{Dir.pwd}/kernels/patches/#{kernel}"

Dir.chdir("/opt/build/sources/linux-#{version}") do
  system 'make headers_install'
end

FileUtils.rm_rf 'src'
FileUtils.rm_rf 'build'
FileUtils.mkdir_p 'build/etc/aufs-util'

system 'git clone git://git.code.sf.net/p/aufs/aufs-util src'

Dir.chdir('src') do
  system 'git checkout aufs3.x-rcN'
  system "CPPFLAGS='-I /opt/build/sources/linux-#{version}/usr/include' make"
  system 'DESTDIR=../build make install'
  FileUtils.cp 'COPYING', '../build/etc/aufs-util/LICENSE'
end
