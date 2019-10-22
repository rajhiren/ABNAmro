#!/usr/bin/env perl
use utf8;
use Modern::Perl '2013';
use Data::Dumper;
use Test::More qw( no_plan ); # for the is() and isnt() functions
use Test::Exception;

use ABNAmro::Logger;

BEGIN { use_ok('ABNAmro::Logger'); }

can_ok('ABNAmro::Logger', 'new');

my $logger = ABNAmro::Logger->new();

isa_ok($logger, 'ABNAmro::Logger');

can_ok($logger, qw ( set_logs ) );

my $log_status = "error";
my $log_message = "Log this message for Tests";
my $failing_string = "failme";
my $log_info = "info";

subtest "Die and Live Ok tests for set_logs" => sub {
  dies_ok { $logger->set_logs(); } "Checking if no parameter causes Exception";
  dies_ok { $logger->set_logs($log_status); } "Checking if ony 1 parameter causes Exception";
  dies_ok { $logger->set_logs($log_status.$failing_string); } "Checking if wrong type of log status parameter causes Exception";

  lives_ok { $logger->set_logs($log_status,$log_message); } "Checking if everything works as expected with valid parameters";

};


is ($logger->set_logs($failing_string,$log_message), undef, "checking if it fails with wrong type of error");
is ($logger->set_logs($log_status,$log_message), 1, "checking we get successful logging of error");
is ($logger->set_logs($log_info,$log_message), 1, "checking we get successful logging of info");


done_testing();
