##!/usr/bin/env perl
use utf8;
use Modern::Perl '2013';
use Data::Dumper;
use Test::More qw( no_plan );
use Test::Exception;

use ABNAmro::FileProcessing;

BEGIN { use_ok('ABNAmro::FileProcessing'); }

can_ok('ABNAmro::FileProcessing', 'new');

my $file_processing = ABNAmro::FileProcessing->new();

isa_ok($file_processing, 'ABNAmro::FileProcessing');

can_ok($file_processing, qw ( validate_file process_file generate_daily_report_csv ) );

my $working_file = "Input.txt";
my $not_working_file = "Input.csv";

subtest "Testing validate_file() methods" => sub {
  dies_ok { $file_processing->validate_file(); } "checking if no params causes Exception";
  is($file_processing->validate_file($not_working_file), 0, "checking if wrong type of file params causes Exception");
  is($file_processing->validate_file($working_file), 1, "checking if correct type of file params works as expected");
};

subtest "Testing process_file() method" => sub {
  dies_ok { $file_processing->process_file(); } "checking if no params causes Exception";
  is($file_processing->process_file("t/Text.csv"), undef, "checking if empty file params causes Exception");
  is($file_processing->process_file("t/Test.txt"), 717, "checking we receive 717 rows for test Test.txt");
};

subtest "Testing generate_daily_report_csv() method" => sub {
  my @daily_summary = [          ];
  dies_ok { $file_processing->generate_daily_report_csv(); } "checking if no params causes Exception";
  is($file_processing->generate_daily_report_csv(@daily_summary), 1 , "test Emptry array gives return 0");
};

done_testing();
