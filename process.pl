#!/usr/bin/perl

use utf8;
use Modern::Perl '2013';
use Cwd;
use Data::Dumper;
use Term::ANSIColor;
use ABNAmro::FileProcessing;
use ABNAmro::Logger;

my $file_processing = ABNAmro::FileProcessing->new();
my $logger = ABNAmro::Logger->new();

#-- check for passed argument
if (@ARGV != 1) {
  $logger->set_logs("error","please pass Input File");
  die   "usage : perl process.pl Input.txt  \n";
}

my ($file) = @ARGV;

if ( $file_processing->validate_file($file) ) {

  print colored("\nInput FileName : \t" .$file . "\n\n","yellow");

  my @daily_summary = $file_processing->process_file($file);

  $logger->set_logs("info","We have processed the file and stored data in daily_summary array");

  print colored("Number of records : \t". scalar @daily_summary . "\n\n", "yellow");

  $logger->set_logs("info", "total records processed " . scalar @daily_summary );

  if ( @daily_summary ) {
    my $is_report_generated = $file_processing->generate_daily_report_csv(@daily_summary);

    if ($is_report_generated) {
      #-- get current working directory for message
      my $cwd = fastgetcwd;
      print colored("Output file created in $cwd \n\n","green");
    } else {
      $logger->set_logs("error", "report file is not generated for some reason ");
    }
  }

} else {
  die colored("File is not validated \n\n",'red');
}
