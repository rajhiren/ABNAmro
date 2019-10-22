#!/usr/bin/env perl
#------------------------------------------------------------------------
# Copyright (c) 2018-2019 Hiren Raj (AUM Infotech)
# Author  : Hiren Raj
#------------------------------------------------------------------------
package ABNAmro::Logger;

use utf8;
use Modern::Perl '2013';
use Carp;
use Data::Dumper;
use Log::Log4perl;
use Log::Log4perl::Level;

#----------------------------------------------------------------
# Syntax  : my $log_object = ABNAmro::Logger->new();
#----------------------------------------------------------------
sub new {
  my ($class) = @_;

  #-- initialise log settings
  Log::Log4perl->init("configs/log.conf");

  my $self = {
    logger  =>  Log::Log4perl->get_logger(),
  };

  return bless $self, $class;
}

#----------------------------------------------------------------
# Syntax  : my $logger = $log_object->set_logs($log_status , $log_message);
#----------------------------------------------------------------
sub set_logs {
  my ($self, $log_status , $log_message) = @_;

  croak "Must Supply Log Status as param!" unless (defined $log_status && (length($log_status) > 3 && length($log_status) < 7) );
  croak "Must Supply Log Message as param!" unless defined $log_message;

  my %status_hash_map = (
    error => 1,
    warn => 1,
    fatal => 1,
    info => 1,
    debug => 1,
    trace => 1,
  );

  if (exists $status_hash_map{$log_status}) {
    $self->{logger}->$log_status($log_message);
    return 1;
  } else {
    return undef;
  }

}
1;
