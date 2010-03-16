require 'rake/clean'

task :default => :spec

desc 'Run specs'
task :spec do
  sh 'bacon -a'
end

# PACKAGING ============================================================

if defined?(Gem)
  # Load the gemspec using the same limitations as github
  $spec = eval(File.read('sinatra-sequel.gemspec'))

  def package(ext='')
    "pkg/#{$spec.name}-#{$spec.version}" + ext
  end

  desc 'Build packages'
  task :package => %w[.gem .tar.gz].map { |ext| package(ext) }

  desc 'Build and install as local gem'
  task :install => package('.gem') do
    sh "gem install #{package('.gem')}"
  end

  directory 'pkg/'
  CLOBBER.include('pkg')

  file package('.gem') => %W[pkg/ #{$spec.name}.gemspec] + $spec.files do |f|
    sh "gem build #{$spec.name}.gemspec"
    mv File.basename(f.name), f.name
  end

  file package('.tar.gz') => %w[pkg/] + $spec.files do |f|
    sh <<-SH
      git archive \
        --prefix=#{$spec.name}-#{$spec.version}/ \
        --format=tar \
        HEAD | gzip > #{f.name}
    SH
  end
end


# rebuild the gemspec manifest and update timestamps.
task "sinatra-sequel.gemspec" => FileList['{lib,spec}/**','Rakefile','COPYING','README.md'] do |f|
  # read spec file and split out manifest section
  spec = File.read(f.name)
  head, manifest, tail = spec.split("  # = MANIFEST =\n")
  # replace version and date
  head.sub!(/\.date = '.*'/, ".date = '#{Date.today.to_s}'")
  # determine file list from git ls-files
  files = `git ls-files`.
    split("\n").
    sort.
    reject{ |file| file =~ /^\./ }.
    reject { |file| file =~ /^doc/ }.
    map{ |file| "    #{file}" }.
    join("\n")
  # piece file back together and write...
  manifest = "  s.files = %w[\n#{files}\n  ]\n"
  spec = [head,manifest,tail].join("  # = MANIFEST =\n")
  File.open(f.name, 'w') { |io| io.write(spec) }
  puts "updated #{f.name}"
end
