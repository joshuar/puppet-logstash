# This type represents a Logstash template file.
#
# Parameters are mutually exclusive. Only one should be specified.
#
# @param [String] template
#  A template from which to render the file.
#
# @param [String] source
#  A file resource to be used for the file.
#
# @example Render a Logstash template from a erb template.
#
#   logstash::templatefile { 'my-template':
#     template => 'site-logstash-module/my-template.erb',
#   }
#
# @example Copy the template from a file source.
#
#   logstash::templatefile { 'my-template':
#     source => 'puppet://path/to/my-template.json',
#   }
#
# @author https://github.com/elastic/puppet-logstash/graphs/contributors
#
define logstash::templatefile(
  $source = undef,
  $template = undef,
)
{
  include logstash

  $path = "${logstash::config_dir}/templates/${name}.json"
  $owner = 'root'
  $group = $logstash::logstash_group
  $mode  = '0640'
  $require = Package['logstash'] # So that we have '/etc/logstash/conf.d'.
  $tag = [ 'logstash_config' ] # So that we notify the service.

  if($template){
    file { $path:
      content => template($template),
      owner   => $owner,
      group   => $group,
      mode    => $mode,
      require => $require,
      tag     => $tag,
    }
  }
  elsif($source){
    file { $path:
      source  => $source,
      owner   => $owner,
      group   => $group,
      mode    => $mode,
      require => $require,
      tag     => $tag,
    }
  }
}
